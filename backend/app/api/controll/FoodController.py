from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from app.services.FoodService import FoodService
from app.schemas.food import FoodListItem, FoodDetail
from app.core.base_response import BaseResponse
from app.db.session import get_db
from typing import Optional, List

router = APIRouter()

# 1. 获取目的地美食列
@router.get("/list", response_model=BaseResponse, summary="获取目的地美食列表")
def get_food_list(
    destination: str = Query(..., description="目的地城市，如：武汉"),
    type: Optional[str] = Query(None, description="美食类型：小吃/正餐/甜品，默认全部"),
    db: Session = Depends(get_db)
):
    data = FoodService.get_food_list(db, destination, type)
    return BaseResponse(data=data)  # data 是 List[FoodListItem]，自动序列化

# 2. 获取美食详情
@router.get("/detail", response_model=BaseResponse, summary="获取美食详情")
def get_food_detail(
    foodId: str = Query(..., description="美食唯一ID，如：F001"),
    db: Session = Depends(get_db)
):
    data = FoodService.get_food_detail(db, foodId)
    return BaseResponse(data=data)  # data 是 FoodDetail，自动序列化