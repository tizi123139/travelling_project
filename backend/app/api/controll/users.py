from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session


from app.core.base_response import BaseResponse, ResponseCode
from app.db.session import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserOut, UserLogin, Token
from app.core.security import get_password_hash, create_access_token
from app.core.security import verify_password
from datetime import datetime, timedelta

from app.services.UserService import UserService


router = APIRouter()


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

