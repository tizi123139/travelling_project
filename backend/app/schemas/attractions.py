from pydantic import BaseModel
from typing import Optional, List

# ---------------------- 景区列表响应项 ----------------------
class ScenicListItem(BaseModel):
    scenicId: str
    name: str
    price: float
    score: float
    imgUrl1: str

    class Config:
        from_attributes = True

# ---------------------- 景区详情响应 ----------------------
class ScenicDetail(BaseModel):
    scenicId: str
    name: str
    price: float
    openingTime: str
    introduction: str
    traffic: List[str]  # 交通方式列表
    ticketUrl: str

    class Config:
        from_attributes = True

# ---------------------- 分页响应包装 ----------------------
class ScenicListResponseData(BaseModel):
    total: int
    list: List[ScenicListItem]