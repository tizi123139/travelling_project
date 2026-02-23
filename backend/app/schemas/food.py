from pydantic import BaseModel, Field
from typing import Optional, List

# ---------------------- 美食列表响应项 ----------------------
class FoodListItem(BaseModel):
    foodId: str
    name: str
    feature: str
    price: float
    recommendedShop: str

    class Config:
        from_attributes = True

# ---------------------- 店铺详情（详情页） ----------------------
class ShopItem(BaseModel):
    shopName: str
    address: str
    score: float

# ---------------------- 美食详情响应 ----------------------
class FoodDetail(BaseModel):
    foodId: str
    name: str
    feature: str
    ingredient: List[str]
    shopList: List[ShopItem]

    class Config:
        from_attributes = True