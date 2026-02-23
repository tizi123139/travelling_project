from sqlalchemy.orm import Session
from app.dao.ScenicDAO import ScenicDAO
from app.schemas.attractions import ScenicListItem, ScenicDetail, ScenicListResponseData
from fastapi import HTTPException


class ScenicService:
    @staticmethod
    def get_scenic_list(
            db: Session,
            destination: str,
            pageNum: int = 1,
            pageSize: int = 10
    ) -> ScenicListResponseData:
        items, total = ScenicDAO.get_scenic_list(db, destination, pageNum, pageSize)
        if not items:
            raise HTTPException(status_code=404, detail="未找到该目的地的景区")
        return ScenicListResponseData(
            total=total,
            list=[ScenicListItem.model_validate(item) for item in items]
        )

    @staticmethod
    def get_scenic_detail(db: Session, scenicId: str) -> ScenicDetail:
        item = ScenicDAO.get_scenic_detail(db, scenicId)
        if not item:
            raise HTTPException(status_code=404, detail="景区不存在")

        # 处理交通方式：逗号分隔转列表
        traffic_list = item.traffic.split(",") if item.traffic else []

        return ScenicDetail(
            scenicId=item.scenicId,
            name=item.name,
            price=float(item.price),
            openingTime=item.openingTime,
            introduction=item.introduction,
            traffic=traffic_list,
            ticketUrl=item.ticketUrl
        )