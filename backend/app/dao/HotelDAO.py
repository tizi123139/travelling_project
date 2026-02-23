from sqlalchemy.orm import Session
from app.models.hotel import Hotel,HotelBook
from app.schemas.hotel import HotelBookRequest
from typing import List, Optional
import datetime

class HotelDAO:
    @staticmethod
    def get_hotel_list(
        db: Session,
        destination: str,
        starLevel: Optional[str] = None,
        priceMin: Optional[int] = 0,
        priceMax: Optional[int] = None
    ) -> List[Hotel]:
        """
        获取酒店列表：按条件筛选
        """
        query = db.query(Hotel)
        # 基础筛选：目的地
        query = query.filter(Hotel.address.like(f"%{destination}%"))
        # 星级筛选
        if starLevel:
            query = query.filter(Hotel.star == starLevel)
        # 价格区间筛选
        if priceMin >= 0:
            query = query.filter(Hotel.price >= priceMin)
        if priceMax:
            query = query.filter(Hotel.price <= priceMax)
        return query.all()

    @staticmethod
    def get_hotel_by_id(db: Session, hotel_id: str) -> Optional[Hotel]:
        """
        根据酒店ID获取详情
        """
        return db.query(Hotel).filter(Hotel.hotelId == hotel_id).first()

    @staticmethod
    def create_hotel_book(db: Session, book_info: HotelBookRequest, hotel_name: str, total_price: float) -> HotelBook:
        """
        创建酒店预订订单
        """
        # 生成唯一订单ID：O+时间戳
        order_id = f"O{datetime.datetime.now().strftime('%Y%m%d%H%M%S')}"
        # 构建订单对象
        book_order = HotelBook(
            orderId=order_id,
            hotelId=book_info.hotelId,
            hotelName=hotel_name,
            roomType=book_info.roomType,
            checkIn=book_info.checkIn,
            checkOut=book_info.checkOut,
            userId=book_info.userId,
            contactName=book_info.contactName,
            contactPhone=book_info.contactPhone,
            totalPrice=total_price
        )
        # 插入数据库
        db.add(book_order)
        db.commit()
        db.refresh(book_order)
        return book_order