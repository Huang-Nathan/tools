FROM python:3.11-slim-bullseye

# 安装依赖
RUN apt-get update && apt-get install -y \
    libatlas3-base \
    liblapack-dev \
    libopenblas-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# 升级 pip 工具
RUN pip install --upgrade pip setuptools wheel

# 安装 Python 包（先尝试清华源，失败再走官方）
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple \
    pandas==2.1.1 numpy==1.26.4 "flask==2.3.*" \
    || pip install pandas==2.1.1 numpy==1.26.4 "flask==2.3.*"

EXPOSE 5000

# 确认一下这里的文件名是否正确
CMD ["python", "folers.py"]
