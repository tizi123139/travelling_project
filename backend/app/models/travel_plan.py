from sqlalchemy import Column, String, Integer, Text, DateTime, Index
from app.db.base import Base
import datetime

class TravelPlan(Base):
    __tablename__ = "travel_plan"

    planId = Column(String(64), primary_key=True, comment="行程唯一ID")
    user_id = Column(Integer, nullable=False, comment="所属用户ID（关联users表id）")
    destination = Column(String(50), nullable=False, comment="旅行目的地")
    travelTime = Column(Integer, nullable=False, comment="旅行天数")
    travelCost = Column(Integer, nullable=False, comment="旅行预算（元）")
    travelPurpose = Column(String(50), nullable=False, comment="旅行目的")
    detailedPlan = Column(Text, nullable=False, comment="详细旅行需求")
    itineraryJson = Column(Text, comment="行程安排JSON")
    hotelJson = Column(Text, comment="酒店推荐JSON")
    foodJson = Column(Text, comment="美食推荐JSON")
    tips = Column(Text, comment="旅行小贴士")
    features = Column(Text, nullable=True, comment="路线亮点 JSON数组")
    createTime = Column(DateTime, default=datetime.datetime.now, comment="创建时间")

    __table_args__ = (
        Index("idx_user_id", "user_id"),
    )