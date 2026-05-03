from sqlalchemy import Column, String, Float, Text,Integer,DECIMAL
from app.db.base import Base

class Food(Base):
    __tablename__ = "food"

    foodId = Column(String(32), primary_key=True, comment='美食唯一ID')  # 恢复 foodId 为主键
    name = Column(String(100), nullable=False, comment='美食名称')
    destination = Column(String(50), nullable=False, comment='所属城市')  # 恢复 destination
    type = Column(String(20), nullable=True, comment='美食类型：小吃/正餐/甜品')  # 恢复 type
    feature = Column(String(200), nullable=True, comment='美食特色描述')  # 恢复 feature
    price = Column(DECIMAL(10, 2), nullable=True, comment='参考价格（元）')
    recommendedShop = Column(String(100), nullable=True, comment='推荐店铺（列表页）')  # 恢复 recommendedShop
    ingredient = Column(String(500), nullable=True, comment='配料（逗号分隔）')
    shopListJson = Column(Text, nullable=True, comment='店铺列表JSON')
    nameEn = Column(String(100), nullable=True, comment='英文名称')
    image = Column(String(255), nullable=True, comment='美食图片URL')
    rating = Column(DECIMAL(2, 1), nullable=True, comment='评分（1-5分）')
    reviewCount = Column(Integer, default=0, comment='评价数量')
    category = Column(String(50), nullable=True, comment='美食分类（新）')
    categoryEn = Column(String(50), nullable=True, comment='英文分类')
    distance = Column(String(20), nullable=True, comment='距离（如 1.2km）')
    address = Column(String(200), nullable=True, comment='地址（中文）')
    addressEn = Column(String(200), nullable=True, comment='地址（英文）')
    hours = Column(String(50), nullable=True, comment='营业时间')
    phone = Column(String(20), nullable=True, comment='联系电话')
    tags = Column(String(500), nullable=True, comment='标签列表（JSON数组）')
    tagsEn = Column(String(500), nullable=True, comment='英文标签列表（JSON数组）')
    recommended = Column(String(500), nullable=True, comment='推荐菜品（JSON数组）')
    recommendedEn = Column(String(500), nullable=True, comment='英文推荐菜品（JSON数组）')
    latitude = Column(DECIMAL(10, 6), nullable=True, comment='纬度')
    longitude = Column(DECIMAL(10, 6), nullable=True, comment='经度')