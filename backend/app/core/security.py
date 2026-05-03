from passlib.context import CryptContext
from passlib.context import CryptContext
from jose import jwt, JWTError
from datetime import datetime, timedelta
from fastapi import HTTPException, status
from typing import Optional, Union

from app.schemas.user import TokenPayload

# JWT 配置（建议放到 .env 文件）
SECRET_KEY =
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30


# 初始化密码加密上下文（指定bcrypt成本因子，增强安全性）
pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto",
    bcrypt__rounds=12  # 成本因子，10-14 是推荐范围
)


def verify_password(plain_password: str, hashed_password: str) -> bool:

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
        )