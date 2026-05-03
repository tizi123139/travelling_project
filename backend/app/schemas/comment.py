from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import date

# 发布点评请求体
class CommentPublishRequest(BaseModel):
    targetId: str = Field(..., description="景区/酒店ID")
    targetType: str = Field(..., description="类型 (scenic=景区 / hotel=酒店)")
    userId: str = Field(..., description="用户ID")
    score: int = Field(..., ge=1, le=5, description="评分（1-5星）")
    content: str = Field(..., max_length=500, description="点评内容")
    imgList: Optional[List[str]] = Field([], description="图片URL列表（≤5张）")

# 单条点评数据
class CommentItem(BaseModel):
    commentId: str
    userId: str
    nickname: str
    score: int
    content: str
    createTime: str
    imgList: List[str]

# 获取点评列表响应
class CommentListResponse(BaseModel):
    total: int
    score: float  # 平均评分
    list: List[CommentItem]

# 发布点评响应
class CommentPublishResponse(BaseModel):
    commentId: str
    createTime: str