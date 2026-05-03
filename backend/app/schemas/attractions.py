from pydantic import BaseModel
from typing import Optional, List

# ---------------------- 景区列表响应项 ----------------------
class ScenicListItem(BaseModel):
    scenicId: str
    name: str
    nameEn: Optional[str] = None  # 新增：英文名称
    price: float
    score: float
    imgUrl1: str
    rating: float
    reviewCount: int
    distance: str
    address: str
    addressEn: Optional[str] = None  # 新增：英文地址
    type: str
    tags: List[str]
    tagsEn: Optional[List[str]] = None  # 新增：英文标签
    priceLevel: str
    latitude: float
    longitude: float
    introduction: str
    introductionEn: Optional[str] = None

    class Config:
        from_attributes = True

# ---------------------- 景区详情响应 ----------------------
class ScenicDetail(BaseModel):
    scenicId: str
    name: str
    nameEn: Optional[str] = None  # 新增：英文名称
    price: float
    openingTime: str
    introduction: str
    introductionEn: Optional[str] = None  # 新增：英文简介
    traffic: List[str]
    # 移除：ticketUrl 字段
    # ticketUrl: str

    # 原有新增字段
    rating: float
    reviewCount: int
    address: str
    addressEn: Optional[str] = None  # 新增：英文地址
    category: str
    latitude: float
    longitude: float
    tags: List[str]
    tagsEn: Optional[List[str]] = None  # 新增：英文标签
    type: str
    priceLevel: str
    distance: str

    class Config:
        from_attributes = True

# ---------------------- 分页响应包装 ----------------------
class ScenicListResponseData(BaseModel):
    total: int
    list: List[ScenicListItem]