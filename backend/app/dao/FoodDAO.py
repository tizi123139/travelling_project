from sqlalchemy.orm import Session
from app.models.food import Food
from typing import List, Optional

class FoodDAO:
    @staticmethod
    def get_food_list(db: Session, type: Optional[str] = None) -> List[Food]:
        query = db.query(Food)
        if type:
            query = query.filter(Food.type == type)
        return query.all()

    @staticmethod
    def get_food_detail(db: Session, foodId: str) -> Optional[Food]:
        return db.query(Food).filter(Food.foodId == foodId).first()