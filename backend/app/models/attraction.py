from sqlalchemy import Column, String, Float, Text, DECIMAL
from app.db.base import Base

class Attractions(Base):
    __tablename__ = "attractions"

    scenicId = Column(String(32), primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    destination = Column(String(50), nullable=False)
    price = Column(DECIMAL(10,2))
    score = Column(DECIMAL(2,1))
    imgUrl1 = Column(String(255))
    openingTime = Column(String(50))
    introduction = Column(Text)
    traffic = Column(String(500))
    ticketUrl = Column(String(255))