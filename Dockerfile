# --- 阶段 1: 构建 C++ 程序 ---
FROM gcc:13 AS builder

WORKDIR /app

# 安装构建工具
RUN apt-get update && \
    apt-get install -y cmake && \
    rm -rf /var/lib/apt/lists/*

COPY . .
RUN mkdir build && cd build && cmake .. && make

# --- 阶段 2: 运行测试 ---
# 关键修改：升级到 Ubuntu 24.04 以支持 GCC 13 的运行时库
FROM ubuntu:24.04

WORKDIR /app

# 1. 复制编译好的程序
COPY --from=builder /app/build/my_app ./build/my_app

# 2. 安装依赖 (Ubuntu 24.04 需要显式安装 pip 和 venv)
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv && \
    rm -rf /var/lib/apt/lists/*

# 3. 复制测试文件
COPY requirements.txt .
COPY tests/ ./tests/

# 4. 创建并激活虚拟环境 (解决 PEP 668 警告)
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# 5. 安装 Python 依赖
RUN pip install --no-cache-dir -r requirements.txt

# 运行测试
CMD ["python", "tests/test_runner.py"]