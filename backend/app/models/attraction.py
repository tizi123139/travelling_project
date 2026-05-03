from pyasn1.type.univ import Integer
from sqlalchemy import Column, String, Float, Text, DECIMAL,Integer
from app.db.base import Base

class Attractions(Base):
    __tablename__ = "attractions"

    scenicId = Column(String(32), primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    nameEn = Column(String(100))  # 新增：英文名称
    destination = Column(String(50), nullable=False)
    price = Column(DECIMAL(10, 2))
    score = Column(DECIMAL(2, 1))
    rating = Column(DECIMAL(2, 1), default=0.0)
    review_count = Column(Integer, default=0)
    reviewCount = Column(Integer, default=0)  # 兼容字段
    imgUrl1 = Column(String(255))
    category = Column(String(50))
    openingTime = Column(String(50))
    introduction = Column(Text)
    introductionEn = Column(Text)  # 新增：英文简介
    traffic = Column(String(500))
    address = Column(String(200))
    addressEn = Column(String(200))  # 新增：英文地址
    latitude = Column(DECIMAL(10, 8))
    longitude = Column(DECIMAL(11, 8))
    tags = Column(String(200))
    tagsEn = Column(String(200))  # 新增：英文标签（逗号/竖线分隔）
    distance = Column(String(20))
    priceLevel = Column(String(10))
    type = Column(String(20))