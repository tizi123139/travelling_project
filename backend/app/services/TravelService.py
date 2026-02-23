from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.dao.TravelDAO import TravelPlanDAO
from app.schemas.travel_plan import TravelPlanRequest, TravelPlanData, TravelPlanListItem
import json
import datetime
from typing import List


# AI生成行程函数（无需修改）
def generate_ai_plan(req: TravelPlanRequest) -> dict:
    return {
        "itinerary": [
            {"day": 1, "activities": [f"抵达{req.destination} → 入住酒店 → 品尝当地小吃", "夜游地标景点"]},
            {"day": 2, "activities": ["核心景点游览", "非遗文化体验"]},
            {"day": req.travelTime, "activities": ["自由购物 → 返程"]}
        ],
        "hotel": {
            "name": f"舒适型酒店（{req.destination}市中心）",
            "address": f"{req.destination}市核心商圈",
            "price": int(req.travelCost / req.travelTime * 0.4),
            "star": "四星"
        },
        "food": [
            {"name": f"{req.destination}特色小吃1", "shop": "老字号店铺", "price": 20},
            {"name": f"{req.destination}特色小吃2", "shop": "网红店", "price": 35}
        ],
        "tips": f"1. {req.destination}当前气温20℃，建议携带薄外套；2. 本地交通以地铁为主，方便快捷；3. 预算{req.travelCost}元足够覆盖{req.travelTime}天行程。"
    }


class TravelPlanService:
    @staticmethod
    def generate_travel_plan(db: Session, req: TravelPlanRequest) -> TravelPlanData:
        """生成行程（外键兜底，无需手动查用户）"""
        # 1. 生成唯一行程ID
        plan_id = f"TP{datetime.datetime.now().strftime('%Y%m%d%H%M%S%f')}"

        # 2. 调用AI生成行程
        ai_result = generate_ai_plan(req)

        # 3. 转换JSON字符串
        itinerary_json = json.dumps(ai_result["itinerary"], ensure_ascii=False)
        hotel_json = json.dumps(ai_result["hotel"], ensure_ascii=False)
        food_json = json.dumps(ai_result["food"], ensure_ascii=False)
        tips = ai_result["tips"]

        # 4. 调用DAO创建行程（捕获外键异常）
        try:
            plan = TravelPlanDAO.create_plan(
                db=db,
                plan_id=plan_id,
                user_id=req.userId,
                destination=req.destination,
                travel_time=req.travelTime,
                travel_cost=req.travelCost,
                travel_purpose=req.travelPurpose,
                detailed_plan=req.detailedPlan,
                itinerary_json=itinerary_json,
                hotel_json=hotel_json,
                food_json=food_json,
                tips=tips
            )
        except ValueError as e:
            # 捕获DAO层的异常，转为HTTP异常
            if "用户ID不存在" in str(e):
                raise HTTPException(status_code=404, detail="用户不存在")
            elif "行程ID已存在" in str(e):
                raise HTTPException(status_code=400, detail="行程创建失败，ID重复")
            else:
                raise HTTPException(status_code=500, detail=str(e))

        # 5. 构建返回数据
        return TravelPlanData(
            planId=plan.planId,
            userId=plan.user_id,
            destination=plan.destination,
            travelTime=plan.travelTime,
            travelCost=plan.travelCost,
            itinerary=ai_result["itinerary"],
            hotel=ai_result["hotel"],
            food=ai_result["food"],
            tips=plan.tips
        )

    @staticmethod
    def get_user_plan_list(db: Session, user_id: int) -> List[TravelPlanListItem]:
        """查询用户行程列表（外键确保user_id合法）"""
        plans = TravelPlanDAO.get_user_plans(db, user_id)
        if not plans:
            raise HTTPException(status_code=404, detail="该用户暂无行程规划")
        return [TravelPlanListItem.model_validate(plan) for plan in plans]

    @staticmethod
    def get_plan_detail(db: Session, plan_id: str, user_id: int) -> TravelPlanData:
        """查询行程详情（校验归属）"""
        plan = TravelPlanDAO.get_plan_by_id(db, plan_id, user_id)
        if not plan:
            raise HTTPException(status_code=404, detail="行程不存在或无访问权限")

        # 解析JSON
        itinerary = json.loads(plan.itineraryJson) if plan.itineraryJson else []
        hotel = json.loads(plan.hotelJson) if plan.hotelJson else {}
        food = json.loads(plan.foodJson) if plan.foodJson else []

        return TravelPlanData(
            planId=plan.planId,
            userId=plan.user_id,
            destination=plan.destination,
            travelTime=plan.travelTime,
            travelCost=plan.travelCost,
            itinerary=itinerary,
            hotel=hotel,
            food=food,
            tips=plan.tips
        )