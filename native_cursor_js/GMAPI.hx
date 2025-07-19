import js.lib.ArrayBuffer;
import js.lib.Uint8ClampedArray;
import js.Browser.window;

class GMAPI {
	public static inline function getBuffer(ind:Int):Uint8ClampedArray {
		var abuf:ArrayBuffer = (cast window).gml_Script_gmcallback__native_cursor__buffer_get_address(null, null, ind);
		return new Uint8ClampedArray(abuf);
	}
}