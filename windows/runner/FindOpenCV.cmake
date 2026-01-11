message(STATUS "=== Starting OpenCV Search ===")

# Основной путь
set(OPENCV_ROOT "C:/opencv")
message(STATUS "OpenCV root: ${OPENCV_ROOT}")

if(NOT EXISTS "${OPENCV_ROOT}")
    message(STATUS "OpenCV root directory not found!")
    return()
endif()

# Ищем include директорию
set(OPENCV_INCLUDE_CANDIDATES
    "${OPENCV_ROOT}/build/include"
    "${OPENCV_ROOT}/include"
    "${OPENCV_ROOT}/opencv/include"
)

foreach(INCLUDE_DIR IN LISTS OPENCV_INCLUDE_CANDIDATES)
    if(EXISTS "${INCLUDE_DIR}/opencv2")
        set(OpenCV_INCLUDE_DIRS "${INCLUDE_DIR}")
        message(STATUS "Found OpenCV includes: ${OpenCV_INCLUDE_DIRS}")
        break()
    endif()
endforeach()

if(NOT OpenCV_INCLUDE_DIRS)
    message(STATUS "OpenCV include directory not found!")
    return()
endif()

# Ищем библиотеки
set(OPENCV_LIB_CANDIDATES
    "${OPENCV_ROOT}/build/x64/vc16/lib"
    "${OPENCV_ROOT}/build/x64/vc15/lib"
    "${OPENCV_ROOT}/build/x64/vc14/lib" 
    "${OPENCV_ROOT}/build/lib"
    "${OPENCV_ROOT}/lib"
)

foreach(LIB_DIR IN LISTS OPENCV_LIB_CANDIDATES)
    if(EXISTS "${LIB_DIR}")
        message(STATUS "Checking lib directory: ${LIB_DIR}")
        
        # Ищем любые OpenCV библиотеки
        file(GLOB OPENCV_LIBS_FOUND 
            "${LIB_DIR}/opencv_world*.lib"
            "${LIB_DIR}/opencv_core*.lib"
        )
        
        if(OPENCV_LIBS_FOUND)
            list(GET OPENCV_LIBS_FOUND 0 OpenCV_LIBS)  # Берем первую найденную
            message(STATUS "Found OpenCV libs: ${OPENCV_LIBS_FOUND}")
            message(STATUS "Using: ${OpenCV_LIBS}")
            break()
        else()
            message(STATUS "No OpenCV lib files found in ${LIB_DIR}")
        endif()
    endif()
endforeach()

if(OpenCV_LIBS)
    set(OpenCV_FOUND TRUE)
    message(STATUS "=== OpenCV FOUND ===")
else()
    message(STATUS "=== OpenCV NOT FOUND ===")
endif()