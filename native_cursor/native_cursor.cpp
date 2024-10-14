// native_cursor.cpp
/// @author YellowAfterlife

#include "stdafx.h"

struct native_cursor {
	int count;
	double frameStart;
	uint64_t timeStart;
	uint64_t timeOffset;
	double timeMult;
	double framerate;
	HCURSOR* cursors;
	HBITMAP* bitmaps;
	uint8_t** pixelArrays;
	inline void init(int _count) {
		frameStart = 0;
		count = _count;
		timeStart = GetTickCount64();
		timeOffset = 0;
		timeMult = 30;
		framerate = 30;
		bitmaps = malloc_arr<HBITMAP>(_count);
		cursors = malloc_arr<HCURSOR>(_count);
		pixelArrays = malloc_arr<uint8_t*>(_count);
		for (int i = 0; i < _count; i++) {
			bitmaps[i] = nullptr;
			cursors[i] = nullptr;
			pixelArrays[i] = nullptr;
		}
	}
	inline void setFramerate(double fps) {
		framerate = fps;
		timeMult = fps / 1000.;
	}
	inline int addFrames(int _count) {
		auto start = count;
		auto newcount = start + _count;
		count = newcount;
		cursors = realloc_arr<HCURSOR>(cursors, newcount);
		bitmaps = realloc_arr<HBITMAP>(bitmaps, newcount);
		pixelArrays = realloc_arr<uint8_t*>(pixelArrays, newcount);
		for (int i = start; i < newcount; i++) {
			cursors[i] = nullptr;
			bitmaps[i] = nullptr;
			pixelArrays[i] = nullptr;
		}
		return start;
	}
	inline void clear() {
		cursors = NULL;
		bitmaps = NULL;
		pixelArrays = nullptr;
	}
	inline int getCurrentFrame() {
		if (count == 0) return -1;
		auto t = GetTickCount64() - timeStart;
		auto f = t * timeMult;
		#if (_M_IX86 == 600)
		// I don't want to implement all_rem myself
		auto fi = ((int)f) % count;
		if (fi < 0) fi += count;
		#else
		auto fi = ((int64_t)f) % count;
		if (fi < 0) fi += count;
		#endif
		//trace("cursor %d/%d->%x", fi, cur->count, cur->cursors[fi]);
		return (int)fi;
	}
	inline HCURSOR getCurrentCursor() {
		auto fi = getCurrentFrame();
		if (fi < 0) return NULL;
		return cursors[fi];
	}
	inline void free() {
		auto n = count;
		if (cursors) {
			for (int i = 0; i < n; i++) {
				if (cursors[i]) DestroyCursor(cursors[i]);
			}
			::free(cursors);
		}
		if (bitmaps) {
			for (int i = 0; i < n; i++) {
				if (bitmaps[i]) DeleteObject(bitmaps[i]);
			}
			::free(bitmaps);
		}
		if (pixelArrays) {
			for (int i = 0; i < n; i++) {
				if (pixelArrays[i]) ::free(pixelArrays[i]);
			}
			::free(pixelArrays);
		}
		clear();
	}
};
struct {
	native_cursor* cursor;
	HCURSOR hcursor;
	int x, y;
	bool moved;
	bool inbound;
	LPARAM lastLPARAM;
	WPARAM lastWPARAM;
	inline void init() {
		cursor = nullptr;
		hcursor = NULL;
		x = 0; y = 0;
		moved = false;
		inbound = false;
		lastLPARAM = 0;
		lastWPARAM = 0;
	}
} current;

static bool SwapRedBlue_needed;
void SwapRedBlue(BYTE* buf, size_t count) {
	if (!SwapRedBlue_needed) return;
	size_t i = 0;
	const size_t count_nand_15 = count & ~15;
	while (i < count_nand_15) {
		std::swap(buf[i], buf[i + 2]);
		std::swap(buf[i + 4], buf[i + 6]);
		std::swap(buf[i + 8], buf[i + 10]);
		std::swap(buf[i + 12], buf[i + 14]);
		i += 16;
	}
	for (; i < count; i += 4) std::swap(buf[i], buf[i + 2]);
}

static uint8_t native_cursor_apply_impl_state = 0;
bool native_cursor_apply_impl(bool force) {
	if (native_cursor_apply_impl_state > 0) force = true;
	auto cur = current.cursor;
	if (cur == nullptr || cur->count <= 0) return false;
	if (!current.inbound) return false;
	auto hc = cur->getCurrentCursor();
	if (!force && hc == current.hcursor) return true;
	current.hcursor = hc;
	SetCursor(hc);
	native_cursor_apply_impl_state = 2;
	return true;
}

HWND game_window;
WNDPROC wndproc_base;
extern bool native_cursor_callback_enable, native_cursor_callback_highp;
bool native_cursor_callback(int x, int y);
LRESULT CALLBACK wndproc_hook(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp) {
	static int mx = 0, my = 0;
	switch (msg) {
		case WM_MOUSEMOVE:
			current.x = (short)LOWORD(lp);
			current.y = (short)HIWORD(lp);
			current.moved = true;
			break;
		case WM_SETCURSOR:
			//trace("x=%d y=%d f=%d", current.x, current.y, (lp & 0xffff));
			
			// a clear miss if it says that it didn't hit client area:
			current.inbound = (lp & 0xffff) == HTCLIENT;
			current.lastLPARAM = lp;
			current.lastWPARAM = wp;
			if (!current.inbound) break;
			
			// why does Windows report hitting client area when mouseovering Win10 window shadow?
			do {
				RECT crect;
				if (!GetClientRect(hwnd, &crect)) continue;
				POINT mousePos;
				if (!GetCursorPos(&mousePos)) continue;
				if (!ScreenToClient(hwnd, &mousePos)) continue;
				//trace("mx=%d my=%d", mousePos.x, mousePos.y);
				if (PtInRect(&crect, mousePos)) continue;
				current.inbound = false;
			} while (false);
			if (!current.inbound) break;

			//
			if (native_cursor_callback_enable && native_cursor_callback_highp) {
				native_cursor_apply_impl_state = 1;
				native_cursor_callback(current.x, current.y);
				auto called = native_cursor_apply_impl_state == 2;
				native_cursor_apply_impl_state = 0;
				if (called) return TRUE;
			}
			//
			if (!native_cursor_apply_impl(true)) break;
			return TRUE;
	}
	return CallWindowProc(wndproc_base, hwnd, msg, wp, lp);
}
///
dllx void native_cursor_update() {
	auto apply = true;
	//
	if (native_cursor_callback_enable && !native_cursor_callback_highp && current.moved) {
		
		native_cursor_apply_impl_state = 1;
		native_cursor_callback(current.x, current.y);
		if (native_cursor_apply_impl_state == 2) apply = false;
		native_cursor_apply_impl_state = 0;
	}
	//
	if (apply) {
		auto cur = current.cursor;
		if (cur && cur->count > 1) native_cursor_apply_impl(false);
	}
	//
	current.moved = false;
}

uint8_t* CreateBgraFromGmPixels(uint8_t* source, size_t size) {
	auto pixels = malloc_arr<uint8_t>(size);
	memcpy(pixels, source, size);
	SwapRedBlue(pixels, size);
	return pixels;
}
HBITMAP CreateBitmapFromBGRA(uint8_t* pixels, int width, int height) {
	auto bitmap = CreateBitmap(width, height, 1, 32, nullptr);
	auto dc = GetDC(NULL);
	BITMAPINFO bm{};
	auto& bmi = bm.bmiHeader;
	bmi.biSize = sizeof(bmi);
	bmi.biWidth = width;
	bmi.biHeight = -height;
	bmi.biPlanes = 1;
	bmi.biBitCount = 32;
	SetDIBits(dc, bitmap, 0, height, pixels, &bm, 0);
	ReleaseDC(NULL, dc);
	return bitmap;
}
HCURSOR CreateCursorFromBitmap(HBITMAP bitmap, int hotspot_x, int hotspot_y) {
	ICONINFO inf{};
	inf.fIcon = FALSE;
	inf.hbmColor = bitmap;
	inf.hbmMask = bitmap;
	inf.xHotspot = hotspot_x;
	inf.yHotspot = hotspot_y;
	return (HCURSOR)CreateIconIndirect(&inf);
}

dllg gml_ptr<native_cursor> native_cursor_create_from_buffer(gml_buffer buf, int width, int height, int hotspot_x, int hotspot_y, double fps = 30) {
	auto cur = malloc_arr<native_cursor>(1);
	auto size = (width * height * 4);
	if (buf.size() < size) return nullptr;

	cur->init(1);
	cur->setFramerate(fps);
	//
	auto pixels = CreateBgraFromGmPixels(buf.data(), (size_t)size);
	cur->pixelArrays[0] = pixels;
	//
	auto bitmap = CreateBitmapFromBGRA(pixels, width, height);
	cur->bitmaps[0] = bitmap;
	//
	auto cursor = CreateCursorFromBitmap(bitmap, hotspot_x, hotspot_y);
	cur->cursors[0] = cursor;
	if (cursor == NULL) trace("Failed to create cursor, GetLastError=%d", GetLastError());
	return cur;
}
dllg void native_cursor_add_from_buffer(gml_ptr<native_cursor> cursor, gml_buffer buf, int width, int height, int hotspot_x, int hotspot_y) {
	auto size = (width * height * 4);
	if (buf.size() < size) return;
	auto frame = cursor->addFrames(1);
	//
	auto pixels = CreateBgraFromGmPixels(buf.data(), (size_t)size);
	cursor->pixelArrays[frame] = pixels;
	//
	auto bitmap = CreateBitmapFromBGRA(pixels, width, height);
	cursor->bitmaps[frame] = bitmap;
	//
	auto hcursor = CreateCursorFromBitmap(bitmap, hotspot_x, hotspot_y);
	cursor->cursors[frame] = hcursor;
	if (hcursor == NULL) trace("Failed to create cursor, GetLastError=%d", GetLastError());
}

dllg gml_ptr<native_cursor> native_cursor_create_empty() {
	auto cur = malloc_arr<native_cursor>(1);
	cur->init(0);
	return cur;
}

dllg gml_ptr<native_cursor> native_cursor_create_from_full_path(const char* path) {
	auto wpathSize = MultiByteToWideChar(CP_UTF8, 0, path, -1, NULL, 0);
	auto wpath = malloc_arr<wchar_t>(wpathSize);
	MultiByteToWideChar(CP_UTF8, 0, path, -1, wpath, wpathSize);
	auto cur = malloc_arr<native_cursor>(1);
	cur->init(1);
	cur->cursors[0] = LoadCursorFromFileW(wpath);
	::free(wpath);
	return cur;
}
dllg void native_cursor_add_from_full_path(gml_ptr<native_cursor> cursor, const char* path) {
	auto wpathSize = MultiByteToWideChar(CP_UTF8, 0, path, -1, NULL, 0);
	auto wpath = malloc_arr<wchar_t>(wpathSize);
	MultiByteToWideChar(CP_UTF8, 0, path, -1, wpath, wpathSize);
	auto i = cursor->addFrames(1);
	cursor->cursors[i] = LoadCursorFromFileW(wpath);
	::free(wpath);
}
dllx double native_cursor_check_full_path(const char* path) {
	auto wpathSize = MultiByteToWideChar(CP_UTF8, 0, path, -1, NULL, 0);
	auto wpath = malloc_arr<wchar_t>(wpathSize);
	MultiByteToWideChar(CP_UTF8, 0, path, -1, wpath, wpathSize);
	auto attrs = GetFileAttributesW(wpath);
	::free(wpath);
	return attrs != INVALID_FILE_ATTRIBUTES && ((attrs & FILE_ATTRIBUTE_DIRECTORY) == 0);
}

dllg void native_cursor_set(gml_ptr<native_cursor> cursor) {
	if (current.cursor) {
		current.cursor->timeOffset = GetTickCount64() - current.cursor->timeStart;
	}
	current.cursor = cursor;
	cursor->timeStart = GetTickCount64() - cursor->timeOffset;
	native_cursor_apply_impl(false);
}
dllg void native_cursor_reset() {
	if (current.cursor) {
		current.cursor->timeOffset = GetTickCount64() - current.cursor->timeStart;
	}
	current.cursor = nullptr;
	current.hcursor = nullptr;
	SetCursor(NULL);
	CallWindowProc(wndproc_base, game_window, WM_SETCURSOR, current.lastWPARAM, current.lastLPARAM);
}

dllg int native_cursor_get_frame(gml_ptr<native_cursor> cursor) {
	return cursor->getCurrentFrame();
}
dllg void native_cursor_set_frame(gml_ptr<native_cursor> cursor, int frame) {
	if (cursor->count <= 0) return;
	frame = frame % cursor->count;
	if (frame < 0) frame += cursor->count;
	if (cursor == current.cursor) {
		cursor->timeStart = GetTickCount64() - (int)(frame / cursor->timeMult);
	} else {
		cursor->timeOffset = (int)(frame / cursor->timeMult);
	}
}

dllg double native_cursor_get_framerate(gml_ptr<native_cursor> cursor) {
	return cursor->framerate;
}
dllg void native_cursor_set_framerate(gml_ptr<native_cursor> cursor, int fps) {
	cursor->setFramerate(fps);
}

dllg void native_cursor_destroy(gml_ptr_destroy<native_cursor> cursor) {
	if (cursor == current.cursor) {
		current.cursor = nullptr;
		current.hcursor = NULL;
		SetCursor(NULL);
		CallWindowProc(wndproc_base, game_window, WM_SETCURSOR, current.lastWPARAM, current.lastLPARAM);
	}
	cursor->free();
}


dllx void native_cursor_preinit_raw(void* _hwnd_as_ptr, double _swapBR) {
	SwapRedBlue_needed = _swapBR > 0.5;
	game_window = (HWND)_hwnd_as_ptr;
	if (wndproc_base == nullptr) {
		wndproc_base = (WNDPROC)SetWindowLongPtr(game_window, GWLP_WNDPROC, (LONG_PTR)wndproc_hook);
	}
}


bool native_cursor_preinit_statics() {
	SwapRedBlue_needed = false;
	wndproc_base = nullptr;
	current.init();
	//
	void native_cursor_preinit_statics_cb();
	native_cursor_preinit_statics_cb();
	return true;
}

#ifdef NDEBUG
BOOL APIENTRY DllMain(HMODULE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved) {
	if (ul_reason_for_call == DLL_PROCESS_ATTACH) {
		native_cursor_preinit_statics();
	}
	return TRUE;
}
#else
static bool __ready__ = native_cursor_preinit_statics();
#endif