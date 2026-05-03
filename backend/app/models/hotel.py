from sqlalchemy import Column, Integer, String, Float, JSON, DateTime,DECIMAL
from app.db.base import Base
import datetime

class Hotel(Base):
    """酒店表模型"""
    __tablename__ = "hotel"

    hotelId = Column(String(32), primary_key=True, index=True, comment="酒店唯一ID")
    name = Column(String(100), index=True, comment="酒店名称")
    name_en = Column(String(100), comment="酒店名称（英文）")
    address = Column(String(200), comment="酒店地址")
    address_en = Column(String(200), comment="酒店地址（英文）")
    image = Column(String(200), comment="酒店主图URL")
    images = Column(String(500), comment="酒店图片列表（逗号分隔，最多3张）")
    price = Column(Float, comment="酒店单价（元/晚）")
    rating = Column(Float, comment="评分（4.9/4.7等）")
    reviewCount = Column(Integer, comment="评论数")
    star = Column(String(10), comment="酒店星级（三星/四星/五星）")
    distance = Column(DECIMAL(5,1), comment="距离（数字，单位km）")  # 数字类型
    facility = Column(String(200), comment="酒店设施，逗号分隔（免费WiFi,停车场,早餐）")
    facility_en = Column(String(200), comment="设施（英文，逗号分隔）")
    roomType = Column(String(200), comment="房型，逗号分隔（标准间,大床房,家庭房）")
    commentScore = Column(Float, comment="点评分数")
    tags = Column(String(200), comment="标签（中文，逗号分隔）")
    tags_en = Column(String(200), comment="标签（英文，逗号分隔）")


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