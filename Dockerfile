# --- 阶段 1: 构建 C++ 程序 ---
FROM gcc:13 AS builder

WORKDIR /app

# 复制源码和构建文件
COPY . .

# 创建构建目录并编译
RUN mkdir build && cd build && cmake .. && make

# --- 阶段 2: 运行测试 ---
FROM ubuntu:20.04

WORKDIR /app

# 从构建阶段复制编译好的程序
COPY --from=builder /app/build/my_app ./build/my_app

# 安装 Python 和依赖
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# 复制测试脚本和依赖文件
COPY requirements.txt .
COPY tests/ ./tests/

# 安装 Python 依赖 (如果有)
RUN pip3 install --no-cache-dir -r requirements.txt

# 运行测试脚本
CMD ["python3", "tests/test_runner.py"]