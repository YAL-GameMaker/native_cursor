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
	static inline var attrCursor = "data-cursor";
	static var nextID = 0;
	//
	static var count = 0;
	//
	public var id:String;
	public var selector:String;
	public function new(dataURL:String) {
		id = Std.string(nextID++);
		selector = 'canvas[$attrCursor="$id"]';
		var rule = '$selector { cursor: url($dataURL), default; }';
		styleSheet.insertRule(rule, styleSheet.cssRules.length);
		style.dataset.count = "" + (++count);
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
		style.dataset.count = "" + (--count);
	}
	public static var prevCursor = null;
	public function apply() {
		canvas.setAttribute(attrCursor, id);
		var cur = canvas.style.cursor;
		if (cur != "") {
			prevCursor = cur;
			canvas.style.cursor = "";
		}
	}
	public static function reset() {
		canvas.removeAttribute(attrCursor);
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