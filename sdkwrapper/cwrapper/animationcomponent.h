#pragma once

#ifdef __cplusplus
extern "C" {
#endif

__declspec(dllexport) void tramsdk_component_animation_set_model(void* component, void* model);
__declspec(dllexport) void* tramsdk_component_animation_get_model(void* component);
__declspec(dllexport) void* tramsdk_component_animation_get_pose(void* component);

__declspec(dllexport) void tramsdk_component_animation_set_keyframe(void* component,
                                                                     float frame,
																	 float l_x, float l_y, float l_z,
																	 float r_x, float r_y, float r_z,
																	 float s_x, float s_y, float s_z);

__declspec(dllexport) void tramsdk_component_animation_set_on_animation_finish_callback(void* component,
                                                                                         void (*callback)(void*, const char*));
__declspec(dllexport) void tramsdk_component_animation_play(void* component, const char* name,
                                                             int repeats, float weight, float speed,
															 int interpolate, int pause_on_last_frame);
__declspec(dllexport) int tramsdk_component_animation_is_playing(void* component, const char* name);
__declspec(dllexport) void tramsdk_component_animation_stop(void* component, const char* name);
__declspec(dllexport) void tramsdk_component_animation_pause(void* component, const char* name);
__declspec(dllexport) void tramsdk_component_animation_continue(void* component, const char* name);

__declspec(dllexport) void tramsdk_component_animation_set_weight(void* component, const char* name, float weight);
__declspec(dllexport) void tramsdk_component_animation_set_speed(void* component, const char* name, float weight);
__declspec(dllexport) void tramsdk_component_animation_set_repeats(void* component, const char* name, int repeats);

__declspec(dllexport) void tramsdk_component_animation_fade_in(void* component, const char* name, float length);
__declspec(dllexport) void tramsdk_component_animation_fade_out(void* component, const char* name, float length);

__declspec(dllexport) void tramsdk_component_animation_set_pause(void* component, const char* name, int pause);
__declspec(dllexport) void tramsdk_component_animation_set_fade(void* component, const char* name,
                                                                int fade_in, float fade_length);
__declspec(dllexport) void tramsdk_component_animation_reparent(void* component, const char* name, const char* new_parent);

__declspec(dllexport) void* tramsdk_component_animation_make();
__declspec(dllexport) void tramsdk_component_animation_yeet(void* component);

__declspec(dllexport) int tramsdk_component_animation_is_debug_info_draw(void* component);
__declspec(dllexport) void tramsdk_component_animation_set_debug_info_draw(void* component, int draw);

#ifdef __cplusplus
}
#endif