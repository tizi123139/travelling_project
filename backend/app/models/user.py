from sqlalchemy import Column, Integer, String, DateTime, Boolean
from sqlalchemy.sql import func
from app.db.base import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, index=True, nullable=False)
    # 存储哈希后的密码，不存明文
    hashed_password = Column(String(255), nullable=False)
    email = Column(String(100), unique=True, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    phone = Column(String(20), unique=True, index=True)  # 新增手机号字段
    is_active = Column(Boolean, default=True)  # 新增激活状态