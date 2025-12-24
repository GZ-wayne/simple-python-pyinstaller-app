FROM python:3.11-slim

WORKDIR /app

COPY sources/ /app/

# 如果你有依赖
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python", "add2vals.py"]
