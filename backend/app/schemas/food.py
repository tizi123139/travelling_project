from pydantic import BaseModel, Field,field_validator
from typing import Optional, List
import json

# ---------------------- 美食列表响应项 ----------------------
class FoodListItem(BaseModel):
    foodId: str
    name: str
    nameEn: Optional[str] = ""
    feature: Optional[str] = ""
    featureEn: Optional[str] = ""
    type: Optional[str] = ""
    typeEn: Optional[str] = ""
    price: Optional[float] = 0.0
    recommendedShop: Optional[str] = ""
    destination: str
    image: Optional[str] = ""
    rating: Optional[float] = 0.0
    reviewCount: int = 0
    category: Optional[str] = ""
    categoryEn: Optional[str] = ""
    distance: Optional[str] = ""
    address: Optional[str] = ""
    addressEn: Optional[str] = ""
    tags: Optional[List[str]] = []
    tagsEn: Optional[List[str]] = []
    phone: Optional[str] = ""
    hours: Optional[str] = ""
    recommended: Optional[List[str]] = []


    @field_validator('tags', mode='before')
    def parse_tags(cls, v):
        """将JSON字符串转为列表，兼容空值/非JSON字符串"""
        if v is None:
            return []
        if isinstance(v, str):
            if v.strip() == "":
                return []
            try:
                # 尝试解析JSON字符串为列表
                return json.loads(v)
            except (json.JSONDecodeError, TypeError):
                # 解析失败返回空列表
                return []
        # 如果已经是列表，直接返回
        if isinstance(v, list):
            return v
        # 其他类型返回空列表
        return []

    @field_validator('tagsEn', mode='before')
    def parse_tags_en(cls, v):
        """将tagsEn的JSON字符串转为列表，逻辑和tags完全一致"""
        if v is None:
            return []
        if isinstance(v, str):
            if v.strip() == "":
                return []
            try:
                # 解析JSON字符串为列表
                return json.loads(v)
            except (json.JSONDecodeError, TypeError):
                # 解析失败返回空列表
                return []
        if isinstance(v, list):
            return v
        # 其他类型返回空列表
        return []

    @field_validator('recommended', mode='before')
    def parse_recommended(cls, v):
        """将tagsEn的JSON字符串转为列表，逻辑和tags完全一致"""
        if v is None:
            return []
        if isinstance(v, str):
            if v.strip() == "":
                return []
            try:
                # 解析JSON字符串为列表
                return json.loads(v)
            except (json.JSONDecodeError, TypeError):
                # 解析失败返回空列表
                return []
        if isinstance(v, list):
            return v
        # 其他类型返回空列表
        return []

    class Config:
        from_attributes = True

# ---------------------- 店铺详情（详情页） ----------------------
class ShopItem(BaseModel):
    shopName: str
    address: str
    score:  Optional[float] = None

# ---------------------- 美食详情响应 ----------------------
class FoodDetail(FoodListItem):
    ingredient: Optional[List[str]] = []  # 改为列表类型（拆分后的配料）
    shopList: Optional[List[ShopItem]] = []
    nameEn: Optional[str] = ""
    image: Optional[str] = ""
    rating: Optional[float] = 0.0  # 评分转 float
    reviewCount: int = 0
    category: Optional[str] = ""
    categoryEn: Optional[str] = ""
    distance: Optional[str] = ""
    address: Optional[str] = ""
    addressEn: Optional[str] = ""
    phone: Optional[str] = ""
    tags: Optional[List[str]] = []  # 改为列表（JSON数组解析后）
    tagsEn: Optional[List[str]] = []
    recommended: Optional[List[str]] = []
    latitude: Optional[float] = 0.0  # 经纬度转 float
    longitude: Optional[float] = 0.0

    class Config:
        from_attributes = True