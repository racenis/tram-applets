#pragma once

#ifdef __cplusplus
extern "C" {
#endif

__declspec(dllexport) void* tramsdk_component_light_make();
__declspec(dllexport) void tramsdk_component_light_yeet(void* component);

__declspec(dllexport) void tramsdk_component_light_set_location(void* component, float x, float y, float z);
__declspec(dllexport) void tramsdk_component_light_set_color(void* component, float r, float g, float b);
__declspec(dllexport) void tramsdk_component_light_set_distance(void* component, float dist);
__declspec(dllexport) void tramsdk_component_light_set_direction(void* component, float x, float y, float z);
__declspec(dllexport) void tramsdk_component_light_set_exponent(void* component, float exponent);

__declspec(dllexport) void tramsdk_component_light_get_color(void* component, float* r, float* g, float* b);
__declspec(dllexport) float tramsdk_component_light_get_distance(void* component);

__declspec(dllexport) int tramsdk_component_light_is_light_draw();
__declspec(dllexport) void tramsdk_component_light_set_light_draw(int value);

#ifdef __cplusplus
}
#endif