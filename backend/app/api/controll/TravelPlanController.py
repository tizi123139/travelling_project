from fastapi import APIRouter, HTTPException, status,Depends
from pydantic import BaseModel, Field
from typing import Optional
import uuid

from sqlalchemy.orm import Session

from app.dao.TravelDAO import TravelPlanDAO
from app.db.session import get_db
from app.schemas.travel_plan import TravelPlanRequest
from app.services.TravelPlanService import TravelPlanService

# 路由配置
router = APIRouter(
    prefix="/plan",
    tags=["旅行规划模块"]
)

# 统一响应模型
class TravelPlanResponse(BaseModel):
    code: int = 200
    message: str = "success"
    data: Optional[dict] = None

# 生成旅行规划接口
def get_house_recommend(db: Session, dest: str, limit=3):
    try:
        from app.services.MobileHouse import mobile_house
        houses = mobile_house.get_multi(db, limit=20)
        res = []
        dest_low = dest.lower()

        for h in houses:
            addr_low = (h.address or "").lower()
            title_low = (h.title or "").lower()
            if dest_low in addr_low or dest_low in title_low:
                # ✅ 关键：把对象转成字典，才能序列化
                res.append({
                    "name": h.title,
                    "price": f"{h.price}元/晚",
                    "address": h.address,
                    "rating": float(h.rating) if h.rating else 0.0,
                    "tags": h.tags
                })
                if len(res) >= limit:
                    break

        # 不够就随机补
        if len(res) < limit:
            others = []
            for h in houses:
                addr_low = (h.address or "").lower()
                title_low = (h.title or "").lower()
                if not (dest_low in addr_low or dest_low in title_low):
                    others.append(h)
            import random
            random.shuffle(others)
            for h in others[:limit - len(res)]:
                res.append({
                    "name": h.title,
                    "price": f"{h.price}元/晚",
                    "address": h.address,
                    "rating": float(h.rating) if h.rating else 0.0,
                    "tags": h.tags
                })
        return res
    except Exception as e:
        print("民宿推荐错误:", e)
        return []

# 生成旅行规划接口
@router.post("/generate", response_model=TravelPlanResponse, summary="生成AI旅行规划")
async def generate_travel_plan(
    request: TravelPlanRequest,
    db: Session = Depends(get_db)
):
    try:
        service_params = {
            "destination": request.destination,
            "travelTime": request.travelTime,
            "travelCost": request.travelCost,
            "travelPurpose": request.travelPurpose,
            "detailedPlan": request.detailedPlan,
        }

        ai_plan_data = TravelPlanService.generate_travel_plan(service_params)



        plan_id = f"TP{uuid.uuid4().hex[:10]}"

        itinerary_json = str(ai_plan_data.get("itinerary", []))
        hotel_json = str(ai_plan_data.get("hotel", {}))
        food_json = str(ai_plan_data.get("food", []))
        tips = ai_plan_data.get("tips", "")
        features_json = str(ai_plan_data.get("features", []))

        db_plan = TravelPlanDAO.create_plan(
            db=db,
            plan_id=plan_id,
            user_id=request.userId,
            destination=request.destination,
            travel_time=request.travelTime,
            travel_cost=request.travelCost,
            travel_purpose=request.travelPurpose,
            detailed_plan=request.detailedPlan,
            itinerary_json=itinerary_json,
            hotel_json=hotel_json,
            food_json=food_json,
            tips=tips,
            features=features_json
        )

        response_data = {
            "planId": db_plan.planId,
            "userId": db_plan.user_id,
            "destination": db_plan.destination,
            "travelTime": db_plan.travelTime,
            "travelCost": db_plan.travelCost,
            "itinerary": ai_plan_data.get("itinerary", []),
            "hotel": ai_plan_data.get("hotel", ""),  # 酒店（AI推荐）
            "guesthouses": get_house_recommend(db, request.destination, 3),
            "food": ai_plan_data.get("food", []),
            "tips": db_plan.tips,
            "features": ai_plan_data.get("features", [])
        }

        return {
            "code": 200,
            "message": "旅行规划生成并保存成功",
            "data": response_data
        }

    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"code": 400, "message": str(e), "data": None}
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail={"code": 500, "message": f"生成失败：{str(e)}", "data": None}
        )