#pragma once

#include "model.h"

#ifdef __cplusplus
extern "C" {
#endif

// just new and delete
__declspec(dllexport) void* tramsdk_components_mesh_vertex_make(int vertex_type);
__declspec(dllexport) void tramsdk_components_mesh_vertex_yeet(void* vertex);

__declspec(dllexport) void tramsdk_components_mesh_vertex_set_position(void* vertex, float x, float y, float z);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_normal(void* vertex, float x, float y, float z);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_color(void* vertex, float r, float g, float b);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_texture_uv(void* vertex, float u, float v);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_lightmap_uv(void* vertex, float u, float v);

__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_name(void* vertex, int index, const char* value);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_bool(void* vertex, int index, bool value);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_int(void* vertex, int index, int value);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_float(void* vertex, int index, float value);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_vec2(void* vertex, int index, float x, float y);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_vec3(void* vertex, int index, float x, float y, float z);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_vec4(void* vertex, int index, float x, float y, float z, float w);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_quat(void* vertex, int index, float x, float y, float z, float w);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_ivec2(void* vertex, int index, int x, int y);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_ivec3(void* vertex, int index, int x, int y, int z);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_ivec4(void* vertex, int index, int x, int y, int z, int w);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_uvec2(void* vertex, int index, int x, int y);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_uvec3(void* vertex, int index, int x, int y, int z);
__declspec(dllexport) void tramsdk_components_mesh_vertex_set_attribute_uvec4(void* vertex, int index, int x, int y, int z, int w);

__declspec(dllexport) void* tramsdk_components_mesh_make();
__declspec(dllexport) void tramsdk_components_mesh_yeet(void* component);

__declspec(dllexport) void tramsdk_components_mesh_add2(void* component, void* vertex1, void* vertex2);
__declspec(dllexport) void tramsdk_components_mesh_add3(void* component, void* vertex1, void* vertex2, void* vertex3);
__declspec(dllexport) void tramsdk_components_mesh_clear(void* component);
__declspec(dllexport) void tramsdk_components_mesh_reserve(void* component, int format, int vertex_count);
__declspec(dllexport) void tramsdk_components_mesh_commit(void* component);

__declspec(dllexport) void tramsdk_components_mesh_set_material(void* component, void* material, int index);

__declspec(dllexport) void tramsdk_components_mesh_get_location(void* component, float* x, float* y, float* z);
__declspec(dllexport) void tramsdk_components_mesh_get_rotation(void* component, float* x, float* y, float* z);
__declspec(dllexport) void tramsdk_components_mesh_get_scale(void* component, float* x, float* y, float* z);

__declspec(dllexport) void tramsdk_components_mesh_set_location(void* component, float x, float y, float z);
__declspec(dllexport) void tramsdk_components_mesh_set_rotation(void* component, float x, float y, float z);
__declspec(dllexport) void tramsdk_components_mesh_set_scale(void* component, float x, float y, float z);
__declspec(dllexport) void tramsdk_components_mesh_set_color(void* component, float r, float g, float b);
__declspec(dllexport) void tramsdk_components_mesh_set_layer(void* component, int layer);

__declspec(dllexport) void tramsdk_components_mesh_set_texture_offset(void* component, const char* material,
                                                                        float x, float y, float z, float w);
																		
__declspec(dllexport) void tramsdk_components_mesh_set_line_drawing_mode(void* component, int enabled);
__declspec(dllexport) void tramsdk_components_mesh_set_directional_light(void* component, int enabled);
__declspec(dllexport) void tramsdk_components_mesh_set_render_debug(void* component, int enabled);

__declspec(dllexport) void tramsdk_components_mesh_get_aabb_min(void* component, float* x, float* y, float* z);
__declspec(dllexport) void tramsdk_components_mesh_get_aabb_max(void* component, float* x, float* y, float* z);

__declspec(dllexport) void tramsdk_components_mesh_draw_aabb(void* component);

__declspec(dllexport) int tramsdk_components_mesh_find_all_from_ray(void* component,
                                                                    float p_x, float p_y, float p_z,
																	float d_x, float d_y, float d_z,
																	TSDKAABBTriangle* tris, int tri_size);
__declspec(dllexport) int tramsdk_components_mesh_find_all_from_aabb(void* component,
                                                                    float min_x, float min_y, float min_z,
																	float max_x, float max_y, float max_z,
																	TSDKAABBTriangle* tris, int tri_size);

#ifdef __cplusplus
}
#endif