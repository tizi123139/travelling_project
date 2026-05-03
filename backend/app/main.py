from sys import prefix

from fastapi import FastAPI
from app.api.controll import (users, HotelController, FoodController, IntangibleController,
                              ScenicController, MapController, TravelLocationController, CommentController, PhotoWallController
                              , TravelPlanController,MobileHouse)
from app.db.base import Base
from app.db.session import engine

# 启动时自动创建所有 MySQL 表
Base.metadata.create_all(bind=engine)

app = FastAPI(title="知音寻迹 后端服务")

# 挂载路由
app.include_router(users.router, prefix="/api/users", tags=["用户模块"])
app.include_router(HotelController.router, prefix="/api/hotel", tags=["酒店服务"])
app.include_router(FoodController.router, prefix="/api/food", tags=["美食板块"])
app.include_router(IntangibleController.router, prefix="/api/intangible", tags=["非遗板块"])
app.include_router(ScenicController.router, prefix="/api/scenic", tags=["景区板块"])
app.include_router(MapController.router, prefix="/api/map", tags=["智能地图"])
app.include_router(TravelLocationController.router, prefix="/api/travel", tags=["旅游定位"])
app.include_router(CommentController.router, prefix="/api/comment", tags=["用户点评"])
app.include_router(PhotoWallController.router, prefix="/api/photo", tags=["照片模块"])
app.include_router(TravelPlanController.router,prefix="/api/travel")
app.include_router(MobileHouse.router,prefix="/api/mobile-houses")

@app.get("/")
def read_root():

    return {"message": "Welcome to Zhiyin Trace API"}

from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 开发环境临时用 *，生产环境要改成你的前端地址
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

