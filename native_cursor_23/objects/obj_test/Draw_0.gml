draw_set_font(fnt_test);
draw_set_color(c_white);

var _text = "Try things out:";
if (native_cursor_get_callback() != undefined) {
	_text += "\n[1] Back to normal modes";
	if (keyboard_check_pressed(ord("1"))) {
		native_cursor_set_callback();
		window_set_cursor(cr_arrow);
		native_cursor_reset();
	}
	//
	var _mode = native_cursor_get_callback_mode(), _mode_name;
	if (_mode == native_cursor_set_callback_mode_highp) {
		_mode_name = "high-precision";
	} else _mode_name = "low-precision";
	_text += "\n[2] Change mode (current: " + _mode_name + ")";
	if (keyboard_check_pressed(ord("2"))) {
		if (_mode == native_cursor_set_callback_mode_highp) {
			_mode = native_cursor_set_callback_mode_lowp;
		} else _mode = native_cursor_set_callback_mode_highp;
		native_cursor_set_callback_mode(_mode);
	}
} else {
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
	
	_text += "\n[5] Directional cursor";
	if (keyboard_check_pressed(ord("5"))) {
		native_cursor_set_callback(dir_callback);
		dir_callback(window_mouse_get_x(), window_mouse_get_y());
	}
	
	_text += "\n[0] Hide cursor";
	if (keyboard_check_pressed(ord("0"))) {
		window_set_cursor(cr_none);
		native_cursor_reset();
	}
}

draw_text(5, 5, _text);