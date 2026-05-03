from sqlalchemy.ext.declarative import declarative_base

# 创建所有 ORM 模型的基类
# 以后 models/ 下的所有类都要继承这个 Base
Base = declarative_base()