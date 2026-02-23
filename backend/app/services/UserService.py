from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from datetime import timedelta

from app.models.user import User  # 你的SQLAlchemy模型
from app.schemas.user import UserCreate, UserLogin, Token
from app.core.security import verify_password, get_password_hash, create_access_token
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
    def create_user(db: Session, user_in: UserCreate):
        """创建新用户（注册逻辑）"""
        # 1. 校验用户名唯一性
        if UserService.get_user_by_username(db, user_in.username):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"用户名 {user_in.username} 已注册"
            )

        # 2. 校验邮箱唯一性（如果传了邮箱）
        if user_in.email and UserService.get_user_by_email(db, user_in.email):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"邮箱 {user_in.email} 已注册"
            )

        # 3. 加密密码 + 创建用户
        hashed_password = get_password_hash(user_in.password)
        db_user = User(
            username=user_in.username,
            email=user_in.email,
            hashed_password=hashed_password
        )
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return db_user

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