import requests
from fastapi import HTTPException

# 替换为你的百度地图AK
<<<<<<< Updated upstream
BAIDU_MAP_AK = "DO52es5XqOzasKMQWvAM2PjBBn72dAJ5"
=======
BAIDU_MAP_AK = ""
>>>>>>> Stashed changes
BAIDU_BASE_URL = "https://api.map.baidu.com"


def get_city_location(city: str) -> dict:
    """
    百度地图 - 地理编码：获取城市坐标和adcode
    """
    url = f"{BAIDU_BASE_URL}/geocoding/v3/"
    params = {
        "address": city,
        "output": "json",
        "ak": BAIDU_MAP_AK
    }
    try:
        resp = requests.get(url, params=params, timeout=10)
        resp.raise_for_status()
        data = resp.json()

        if data.get("status") != 0 or not data.get("result"):
            raise HTTPException(status_code=404, detail=f"未找到城市: {data.get('message')}")

        result = data["result"]
        # 修正：从 addressComponent 中获取 adcode
        adcode = result.get("addressComponent", {}).get("adcode", "")

        return {
            "city": city,
            "longitude": float(result["location"]["lng"]),
            "latitude": float(result["location"]["lat"]),
            "adcode": adcode
        }
    except KeyError as e:
        print(f"百度地理编码返回: {data}")
        raise HTTPException(status_code=500, detail=f"城市坐标查询失败: 缺少关键字段 {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"城市坐标查询失败: {str(e)}")

def get_city_weather(city: str) -> str:
    """
    百度天气接口 - 使用城市名直接查询
    """
    url = "https://api.map.baidu.com/weather/v1/"
    params = {
        "ak": BAIDU_MAP_AK,
        "location": city,  # 直接传城市名，如"武汉"
        "output": "json",
        "data_type": "now"
    }

    try:
        resp = requests.get(url, params=params, timeout=10)
        resp.raise_for_status()
        data = resp.json()

        if data.get("status") != 0:
            print(f"百度天气返回错误: {data}")
            return "晴, 20℃"

        now = data["result"]["now"]
        return f"{now['text']}, {now['temp']}℃"

    except Exception as e:
        print(f"天气查询异常: {str(e)}")
        return "晴, 20℃"

def get_nearby_poi(
    longitude: float,
    latitude: float,
    radius: int = 5000,
    poi_type: str = "全部"
) -> list:
    """
    百度地图 - 周边POI搜索（景点/酒店/美食）
    """
    type_map = {
        "景点": "110000",    # 旅游景点
        "酒店": "140000",    # 酒店住宿
        "美食": "050000",    # 餐饮服务
        "全部": ""           # 不限类型
    }
    if poi_type not in type_map:
        raise HTTPException(status_code=400, detail="不支持的类型（仅支持：景点/酒店/美食/全部）")

    url = f"{BAIDU_BASE_URL}/place/v2/search"
    params = {
        "ak": BAIDU_MAP_AK,
        "output": "json",
        "location": f"{latitude},{longitude}",  # 百度格式：lat,lng
        "radius": radius,
        "query": type_map[poi_type],
        "page_size": 20,
        "scope": 2
    }
    try:
        resp = requests.get(url, params=params, timeout=10)
        resp.raise_for_status()
        data = resp.json()

        if data.get("status") != 0:
            raise HTTPException(status_code=500, detail=f"周边查询失败: {data.get('message')}")

        pois = data.get("results", [])
        result = []
        for poi in pois:
            distance = f"{float(poi.get('distance', 0)) / 1000:.1f}km"
            result.append({
                "name": poi["name"],
                "type": poi["type"].split(";")[0],
                "distance": distance,
                "address": poi.get("address", "无详细地址")
            })
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"周边查询失败: {str(e)}")