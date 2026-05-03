from pydantic import BaseModel, Field, EmailStr, field_validator
from typing import Optional, List
from datetime import date
import re

# ---------------------- 酒店列表请求参数 ----------------------
class HotelListRequest(BaseModel):
    destination: str = Field(..., description="目的地城市")
    checkIn: str = Field(..., description="入住日期（yyyy-MM-dd）")
    checkOut: str = Field(..., description="离店日期（yyyy-MM-dd）")
    starLevel: Optional[str] = Field(None, description="酒店星级（三星/四星/五星）")
    priceMin: Optional[int] = Field(0, ge=0, description="最低价格（元）")
    priceMax: Optional[int] = Field(None, description="最高价格（元）")

# ---------------------- 酒店列表响应模型 ----------------------
class HotelListItem(BaseModel):
    hotelId: str
    name: str
    name_en: str
    image: str
    images: List[str] = Field([], description="酒店图片列表")
    rating: float
    reviewCount: int
    address: str
    address_en: str
    price: float
    star: str
    distance: float
    facility: Optional[List[str]] = Field([], description="酒店设施列表")
    facility_en: List[str] = Field([], description="设施列表（英文）")
    tags: List[str] = Field([], description="标签列表（中文）")
    tags_en: List[str] = Field([], description="标签列表（英文）")

    class Config:
        # 修复：orm_mode → from_attributes（Pydantic 2.x 标配）
        from_attributes = True

# ---------------------- 酒店详情响应模型 ----------------------
class HotelDetailResponse(BaseModel):
    hotelId: str
    name: str
    address: str
    address_en: str
    price: float
    image: str
    images: List[str] = Field([], description="酒店图片列表")
    rating: float
    reviewCount: int
    facility: List[str]  # 转成列表
    facility_en: List[str]
    roomType: List[str]   # 转成列表
    commentScore: float
    tags: List[str]
    tags_en: List[str]

    class Config:
        from_attributes = True

# ---------------------- 酒店预订请求参数 ----------------------
class HotelBookRequest(BaseModel):
    hotelId: str = Field(..., description="酒店ID")
    roomType: str = Field(..., description="房型（标准间/大床房/家庭房）")
    checkIn: str = Field(..., description="入住日期（yyyy-MM-dd）")
    checkOut: str = Field(..., description="离店日期（yyyy-MM-dd）")
    userId: str = Field(..., description="用户ID")
    contactName: str = Field(..., description="联系人姓名")
    # Pydantic 2.x 用 pattern 替代 regex
    contactPhone: str = Field(..., description="联系人电话", pattern=r"^1[3-9]\d{9}$")

    # 手机号校验器
    @field_validator('contactPhone')
    def validate_phone_number(cls, value):
        if not re.match(r"^1[3-9]\d{9}$", value):
            raise ValueError('手机号格式错误，请输入11位有效手机号（13/14/15/16/17/18/19开头）')
        return value

    # 日期校验：离店日期必须晚于入住
    @field_validator('checkOut')
    def validate_checkout_date(cls, value, values):
        check_in = values.data.get('checkIn')
        if check_in and value <= check_in:
            raise ValueError('离店日期必须晚于入住日期')
        return value

# ---------------------- 酒店预订响应模型 ----------------------
class HotelBookResponse(BaseModel):
    orderId: str
    hotelName: str
    roomType: str
    totalPrice: float
    orderStatus: str

    class Config:
        from_attributes = True