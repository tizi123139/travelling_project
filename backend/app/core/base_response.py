from pydantic import BaseModel
from typing import Any, Optional

class BaseResponse(BaseModel):
    """所有接口的标准化响应模型"""
    code: int = 200
    message: str = "获取成功"
    data: Optional[Any] = None

    class Config:
        from_attributes = True  # 支持ORM对象直接转换
        arbitrary_types_allowed = True  # 允许任意类型序列化