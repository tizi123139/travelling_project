from sqlalchemy.orm import Session
from fastapi import HTTPException, UploadFile
import datetime
from app.dao.PhotoWallDAO import PhotoWallDAO
from app.schemas.photo_wall import PhotoWallItem, PhotoWallListResponseData, PhotoUploadResponseData
from app.core.aliyun_oss import upload_file_to_oss  # 导入OSS上传函数


class PhotoWallService:
    @staticmethod
    def get_photo_list(
            db: Session,
            scenicId: str,
            pageNum: int = 1,
            pageSize: int = 20
    ) -> PhotoWallListResponseData:
        """获取景区照片列表（分页）"""
        items, total = PhotoWallDAO.get_photo_list(db, scenicId, pageNum, pageSize)
        if not items:
            raise HTTPException(status_code=404, detail="该景区暂无用户实拍照片")
        return PhotoWallListResponseData(
            total=total,
            list=[PhotoWallItem.model_validate(item) for item in items]
        )

    @staticmethod
    def upload_photo(
            db: Session,
            file: UploadFile,
            scenicId: str,
            userId: str,
            description: str = None
    ) -> PhotoUploadResponseData:
        """上传照片到OSS并写入数据库"""
        # 1. 上传图片到阿里云OSS
        img_url = upload_file_to_oss(file)

        # 2. 生成唯一photoId
        photo_id = f"P{datetime.datetime.now().strftime('%Y%m%d%H%M%S%f')}"

        # 3. 从用户表查询昵称
        nickname = "游客"  # 可通过userId查询users表获取真实昵称

        # 4. 写入数据库
        photo = PhotoWallDAO.create_photo(
            db=db,
            photo_id=photo_id,
            scenic_id=scenicId,
            user_id=userId,
            nickname=nickname,
            img_url=img_url,
            description=description
        )

        return PhotoUploadResponseData(
            photoId=photo.photoId,
            imgUrl=photo.imgUrl
        )