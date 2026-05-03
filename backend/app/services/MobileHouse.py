from sqlalchemy.orm import Session
from app.models.mobile_house import MobileHouse
from app.schemas.mobile_house import MobileHouseCreate, MobileHouseUpdate
from typing import Optional, List

class CRUDMobileHouse:
    def get_multi(self, db: Session, skip: int = 0, limit: int = 10) -> List[MobileHouse]:
        return db.query(MobileHouse).offset(skip).limit(limit).all()

    def get_by_id(self, db: Session, id: int) -> Optional[MobileHouse]:
        return db.query(MobileHouse).filter(MobileHouse.id == id).first()

mobile_house = CRUDMobileHouse()