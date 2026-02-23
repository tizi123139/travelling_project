from fastapi import APIRouter, Depends, Query, UploadFile, File, Form
from sqlalchemy.orm import Session
from app.services.PhotoWallService import PhotoWallService
from app.schemas.photo_wall import PhotoWallListResponseData, PhotoUploadResponseData
from app.core.base_response import BaseResponse
from app.db.session import get_db
from typing import Optional

router = APIRouter()

# 1. 获取景区照片列表（分页）
@router.get("/wall", response_model=BaseResponse, summary="获取用户实拍照片列表")
def get_photo_wall(
    scenicId: str = Query(..., description="景区ID，如：S001"),
    pageNum: int = Query(1, ge=1, description="页码，默认1"),
    pageSize: int = Query(20, ge=1, description="每页条数，默认20"),
    db: Session = Depends(get_db)
):
    data = PhotoWallService.get_photo_list(db, scenicId, pageNum, pageSize)
    return BaseResponse(
        code=200,
        message="获取成功",
        data=data
    )

# 2. 上传实拍照片
@router.post("/upload", response_model=BaseResponse, summary="上传实拍照片")
def upload_photo(
    file: UploadFile = File(..., description="照片文件（支持jpg/png，≤10MB）"),
    scenicId: str = Form(..., description="景区ID，如：S001"),
    userId: str = Form(..., description="用户ID，如：U001"),
    description: Optional[str] = Form(None, description="照片描述（≤100字）"),
    db: Session = Depends(get_db)
):
    data = PhotoWallService.upload_photo(db, file, scenicId, userId, description)
    return BaseResponse(
        code=200,
        message="照片上传成功",
        data=data
    )