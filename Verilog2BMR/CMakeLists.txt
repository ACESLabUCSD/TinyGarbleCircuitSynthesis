cmake_minimum_required (VERSION 3.1.0 FATAL_ERROR)
project (TinyGarble-BMR
  VERSION 1.0.0
  LANGUAGES C CXX)

##############
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "4.6.3")
    message(FATAL_ERROR "Insufficient gcc version, should be at least 4.6.3")
  endif()
endif()

#############
enable_testing()
include_directories (${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${PROJECT_BINARY_DIR})

##############
# build type
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

if (CMAKE_BUILD_TYPE MATCHES Debug)
  message("Debug build.")
elseif (CMAKE_BUILD_TYPE MATCHES Release)
  message("Release build.")
else()
  message("Some other build type.")
endif ()

###############
# Compiler flags
set(CMAKE_CXX_FLAGS
  "${CMAKE_CXX_FLAGS} -Wall -Wno-strict-aliasing -march=native")

set (CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0 -g -DDEBUG")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -DNDEBUG")

###############
# Library

## Thread
find_package (Threads)

## Boost
set (Boost_USE_STATIC_LIBS OFF)
set (Boost_USE_MULTITHREADED ON)
set (Boost_USE_STATIC_RUNTIME OFF)
find_package (Boost 1.45.0
  REQUIRED
  COMPONENTS program_options)

if (Boost_FOUND)
  include_directories (${Boost_INCLUDE_DIRS})
endif (Boost_FOUND)

## OpenSSL
find_package (OpenSSL)

if (OPENSSL_FOUND)
	include_directories (${OPENSSL_INCLUDE_DIR})
endif (OPENSSL_FOUND)

###############
# Options
option (ENABLE_DUMP "Enable dump hex feature" ON)
option (ENABLE_LOG "Enable log feature" ON)
if (CMAKE_BUILD_TYPE MATCHES Debug)
	message("Turn Log on.")
	SET(ENABLE_LOG ON BOOL "Turn on logs in debug mode.")
endif (CMAKE_BUILD_TYPE MATCHES Debug)

add_library (Util_Log OBJECT
  "log.cpp")

add_library (BMR_ParseNetlist OBJECT
  "parse_netlist.cpp")

add_library (BMR_Scheduling OBJECT
  "scheduling.cpp")

add_library (BMR_BMR OBJECT
  "bmr.cpp")

add_library (BMR_V2BMR OBJECT
  "v_2_bmr.cpp")

add_executable(V2BMR_Main
  "v_2_bmr_main.cpp"
  "$<TARGET_OBJECTS:BMR_V2BMR>"
  "$<TARGET_OBJECTS:BMR_ParseNetlist>"
  "$<TARGET_OBJECTS:BMR_Scheduling>"
  "$<TARGET_OBJECTS:BMR_BMR>"
  "$<TARGET_OBJECTS:Util_Log>")

if (Boost_FOUND)
  target_link_libraries(V2BMR_Main ${Boost_LIBRARIES})
endif (Boost_FOUND)
target_link_libraries(V2BMR_Main -lrt)
