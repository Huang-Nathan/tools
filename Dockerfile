# 选择官方 Python 轻量镜像
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器
COPY . /app

# 安装依赖
RUN pip install --no-cache-dir -r requirements.txt

# 暴露容器内部端口
EXPOSE 5000

# 启动 Flask
CMD ["python", "folers.py"]
