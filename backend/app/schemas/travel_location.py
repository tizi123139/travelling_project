from pydantic import BaseModel
from typing import List, Optional

# 目的地位置信息响应
class CityLocationData(BaseModel):
    city: str
    longitude: float
    latitude: float
    weather: str
    traffic: List[str]

# 周边景点/设施响应项
class NearbyPoiItem(BaseModel):
    name: str
    type: str
    distance: str
    address: str