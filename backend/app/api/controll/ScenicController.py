from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from app.services.ScenicService import ScenicService
from app.schemas.attractions import ScenicListResponseData, ScenicDetail
from app.core.base_response import BaseResponse
from app.db.session import get_db
from typing import Optional

router = APIRouter()

# 1. 获取热门景区列表（分页）
@router.get("/hot", response_model=BaseResponse, summary="获取热门景区列表")
def get_hot_scenic(
    pageNum: int = Query(1, ge=1, description="页码，默认1"),
    pageSize: int = Query(10, ge=1, description="每页条数，默认10"),
    db: Session = Depends(get_db)
):
    data = ScenicService.get_scenic_list(db,  pageNum, pageSize)
    return BaseResponse(data=data)

# 2. 获取景区详情
@router.get("/detail", response_model=BaseResponse, summary="获取景区详情")
def get_scenic_detail(
    scenicId: str = Query(..., description="景区唯一ID，如：S001"),
    db: Session = Depends(get_db)
):
    data = ScenicService.get_scenic_detail(db, scenicId)
    return BaseResponse(data=data)