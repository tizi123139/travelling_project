from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from datetime import timedelta

from app.core.sms_config import SmsService
from app.models.user import User  # 你的SQLAlchemy模型
from app.schemas.user import UserCreate, UserLogin, Token
from app.core.security import verify_password, get_password_hash, create_access_token, pwd_context
from app.core.security import ACCESS_TOKEN_EXPIRE_MINUTES
from datetime import datetime


class UserService:
    @staticmethod
    def get_user_by_username(db: Session, username: str):
        """根据用户名查询用户"""
        return db.query(User).filter(User.username == username).first()

    @staticmethod
    def get_user_by_email(db: Session, email: str):
        """根据邮箱查询用户"""
        return db.query(User).filter(User.email == email).first()

    @staticmethod
    def get_user_by_phone(db: Session, phone: str):
        """新增：根据手机号查询用户"""
        return db.query(User).filter(User.phone == phone).first()

    @staticmethod
    def create_user(db: Session, user_in: UserCreate) -> User:
        # 1. 密码加密（必做，否则会报错）
        hashed_password = pwd_context.hash(user_in.password)

        # 2. 创建用户实例
        db_user = User(
            username=user_in.username,
            phone=user_in.phone,
            hashed_password=hashed_password, # 存加密后的密码，不是明文
            email=user_in.email
        )

        # 3. 提交数据库
        db.add(db_user)
        try:
            db.commit()  # 提交可能失败（如手机号唯一索引冲突）
            db.refresh(db_user)
            return db_user
        except Exception as e:
            db.rollback()  # 失败回滚
            raise Exception(f"数据库操作失败：{str(e)}")

    @staticmethod
    def authenticate_user(db: Session, user_in: UserLogin):
        """用户登录认证"""
        # 1. 查询用户
        user = UserService.get_user_by_username(db, user_in.username)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="用户名或密码错误"
            )

        # 2. 验证密码
        if not verify_password(user_in.password, user.hashed_password):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="用户名或密码错误"
            )

        # 3. 生成Token
        access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = create_access_token(
            subject=user.id,
            expires_delta=access_token_expires
        )

        # 4. 构造Token返回数据
        return Token(
            access_token=access_token,
            token_type="bearer",
            username=user.username,
            expires_at=int((datetime.now() + access_token_expires).timestamp())
        )