from fastapi import APIRouter, Depends, HTTPException, status,  Request
from sqlalchemy.orm import Session


from app.core.base_response import BaseResponse, ResponseCode
from app.core.sms_config import SmsService
from app.db.session import get_db
from app.models.user import User
from app.schemas.user import UserCreate, UserOut, UserLogin, Token, SmsCodeRequest
from app.core.security import get_password_hash, create_access_token
from app.core.security import verify_password
from datetime import datetime, timedelta
from app.core.sms_config import SmsService
from app.services.UserService import UserService


router = APIRouter()


@router.post("/register", response_model=BaseResponse)
def register(
    request: Request,
    user_in: UserCreate,
    db: Session = Depends(get_db),

):
    import asyncio
    body = asyncio.run(request.json())
    print("收到的注册请求体:", body)
    try:
        # 1. 第一步：校验验证码（核心缺失逻辑）
        if not SmsService.verify_code(user_in.phone, user_in.verify_code):
            raise HTTPException(
                status_code=ResponseCode.BAD_REQUEST,
                detail="验证码错误、已过期或未发送"
            )

        # 2. 第二步：检查手机号是否已注册（防止重复注册）
        if UserService.get_user_by_phone(db, user_in.phone):
            raise HTTPException(
                status_code=ResponseCode.BAD_REQUEST,
                detail="该手机号已注册"
            )

        # 3. 第三步：创建用户（原有逻辑）
        db_user = UserService.create_user(db, user_in)

        # 4. 返回注册成功响应
        return BaseResponse(
            code=ResponseCode.CREATED,
            message="注册成功",
            data=UserOut.from_orm(db_user).dict()
        )

        # 5. 捕获业务异常（验证码错误、手机号已注册等）
    except HTTPException as e:
        return BaseResponse(
            code=e.status_code,
            message=e.detail,
            data=None
        )

        # 6. 捕获系统异常（数据库错误、模型转换错误等）
    except Exception as e:
        # 打印详细错误栈，方便排查
        import traceback
        traceback.print_exc()
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

@router.post("/send-sms-code", response_model=BaseResponse)
async def send_sms_code(
        req: SmsCodeRequest,
        request: Request,
        db: Session = Depends(get_db)  # 注入数据库会话
):
    try:
        # 1. 校验变量名：req.phone 而非 sms_in.phone（核心错误）
        phone = req.phone

        # 2. 检查手机号是否已注册
        if UserService.get_user_by_phone(db, phone):
            raise HTTPException(
                status_code=ResponseCode.BAD_REQUEST,
                detail="该手机号已注册"
            )

        # 3. 发送验证码（同步方法，无需await）
        SmsService.send_sms_code(phone)

        # 4. 返回成功响应
        return BaseResponse(
            code=ResponseCode.SUCCESS,
            message="验证码发送成功",
            data=None
        )

    # 5. 捕获手机号格式/发送频率等业务异常
    except ValueError as e:
        raise HTTPException(
            status_code=ResponseCode.BAD_REQUEST,
            detail=str(e)
        )

    # 6. 捕获其他未知异常（打印详细栈信息）
    except Exception as e:
        import traceback
        traceback.print_exc()  # 终端打印完整错误栈，方便排查
        raise HTTPException(
            status_code=ResponseCode.SERVER_ERROR,
            detail=f"验证码发送失败：{str(e)}"
        )
