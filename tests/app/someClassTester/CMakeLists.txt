cmake_minimum_required(VERSION 3.2)

SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# Test coverage
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -Wall -fprofile-arcs -ftest-coverage")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0 -Wall -W -fprofile-arcs -ftest-coverage")
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fprofile-arcs -ftest-coverage")

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")

project(someClassTester)

find_package(GTest REQUIRED)

set(TESTED_SOURCE_FOLDER ${CMAKE_SOURCE_DIR}/apps/app/src)

set(TESTED_SOURCES 
	${TESTED_SOURCE_FOLDER}/someClass.h
	${TESTED_SOURCE_FOLDER}/someClass.cpp
)

file( GLOB_RECURSE SOURCES FOLLOW_SYMLINKS
	${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp
   	${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
   	${CMAKE_CURRENT_SOURCE_DIR}/src/*.h
   	${CMAKE_CURRENT_SOURCE_DIR}/src/*.c
)

add_executable(${PROJECT_NAME} ${SOURCES} ${TESTED_SOURCES})

target_include_directories(${PROJECT_NAME}
    PRIVATE
	${GTEST_INCLUDE_DIRS}
    ${TESTED_SOURCE_FOLDER}
)

target_link_libraries(${PROJECT_NAME} PRIVATE GTest::gtest)

# # Testing
enable_testing()
