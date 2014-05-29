#save our config for later
configure_file(moai_config.h.in "${CMAKE_CURRENT_BINARY_DIR}/moai_config.h")
configure_file(moai_version.h.in "${CMAKE_CURRENT_BINARY_DIR}/moai_version.h")

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/moai_config.h" 
              "${CMAKE_CURRENT_BINARY_DIR}/moai_version.h" 

	DESTINATION "include/config")