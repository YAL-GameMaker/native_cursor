draw_set_font(fnt_test);
draw_set_color(c_white);

draw_text(5, 5, @"Try things out:
1: System cursor
2: Custom cursor
3: Animated cursor
4: Big cursor (may not work on some computers)
");
//if (keyboard_check_pressed(ord("0"))) native_cursor_set(emptyCursor);
if (keyboard_check_pressed(ord("1"))) native_cursor_reset();
if (keyboard_check_pressed(ord("2"))) native_cursor_set(imageCursor);
if (keyboard_check_pressed(ord("3"))) native_cursor_set(spriteCursor);
if (keyboard_check_pressed(ord("4"))) native_cursor_set(bigCursor);
