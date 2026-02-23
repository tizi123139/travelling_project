from passlib.context import CryptContext
from fastapi import HTTPException, status

# 初始化密码加密上下文（指定bcrypt成本因子，增强安全性）
pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto",
    bcrypt__rounds=12  # 成本因子，10-14 是推荐范围
)


def verify_password(plain_password: str, hashed_password: str) -> bool:
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
        )