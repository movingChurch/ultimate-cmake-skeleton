add_external_package(
  VERSION 1.12.1
  DESCRIPTION "Google Test Framework"
  REPOSITORY_URL "https://github.com/google/googletest.git"
  REPOSITORY_TAG "release-1.12.1"
  COMPILE_ARGUMENTS -DBUILD_GMOCK=ON -DINSTALL_GTEST=ON
  LIBRARIES GTest::gtest GTest::gtest_main GTest::gmock GTest::gmock_main
)
