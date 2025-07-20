g++ -std=c++17 \
    native_cursor.cpp autogen.cpp \
    -shared -fPIC \
    -D_LINUX -D_BUILD \
    -lX11 -lXcursor \
    -o ../export/native_cursor.so
