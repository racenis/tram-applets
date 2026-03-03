#pragma once

#ifdef __cplusplus
extern "C" {
#endif

struct TSDKAABBTriangle {
	float p1_x, p1_y, p1_z;
	float p2_x, p2_y, p2_z;
	float p3_x, p3_y, p3_z;
	float n_x, n_y, n_z;
	int material;
};

__declspec(dllexport) int tramsdk_render_model_get_vertex_format(void* component);

__declspec(dllexport) void tramsdk_render_model_get_aabb_min(void* component, float* x, float* y, float* z);
__declspec(dllexport) void tramsdk_render_model_get_aabb_max(void* component, float* x, float* y, float* z);

__declspec(dllexport) void tramsdk_render_model_draw_aabb(void* component, float p_x, float p_y, float p_z, float r_x, float r_y, float r_z);

__declspec(dllexport) int tramsdk_render_model_find_all_from_ray(void* component,
                                                                 float p_x, float p_y, float p_z,
															     float d_x, float d_y, float d_z,
																 TSDKAABBTriangle* tris, int tri_size);
__declspec(dllexport) int tramsdk_render_model_find_all_from_aabb(void* component,
                                                                  float min_x, float min_y, float min_z,
															  	  float max_x, float max_y, float max_z,
																  TSDKAABBTriangle* tris, int tri_size);

__declspec(dllexport) int tramsdk_render_model_get_materials(void* component, void** materials, int material_size);

__declspec(dllexport) void tramsdk_render_model_get_origin(void* component, float* x, float* y, float* z);

__declspec(dllexport) float tramsdk_render_model_get_near_distance(void* component);
__declspec(dllexport) float tramsdk_render_model_get_far_distance(void* component);
__declspec(dllexport) void tramsdk_render_model_set_near_distance(void* component, float dist);
__declspec(dllexport) void tramsdk_render_model_set_far_distance(void* component, float dist);


__declspec(dllexport) void tramsdk_render_model_load_as_modification_model(void* component, void* source,
                                                                           void** mapping, int size);

__declspec(dllexport) float tramsdk_render_model_find(const char* name);

#ifdef __cplusplus
}
#endif