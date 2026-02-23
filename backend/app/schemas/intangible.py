from pydantic import BaseModel
from typing import Optional, List

# ---------------------- 非遗列表响应项 ----------------------
class IntangibleListItem(BaseModel):
    id: str
    name: str
    level: str
    feature: str

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