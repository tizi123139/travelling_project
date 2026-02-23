from sqlalchemy import Column, String, Float, Text
from app.db.base import Base

class Food(Base):
    __tablename__ = "food"

    foodId = Column(String(32), primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    destination = Column(String(50), nullable=False)
    type = Column(String(20))
    feature = Column(String(200))
    price = Column(Float)
    recommendedShop = Column(String(100))
    ingredient = Column(String(500))
    shopListJson = Column(Text)