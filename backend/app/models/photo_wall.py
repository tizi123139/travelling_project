from sqlalchemy import Column, String, Integer, DateTime
from app.db.base import Base
import datetime

class PhotoWall(Base):
    __tablename__ = "photo_wall"

    photoId = Column(String(32), primary_key=True, index=True)
    scenicId = Column(String(32), nullable=False, index=True)
    userId = Column(String(32), nullable=False)
    nickname = Column(String(50))
    imgUrl = Column(String(255), nullable=False)
    description = Column(String(100))
    createTime = Column(DateTime, default=datetime.datetime.now)
    likeNum = Column(Integer, default=0)