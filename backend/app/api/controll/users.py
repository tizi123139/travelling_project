from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
<<<<<<< Updated upstream
from app.db.session import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserOut, UserLogin, Token
from app.core.security import get_password_hash
from app.core.security import verify_password
=======

from app.core.base_response import BaseResponse, ResponseCode
from app.db.session import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserOut, UserLogin, Token
from app.core.security import get_password_hash, create_access_token
from app.core.security import verify_password
from datetime import datetime, timedelta

from app.services.UserService import UserService
>>>>>>> Stashed changes

router = APIRouter()


<<<<<<< Updated upstream
@router.post("/register", response_model=UserOut)
def register(user_in: UserCreate, db: Session = Depends(get_db)):
    # 1. 检查用户是否已存在
    db_user = db.query(User).filter(User.username == user_in.username).first()
    if db_user:
        raise HTTPException(status_code=400, detail="用户名已注册")

    # 2. 创建用户
    new_user = User(
        username=user_in.username,
        hashed_password=get_password_hash(user_in.password), # 注意：后续需集成 security.py 加密
        email=user_in.email
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


@router.post("/login", response_model=Token)
def login(user_in: UserLogin, db: Session = Depends(get_db)):
    # 1. 查找用户
    user = db.query(User).filter(User.username == user_in.username).first()

    # 2. 验证用户是否存在以及密码是否正确
    # 注意：现在存的是明文，后续集成 security.py 后需改为 verify_password(user_in.password, user.hashed_password)
    if not user or not verify_password(user_in.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="用户名或密码错误",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # 3. 返回登录成功的凭证雏形
    # 目前先返回一个模拟的 token，等安全同学配置好 JWT 后再替换为真实生成的 token
    return {
        "access_token": f"mock_token_for_{user.username}",
        "token_type": "bearer",
        "username": user.username
    }
=======
@router.post("/register", response_model=BaseResponse)
def register(
    user_in: UserCreate,
    db: Session = Depends(get_db)
):
    try:
        # 调用服务层创建用户
        db_user = UserService.create_user(db, user_in)
        return BaseResponse(
            code=ResponseCode.CREATED,
            message="注册成功",
            data=UserOut.from_orm(db_user)
        )
    except HTTPException as e:
        # 业务错误（用户名重复等）
        return BaseResponse(
            code=e.status_code,
            message=e.detail,
            data=None
        )
    except Exception as e:
        # 未知错误
        return BaseResponse(
            code=ResponseCode.SERVER_ERROR,
            message=f"注册失败：{str(e)}",
            data=None
        )

# 登录接口
@router.post("/login", response_model=BaseResponse)
def login(
    user_in: UserLogin,
    db: Session = Depends(get_db)
):
    try:
        # 调用服务层认证用户
        token = UserService.authenticate_user(db, user_in)
        return BaseResponse(
            code=ResponseCode.SUCCESS,
            message="登录成功",
            data=token
        )
    except HTTPException as e:
        # 认证失败
        return BaseResponse(
            code=e.status_code,
            message=e.detail,
            data=None
        )
    except Exception as e:
        # 未知错误
        return BaseResponse(
            code=ResponseCode.SERVER_ERROR,
            message=f"登录失败：{str(e)}",
            data=None
        )
>>>>>>> Stashed changes
