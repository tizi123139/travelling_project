from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from app.services.TravelService import TravelPlanService
from app.schemas.travel_plan import TravelPlanRequest
from app.core.base_response import BaseResponse
from app.db.session import get_db

router = APIRouter()

# 1. 生成AI行程
@router.post("/generate", response_model=BaseResponse, summary="生成AI旅行规划")
def generate_travel_plan(
    req: TravelPlanRequest,
    db: Session = Depends(get_db)
):
    data = TravelPlanService.generate_travel_plan(db, req)
    return BaseResponse(
        code=200,
        message="AI旅行规划生成成功",
        data=data
    )

# 2. 查询用户行程列表
@router.get("/list", response_model=BaseResponse, summary="查询用户行程列表")
def get_user_plan_list(
    userId: int = Query(..., description="用户ID（关联users表id）"),
    db: Session = Depends(get_db)
):
    data = TravelPlanService.get_user_plan_list(db, userId)
    return BaseResponse(data=data)

# 3. 查询行程详情
@router.get("/detail", response_model=BaseResponse, summary="查询行程详情")
def get_plan_detail(
    planId: str = Query(..., description="行程ID"),
    userId: int = Query(..., description="用户ID（关联users表id）"),
    db: Session = Depends(get_db)
):
    data = TravelPlanService.get_plan_detail(db, planId, userId)
    return BaseResponse(data=data)