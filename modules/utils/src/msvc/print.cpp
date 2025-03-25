#include "utils/print.hpp"

#include <iostream>

namespace ultimate_cmake_template::utils {
void print(const std::string &message) {
  std::cout << "[MSVC] " << message << std::endl;
}
}  // namespace ultimate_cmake_template::utils