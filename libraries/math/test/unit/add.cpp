#include "math/add.hpp"

#include <gtest/gtest.h>

namespace ultimate_cmake_template::math {
TEST(Add, Add) { EXPECT_EQ(Add(1, 2), 3); }
}  // namespace ultimate_cmake_template::math
