from sqlalchemy.orm import Session
from app.models.intangible import Intangible
from typing import List, Optional

class IntangibleDAO:
    @staticmethod
    def get_intangible_list(db: Session, region: str = None) -> List[Intangible]:
        query = db.query(Intangible)
        # 如果传了 region 且不是“全部”，按大区筛选
        if region is not None and region != "全部":
            query = query.filter(Intangible.region == region)
        return query.all()

    @staticmethod
    def get_intangible_detail(db: Session, id: str) -> Optional[Intangible]:
        return db.query(Intangible).filter(Intangible.id == id).first()