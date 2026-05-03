from pydantic import BaseModel, EmailStr, Field, validator, field_validator
from typing import Optional

from typing import Optional, Union
from datetime import datetime
import re

# 注册时输入的格式
class UserCreate(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    password: str = Field(..., min_length=6)
    email: Optional[EmailStr] = None
    phone: str = Field(..., pattern=r"^1[3-9]\d{9}$")  # 手机号必填+格式校验
    verify_code: str = Field(..., min_length=6, max_length=6)  # 验证码

    # Pydantic v2 中 validator 改成 field_validator，且需要加 mode='before'
    @field_validator('phone', mode='before')
    def validate_phone(cls, v):
        if not re.match(r"^1[3-9]\d{9}$", v):
            raise ValueError("手机号格式错误")
        return v

class UserOut(BaseModel):
    id: int
    username: str
    email: Optional[EmailStr]
    phone: Optional[str]

    class Config:
        from_attributes = True

# 新增：发送验证码请求模型
class SmsCodeRequest(BaseModel):
    phone: str = Field(..., pattern=r"^1[3-9]\d{9}$")


class UserLogin(BaseModel):
    username: str
    password: str

# 登录成功后返回的格式
class Token(BaseModel):
    access_token: str
    token_type: str
    username: str
    expires_at: Optional[int] = None

class TokenPayload(BaseModel):
    sub: Union[int, str]
    exp: datetime
