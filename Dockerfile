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
RUN pip install --no-cache-dir --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt

EXPOSE 5000
CMD ["python", "folers.py"]
