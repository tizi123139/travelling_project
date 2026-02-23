from sqlalchemy.orm import Session
from app.dao.IntangibleDAO import IntangibleDAO
from app.schemas.intangible import IntangibleListItem, IntangibleDetail
from fastapi import HTTPException


class IntangibleService:
    @staticmethod
    def get_intangible_list(db: Session, destination: str):
        items = IntangibleDAO.get_intangible_list(db, destination)
        if not items:
            raise HTTPException(status_code=404, detail="未找到该目的地的非遗项目")
        return [IntangibleListItem.model_validate(item) for item in items]

    @staticmethod
    def get_intangible_detail(db: Session, id: str):
        item = IntangibleDAO.get_intangible_detail(db, id)
        if not item:
            raise HTTPException(status_code=404, detail="非遗项目不存在")

        # 处理体验项目：逗号分隔转列表
        experience_list = item.experience.split(",") if item.experience else []

        return IntangibleDetail(
            id=item.id,
            name=item.name,
            level=item.level,
            history=item.history,
            experience=experience_list,
            shop=item.shop
        )