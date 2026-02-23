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
<<<<<<< Updated upstream
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
=======

        result = []
        for item in items:
            # 处理多值字段（逗号分隔转列表）
            images = item.images.split(",") if item.images else []
            tags = item.tags.split(",") if item.tags else []

            result.append({
                "id": item.id,
                "name": item.name,
                "category": item.category,
                "region": item.region,
                "description": item.description,
                "images": images,
                "tags": tags,
                "likes": item.likes,
                "shares": item.shares,
                "view_count": item.view_count,
                "experience_location": item.experience_location,
                "experience_contact": item.experience_contact,
                "experience_price": item.experience_price,
                "created_at": item.created_at.isoformat(),
                "posts": []  # 暂时空，可后续扩展用户帖子功能
            })
        return result
>>>>>>> Stashed changes
