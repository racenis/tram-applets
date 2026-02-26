#include "uiwrapper.h"

#include <framework/logging.h>
#include <platform/api.h>

#include <chrono>

#ifndef _WIN32
    #include <GL/gl.h>
#else
    #include <glad.c>
#endif

#undef ERROR

static tram::Platform::Window::callbacks_t callbacks;

/// Specifies new or initial dimensions of screen frame.
void tramsdk_platform_window_screen_resize(int width, int height) {
    callbacks.screen_resize(width, height);
}

/// Called when shutting down the program.
void tramsdk_platform_window_screen_close() {
    callbacks.screen_close();
}

/// Passes keyboard input to library
/// @param keycode Value from tram::UI::KeyboardKey
void tramsdk_platform_window_key_press(int keycode) {
    callbacks.key_press((tram::UI::KeyboardKey)keycode);
}

/// Passes keyboard input to library
/// @param keycode Value from tram::UI::KeyboardKey
void tramsdk_platform_window_key_release(int keycode) {
    callbacks.key_release((tram::UI::KeyboardKey)keycode);
}

/// Passes keyboard input to library
/// @param keycode UTF-16 characted code
void tramsdk_platform_window_key_character(int keycode) {
    callbacks.key_code(keycode);
}

/// Passes mouse input to library
/// @param x,y Cursor position in screen frame
void tramsdk_platform_window_cursor_pos(int x, int y) {
    callbacks.key_mouse(x, y);
}

/// Passes mouse input to library
/// @param offset Vertical scroll amount
void tramsdk_platform_window_key_scroll(int offset) {
    callbacks.key_scroll(offset);
}



namespace tram::Platform {

using namespace tram::UI;

void Window::Init() {

    // actually by this time the opengl context should have been opened already.
    // we just load additional functions for windoze
#ifdef _WIN32
    if (!gladLoadGL()) {
    //if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        Log(Severity::ERROR, System::UI, "OpenGL context didn't open");
        abort();
    }
#endif

}

void Window::Update() {
    
}

void Window::Uninit() {
    
}

void Window::SetTitle(const char* title) {
    
}

void Window::SetSize(int w, int h) {
    
}

void Window::SetCursor(CursorType cursor) {
    
}

void Window::SetCursorPosition(float x, float y) {
    
}

void Window::EnableCursor() {

}

void Window::DisableCursor() {

}

bool Window::IsRawInput() {
    return false;
}

void Window::SetRawInput(bool input) {

}

static std::chrono::time_point<std::chrono::steady_clock> init_time;

double Window::GetTime() {
    auto current_time = std::chrono::steady_clock::now();
    auto duration = std::chrono::duration<double>(current_time - init_time);
    return duration.count();
}

int Window::GetCurrentMonitor() {
    return 0;
}

int Window::GetMonitorCount() {
    return 1;
}

void Window::SetMonitor(int monitor) {

}

bool Window::IsFullscreen() {
    return false;
}

void Window::SetFullscreen(bool fullscreen) {

}

bool Window::IsVsync() {
    return false;
}

void Window::SetVsync(bool value) {

}

bool Window::IsRenderContextThread() {
    return true;
}

void Window::SetCallbacks(callbacks_t window_callbacks) {
    callbacks = window_callbacks;
}

void Input::Init() {
    
}

void Input::Update() {

}

void Input::Uninit() {

}

}
