cmake_minimum_required(VERSION 3.2)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")

project(app)

add_executable(${PROJECT_NAME} src/main.cpp src/someClass.h src/someClass.cpp)


