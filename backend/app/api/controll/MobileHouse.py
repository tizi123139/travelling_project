from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import services, schemas
from app.db.session import get_db
from app.services.MobileHouse import mobile_house
from app.schemas.mobile_house import MobileHouseOut

router = APIRouter()

@router.get("/", response_model=List[MobileHouseOut])
def read_mobile_houses(
    skip: int = 0,
    limit: int = 10,
    db: Session = Depends(get_db)
):
    houses = mobile_house.get_multi(db, skip=skip, limit=limit)
    return houses

@router.get("/{id}", response_model=MobileHouseOut)
def read_mobile_house(id: int, db: Session = Depends(get_db)):
    house = mobile_house.get_by_id(db, id=id)
    if not house:
        raise HTTPException(status_code=404, detail="MobileHouse not found")
    return house