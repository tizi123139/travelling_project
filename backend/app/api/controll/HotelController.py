from typing import Optional
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from app.services.HotelService import HotelService
from app.schemas.hotel import HotelListRequest, HotelBookRequest, HotelBookResponse, HotelListItem, HotelDetailResponse
from app.core.base_response import BaseResponse
from app.db.session import get_db


router = APIRouter()

# ---------------------- 1. 获取酒店列表 ----------------------
@router.get("/list", response_model=BaseResponse,summary="获取酒店列表")
def get_hotel_list(
        destination: str = Query(..., description="目的地城市"),
        checkIn: str = Query(..., description="入住日期（yyyy-MM-dd）"),
        checkOut: str = Query(..., description="离店日期（yyyy-MM-dd）"),
        starLevel: Optional[str] = Query(None, description="酒店星级（三星/四星/五星）"),
        priceMin: Optional[int] = Query(0, ge=0, description="最低价格（元）"),
        priceMax: Optional[int] = Query(None, description="最高价格（元）"),
        db: Session = Depends(get_db)
):
    req = HotelListRequest(
        destination=destination,
        checkIn=checkIn,
        checkOut=checkOut,
        starLevel=starLevel,
        priceMin=priceMin,
        priceMax=priceMax
    )
    # 调用Service获取ORM对象列表
    hotel_orm_list = HotelService.get_hotel_list_service(db, req)

    # 将ORM对象转换为Pydantic模型实例
    hotel_list = [HotelListItem.model_validate(hotel) for hotel in hotel_orm_list]

    return BaseResponse(data=hotel_list)


# ---------------------- 2. 获取酒店详情 ----------------------
@router.get("/detail", response_model=BaseResponse,summary="获取酒店详情")
def get_hotel_detail(
        hotelId: str = Query(..., description="酒店唯一ID"),
        db: Session = Depends(get_db)
):
    # 调用Service获取处理后的酒店数据
    hotel_data = HotelService.get_hotel_detail_service(db, hotelId)

    # 转换为Pydantic模型实例
    hotel_detail = HotelDetailResponse.model_validate(hotel_data)

    return BaseResponse(data=hotel_detail)


# ---------------------- 3. 预订酒店 ----------------------
@router.post("/book", response_model=BaseResponse,summary="预定酒店")
def book_hotel(
        req: HotelBookRequest,
        db: Session = Depends(get_db)
):
    order_data = HotelService.hotel_book_service(db, req)
    order_detail = HotelBookResponse.model_validate(order_data)
    return BaseResponse(
        code=200,
        message="预订成功",
        data=order_detail
    )