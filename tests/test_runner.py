import subprocess
import sys

def run_cpp_app(num1, num2, expected):
    print(f"测试: {num1} + {num2}")
    
    # 修改这里的路径
    # 原来的错误路径: '../build/my_app' (这会去上级目录找)
    # 新的正确路径: './build/my_app' (这会在当前目录下的 build 文件夹里找)
    executable_path = './build/my_app' 

    try:
        # 启动 C++ 程序
        result = subprocess.run(
            [executable_path, str(num1), str(num2)], # 使用修正后的路径
            capture_output=True,
            text=True,
            timeout=10
        )
        
        print("C++ 输出:", result.stdout.strip())
        
        if result.returncode != 0:
            print("错误: C++ 程序崩溃了!")
            print("错误输出:", result.stderr)
            sys.exit(1)
        
        expected_str = f"CALCULATION_RESULT: {expected}"
        if expected_str in result.stdout:
            print("✅ 测试通过!")
            return True
        else:
            print("❌ 测试失败: 结果不匹配")
            sys.exit(1)
            
    except FileNotFoundError:
        # 如果文件还是找不到，打印当前目录结构帮助调试
        print("错误: 找不到 C++ 可执行文件!")
        print("请检查路径是否正确。")
        # 列出当前目录下的文件，确认 build 目录是否存在
        subprocess.run(['ls', '-R', '/app'])
        sys.exit(1)
    except subprocess.TimeoutExpired:
        print("错误: 程序运行超时")
        sys.exit(1)

if __name__ == "__main__":
    run_cpp_app(2, 3, 5)
    run_cpp_app(11, 4, 15)
    print("所有测试完成。")