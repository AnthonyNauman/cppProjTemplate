cmake_minimum_required(VERSION 3.2)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")

project(app)


find_package(nlohmann_json REQUIRED)

add_executable(${PROJECT_NAME} src/main.cpp src/someClass.h src/someClass.cpp)

target_link_libraries(${PROJECT_NAME} nlohmann_json::nlohmann_json)
