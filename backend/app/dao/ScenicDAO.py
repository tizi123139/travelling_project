from sqlalchemy.orm import Session
from app.models.attraction import Attractions
from typing import List, Optional

class ScenicDAO:
    @staticmethod
    def get_scenic_list(
        db: Session,
        pageNum: int = 1,
        pageSize: int = 10
    ) -> (List[Attractions], int):
        # 分页查询
        query = db.query(Attractions)
        total = query.count()
        items = query.offset((pageNum - 1) * pageSize).limit(pageSize).all()
        return items, total

    @staticmethod
    def get_scenic_detail(db: Session, scenicId: str) -> Optional[Attractions]:
        return db.query(Attractions).filter(Attractions.scenicId == scenicId).first()