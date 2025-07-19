import js.html.CSSStyleRule;
import js.html.CanvasElement;
import js.Browser;
import js.html.StyleElement;
import js.html.CSSStyleSheet;
import js.html.CSSRuleList;
using StringTools;

class NativeCursorFrame {
	public static var canvas:CanvasElement;
	public static var style:StyleElement;
	public static var styleSheet:CSSStyleSheet;
	static inline var attr = "data-cursor";
	static var nextID = 0;
	//
	public var id:String;
	public var selector:String;
	public function new(dataURL:String) {
		id = Std.string(nextID++);
		selector = 'canvas[$attr="$id"]';
		var rule = '$selector { cursor: url($dataURL), default; }';
		styleSheet.insertRule(rule, styleSheet.cssRules.length);
	}
	public function destroy() {
		var rules = styleSheet.cssRules;
		for (i in 0 ... rules.length) {
			var rule:CSSStyleRule = cast rules[i];
			var sel:String = rule.selectorText ?? rule.cssText;
			if (sel.startsWith(selector)) {
				styleSheet.deleteRule(i);
				break;
			}
		}
	}
	public static var prevCursor = null;
	public function apply() {
		canvas.setAttribute(attr, id);
		var cur = canvas.style.cursor;
		if (cur != "") {
			prevCursor = cur;
			canvas.style.cursor = "";
		}
	}
	public static function reset() {
		canvas.removeAttribute(attr);
		var pc = prevCursor;
		if (pc != null) {
			canvas.style.cursor = pc;
			prevCursor = null;
		}
	}
	//
	public static function init() {
		style = Browser.document.createStyleElement();
		style.id = "native_cursor";
		Browser.document.body.appendChild(style);
		styleSheet = (cast style.sheet);
	}
}