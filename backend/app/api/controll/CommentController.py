from fastapi import APIRouter, Query
from app.services.CommentService import get_comment_list, publish_comment
from app.schemas.comment import CommentPublishRequest, CommentListResponse, CommentPublishResponse

router = APIRouter()

@router.get("/list", response_model=CommentListResponse, summary="获取景区/酒店点评列表")
async def list_comments(
    targetId: str = Query(..., description="景区/酒店ID"),
    targetType: str = Query(..., description="类型 (scenic=景区 / hotel=酒店)"),
    pageNum: int = Query(1, ge=1, description="页码"),
    pageSize: int = Query(10, ge=1, le=100, description="每页条数")
):
    return get_comment_list(targetId, targetType, pageNum, pageSize)

@router.post("/publish", response_model=CommentPublishResponse, summary="发布点评")
async def publish(req: CommentPublishRequest):
    return publish_comment(req)