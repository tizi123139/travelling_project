from passlib.context import CryptContext
from fastapi import HTTPException, status
<<<<<<< Updated upstream
=======
from passlib.context import CryptContext
from jose import jwt, JWTError
from datetime import datetime, timedelta
from fastapi import HTTPException, status
from typing import Optional, Union

from app.schemas.user import TokenPayload

# JWT 配置（建议放到 .env 文件）
SECRET_KEY = "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30
>>>>>>> Stashed changes

# 初始化密码加密上下文（指定bcrypt成本因子，增强安全性）
pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto",
    bcrypt__rounds=12  # 成本因子，10-14 是推荐范围
)


def verify_password(plain_password: str, hashed_password: str) -> bool:
<<<<<<< Updated upstream
    """验证明文密码和加密密码是否匹配（先截断再验证）"""
    # 截断超长密码，避免验证时也触发报错
    truncated_password = plain_password.encode('utf-8')[:72].decode('utf-8', errors='ignore')
    return pwd_context.verify(truncated_password, hashed_password)


def get_password_hash(password: str) -> str:
    """生成密码哈希值（自动截断超长密码+友好异常）"""
    try:
        # 关键：按utf-8编码截断到72字节，兼容中文
        byte_password = password.encode('utf-8')
        if len(byte_password) > 72:
            password = byte_password[:72].decode('utf-8', errors='ignore')

        # 生成哈希
        return pwd_context.hash(password)
    except Exception as e:
        # 抛出自定义400错误，而非500
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"密码加密失败：{str(e)}（密码长度请控制在72字节内，中文约24个字符）"
=======
    """验证明文密码与哈希密码"""
    truncated_pwd = plain_password.encode('utf-8')[:72].decode('utf-8', errors='ignore')
    return pwd_context.verify(truncated_pwd, hashed_password)


def get_password_hash(password: str) -> str:
    """生成密码哈希值"""
    try:
        truncated_pwd = password.encode('utf-8')[:72].decode('utf-8', errors='ignore')
        return pwd_context.hash(truncated_pwd)
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"密码加密失败：{str(e)}"
        )


def create_access_token(
        subject: Union[int, str],
        expires_delta: Optional[timedelta] = None
) -> str:
    """生成JWT Token"""
    if expires_delta:
        expire = datetime.now() + expires_delta
    else:
        expire = datetime.now() + timedelta(minutes=15)

    to_encode = {"sub": str(subject), "exp": expire}
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


def decode_access_token(token: str) -> TokenPayload:
    """解析Token（验证有效性）"""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return TokenPayload(**payload)
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token无效或已过期"
>>>>>>> Stashed changes
        )