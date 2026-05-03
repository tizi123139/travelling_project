from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.core.config import settings

# 使用 MySQL 引擎
engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,  # 自动检测失效连接并重连
    pool_size=10,        # 连接池大小
    max_overflow=20      # 超过池大小后允许的并发连接数
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()