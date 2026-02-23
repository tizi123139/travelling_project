from pydantic import BaseModel, EmailStr
from typing import Optional

# 注册时输入的格式
class UserCreate(BaseModel):
    username: str
    password: str
    email: Optional[EmailStr] = None

# 返回给前端的格式（隐藏密码）
class UserOut(BaseModel):
    id: int
    username: str
    email: Optional[EmailStr]

    class Config:
        from_attributes = True


class UserLogin(BaseModel):
    username: str
    password: str

# 登录成功后返回的格式
class Token(BaseModel):
    access_token: str
    token_type: str
    username: str