#pragma once

#ifdef __cplusplus
extern "C" {
#endif

__declspec(dllexport) void* tramsdk_components_render_make();
__declspec(dllexport) void tramsdk_components_render_yeet(void* component);

__declspec(dllexport) void* tramsdk_components_render_get_model(void* component);
__declspec(dllexport) void* tramsdk_components_render_get_light_map(void* component);

__declspec(dllexport) void tramsdk_components_render_set_model(void* component, void* model);
__declspec(dllexport) void tramsdk_components_render_set_light_map(void* component, void* light_map);
__declspec(dllexport) void tramsdk_components_render_set_environment_map(void* component, void* material);
__declspec(dllexport) void tramsdk_components_render_set_armature(void* component, void* armature);

__declspec(dllexport) void tramsdk_components_render_get_location(void* component, float* x, float* y, float* z);
__declspec(dllexport) void tramsdk_components_render_get_rotation(void* component, float* x, float* y, float* z);
__declspec(dllexport) void tramsdk_components_render_get_scale(void* component, float* x, float* y, float* z);

__declspec(dllexport) void tramsdk_components_render_set_location(void* component, float x, float y, float z);
__declspec(dllexport) void tramsdk_components_render_set_rotation(void* component, float x, float y, float z);
__declspec(dllexport) void tramsdk_components_render_set_scale(void* component, float x, float y, float z);
__declspec(dllexport) void tramsdk_components_render_set_color(void* component, float r, float g, float b);
__declspec(dllexport) void tramsdk_components_render_set_layer(void* component, int layer);

__declspec(dllexport) void tramsdk_components_render_set_texture_offset(void* component, const char* material,
                                                                        float x, float y, float z, float w);
																		
__declspec(dllexport) void tramsdk_components_render_set_line_drawing_mode(void* component, int enabled);
__declspec(dllexport) void tramsdk_components_render_set_directional_light(void* component, int enabled);
__declspec(dllexport) void tramsdk_components_render_set_render_debug(void* component, int enabled);

#ifdef __cplusplus
}
#endif