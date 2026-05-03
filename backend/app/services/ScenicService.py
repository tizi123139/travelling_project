from sqlalchemy.orm import Session
from app.dao.ScenicDAO import ScenicDAO
from app.schemas.attractions import ScenicListItem, ScenicDetail, ScenicListResponseData
from fastapi import HTTPException
import re

class ScenicService:
    @staticmethod
    def get_scenic_list(
            db: Session,
            pageNum: int = 1,
            pageSize: int = 10
    ) -> ScenicListResponseData:
        items, total = ScenicDAO.get_scenic_list(db, pageNum, pageSize)
        if not items:
            raise HTTPException(status_code=404, detail="未找到该目的地的景区")
        scenic_list = []
        for item in items:
            tags_en = re.split(r'[,|]', item.tagsEn) if item.tagsEn else []
            scenic_list.append({
                "scenicId": item.scenicId,
                "name": item.name,
                "nameEn": item.nameEn or "",  # 新增英文名称
                "price": float(item.price) if item.price else 0.0,
                "score": float(item.score) if hasattr(item, 'score') and item.score else 0.0,
                "imgUrl1": item.imgUrl1 or "",
                "rating": float(item.score) if hasattr(item, 'score') and item.score else 0.0,
                "reviewCount": item.review_count or 0,
                "distance": item.distance or "",
                "address": item.address or "",
                "addressEn": item.addressEn or "",  # 新增英文地址
                "type": item.type or "",
                "introduction": item.introduction or "",
                "introductionEn": item.introductionEn or "",  # 新增英文简介
                "tags": re.split(r'[,|]', item.tags) if item.tags else [],
                "tagsEn": tags_en,  # 新增英文标签列表
                "priceLevel": item.priceLevel or "",
                "latitude": float(item.latitude) if item.latitude else 0.0,
                "longitude": float(item.longitude) if item.longitude else 0.0
            })

        return ScenicListResponseData(
            total=total,
            list=scenic_list
        )

    @staticmethod
    def get_scenic_detail(db: Session, scenicId: str) -> ScenicDetail:
        item = ScenicDAO.get_scenic_detail(db, scenicId)
        if not item:
            raise HTTPException(status_code=404, detail="景区不存在")
        tags_en = re.split(r'[,|]', item.tagsEn) if item.tagsEn else []

        return ScenicDetail(
            scenicId=item.scenicId,
            name=item.name,
            nameEn=item.nameEn or "",  # 新增英文名称
            price=float(item.price) if item.price else 0.0,
            openingTime=item.openingTime or "",
            introduction=item.introduction or "",
            introductionEn=item.introductionEn or "",  # 新增英文简介
            traffic=item.traffic.split(",") if item.traffic else [],
            # 原有字段
            rating=float(item.score) if hasattr(item, 'score') and item.score else 0.0,
            reviewCount=item.review_count or 0,
            address=item.address or "",
            addressEn=item.addressEn or "",  # 新增英文地址
            category=item.category or "",
            latitude=float(item.latitude) if item.latitude else 0.0,
            longitude=float(item.longitude) if item.longitude else 0.0,
            tags=re.split(r'[,|]', item.tags) if item.tags else [],
            tagsEn=tags_en,  # 新增英文标签列表
            type=item.type or "",
            priceLevel=item.priceLevel or "",
            distance=item.distance or ""
        )