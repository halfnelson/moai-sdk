cmake_minimum_required ( VERSION 2.8.11 )
project ( moai-ios-adcolony )

set(ADCOLONY_LIB ${MOAI_ROOT}/3rdparty/adcolonyiOS-1911/Library/libAdColony.a)
add_library(libAdColony STATIC IMPORTED)
set_property(TARGET libAdColony PROPERTY IMPORTED_LOCATION ${ADCOLONY_LIB})

install(FILES ${ADCOLONY_LIB} DESTINATION lib)