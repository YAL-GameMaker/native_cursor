// native_cursor_callback.cpp
#include "stdafx.h"

const int VALUE_REAL = 0;

#pragma pack( push, 4)
struct RValue {
	union {
		double val;
		void* ptr;
	};
	unsigned int flags = 0;
	unsigned int kind = VALUE_REAL;
};
class CInstance;
#pragma pack(pop)
#define YYFuncArgs RValue& result, CInstance* self, CInstance* other, int argc, RValue* arg
typedef void(*YYFunc) (YYFuncArgs);

static int CScriptRefOffset;
static int findCScriptRefOffset(void* _fptr_1, void* _fptr_2, void* _mptr_1, void* _mptr_2) {
	auto f1 = (void**)_fptr_1;
	auto f2 = (void**)_fptr_2;
	auto f3 = (void**)_mptr_1;
	auto f4 = (void**)_mptr_2;
	void** fx[] = { f1, f2, f3, f4 };
	for (auto i = 10u; i < 24; i++) {
		auto step = 0u;
		for (; step < 2; step++) {
			auto fi = fx[step];

			// should be NULL, <addr>, NULL:
			if (fi[i - 1] != nullptr) break;
			if (fi[i] == nullptr) break;
			if (fi[i + 1] != nullptr) break;
			// and the method pointers shouldn't have a function in them:
			auto mi = fx[step + 2];
			if (mi[i] != nullptr) break;
		}
		if (step < 2u) continue;

		// destination address must match:
		auto dest = f1[i];
		if (dest != f2[i]) continue;

		return (int)(sizeof(void*) * i);
	}
	return -1;
}
dllx double native_cursor_preinit_raw_cb1(void* _fptr_1, void* _fptr_2, void* _mptr_1, void* _mptr_2) {
	CScriptRefOffset = findCScriptRefOffset(_fptr_1, _fptr_2, _mptr_1, _mptr_2);
	return CScriptRefOffset >= 0;
}

static YYFunc script_execute = nullptr;
static int native_cursor_callback_script = -1;
CInstance* native_cursor_callback_self = nullptr;
bool native_cursor_callback_enable = false;
bool native_cursor_callback_highp = false;
dllx void native_cursor_preinit_raw_cb2(void* _method) {
	if (CScriptRefOffset < 0) {
		script_execute = nullptr;
	} else {
		auto _func_at = (uint8_t*)_method + CScriptRefOffset;
		script_execute = *(YYFunc*)_func_at;
	}
}

dllm void native_cursor_preinit_raw_cb3(YYFuncArgs) {
	result.kind = VALUE_REAL;
	if (arg[0].kind != VALUE_REAL) {
		result.val = 0.0;
		return;
	}
	result.val = 1.0;
	//
	native_cursor_callback_script = (int)arg[0].val;
	native_cursor_callback_self = self;
}

dllx void native_cursor_set_callback_raw(double _enable) {
	native_cursor_callback_enable = script_execute != nullptr && _enable > 0.5;
}

///
enum class native_cursor_set_callback_mode {
	lowp = 0,
	highp = 1,
};
///
dllx void native_cursor_set_callback_mode(double mode) {
	native_cursor_callback_highp = mode > 0.5;
}
///
dllx double native_cursor_get_callback_mode() {
	auto mode = (native_cursor_callback_highp
		? native_cursor_set_callback_mode::highp
		: native_cursor_set_callback_mode::lowp
	);
	return (int)mode;
}

bool native_cursor_callback(int x, int y) {
	if (script_execute == nullptr) return false;
	if (native_cursor_callback_script < 0) return false;

	RValue args[3]{};
	args[0].val = native_cursor_callback_script;
	args[1].val = x;
	args[2].val = y;
	RValue result{};
	auto self = native_cursor_callback_self;
	script_execute(result, self, self, (int)std::size(args), args);
	return true;
}

void native_cursor_preinit_statics_cb() {
	script_execute = nullptr;
	native_cursor_callback_script = -1;
	CScriptRefOffset = -1;
	native_cursor_callback_enable = false;
	native_cursor_callback_highp = true;
}