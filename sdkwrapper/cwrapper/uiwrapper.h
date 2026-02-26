#pragma once

#ifdef __cplusplus
extern "C" {
#endif

__declspec(dllexport) void tramsdk_platform_window_screen_resize(int width, int height);
__declspec(dllexport) void tramsdk_platform_window_screen_close();

__declspec(dllexport) void tramsdk_platform_window_key_press(int keycode);
__declspec(dllexport) void tramsdk_platform_window_key_release(int keycode);
__declspec(dllexport) void tramsdk_platform_window_key_character(int keycode);

__declspec(dllexport) void tramsdk_platform_window_cursor_pos(int x, int y);

__declspec(dllexport) void tramsdk_platform_window_key_scroll(int offset);

#ifdef __cplusplus
}
#endif