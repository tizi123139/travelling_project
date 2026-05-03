from pydantic import BaseModel
from typing import List

# 路线规划响应
class RouteData(BaseModel):
    distance: str
    duration: str
    steps: List[str]

# 坐标查询响应
class CoordinateData(BaseModel):
    name: str
    longitude: float
    latitude: float
    address: str