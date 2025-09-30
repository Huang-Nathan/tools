# 选择官方 Python 轻量镜像
FROM python:3.11-slim

# 更新系统和安装必要编译依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    libatlas3-base \
    gfortran \
    && rm -rf /var/lib/apt/lists/*


# 升级 pip、setuptools、wheel
RUN pip install --upgrade pip setuptools wheel

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器
COPY . /app

# 安装依赖（建议在 requirements.txt 中锁定版本）
# 例如 requirements.txt 内容：
# Flask==2.3.2
# pandas==2.1.1
# numpy==1.26.5
RUN pip install --no-cache-dir -r requirements.txt

# 暴露 Flask 端口
EXPOSE 5000

# 启动 Flask 应用
CMD ["python", "folers.py"]
