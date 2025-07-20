//show_message("!");
emptyCursor = native_cursor_create_empty();
imageCursor = native_cursor_create_from_sprite(spr_cursor, 0);
spriteCursor = native_cursor_create_from_sprite(spr_cursor_stripes, undefined, 8);
native_cursor_set_frame(spriteCursor, 1);
bigCursor = native_cursor_create_from_sprite_ext(spr_cursor, 0, 2, 2, c_white, 1);
native_cursor_set(imageCursor);
