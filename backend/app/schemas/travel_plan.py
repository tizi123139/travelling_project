from pydantic import BaseModel, Field
from typing import Optional, List, Any
from datetime import datetime

class TravelPlanRequest(BaseModel):
    userId: int = Field(..., description="用户ID（关联users表id）")
    travelTime: int = Field(..., ge=1, le=15, description="旅行天数（1-15天）")
    travelCost: int = Field(..., ge=0, description="旅行预算（元，≥0）")
    travelPurpose: str = Field(..., description="旅行目的：文化探索/休闲度假/美食打卡/亲子游玩/户外探险")
    detailedPlan: str = Field(..., description="详细旅行需求描述")
    destination: str = Field(..., description="旅行目的地（国内城市）")

class TravelPlanData(BaseModel):
    planId: str
    userId: int
    destination: str
    travelTime: int
    travelCost: int
    itinerary: List[Any]
    hotel: Any
    food: List[Any]
    tips: str

    class Config:
        from_attributes = True

class TravelPlanListItem(BaseModel):
    planId: str
    destination: str
    travelTime: int
    createTime: datetime

    class Config:
        from_attributes = True