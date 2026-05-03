from sqlalchemy.orm import Session
from app.dao.IntangibleDAO import IntangibleDAO
from app.schemas.intangible import IntangibleListItem, IntangibleDetail
from fastapi import HTTPException


class IntangibleService:
    @staticmethod
    def get_intangible_list(db: Session, region: str = None):
        items = IntangibleDAO.get_intangible_list(db, region)
        if not items:
            return []  # 空数据直接返回空列表，不再抛 404

        result = []
        for item in items:
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
                "posts": []
            })
        return result

