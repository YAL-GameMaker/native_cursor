draw_set_font(fnt_test);
draw_set_color(c_white);

var _text = "Try things out:";
_text += "\n[1] Default cursor";
if (keyboard_check_pressed(ord("1"))) {
	window_set_cursor(cr_arrow);
	native_cursor_reset();
}

_text += "\n[2] Custom cursor";
if (keyboard_check_pressed(ord("2"))) native_cursor_set(imageCursor);

_text += "\n[3] Animated cursor";
if (keyboard_check_pressed(ord("3"))) native_cursor_set(spriteCursor);

_text += "\n[4] Huge cursor (may not work on some computers)";
if (keyboard_check_pressed(ord("4"))) native_cursor_set(bigCursor);

_text += "\n[0] Hide cursor";
if (keyboard_check_pressed(ord("0"))) {
	window_set_cursor(cr_none);
	native_cursor_reset();
}

draw_text(5, 5, _text);