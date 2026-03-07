#pragma once

#ifdef __cplusplus
extern "C" {
#endif

__declspec(dllexport) void tramsdk_render_project(float x, float y, float z, float* p_x, float* p_y, float* p_z, int layer);
__declspec(dllexport) void tramsdk_render_project_inverse(float p_x, float p_y, float p_z, float* x, float* y, float* z, int layer);

__declspec(dllexport) void tramsdk_render_set_sun_direction(float x, float y, float z, int layer);
__declspec(dllexport) void tramsdk_render_set_sun_color(float r, float g, float b, int layer);
__declspec(dllexport) void tramsdk_render_set_sun_ambient_color(float r, float g, float b, int layer);

__declspec(dllexport) void tramsdk_render_set_background_color(float r, float g, float b);

__declspec(dllexport) void tramsdk_render_set_fog_distance(float near, float far, int layer);
__declspec(dllexport) void tramsdk_render_set_fog_color(float r, float g, float b, int layer);

__declspec(dllexport) void tramsdk_render_set_ortho_ratio(float ratio, int layer);

__declspec(dllexport) void tramsdk_render_set_view_fov(float fov, int layer);
__declspec(dllexport) float tramsdk_render_get_view_fov(int layer);

__declspec(dllexport) void tramsdk_render_set_view_distance(float dist, int layer);
__declspec(dllexport) float tramsdk_render_get_view_distance(int layer);

__declspec(dllexport) void tramsdk_render_set_view_position(float x, float y, float z, int layer);
__declspec(dllexport) void tramsdk_render_set_view_rotation(float x, float y, float z, int layer);

__declspec(dllexport) void tramsdk_render_get_view_position(float* x, float* y, float* z, int layer);
__declspec(dllexport) void tramsdk_render_get_view_rotation(float* x, float* y, float* z, int layer);

__declspec(dllexport) void tramsdk_render_add_line(float f_x, float f_y, float f_z, float t_x, float t_y, float t_z, float r, float g, float b);
__declspec(dllexport) void tramsdk_render_add_line_marker(float x, float y, float z, float r, float g, float b);
__declspec(dllexport) void tramsdk_render_add_aabb(float min_x, float min_y, float min_z, float max_x, float max_y, float max_z, float c_x, float c_y, float c_z, float r_x, float r_y, float r_z, float r, float g, float b);
__declspec(dllexport) void tramsdk_render_add_sphere(float x, float y, float z, float radius, float r, float g, float b);
__declspec(dllexport) void tramsdk_render_add_cylinder(float x, float y, float z, float height, float radius, float r, float g, float b);
__declspec(dllexport) void tramsdk_render_add_cube(float x, float y, float z, float extent, float r, float g, float b);
__declspec(dllexport) void tramsdk_render_add_text(float x, float y, float z, const char* text, float r, float g, float b);
__declspec(dllexport) void tramsdk_render_add_text_2d(float x, float y, const char* text, float r, float g, float b);

#ifdef __cplusplus
}
#endif