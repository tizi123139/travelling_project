from sqlalchemy.orm import Session
from app.dao.HotelDAO import HotelDAO
from app.schemas.hotel import HotelListRequest, HotelBookRequest
from typing import List, Optional
from app.models.hotel import Hotel
from fastapi import HTTPException
import datetime

class HotelService:
    @staticmethod
    def get_hotel_list_service(db: Session, req: HotelListRequest) -> List[dict]:
        """
        返回字典列表，而非原始ORM对象
        """
        hotels_orm = HotelDAO.get_hotel_list(
            db=db,
            destination=req.destination,
            starLevel=req.starLevel,
            priceMin=req.priceMin,
            priceMax=req.priceMax
        )
        if not hotels_orm:
            raise HTTPException(status_code=404, detail="未查询到符合条件的酒店")

        # 将ORM对象转换为字典
        hotel_list = []
        for hotel in hotels_orm:
            images_list = hotel.images.split(",") if hotel.images else [hotel.image] if hotel.image else []
            valid_images = [img.strip() for img in images_list if img.strip().startswith(('http://', 'https://'))]

            hotel_list.append({
                "hotelId": hotel.hotelId,
                "name": hotel.name,
                "name_en": hotel.name_en or "",
                "image": hotel.image or f"https://picsum.photos/400/300?random={hotel.hotelId}",  # 主图
                "images": valid_images,
                "rating": hotel.rating or hotel.commentScore or 0.0,  # 优先用rating，兼容旧commentScore
                "reviewCount": hotel.reviewCount or 0,
                "address": hotel.address,
                "address_en": hotel.address_en or "",
                "price": hotel.price,
                "star": hotel.star,
                "distance": hotel.distance,
                "tags": hotel.tags.split(",") if hotel.tags else [],
                "tags_en": hotel.tags_en.split(",") if hotel.tags_en else [],
                "facility": hotel.facility.split(",") if hotel.facility else [],  # 新增：设施列表
                "facility_en": hotel.facility_en.split(",") if hotel.facility_en else [],
                 "commentScore": hotel.commentScore,
                 "roomType": hotel.roomType.split(",") if hotel.roomType else [],
            })
        return hotel_list

    @staticmethod
    def get_hotel_detail_service(db: Session, hotel_id: str) -> dict:
        """
        返回字典，而非修改后的ORM对象
        """
        hotel_orm = HotelDAO.get_hotel_by_id(db, hotel_id)
        if not hotel_orm:
            raise HTTPException(status_code=404, detail="酒店不存在")

        images_list = hotel_orm.images.split(",") if hotel_orm.images else [hotel_orm.image] if hotel_orm.image else []
        valid_images = [img.strip() for img in images_list if img.strip().startswith(('http://', 'https://'))]
        # 转换为字典，并处理设施/房型为列表
        hotel_detail = {
            "hotelId": hotel_orm.hotelId,
            "name": hotel_orm.name,
            "name_en": hotel_orm.name_en or "",
             "image": hotel_orm.image or f"https://picsum.photos/400/300?random={hotel_orm.hotelId}",  # 主图
             "images": valid_images,
            "rating": hotel_orm.rating or hotel_orm.commentScore or 0.0,
            "reviewCount": hotel_orm.reviewCount or 0,
            "address": hotel_orm.address,
            "address_en": hotel_orm.address_en or "",
            "price": hotel_orm.price,
            "facility": hotel_orm.facility.split(",") if hotel_orm.facility else [],
            "roomType": hotel_orm.roomType.split(",") if hotel_orm.roomType else [],
            "facility_en": hotel_orm.facility_en.split(",") if hotel_orm.facility_en else [],
            "tags": hotel_orm.tags.split(",") if hotel_orm.tags else [],
            "tags_en": hotel_orm.tags_en.split(",") if hotel_orm.tags_en else [],
            "commentScore": hotel_orm.commentScore
        }
        return hotel_detail

    @staticmethod
    def hotel_book_service(db: Session, req: HotelBookRequest) -> dict:
        hotel_orm = HotelDAO.get_hotel_by_id(db, req.hotelId)
        if not hotel_orm:
            raise HTTPException(status_code=404, detail="酒店不存在")

        room_types = hotel_orm.roomType.split(",") if hotel_orm.roomType else []
        if req.roomType not in room_types:
            raise HTTPException(status_code=400, detail=f"该酒店无此房型，支持房型：{','.join(room_types)}")

        # 计算天数和总价
        try:
            check_in = datetime.datetime.strptime(req.checkIn, "%Y-%m-%d")
            check_out = datetime.datetime.strptime(req.checkOut, "%Y-%m-%d")
        except ValueError:
            raise HTTPException(status_code=400, detail="日期格式错误，需为yyyy-MM-dd")

        if check_out <= check_in:
            raise HTTPException(status_code=400, detail="离店日期必须晚于入住日期")

        days = (check_out - check_in).days
        total_price = float(hotel_orm.price) * days  # 确保浮点型

        # 创建订单
        order = HotelDAO.create_hotel_book(db, req, hotel_orm.name, total_price)

        # 返回字典
        return {
            "orderId": order.orderId,
            "hotelName": order.hotelName,
            "roomType": order.roomType,
            "totalPrice": order.totalPrice,
            "orderStatus": order.orderStatus
        }