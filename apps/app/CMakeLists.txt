cmake_minimum_required(VERSION 3.2)
project(app)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
add_executable(${PROJECT_NAME} src/main.cpp)
