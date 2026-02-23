from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from app.services.IntangibleService import IntangibleService
from app.schemas.intangible import IntangibleListItem, IntangibleDetail
from app.core.base_response import BaseResponse
from app.db.session import get_db
from typing import Optional

router = APIRouter()

# 1. 获取目的地非遗列表
@router.get("/list", response_model=BaseResponse, summary="获取目的地非遗列表")
def get_intangible_list(
    destination: str = Query(..., description="目的地城市，如：武汉"),
    db: Session = Depends(get_db)
):
    data = IntangibleService.get_intangible_list(db, destination)
    return BaseResponse(data=data)

# 2. 获取非遗详情
@router.get("/detail", response_model=BaseResponse, summary="获取非遗详情")
def get_intangible_detail(
    id: str = Query(..., description="非遗项目唯一ID，如：I001"),
    db: Session = Depends(get_db)
):
    data = IntangibleService.get_intangible_detail(db, id)
    return BaseResponse(data=data)