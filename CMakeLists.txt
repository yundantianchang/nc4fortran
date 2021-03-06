cmake_minimum_required(VERSION 3.14)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release")
endif()
project(nc4fortran
  LANGUAGES Fortran
  VERSION 0.5.0
  DESCRIPTION "thin, light object-oriented NetCDF4 Fortran interface"
  HOMEPAGE_URL https://github.com/geospace-code/nc4fortran)

enable_testing()
include(CTest)
include(FeatureSummary)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

# this helps linters e.g. Visual Studio Intellicode work properly
set(CMAKE_EXPORT_COMPILE_COMMANDS on)

set_package_properties(NetCDF PROPERTIES URL "https://www.unidata.ucar.edu/software/netcdf/" DESCRIPTION "fast, versatile file I/O format")

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/compilers.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/netcdf.cmake)

if(NOT NCDFOK)
  message(STATUS "nc4fortran: NetCDF4 not working")
  if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    message(FATAL_ERROR)
  else()
    return()
  endif()
endif()

# --- build

add_library(nc4fortran)
target_include_directories(nc4fortran
  PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/include  # for IBM XL
  INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
  $<INSTALL_INTERFACE:include>)
target_link_libraries(nc4fortran PUBLIC NetCDF::NetCDF_Fortran)
set_target_properties(nc4fortran PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include)
add_library(nc4fortran::nc4fortran ALIAS nc4fortran)

add_subdirectory(src)

if(PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  add_subdirectory(src/tests)

  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/install.cmake)

  feature_summary(WHAT ALL)
endif()
