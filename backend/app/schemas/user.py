from pydantic import BaseModel, EmailStr
from typing import Optional
<<<<<<< Updated upstream
=======
from typing import Optional, Union
from datetime import datetime
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
    username: str
=======
    username: str
    expires_at: Optional[int] = None

class TokenPayload(BaseModel):
    sub: Union[int, str]
    exp: datetime
>>>>>>> Stashed changes
