from pydantic import BaseModel
from typing import Optional, List

# ---------------------- 非遗列表响应项 ----------------------
class IntangibleListItem(BaseModel):
    id: str
    name: str
    category: str  # 传统技艺/表演艺术/民俗活动等
    region: str  # 华中/华东等
    description: str
    images: List[str]  # 图片URL列表
    tags: List[str]  # 标签列表
    likes: int = 0
    shares: int = 0
    view_count: int = 0  # 对应前端 viewCount
    experience_location: Optional[str] = None  # 体验地址
    experience_contact: Optional[str] = None  # 体验联系方式
    experience_price: Optional[float] = 0.0  # 体验价格
    created_at: str  # ISO格式时间字符串
    posts: List[dict] = []  # 暂时返回空列表（前端模拟帖子）

    class Config:
        from_attributes = True

# ---------------------- 非遗详情响应 ----------------------
class IntangibleDetail(BaseModel):
    id: str
    name: str
    level: str
    history: str
    experience: List[str]  # 体验项目列表
    shop: str

    class Config:
        from_attributes = True