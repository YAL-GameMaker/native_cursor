import sys.io.File;
import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr;

class Postproc {
	static var exposeList:Array<ExposeItem> = [];
	static var exposeMap = new Map<String, ExposeItem>();
	public static macro function build():Array<Field> {
		var fields = Context.getBuildFields();
		for (field in fields) {
			var expose = field.meta.filter(m -> m.name == ":expose")[0];
			if (expose == null) continue;
			var name = switch (expose.params[0].expr) {
				case EConst(CString(s)): s;
				default: continue;
			}
			var item = new ExposeItem();
			item.name = name;
			item.isDoc = field.meta.filter(m -> m.name == ":doc").length > 0;
			exposeList.push(item);
			exposeMap[name] = item;
		}
		return null;
	}
	public static macro function main():Void {
		Context.onAfterGenerate(() -> {
			var path = Compiler.getOutput();
			var js = File.getContent(path);
			var rx = new EReg(("^"
				+ ".+?"
				+ "\\$hx_exports\\[\"(\\w+)\"\\]"
			), "gm");
			js = rx.map(js, (rx) -> {
				var snip = rx.matched(0);
				var name = rx.matched(1);
				var item = exposeMap[name];
				if (item != null && !item.isDoc) {
					snip = "///~\n" + snip;
				}
				return snip;
			});
			File.saveContent(path, js);
		});
	}
}
class ExposeItem {
	public var name:String = null;
	public var isDoc = false;
	public var hasReturn = false;
	public function new() {
		
	}
}