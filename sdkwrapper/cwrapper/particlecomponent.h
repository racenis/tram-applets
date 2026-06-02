#pragma once

#ifdef __cplusplus
extern "C" {
#endif

__declspec(dllexport) void* tramsdk_components_particle_make();
__declspec(dllexport) void tramsdk_components_particle_yeet(void* component);

__declspec(dllexport) void tramsdk_components_particle_update_location(void* component, float x, float y, float z);
__declspec(dllexport) void tramsdk_components_particle_set_particle(void* component, void* particle);

/* will add methods SetControl(vec3)/SetControl(float), leave calling code commented out for now */
__declspec(dllexport) void tramsdk_components_particle_set_control_scalar(void* component, const char* control, float value);
__declspec(dllexport) void tramsdk_components_particle_set_control_vector(void* component, const char* control, float x, float y, float z);

#ifdef __cplusplus
}
#endif