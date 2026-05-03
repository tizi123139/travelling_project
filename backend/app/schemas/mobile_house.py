from pydantic import BaseModel
from typing import Optional, List


class MobileHouseBase(BaseModel):
    title: str
    intro: Optional[str] = None
    cover_image: Optional[str] = None
    address: str
    location_lng: Optional[float] = None
    location_lat: Optional[float] = None
    contact: str
    price: float
    checkin_time: Optional[str] = None
    checkout_time: Optional[str] = None
    tags: Optional[str] = None
    rating: Optional[float] = 5.0
    review_count: Optional[int] = 0

class MobileHouseCreate(MobileHouseBase):
    pass

class MobileHouseUpdate(MobileHouseBase):
    pass

class MobileHouseOut(MobileHouseBase):
    id: int
    distance: Optional[float] = None  # 前端计算后返回

    class Config:
        from_attributes = True