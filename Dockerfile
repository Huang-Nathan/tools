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

# 安装 Python 包（清华源优先，失败再走官方源）
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple \
    pandas==2.1.1 numpy==1.26.4 "flask==2.3.*" xlrd>=2.0.1 openpyxl \
    || pip install pandas==2.1.1 numpy==1.26.4 "flask==2.3.*" xlrd>=2.0.1 openpyxl

EXPOSE 5000

# 确认文件名
CMD ["python", "folers.py"]
