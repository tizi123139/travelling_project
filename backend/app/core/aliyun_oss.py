import oss2
from datetime import datetime
import uuid
from fastapi import HTTPException
import os

ALIYUN_OSS_CONFIG = {
    "access_key_id":
    "access_key_secret":
    "endpoint":
    "bucket_name":
    "base_url":
}

# 初始化OSS客户端
auth = oss2.Auth(
    ALIYUN_OSS_CONFIG["access_key_id"],
    ALIYUN_OSS_CONFIG["access_key_secret"]
)
bucket = oss2.Bucket(
    auth,
    ALIYUN_OSS_CONFIG["endpoint"],
    ALIYUN_OSS_CONFIG["bucket_name"]
)


def upload_file_to_oss(file) -> str:
    """
    上传图片到阿里云OSS
    :param file: FastAPI的UploadFile对象
    :return: 图片的公网访问URL
    """
    # 1. 校验文件类型（仅允许图片）
    allowed_ext = [".jpg", ".jpeg", ".png", ".gif"]
    file_name = file.filename
    if not file_name or "." not in file_name:
        raise HTTPException(status_code=400, detail="文件名称无效")

    file_ext = file_name.split(".")[-1].lower()
    ext = f".{file_ext}"
    if f".{file_ext}" not in allowed_ext:
        raise HTTPException(status_code=400, detail="仅支持jpg/jpeg/png/gif格式图片")

    # 2. 校验文件大小（限制10MB）
    file_content = file.file.read()
    if file.size > 10 * 1024 * 1024:
        raise HTTPException(status_code=400, detail="文件大小不能超过10MB")

    # 3. 生成唯一文件名
    date_str = datetime.now().strftime("%Y/%m/%d")  # 按年月日分目录
    unique_file_name = f"{uuid.uuid4().hex}.{file_ext}"  # 唯一ID
    oss_file_key = f"photo_wall/{date_str}/{unique_file_name}"  # OSS中的存储路径

    content_type_map = {
        ".jpg": "image/jpeg",
        ".jpeg": "image/jpeg",
        ".png": "image/png",
        ".gif": "image/gif"
    }
    content_type = content_type_map[ext]

    # 5. 上传文件到OSS（指定Content-Type + 公共读权限）
    try:
        bucket.put_object(
            key=oss_file_key,
            data=file_content,
            headers={
                "x-oss-object-acl": "public-read",  # 公共读权限
                "Content-Type": content_type  # 关键：指定图片的MIME类型
            }
        )

        # 6. 返回公网访问URL
        return f"{ALIYUN_OSS_CONFIG['base_url']}/{oss_file_key}"
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"图片上传失败：{str(e)}")