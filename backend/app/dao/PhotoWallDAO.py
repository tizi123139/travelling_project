from sqlalchemy.orm import Session
from app.models.photo_wall import PhotoWall
from typing import List, Optional
import datetime

class PhotoWallDAO:
    @staticmethod
    def get_photo_list(
        db: Session,
        scenicId: str,
        pageNum: int = 1,
        pageSize: int = 20
    ) -> (List[PhotoWall], int):
        """分页查询景区的照片列表"""
        query = db.query(PhotoWall).filter(PhotoWall.scenicId == scenicId)
        total = query.count()
        items = query.offset((pageNum - 1) * pageSize).limit(pageSize).all()
        return items, total

    @staticmethod
    def create_photo(
        db: Session,
        photo_id: str,
        scenic_id: str,
        user_id: str,
        nickname: str,
        img_url: str,
        description: str = None
    ) -> PhotoWall:
        """创建照片记录"""
        photo = PhotoWall(
            photoId=photo_id,
            scenicId=scenic_id,
            userId=user_id,
            nickname=nickname,
            imgUrl=img_url,
            description=description
        )
        db.add(photo)
        db.commit()
        db.refresh(photo)
        return photo