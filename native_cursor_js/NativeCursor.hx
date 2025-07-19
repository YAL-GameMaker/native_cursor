import js.Browser;
import js.lib.Uint8ClampedArray;
import js.html.Console;
using StringTools;

@:keep class NativeCursor {
	public static var current:NativeCursor = new NativeCursor();
	public static var currentFrame:NativeCursorFrame = null;
	public static var moved = false;
	//
	public var frames:Array<NativeCursorFrame> = [];
	public var count(get, never):Int;
	inline function get_count() {
		return frames.length;
	}
	//
	public var timeStart = 0.0;
	public var timeOffset = 0.0;
	public var timeMult = 30.0;
	public var framerate = 30.0;
	public static inline function getTime() {
		return Date.now().getTime();
	}
	public function new() {
		timeStart = getTime();
	}
	public function destroy() {
		for (frame in frames) frame.destroy();
		frames.resize(0);
	}
	//
	public function addFromBuffer(buf:Int, width:Int, height:Int, x:Int, y:Int) {
		var arr = GMAPI.getBuffer(buf);
		var url = CursorConverter.run(arr, width, height, x, y);
		var frame = new NativeCursorFrame(url);
		frames.push(frame);
	}
	public function getCurrentFrame() {
		var n = count;
		if (n <= 0) return -1;
		var t = getTime() - timeStart;
		var f = t * timeMult;
		var fi = Std.int(f) % n;
		if (fi < 0) fi += n;
		return fi;
	}
	public function setFrame(frame:Int) {
		var n = count;
		if (n <= 0) return false;
		frame %= n;
		if (frame < 0) frame += n;
		if (this == current) {
			timeStart = getTime() - Std.int(frame / timeMult);
		} else {
			timeOffset = Std.int(frame / timeMult);
		}
		return true;
	}
	public function apply(force:Bool) {
		var cur = current;
		if (cur == null || cur.frames.length == 0) return false;
		
		var frame = cur.frames[cur.getCurrentFrame()];
		if (frame == null) return false;
		
		if (!force && frame == currentFrame) return true;
		currentFrame = frame;
		frame.apply();
		return true;
	}
}
