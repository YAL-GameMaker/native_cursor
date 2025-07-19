import js.html.MouseEvent;
import js.html.CanvasElement;
import js.html.CSSStyleSheet;
import js.Browser;
import js.html.StyleElement;
import js.html.Console;
import NativeCursor;

@:build(Postproc.build())
class Extension {
	@:expose("native_cursor_create_empty")
	static function createEmpty() {
		return new NativeCursor();
	}
	
	@:expose("native_cursor_create_from_buffer")
	static function createFromBuffer(buf:Int, width:Int, height:Int, x:Int, y:Int, fps:Float) {
		var cur = new NativeCursor();
		cur.addFromBuffer(buf, width, height, x, y);
		return cur;
	}
	
	@:expose("native_cursor_add_from_buffer")
	static function addFromBuffer(cur:NativeCursor, buf:Int, width:Int, height:Int, x:Int, y:Int) {
		cur.addFromBuffer(buf, width, height, x, y);
		return cur;
	}
	
	@:expose("native_cursor_destroy")
	static function destroy(cur:NativeCursor) {
		if (cur == NativeCursor.current) {
			NativeCursorFrame.reset();
		}
		cur.destroy();
	}
	
	@:expose("native_cursor_update")
	static function update() {
		var cur = NativeCursor.current;
		if (cur != null && cur.frames.length > 0) {
			cur.apply(false);
		}
		return false;
	}
	
	@:expose("native_cursor_set")
	static function set(cur:NativeCursor) {
		var current = NativeCursor.current;
		if (current != null) {
			current.timeOffset = NativeCursor.getTime() - current.timeStart;
		}
		NativeCursor.current = cur;
		cur.timeStart = NativeCursor.getTime() - cur.timeOffset;
		cur.apply(false);
	}
	
	@:expose("native_cursor_reset")
	static function reset() {
		var current = NativeCursor.current;
		if (current != null) {
			current.timeOffset = NativeCursor.getTime() - current.timeStart;
		}
		NativeCursor.current = null;
		NativeCursor.currentFrame = null;
		NativeCursorFrame.reset();
	}
	
	@:expose("native_cursor_get_frame")
	static function getFrame(cur:NativeCursor) {
		return cur.getCurrentFrame();
	}
	
	@:expose("native_cursor_set_frame")
	static function setFrame(cur:NativeCursor, frame:Int) {
		cur.setFrame(frame);
	}
	
	@:expose("native_cursor_get_framerate")
	static function getFramerate(cur:NativeCursor) {
		return cur.framerate;
	}
	
	@:expose("native_cursor_set_framerate")
	static function setFramerate(cur:NativeCursor, fps:Int) {
		cur.framerate = fps;
		cur.timeMult = fps / 1000.0;
	}
	
	@:expose("native_cursor_preinit_raw")
	static function init(canvasID:String, _) {
		var canvas:CanvasElement = cast Browser.document.getElementById(canvasID);
		canvas.addEventListener("mousemove", (e:MouseEvent) -> {
			NativeCursor.moved = true;
		});
		NativeCursorFrame.canvas = canvas;
		NativeCursorFrame.init();
		return false;
	}
	
	static inline function main() {
		
	}
}