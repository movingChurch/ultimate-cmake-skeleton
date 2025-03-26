# Ultimate CMake Skeleton

A comprehensive and modular CMake template for C++ projects, providing standardized directory structure and build configurations.

## Overview

This template provides a robust foundation for C++ projects with:

- Modular project organization
- Standardized build system
- Automated dependency management
- Code formatting tools
- Test framework integration

## Project Structure

project_root/
├── applications/ # Standalone applications
├── externals/ # External dependencies
├── libraries/ # Internal libraries
├── scripts/ # Build and utility scripts
│ ├── executable/ # Executable scripts
│ └── features/ # Script modules
├── cmake/ # CMake modules
└── CMakeLists.txt # Root CMake configuration

## Features

### Library Management (`libraries/`)

- Modular library development
- Automatic header installation
- Dependency tracking
- Test integration support

Example:

```cmake
# libraries/my_library/CMakeLists.txt
cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

add_library_module(
  NAME my_library
  SOURCES
    src/my_source.cpp
  DEPENDENCIES
    other_library  # Optional dependencies
)
```

### Application Development (`applications/`)

- Standalone executable creation
- Library linking
- Resource management

Example:

```cmake
# applications/my_app/CMakeLists.txt
cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

add_application_module(
  NAME my_app
  SOURCES
    src/main.cpp
  DEPENDENCIES
    my_library
)
```

### External Dependencies (`externals/`)

- Automated dependency fetching
- Version control
- Build configuration management

Example:

```cmake
# externals/external_lib/CMakeLists.txt
cmake_minimum_required(VERSION ${CMAKE_VERSION_MINIMUM})

add_external_package(
  VERSION "1.0.0"
  DESCRIPTION "External library description"
  REPOSITORY_URL "https://github.com/example/lib.git"
  REPOSITORY_TAG "v1.0.0"
  LIBRARIES "lib1" "lib2"
  COMPILE_ARGUMENTS
    -DBUILD_TESTING=OFF
)
```

### Script System (`scripts/`)

Organized in two main directories:

- `executable/`: Contains runnable scripts
- `features/`: Contains reusable script modules

Example script structure:

```bash
#!/bin/bash

SCRIPT_DIRECTORY="$(dirname "${BASH_SOURCE[0]}")"
PROJECT_ROOT_DIRECTORY="$(cd "${SCRIPT_DIRECTORY}/../.." && pwd)"
FEATURES_DIRECTORY="${SCRIPT_DIRECTORY}/../features"

source "${FEATURES_DIRECTORY}/my_feature/my_module.sh"

function main() {
    # Script logic here
}

main
```

## Build Instructions

### Prerequisites

- CMake 3.15 or higher
- C++17 compatible compiler
- clang-format (for code formatting)

### Basic Build

```bash
# Configure
cmake -B build -DCMAKE_BUILD_TYPE=Release

# Build
cmake --build build

# Install
cmake --install build
```

### Code Formatting

Automatic code formatting is integrated into the build process:

```bash
cmake --build build
```

### Testing

Add tests to any module:

```cmake
# libraries/my_library/test/CMakeLists.txt
add_test_suite()
```

## License

### For Non-Commercial Use

This software is available under the terms of the MIT License for non-commercial use. See the [LICENSE](LICENSE) file for details.

### For Commercial Use

Commercial use requires compliance with additional terms as specified in the [LICENSE](LICENSE) file. Key points include:

- No reverse engineering
- No reproduction except for backup
- No sub-licensing, renting, or leasing
- All rights reserved by HolyGround

For commercial licensing inquiries, please contact: <fin@holyground.world>

## Contact

For questions or support regarding this template, please contact:

- Email: <fin@holyground.world>
- Project Homepage: <https://github.com/movingChurch/ultimate-cmake-skeleton>

## Contributing

While this is primarily a template project, contributions that improve the base functionality are welcome. Please ensure any contributions maintain the existing structure and coding standards.

## Acknowledgments

This template is maintained by HolyGround and is designed to provide a solid foundation for C++ projects of any scale.
