set(tmpdir ${CMAKE_CURRENT_BINARY_DIR})

add_executable(test_io test_io.f90)
target_link_libraries(test_io PRIVATE nc4fortran::nc4fortran)
if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  target_compile_options(test_io PRIVATE -Wno-compare-reals)
endif()
add_test(NAME ReadWrite COMMAND $<TARGET_FILE:test_io> ${CMAKE_CURRENT_BINARY_DIR})
set_tests_properties(ReadWrite PROPERTIES SKIP_RETURN_CODE 77)

add_executable(test_errors test_errors.f90)
target_link_libraries(test_errors PRIVATE nc4fortran::nc4fortran)
add_test(NAME Errors COMMAND $<TARGET_FILE:test_errors> ${CMAKE_CURRENT_BINARY_DIR})
set_tests_properties(Errors PROPERTIES SKIP_RETURN_CODE 77)
