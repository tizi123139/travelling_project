from pydantic import BaseModel
from typing import Any, Optional

<<<<<<< Updated upstream
class BaseResponse(BaseModel):
    """所有接口的标准化响应模型"""
    code: int = 200
    message: str = "获取成功"
=======
# 定义业务状态码常量（避免硬编码）
class ResponseCode:
    SUCCESS = 200          # 成功
    CREATED = 201          # 创建成功
    BAD_REQUEST = 400      # 参数错误/业务规则错误
    UNAUTHORIZED = 401     # 未授权/密码错误
    SERVER_ERROR = 500     # 服务器内部错误

class BaseResponse(BaseModel):
    """所有接口的标准化响应模型"""
    code: int = ResponseCode.SUCCESS
    message: str = "操作成功"
>>>>>>> Stashed changes
    data: Optional[Any] = None

    class Config:
        from_attributes = True  # 支持ORM对象直接转换
        arbitrary_types_allowed = True  # 允许任意类型序列化