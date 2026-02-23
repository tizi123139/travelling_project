from sqlalchemy.orm import Session
from app.models.intangible import Intangible
from typing import List, Optional

class IntangibleDAO:
    @staticmethod
    def get_intangible_list(db: Session, destination: str) -> List[Intangible]:
        return db.query(Intangible).filter(Intangible.destination == destination).all()

    @staticmethod
    def get_intangible_detail(db: Session, id: str) -> Optional[Intangible]:
        return db.query(Intangible).filter(Intangible.id == id).first()