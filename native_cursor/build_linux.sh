g++ -std=c++17 \
    native_cursor.cpp autogen.cpp \
    -shared -fPIC \
    -D_LINUX -D_BUILD \
    -lX11 -lXcursor \
    -o ../native_cursor_23/extensions/native_cursor/native_cursor.so
