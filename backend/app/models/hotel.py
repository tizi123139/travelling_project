from sqlalchemy import Column, Integer, String, Float, JSON, DateTime
from app.db.base import Base
import datetime

class Hotel(Base):
    """酒店表模型"""
    __tablename__ = "hotel"

    hotelId = Column(String(32), primary_key=True, index=True, comment="酒店唯一ID")
    name = Column(String(100), index=True, comment="酒店名称")
    address = Column(String(200), comment="酒店地址")
    price = Column(Float, comment="酒店单价（元/晚）")
    star = Column(String(10), comment="酒店星级（三星/四星/五星）")
    distance = Column(String(50), comment="距商圈/地铁距离")
    facility = Column(String(200), comment="酒店设施，逗号分隔（免费WiFi,停车场,早餐）")
    roomType = Column(String(200), comment="房型，逗号分隔（标准间,大床房,家庭房）")
    commentScore = Column(Float, comment="点评分数")


class HotelBook(Base):
    """酒店预订订单表模型"""
    __tablename__ = "hotel_book"

    orderId = Column(String(32), primary_key=True, index=True, comment="订单唯一ID")
    hotelId = Column(String(32), index=True, comment="酒店ID")
    hotelName = Column(String(100), comment="酒店名称")
    roomType = Column(String(50), comment="预订房型")
    checkIn = Column(String(20), comment="入住日期")
    checkOut = Column(String(20), comment="离店日期")
    userId = Column(String(32), index=True, comment="用户ID")
    contactName = Column(String(50), comment="联系人姓名")
    contactPhone = Column(String(20), comment="联系人电话")
    totalPrice = Column(Float, comment="订单总价")
    orderStatus = Column(String(20), default="待支付", comment="订单状态（待支付/已支付/已取消）")
    createTime = Column(DateTime, default=datetime.datetime.now, comment="创建时间")