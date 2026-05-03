from app.db.base import Base

from sqlalchemy import Column, String, Text, Integer, Float, DateTime
import datetime

class Intangible(Base):
    __tablename__ = "intangible"

    id = Column(String(32), primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    destination = Column(String(50), nullable=False)
    level = Column(String(20))
    feature = Column(String(200))
    history = Column(Text)
    experience = Column(String(500))
    shop = Column(String(200))

    category = Column(String(50))  # 类别（传统技艺/表演艺术/民俗活动等）
    region = Column(String(20))  # 所属区域（华中/华东等）
    description = Column(Text)  # 详情描述
    images = Column(String(1000))  # 图片URL（逗号分隔）
    tags = Column(String(200))  # 标签（逗号分隔）
    likes = Column(Integer, default=0)  # 点赞数
    shares = Column(Integer, default=0)  # 分享数
    view_count = Column(Integer, default=0)  # 浏览量
    experience_location = Column(String(200))  # 体验地址
    experience_contact = Column(String(50))  # 体验联系方式
    experience_price = Column(Float, default=0.0)  # 体验价格
    created_at = Column(DateTime, default=datetime.datetime.now)  # 创建时间
