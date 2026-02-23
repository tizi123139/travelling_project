from typing import Dict, List
from datetime import date
from app.schemas.comment import CommentPublishRequest, CommentItem, CommentListResponse, CommentPublishResponse
from fastapi import HTTPException

# 模拟点评数据库
_comments_db: Dict[str, List[dict]] = {}  # key: f"{targetType}_{targetId}", value: 点评列表
_next_comment_id = 1000  # 自增点评ID


def get_comment_list(targetId: str, targetType: str, pageNum: int = 1, pageSize: int = 10) -> CommentListResponse:
    key = f"{targetType}_{targetId}"
    all_comments = _comments_db.get(key, [])

    # 分页
    start = (pageNum - 1) * pageSize
    end = start + pageSize
    page_comments = all_comments[start:end]

    # 计算平均评分
    if all_comments:
        avg_score = round(sum(c["score"] for c in all_comments) / len(all_comments), 1)
    else:
        avg_score = 0.0

    return CommentListResponse(
        total=len(all_comments),
        score=avg_score,
        list=[CommentItem(**c) for c in page_comments]
    )


def publish_comment(req: CommentPublishRequest) -> CommentPublishResponse:
    global _next_comment_id
    key = f"{req.targetType}_{req.targetId}"

    # 生成新点评ID和时间
    comment_id = f"C{_next_comment_id:03d}"
    _next_comment_id += 1
    create_time = date.today().strftime("%Y-%m-%d")

    # 构造点评数据（nickname这里模拟，实际应从用户服务获取）
    new_comment = {
        "commentId": comment_id,
        "userId": req.userId,
        "nickname": "旅行达人",
        "score": req.score,
        "content": req.content,
        "createTime": create_time,
        "imgList": req.imgList
    }

    # 写入数据库
    if key not in _comments_db:
        _comments_db[key] = []
    _comments_db[key].append(new_comment)

    return CommentPublishResponse(
        commentId=comment_id,
        createTime=create_time
    )