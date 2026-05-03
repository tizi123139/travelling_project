from sqlalchemy import Column, Integer, String, Text, DECIMAL, TIMESTAMP, func
from app.db.base import Base

class MobileHouse(Base):
    __tablename__ = "mobile_house"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(100), nullable=False)
    intro = Column(Text)
    cover_image = Column(String(255))
    address = Column(String(255), nullable=False)
    location_lng = Column(DECIMAL(10,6))
    location_lat = Column(DECIMAL(10,6))
    contact = Column(String(50), nullable=False)
    price = Column(DECIMAL(10,2), nullable=False)
    checkin_time = Column(String(50))
    checkout_time = Column(String(50))
    tags = Column(String(255))  # 逗号分隔
    rating = Column(DECIMAL(3,2), default=5.00)
    review_count = Column(Integer, default=0)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, onupdate=func.now())