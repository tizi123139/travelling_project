class Settings:
    PROJECT_NAME: str = "知音寻迹"

    # MySQL 配置格式: mysql+pymysql://用户名:密码@主机地址:端口/数据库名
    MYSQL_USER: str = ""
    MYSQL_PASSWORD: str = ""
    MYSQL_SERVER: str = "localhost"
    MYSQL_PORT: int = 3306
    MYSQL_DB: str = "travelling"

    DATABASE_URL: str = f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_SERVER}:{MYSQL_PORT}/{MYSQL_DB}"


settings = Settings()