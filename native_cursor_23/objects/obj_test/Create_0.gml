//var c = native_cursor_create_from_file(@"C:\Windows\Cursors\aero_busy_l.ani")//native_cursor_create();
emptyCursor = native_cursor_create_empty();
imageCursor = native_cursor_create_from_sprite(spr_cursor, 0);
spriteCursor = native_cursor_create_from_sprite(spr_cursor_stripes, undefined, 8);
native_cursor_set_frame(spriteCursor, 1);
show_debug_message(native_cursor_get_frame(spriteCursor))
bigCursor = native_cursor_create_from_sprite_ext(spr_cursor, 0, 2, 2, c_white, 1);
native_cursor_set(imageCursor);

#region directional cursor
dir_count = 360;
dir_cursors = [];
var _surf = surface_create(64, 64);
var _texf = gpu_get_texfilter();
gpu_set_tex_filter(true);
for (var i = 0; i < dir_count; i++) {
	surface_set_target(_surf);
	draw_clear_alpha(c_white, 0);
	draw_sprite_ext(spr_cursor_dir, 0, 32, 32, 1, 1, i * 360 / dir_count, c_white, 1);
	surface_reset_target();
	dir_cursors[i] = native_cursor_create_from_surface(_surf, 32, 32);
}
surface_free(_surf);
gpu_set_tex_filter(_texf);
dir_callback = function(_x, _y) {
	var dir = point_direction(window_get_width() div 2, window_get_height() div 2, _x, _y);
	var ind = round(dir / 360 * dir_count) % dir_count;
	if (ind < 0) ind += dir_count;
	native_cursor_set(dir_cursors[ind]);
};
#endregion