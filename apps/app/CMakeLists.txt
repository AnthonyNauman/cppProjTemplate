cmake_minimum_required(VERSION 3.2)

SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")

project(app)

add_executable(${PROJECT_NAME} src/main.cpp src/someClass.h src/someClass.cpp)


