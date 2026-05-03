from typing import Optional

from sqlalchemy.orm import Session
from app.dao.FoodDAO import FoodDAO
from app.models.food import Food
from app.schemas.food import FoodListItem, FoodDetail, ShopItem
from fastapi import HTTPException
import json


class FoodService:
    @staticmethod
    def get_food_list(db: Session,  type: Optional[str] = None):

        query = db.query(Food)

            # 类型筛选
        if type is not None and type != "全部":
            query = query.filter(Food.type == type)

        foods = query.all()
        if not foods:
            raise HTTPException(status_code=404, detail="未找到相关美食")
        result = []
        for f in foods:
            # 手动解析tags（双重保障）
            tags = []
            if f.tags and f.tags.strip():
                try:
                    tags = json.loads(f.tags)
                except:
                    tags = []

            # 构建FoodListItem对象，处理Decimal类型
            item = FoodListItem(
                foodId=f.foodId,
                name=f.name,
                nameEn=f.nameEn or "",
                feature=f.feature or "",
                type=f.type or "",
                typeEn=f.type or "",
                price=float(f.price) if f.price else 0.0,  # Decimal转float
                recommendedShop=f.recommendedShop or "",
                destination=f.destination,
                tags=tags , # 传入解析后的列表
                tagsEn=f.tagsEn or "",
                image= f.image,  # 兜底图片
                rating= float(f.rating) if f.rating else 4.7,  # 兜底评分
                reviewCount= f.reviewCount or 9876,  # 兜底评价数
                category=f.category or f.type or "小吃",  # 兜底分类（兼容type字段）
                categoryEn=f.categoryEn or "",
                distance= f.distance or "1.2km",  # 兜底距离
                address= f.address or "江汉区中山大道539号",  # 兜底地址
                addressEn=f.addressEn or "",
                phone=f.phone,
                hours= f.hours or "",
                recommended=f.recommended,

            )
            result.append(item)

        return result

    @staticmethod
    def get_food_detail(db: Session, foodId: str):
        food = FoodDAO.get_food_detail(db, foodId)
        if not food:
            raise HTTPException(status_code=404, detail="美食不存在")

        # 处理配料：逗号分隔转列表
        ingredient_list = []
        if food.ingredient and food.ingredient.strip():
            ingredient_list = [i.strip() for i in food.ingredient.split(",") if i.strip()]

        # 处理店铺列表：JSON字符串转对象
        shop_list = json.loads(food.shopListJson) if food.shopListJson else []
        shop_items = []
        if food.shopListJson and food.shopListJson.strip():
            try:
                shop_list = json.loads(food.shopListJson)
                for item in shop_list:
                    # 补全缺失字段
                    item.setdefault("score", 4.5)
                    item.setdefault("shopName", "")
                    item.setdefault("address", "")
                    shop_items.append(ShopItem(**item))
            except json.JSONDecodeError:
                # JSON解析失败时返回空列表，避免接口崩溃
                shop_items = []
        tags = []
        if food.tags and food.tags.strip():
            try:
                tags = json.loads(food.tags)
            except:
                tags = []

        recommended = []
        if food.recommended and food.recommended.strip():
            try:
                recommended = json.loads(food.recommended)
            except:
                recommended = []
        return FoodDetail(
            foodId=food.foodId,
            name=food.name,
            nameEn=food.nameEn or "",
            feature=food.feature or "",
            type=food.type or "",
            typeEn=food.type or "",
            price=float(food.price) if food.price else 0.0,
            recommendedShop=food.recommendedShop or "",
            destination=food.destination or "",
            ingredient=ingredient_list,
            shopList=shop_items,
            image=food.image or "https://picsum.photos/400/300?random=103",  # 兜底图片
            rating=float(food.rating) if food.rating else 4.5,
            reviewCount=food.reviewCount or 0,
            category=food.category or food.type or "小吃",  # 兜底分类
            categoryEn=food.categoryEn or "",
            distance=food.distance or "1.2km",
            address=food.address or "江汉区中山大道579号",  # 兜底地址
            addressEn=food.addressEn or "",
            phone=food.phone or "027-82831234",  # 兜底电话
            tags=tags,
            tagsEn=food.tagsEn or "",
            hours=food.hours or "",
            recommended=food.recommended,
            latitude=float(food.latitude) if food.latitude else 30.5788,
            longitude=float(food.longitude) if food.longitude else 114.2891
        )