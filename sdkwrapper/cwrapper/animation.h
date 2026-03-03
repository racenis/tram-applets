#pragma once

#ifdef __cplusplus
extern "C" {
#endif

__declspec(dllexport) void* tramsdk_render_animation_find(const char* name);
__declspec(dllexport) void tramsdk_render_animation_load_all();

#ifdef __cplusplus
}
#endif