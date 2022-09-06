#define native_cursor_compat_preinit
//#init native_cursor_compat_preinit
global.__native_cursor_compat_current = undefined;

#define window_set_cursor_normal
var c0 = global.__native_cursor_compat_current;
global.__native_cursor_compat_current = undefined;
native_cursor_reset();
if (c0 != undefined) native_cursor_destroy(c0);

#define window_set_cursor_sprite
/// (sprite, subimg)
var c0 = global.__native_cursor_compat_current;
var c1 = native_cursor_create_from_sprite(argument0, argument1);
global.__native_cursor_compat_current = c1;
native_cursor_set(c1);
if (c0 != undefined) native_cursor_destroy(c0);

#define window_set_cursor_sprite_ext
/// (sprite, subimg, image_xscale, image_yscale, image_blend, image_alpha)
var c0 = global.__native_cursor_compat_current;
var c1 = native_cursor_create_from_sprite_ext(argument0, argument1, argument2, argument3, argument4, argument5);
global.__native_cursor_compat_current = c1;
native_cursor_set(c1);
if (c0 != undefined) native_cursor_destroy(c0);

#define window_set_cursor_surface
/// (surface, xoffset, yoffset)
var c0 = global.__native_cursor_compat_current;
var c1 = native_cursor_create_from_surface(argument0, argument1, argument2);
global.__native_cursor_compat_current = c1;
native_cursor_set(c1);
if (c0 != undefined) native_cursor_destroy(c0);
