"""
九州Traveling JWT鉴权插件
适配FastAPI框架，支持：
1. 随机生成密钥
2. HS256签名算法
3. Access Token(1小时)/Refresh Token(1天)
4. IP绑定
5. 角色鉴权（普通用户/管理员）
6. Token自动刷新
7. 统一响应格式
"""
import os
import secrets
from datetime import datetime, timedelta
from typing import Optional, Dict, Any
from jose import JWTError, jwt
from passlib.context import CryptContext
from pydantic import BaseModel
from fastapi import Depends, HTTPException, status, Request
from fastapi.security import OAuth2PasswordBearer

# ============================ 核心配置 ============================
# 随机生成密钥（首次运行生成后保存到.env文件，避免重启丢失）
ENV_FILE = ".env"
SECRET_KEY_ENV_KEY = "JWT_SECRET_KEY"


def generate_secret_key() -> str:
    """生成32位随机密钥"""
    return secrets.token_hex(32)


def get_secret_key() -> str:
    """获取密钥（优先从.env读取，无则生成并保存）"""
    # 检查.env文件是否存在
    if os.path.exists(ENV_FILE):
        with open(ENV_FILE, "r", encoding="utf-8") as f:
            lines = f.readlines()
            for line in lines:
                if line.startswith(SECRET_KEY_ENV_KEY):
                    return line.split("=")[1].strip()

    # 生成新密钥并保存
    new_key = generate_secret_key()
    with open(ENV_FILE, "a", encoding="utf-8") as f:
        f.write(f"\n{SECRET_KEY_ENV_KEY}={new_key}")
    return new_key


# 核心常量
SECRET_KEY = get_secret_key()
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_HOURS = 1  # Access Token有效期1小时
REFRESH_TOKEN_EXPIRE_DAYS = 1  # Refresh Token有效期1天

# 密码加密上下文
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# 角色定义
USER_ROLE_NORMAL = "normal"  # 普通用户
USER_ROLE_ADMIN = "admin"  # 管理员


# ============================ 数据模型 ============================
class TokenData(BaseModel):
    """Token解析后的数据模型"""
    user_id: Optional[str] = None
    role: Optional[str] = USER_ROLE_NORMAL  # 默认普通用户


class TokenResponse(BaseModel):
    """Token返回格式"""
    code: int
    message: str
    data: Dict[str, Any]


# ============================ OAuth2配置 ============================
# 指定登录接口，Token通过Authorization: Bearer <token>传递
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/users/login")


# ============================ 密码处理函数 ============================
def verify_password(plain_password: str, hashed_password: str) -> bool:
    """验证明文密码与哈希密码是否匹配"""
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    """生成密码的bcrypt哈希值"""
    return pwd_context.hash(password)


# ============================ Token生成函数 ============================
def create_access_token(
        user_id: str,
        role: str = USER_ROLE_NORMAL,
        client_ip: str = ""
) -> str:
    """
    生成Access Token（绑定IP和角色）
    :param user_id: 用户ID
    :param role: 用户角色（normal/admin）
    :param client_ip: 客户端IP地址
    :return: 加密后的Access Token
    """
    expire = datetime.utcnow() + timedelta(hours=ACCESS_TOKEN_EXPIRE_HOURS)
    to_encode = {
        "sub": user_id,
        "role": role,
        "ip": client_ip,
        "exp": expire,
        "type": "access"  # 标记为access token
    }
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


def create_refresh_token(
        user_id: str,
        role: str = USER_ROLE_NORMAL,
        client_ip: str = ""
) -> str:
    """
    生成Refresh Token（绑定IP和角色）
    :param user_id: 用户ID
    :param role: 用户角色
    :param client_ip: 客户端IP
    :return: 加密后的Refresh Token
    """
    expire = datetime.utcnow() + timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS)
    to_encode = {
        "sub": user_id,
        "role": role,
        "ip": client_ip,
        "exp": expire,
        "type": "refresh"  # 标记为refresh token
    }
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


# ============================ Token验证函数 ============================
def verify_token(
        token: str,
        token_type: str = "access",  # access/refresh
        client_ip: str = ""
) -> TokenData:
    """
    验证Token有效性（含IP校验、类型校验）
    :param token: 待验证的Token
    :param token_type: 期望的Token类型
    :param client_ip: 当前请求的客户端IP
    :return: TokenData对象
    :raise HTTPException: 验证失败抛出异常
    """

    # 统一异常格式
    def raise_auth_exception(detail: str):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail={
                "code": 401,
                "message": detail,
                "data": None
            },
            headers={"WWW-Authenticate": "Bearer"},
        )

    try:
        # 解析Token
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])

        # 校验Token类型
        token_type_from_payload = payload.get("type")
        if token_type_from_payload != token_type:
            raise_auth_exception(f"无效的{token_type} token")

        # 校验用户ID
        user_id: str = payload.get("sub")
        if user_id is None:
            raise_auth_exception("Token中无用户信息")

        # 校验IP（非空时校验）
        token_ip: str = payload.get("ip")
        if client_ip and token_ip and token_ip != client_ip:
            raise_auth_exception("Token与当前IP不匹配，疑似被盗用")

        # 校验角色
        role: str = payload.get("role", USER_ROLE_NORMAL)
        if role not in [USER_ROLE_NORMAL, USER_ROLE_ADMIN]:
            role = USER_ROLE_NORMAL

        return TokenData(user_id=user_id, role=role)

    except JWTError:
        raise_auth_exception("Token无效或已过期")


# ============================ 依赖注入函数 ============================
def get_current_user(
        request: Request,
        token: str = Depends(oauth2_scheme)
) -> TokenData:
    """
    通用鉴权依赖：验证Access Token，返回用户信息
    使用方式：current_user: TokenData = Depends(get_current_user)
    """
    # 获取客户端IP
    client_ip = request.client.host
    # 验证Token
    return verify_token(token, token_type="access", client_ip=client_ip)


def get_current_admin(
        current_user: TokenData = Depends(get_current_user)
) -> TokenData:
    """
    管理员鉴权依赖：仅允许管理员访问
    使用方式：current_admin: TokenData = Depends(get_current_admin)
    """
    if current_user.role != USER_ROLE_ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={
                "code": 403,
                "message": "无管理员权限",
                "data": None
            }
        )
    return current_user


# ============================ Token刷新函数 ============================
def refresh_access_token(
        refresh_token: str,
        client_ip: str = ""
) -> Dict[str, str]:
    """
    刷新Access Token
    :param refresh_token: 有效的Refresh Token
    :param client_ip: 当前客户端IP
    :return: 新的Access Token
    """
    # 验证Refresh Token
    token_data = verify_token(refresh_token, token_type="refresh", client_ip=client_ip)

    # 生成新的Access Token
    new_access_token = create_access_token(
        user_id=token_data.user_id,
        role=token_data.role,
        client_ip=client_ip
    )

    return {
        "access_token": new_access_token,
        "token_type": "bearer",
        "expire_hours": ACCESS_TOKEN_EXPIRE_HOURS
    }