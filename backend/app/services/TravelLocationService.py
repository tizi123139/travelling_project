from app.core.travel_location_baidu import get_city_location, get_city_weather, get_nearby_poi
from app.schemas.travel_location import CityLocationData, NearbyPoiItem
from fastapi import HTTPException
from typing import List

class TravelLocationService:
    @staticmethod
    def get_destination_location(destination: str) -> CityLocationData:
        """获取目的地位置信息（坐标+天气+交通）"""
        location = get_city_location(destination)
        weather = get_city_weather(destination)
        # 示例交通（可扩展为真实地铁查询）
        traffic = ["地铁2号线", "4号线", "8号线"]
        return CityLocationData(
            city=location["city"],
            longitude=location["longitude"],
            latitude=location["latitude"],
            weather=weather,
            traffic=traffic
        )

    @staticmethod
    def get_nearby_facilities(
        longitude: float,
        latitude: float,
        radius: int = 5000,
        poi_type: str = "全部"
    ) -> List[NearbyPoiItem]:
        """获取周边景点/酒店/美食"""
        pois = get_nearby_poi(longitude, latitude, radius, poi_type)
        if not pois:
            raise HTTPException(status_code=404, detail="该位置周边暂无相关设施")
        return [NearbyPoiItem(**poi) for poi in pois]