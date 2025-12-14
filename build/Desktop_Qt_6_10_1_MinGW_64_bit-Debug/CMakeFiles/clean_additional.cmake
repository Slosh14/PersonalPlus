# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appPersonalPlus_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appPersonalPlus_autogen.dir\\ParseCache.txt"
  "appPersonalPlus_autogen"
  )
endif()
