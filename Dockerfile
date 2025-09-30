FROM python:3.11-slim-bullseye
RUN apt-get update && apt-get install -y \
    build-essential \
    gfortran \
    libatlas3-base \
    liblapack-dev \
    libopenblas-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN pip install --upgrade pip setuptools wheel
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple \
    pandas==2.1.1 numpy==1.26.4 flask==2.3.6


EXPOSE 5000
CMD ["python", "folers.py"]
