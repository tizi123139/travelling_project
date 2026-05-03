from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

# ---------------------- 照片列表响应项 ----------------------
class PhotoWallItem(BaseModel):
    photoId: str
    imgUrl: str
    userId: str
    nickname: str
    createTime: datetime
    likeNum: int

    class Config:
        from_attributes = True

# ---------------------- 分页响应包装 ----------------------
class PhotoWallListResponseData(BaseModel):
    total: int
    list: List[PhotoWallItem]

# ---------------------- 上传照片响应 ----------------------
class PhotoUploadResponseData(BaseModel):
    photoId: str
    imgUrl: str