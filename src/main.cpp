#include <iostream>
#include <string>

int main(int argc, char* argv[]) {
    // 检查参数数量
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <num1> <num2>" << std::endl;
        return 1;
    }

    try {
        // 将参数转换为数字
        double a = std::stod(argv[1]);
        double b = std::stod(argv[2]);
        double result = a + b;

        // 输出结果
        std::cout << "CALCULATION_RESULT: " << result << std::endl;
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
}