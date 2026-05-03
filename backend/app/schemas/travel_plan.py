from pydantic import BaseModel, Field,ConfigDict
from typing import Optional, List, Any
from datetime import datetime

class TravelPlanRequest(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    userId: int = Field(..., description="用户ID（关联users表id）")
    travelTime: int = Field(..., ge=1, le=15, description="旅行天数（1-15天）")
    travelCost: int = Field(..., ge=0, description="预算（元，≥0）")
    travelPurpose: str = Field(..., description="旅行目的")
    detailedPlan: str = Field(..., description="详细要求")
    destination: str = Field(..., description="目的地")


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
    features: List[Any]

    class Config:
        from_attributes = True

class TravelPlanListItem(BaseModel):
    planId: str
    destination: str
    travelTime: int
    createTime: datetime

    class Config:
        from_attributes = True