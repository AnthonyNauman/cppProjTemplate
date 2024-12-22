cmake_minimum_required(VERSION 3.2)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")

project(App)


option(BUILD_TEST_TOOLS "Build test tools" ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


add_subdirectory(apps/app)
if (BUILD_TEST_TOOLS)
    add_subdirectory(tests/app/someClassTester)
endif()

