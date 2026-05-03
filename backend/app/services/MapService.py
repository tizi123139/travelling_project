from app.core.map_baidu import get_route_plan, get_location_coordinate
from app.schemas.map import RouteData, CoordinateData
from fastapi import HTTPException

class MapService:
    @staticmethod
    def get_route(origin: str, destination: str, travel_type: str) -> RouteData:
        route_info = get_route_plan(origin, destination, travel_type)
        return RouteData(**route_info)

    @staticmethod
    def get_coordinate(name: str, city: str) -> CoordinateData:
        coord_info = get_location_coordinate(name, city)
        return CoordinateData(**coord_info)