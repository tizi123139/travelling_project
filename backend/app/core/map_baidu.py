import requests
from fastapi import HTTPException

# 替换为你的百度地图AK
BAIDU_MAP_AK = ""
BAIDU_BASE_URL = "https://api.map.baidu.com"

def get_route_plan(origin: str, destination: str, travel_type: str) -> dict:
    """
    百度地图 - 路线规划
    origin/destination: 经纬度（格式：lng,lat）或详细地址
    travel_type: driving/transit/walking
    """
    route_map = {
        "driving": "/direction/v2/driving",
        "transit": "/direction/v2/transit",
        "walking": "/direction/v2/walking"
    }
    if travel_type not in route_map:
        raise HTTPException(status_code=400, detail="不支持的出行方式")

    url = f"{BAIDU_BASE_URL}{route_map[travel_type]}"
    params = {
        "ak": BAIDU_MAP_AK,
        "output": "json",
        "origin": origin,
        "destination": destination
    }

    try:
        resp = requests.get(url, params=params, timeout=10)
        resp.raise_for_status()
        data = resp.json()

        if data.get("status") != 0:
            raise HTTPException(status_code=500, detail=f"路线规划失败: {data.get('message')}")

        result = data["result"]
        if travel_type == "transit":
            route = result["routes"][0]
            distance = f"{float(route['distance']) / 1000:.1f}km"
            duration = f"{int(route['duration']) // 60}分钟"
            steps = [step["instructions"] for step in route["steps"]]
        else:
            route = result["routes"][0]
            distance = f"{float(route['distance']) / 1000:.1f}km"
            duration = f"{int(route['duration']) // 60}分钟"
            steps = [step["instruction"] for step in route["steps"]]

        return {
            "distance": distance,
            "duration": duration,
            "steps": steps
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"路线规划失败: {str(e)}")


def get_location_coordinate(name: str, city: str) -> dict:
    """
    百度地图 - 地点检索：获取景点/酒店的坐标和详细地址
    """
    # 使用地点检索接口（Place API）
    url = f"{BAIDU_BASE_URL}/place/v2/search"
    params = {
        "query": name,  # 搜索关键词：景点/酒店名称
        "region": city,  # 限定城市
        "output": "json",
        "ak": BAIDU_MAP_AK,
        "page_size": 1  # 只返回最相关的一条结果
    }

    try:
        resp = requests.get(url, params=params, timeout=10)
        resp.raise_for_status()
        data = resp.json()

        if data.get("status") != 0 or not data.get("results"):
            raise HTTPException(status_code=404, detail=f"未找到地点: {data.get('message')}")

        # 取第一条结果
        poi = data["results"][0]

        # 从地点详情中提取信息
        longitude = float(poi["location"]["lng"])
        latitude = float(poi["location"]["lat"])
        address = poi.get("address", "无详细地址")
        name = poi.get("name", name)  # 如果有更标准的名称，就用它

        return {
            "name": name,
            "longitude": longitude,
            "latitude": latitude,
            "address": address
        }
    except KeyError as e:
        print(f"百度地点API返回: {data}")
        raise HTTPException(status_code=500, detail=f"坐标查询失败: 缺少关键字段 {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"坐标查询失败: {str(e)}")