import subprocess
import sys

def run_cpp_app(num1, num2, expected):
    print(f"测试: {num1} + {num2}")
    
    # 启动 C++ 程序作为子进程
    try:
        # 注意：../build/my_app 是根据 Dockerfile 中的路径设定的
        result = subprocess.run(
            ["../build/my_app", str(num1), str(num2)],
            capture_output=True,
            text=True,
            timeout=10
        )
        
        # 打印 C++ 程序的输出
        print("C++ 输出:", result.stdout.strip())
        
        # 检查返回码
        if result.returncode != 0:
            print("错误: C++ 程序崩溃了!")
            print("错误输出:", result.stderr)
            sys.exit(1)
        
        # 简单的验证 (检查输出中是否包含预期的结果)
        expected_str = f"CALCULATION_RESULT: {expected}"
        if expected_str in result.stdout:
            print("✅ 测试通过!")
            return True
        else:
            print("❌ 测试失败: 结果不匹配")
            sys.exit(1)
            
    except subprocess.TimeoutExpired:
        print("错误: 程序运行超时")
        sys.exit(1)

if __name__ == "__main__":
    # 运行测试用例
    run_cpp_app(2, 3, 5)
    run_cpp_app(10.5, 2.5, 13.0)
    print("所有测试完成。")