#save our config for later
configure_file(moai_config.h.in "${CMAKE_CURRENT_BINARY_DIR}/moai_config.h")
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/moai_config.h" DESTINATION "include/config")