from fastapi import APIRouter, Query
from app.services.TravelLocationService import TravelLocationService
from app.schemas.travel_location import CityLocationData, NearbyPoiItem
from app.core.base_response import BaseResponse
from typing import List

router = APIRouter()

# 1. 获取目的地位置信息
@router.get("/location", response_model=BaseResponse, summary="获取目的地位置+天气+交通")
def get_destination_location(
    destination: str = Query(..., description="目的地城市，如：武汉")
):
    data = TravelLocationService.get_destination_location(destination)
    return BaseResponse(
        code=200,
        message="获取成功",
        data=data
    )

# 2. 获取周边景点/设施
@router.get("/around", response_model=BaseResponse, summary="获取周边POI")
def get_nearby_facilities(
    longitude: float = Query(..., description="经度，如：114.31"),
    latitude: float = Query(..., description="纬度，如：30.59"),
    radius: int = Query(5000, ge=100, description="搜索半径（米），默认5000"),
    type: str = Query("全部", description="类型：景点/酒店/美食，默认全部")
):
    data = TravelLocationService.get_nearby_facilities(longitude, latitude, radius, type)
    return BaseResponse(
        code=200,
        message="获取成功",
        data=data
    )