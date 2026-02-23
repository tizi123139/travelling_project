from app.db.base import Base
from sqlalchemy import Column, String, Text

class Intangible(Base):
    __tablename__ = "intangible"

    id = Column(String(32), primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    destination = Column(String(50), nullable=False)
    level = Column(String(20))
    feature = Column(String(200))
    history = Column(Text)
    experience = Column(String(500))
    shop = Column(String(200))