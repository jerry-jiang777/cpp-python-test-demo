# --- 阶段 2: 运行测试 ---
# 改为使用更新的 Ubuntu 版本
FROM ubuntu:22.04 # 或者 ubuntu:24.04

WORKDIR /app

# 从构建阶段复制编译好的程序
COPY --from=builder /app/build/my_app ./build/my_app

# 安装 Python 和依赖 (Ubuntu 22.04/24.04 默认自带 python3)
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# 复制测试脚本和依赖文件
COPY requirements.txt .
COPY tests/ ./tests/

# 安装 Python 依赖
RUN pip3 install --no-cache-dir -r requirements.txt

# 运行测试脚本
CMD ["python3", "tests/test_runner.py"]