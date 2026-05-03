class Settings:
    PROJECT_NAME: str = "知音寻迹"

    # MySQL 配置格式: mysql+pymysql://用户名:密码@主机地址:端口/数据库名
    MYSQL_USER: str = "tizi1234"
    MYSQL_PASSWORD: str = "Tizi6666"
    MYSQL_SERVER: str = "localhost"
    MYSQL_PORT: int = 3306
    MYSQL_DB: str = "travelling"

    DATABASE_URL: str = f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}@{MYSQL_SERVER}:{MYSQL_PORT}/{MYSQL_DB}"

    DASHSCOPE_API_KEY: str = # 替换成真实的 API Key
    MODEL_NAME: str = "qwen-turbo"  # 模型版本（可选 qwen-plus/qwen-max）
    TEMPERATURE: float = 0.7  # 生成随机性（0-1）

settings = Settings()