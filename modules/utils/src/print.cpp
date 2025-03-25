#include "utils/print.hpp"

#include <iostream>

namespace ultimate_cmake_template::utils {
void Print(const std::string &message) {
  std::cout << "[Common] " << message << std::endl;
}
}  // namespace ultimate_cmake_template::utils
