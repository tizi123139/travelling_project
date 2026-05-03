from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError  # 导入外键冲突异常
from app.models.travel_plan import TravelPlan
from typing import Optional, List
import datetime

class TravelPlanDAO:
    @staticmethod
    def create_plan(
        db: Session,
        plan_id: str,
        user_id: int,
        destination: str,
        travel_time: int,
        travel_cost: int,
        travel_purpose: str,
        detailed_plan: str,
        itinerary_json: str,
        hotel_json: str,
        food_json: str,
        tips: str,
        features: str = "",
    ) -> TravelPlan:
        """创建行程（捕获外键冲突异常）"""
        try:
            plan = TravelPlan(
                planId=plan_id,
                user_id=user_id,
                destination=destination,
                travelTime=travel_time,
                travelCost=travel_cost,
                travelPurpose=travel_purpose,
                detailedPlan=detailed_plan,
                itineraryJson=itinerary_json,
                hotelJson=hotel_json,
                foodJson=food_json,
                tips=tips,
                features=features
            )
            db.add(plan)
            db.commit()
            db.refresh(plan)
            return plan
        except IntegrityError as e:
            db.rollback()  # 回滚事务
            # 识别外键冲突（user_id不存在）
            if "foreign key constraint fails" in str(e).lower():
                raise ValueError("用户ID不存在")
            # 其他完整性异常（比如主键重复）
            elif "duplicate entry" in str(e).lower():
                raise ValueError("行程ID已存在")
            else:
                raise ValueError(f"创建行程失败：{str(e)}")
        except Exception as e:
            db.rollback()
            raise e

    @staticmethod
    def get_plan_by_id(db: Session, plan_id: str, user_id: int) -> Optional[TravelPlan]:
        return db.query(TravelPlan).filter(
            TravelPlan.planId == plan_id,
            TravelPlan.user_id == user_id
        ).first()

    @staticmethod
    def get_user_plans(db: Session, user_id: int) -> List[TravelPlan]:
        return db.query(TravelPlan).filter(
            TravelPlan.user_id == user_id
        ).order_by(TravelPlan.createTime.desc()).all()