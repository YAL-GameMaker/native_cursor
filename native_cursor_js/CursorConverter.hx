import js.Browser;
import haxe.ds.Vector;
import haxe.io.BytesOutput;
import js.lib.Uint8ClampedArray;

class CursorConverter {
	public static function run(d:PixelData, width:Int, height:Int, cx:Int, cy:Int) {
		var o = new BytesOutput();
		var area = width * height;
		var size = area * 4 + Math.ceil(area / 8);
		var b = new CursorBuf(size + (40 + 16 + 6));
		var bw = width; if (bw > 255) bw = 0;
		var bh = height; if (bh > 255) bh = 0;
		// header (6B):
		b.addShort(0); // reserved
		b.addShort(2); // { Icon = 1, Cursor = 2 }
		b.addShort(1); // # of images
		// directory (16B):
		b.addByte(bw);
		b.addByte(bh);
		b.addByte(0); // color count
		b.addByte(0); // reserved(?)
		b.addShort(cx);
		b.addShort(cy);
		b.addInt(size + 40);
		b.addInt(b.tell() + 4);
		// data header (40B):
		b.addInt(40); // header size
		b.addInt(width);
		b.addInt(height * 2);
		b.addShort(1); // reserved
		b.addShort(32); // bits per pixel
		b.addInt(0); // uncompressed
		b.addInt(0); // raw size
		b.addInt(0); // not h resolution?
		b.addInt(0); // not v resolution?
		b.addInt(0); // color count
		b.addInt(0); // important colors
		// pixels and mask:
		var maskPos = b.tell() + area * 4;
		var maskBit = 0;
		var dy = height;
		while (--dy >= 0) for (dx in 0 ... width) {
			var dp = (dy * width + dx) << 2;
			//
			var dr = d.red(dp);
			var dg = d.green(dp);
			var db = d.blue(dp);
			var da = d.alpha(dp);
			//
			#if sfgml_next
			b.addByte(dr);
			b.addByte(dg);
			b.addByte(db);
			b.addByte(da);
			#else
			b.addByte(db);
			b.addByte(dg);
			b.addByte(dr);
			b.addByte(da);
			#end
			//
			var dm = da == 0 ? (1 << (7 - maskBit)) : 0;
			b.set(maskPos, b.get(maskPos) | dm);
			if (++maskBit == 8) {
				maskBit = 0;
				maskPos += 1;
			}
		}
		//
		return b.finish();
	}
}

abstract PixelData(Dynamic) from Uint8ClampedArray to Uint8ClampedArray {
	public inline function new(size:Int) this = new Uint8ClampedArray(size);
	public inline function red(p:Int):Int return this[p];
	public inline function green(p:Int):Int return this[p + 1];
	public inline function blue(p:Int):Int return this[p + 2];
	public inline function alpha(p:Int):Int return this[p + 3];
}
class CursorBuf {
	public var arr:Vector<Int>;
	public var pos:Int;
	public var val:Int;
	public inline function new(size:Int) {
		arr = new Vector(size);
		pos = 0;
		val = 0;
	}
	public inline function tell() return pos;
	public inline function get(p:Int) return arr[p];
	public inline function set(p:Int, b:Int) arr[p] = b;
	public inline function addByte(b:Int) arr[pos++] = b;
	public inline function addShort(s:Int) {
		val = s;
		arr[pos++] = val & 0xff;
		arr[pos++] = (val >> 8) & 0xff;
	}
	public inline function addInt(s:Int) {
		val = s;
		arr[pos++] = val & 0xff;
		arr[pos++] = (val >> 8) & 0xff;
		arr[pos++] = (val >> 16) & 0xff;
		arr[pos++] = (val >>> 24) & 0xff;
	}
	public inline function finish() {
		var b64 = Browser.window.btoa(arr.map(String.fromCharCode).join(""));
		return 'data:image/x-icon;base64,$b64';
	}
}