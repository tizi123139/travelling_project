from typing import Optional

from sqlalchemy.orm import Session
from app.dao.FoodDAO import FoodDAO
from app.schemas.food import FoodListItem, FoodDetail, ShopItem
from fastapi import HTTPException
import json


class FoodService:
    @staticmethod
    def get_food_list(db: Session, destination: str, type: Optional[str] = None):
        foods = FoodDAO.get_food_list(db, destination, type)
        if not foods:
            raise HTTPException(status_code=404, detail="未找到该目的地的美食")
        return [FoodListItem.model_validate(f) for f in foods]

    @staticmethod
    def get_food_detail(db: Session, foodId: str):
        food = FoodDAO.get_food_detail(db, foodId)
        if not food:
            raise HTTPException(status_code=404, detail="美食不存在")

        # 处理配料：逗号分隔转列表
        ingredient_list = food.ingredient.split(",") if food.ingredient else []
        # 处理店铺列表：JSON字符串转对象
        shop_list = json.loads(food.shopListJson) if food.shopListJson else []
        shop_items = [ShopItem(**item) for item in shop_list]

        return FoodDetail(
            foodId=food.foodId,
            name=food.name,
            feature=food.feature,
            ingredient=ingredient_list,
            shopList=shop_items
        )