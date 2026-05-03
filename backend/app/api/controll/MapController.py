from fastapi import APIRouter, Query
from app.services.MapService import MapService
from app.schemas.map import RouteData, CoordinateData
from app.core.base_response import BaseResponse

router = APIRouter()

# 1. 获取路线规划
@router.get("/route", response_model=BaseResponse, summary="获取路线规划")
def get_route(
    origin: str = Query(..., description="起点（经纬度/地址）"),
    destination: str = Query(..., description="终点（经纬度/地址）"),
    type: str = Query(..., description="出行方式：driving/transit/walking")
):
    data = MapService.get_route(origin, destination, type)
    return BaseResponse(
        code=200,
        message="获取成功",
        data=data
    )

# 2. 获取景点/酒店坐标
@router.get("/coordinate", response_model=BaseResponse, summary="获取景点/酒店坐标")
def get_coordinate(
    name: str = Query(..., description="景点/酒店名称"),
    city: str = Query(..., description="所在城市")
):
    data = MapService.get_coordinate(name, city)
    return BaseResponse(
        code=200,
        message="获取成功",
        data=data
    )