#include "meshcomponent.h"

#include <components/mesh.h>

using namespace tram;
using namespace tram::Render;

void* tramsdk_components_mesh_vertex_make(int vertex_type) {
	return new MeshVertex(vertex_type);
}

void tramsdk_components_mesh_vertex_yeet(void* vertex) {
	delete ((MeshVertex*)vertex);
}

void tramsdk_components_mesh_vertex_set_position(void* vertex, float x, float y, float z) {
	((MeshVertex*)vertex)->SetPosition({x, y, z});
}

void tramsdk_components_mesh_vertex_set_normal(void* vertex, float x, float y, float z) {
	((MeshVertex*)vertex)->SetNormal({x, y, z});
}

void tramsdk_components_mesh_vertex_set_color(void* vertex, float r, float g, float b) {
	((MeshVertex*)vertex)->SetColor({r, g, b});
}

void tramsdk_components_mesh_vertex_set_texture_uv(void* vertex, float u, float v) {
	((MeshVertex*)vertex)->SetTextureUV({u, v});
}

void tramsdk_components_mesh_vertex_set_lightmap_uv(void* vertex, float u, float v) {
	((MeshVertex*)vertex)->SetLightmapUV({u, v});
}


void tramsdk_components_mesh_vertex_set_attribute_name(void* vertex, int index, const char* value) {
	((MeshVertex*)vertex)->SetAttribute(index, value_t(value));
}

void tramsdk_components_mesh_vertex_set_attribute_bool(void* vertex, int index, bool value) {
	((MeshVertex*)vertex)->SetAttribute(index, value_t(value));
}

void tramsdk_components_mesh_vertex_set_attribute_int(void* vertex, int index, int value) {
	((MeshVertex*)vertex)->SetAttribute(index, value_t(value));
}

void tramsdk_components_mesh_vertex_set_attribute_float(void* vertex, int index, float value) {
	((MeshVertex*)vertex)->SetAttribute(index, value_t(value));
}

void tramsdk_components_mesh_vertex_set_attribute_vec2(void* vertex, int index, float x, float y) {
	((MeshVertex*)vertex)->SetAttribute(index, value_t(vec2{x, y}));
}

void tramsdk_components_mesh_vertex_set_attribute_vec3(void* vertex, int index, float x, float y, float z) {
	((MeshVertex*)vertex)->SetAttribute(index, value_t(vec3{x, y, z}));
}

void tramsdk_components_mesh_vertex_set_attribute_vec4(void* vertex, int index, float x, float y, float z, float w) {
	((MeshVertex*)vertex)->SetAttribute(index, value_t(vec4{x, y, z, w}));
}

void tramsdk_components_mesh_vertex_set_attribute_quat(void* vertex, int index, float x, float y, float z, float w) {
	((MeshVertex*)vertex)->SetAttribute(index, value_t(quat{x, y, z, w}));
}

void tramsdk_components_mesh_vertex_set_attribute_ivec2(void* vertex, int index, int x, int y) {
	/*((MeshVertex*)vertex)->SetAttribute(index, value_t(ivec2{x, y}));*/
}

void tramsdk_components_mesh_vertex_set_attribute_ivec3(void* vertex, int index, int x, int y, int z) {
	/*((MeshVertex*)vertex)->SetAttribute(index, value_t(ivec3{x, y, z}));*/
}

void tramsdk_components_mesh_vertex_set_attribute_ivec4(void* vertex, int index, int x, int y, int z, int w) {
	/*((MeshVertex*)vertex)->SetAttribute(index, value_t(ivec4{x, y, z, w}));*/
}

void tramsdk_components_mesh_vertex_set_attribute_uvec2(void* vertex, int index, int x, int y) {
	/*((MeshVertex*)vertex)->SetAttribute(index, value_t(uvec2{x, y}));*/
}

void tramsdk_components_mesh_vertex_set_attribute_uvec3(void* vertex, int index, int x, int y, int z) {
	/*((MeshVertex*)vertex)->SetAttribute(index, value_t(uvec3{x, y, z}));*/
}

void tramsdk_components_mesh_vertex_set_attribute_uvec4(void* vertex, int index, int x, int y, int z, int w) {
	/*((MeshVertex*)vertex)->SetAttribute(index, value_t(uvec4{x, y, z, w}));*/
}





void* tramsdk_components_mesh_make() {
	return new MeshComponent();
}

void tramsdk_components_mesh_yeet(void* component) {
	delete (MeshComponent*)component;
}

void tramsdk_components_mesh_add2(void* component, void* vertex1, void* vertex2) {
	((MeshComponent*)component)->Add(*((MeshVertex*)vertex1), *((MeshVertex*)vertex2));
}

void tramsdk_components_mesh_add3(void* component, void* vertex1, void* vertex2, void* vertex3) {
	((MeshComponent*)component)->Add(*((MeshVertex*)vertex1), *((MeshVertex*)vertex2), *((MeshVertex*)vertex3));
}

void tramsdk_components_mesh_clear(void* component) {
	((MeshComponent*)component)->Clear();
}

void tramsdk_components_mesh_reserve(void* component, int format, int vertex_count) {
	((MeshComponent*)component)->Reserve((Render::vertexformat_t)format, vertex_count);
}

void tramsdk_components_mesh_commit(void* component) {
	((MeshComponent*)component)->Commit();
}

void tramsdk_components_mesh_set_material(void* component, void* material, int index) {
	((MeshComponent*)component)->SetMaterial((Render::Material*)material, index);
}

void tramsdk_components_mesh_get_location(void* component, float* x, float* y, float* z) {
	vec3 v = ((MeshComponent*)component)->GetLocation(); *x = v.x; *y = v.y; *z = v.z;
}

void tramsdk_components_mesh_get_rotation(void* component, float* x, float* y, float* z) {
	vec3 euler = glm::eulerAngles(((MeshComponent*)component)->GetRotation());
	*x = euler.x; *y = euler.y; *z = euler.z;
}

void tramsdk_components_mesh_get_scale(void* component, float* x, float* y, float* z) {
	vec3 v = ((MeshComponent*)component)->GetScale(); *x = v.x; *y = v.y; *z = v.z;
}

void tramsdk_components_mesh_set_location(void* component, float x, float y, float z) {
	((MeshComponent*)component)->SetLocation({x, y, z});
}

void tramsdk_components_mesh_set_rotation(void* component, float x, float y, float z) {
	((MeshComponent*)component)->SetRotation(vec3(x, y, z));
}

void tramsdk_components_mesh_set_scale(void* component, float x, float y, float z) {
	((MeshComponent*)component)->SetScale({x, y, z});
}

void tramsdk_components_mesh_set_color(void* component, float r, float g, float b) {
	((MeshComponent*)component)->SetColor({r, g, b});
}

void tramsdk_components_mesh_set_layer(void* component, int layer) {
	((MeshComponent*)component)->SetLayer(layer);
}

void tramsdk_components_mesh_set_texture_offset(void* component, const char* material,
											float x, float y, float z, float w) {
	((MeshComponent*)component)->SetTextureOffset(material, {x, y, z, w});
}

void tramsdk_components_mesh_set_line_drawing_mode(void* component, int enabled) {
	((MeshComponent*)component)->SetLineDrawingMode(enabled);
}

void tramsdk_components_mesh_set_directional_light(void* component, int enabled) {
	((MeshComponent*)component)->SetDirectionaLight(enabled);
}

void tramsdk_components_mesh_set_render_debug(void* component, int enabled) {
	((MeshComponent*)component)->SetRenderDebug(enabled);
}

void tramsdk_components_mesh_get_aabb_min(void* component, float* x, float* y, float* z) {
	vec3 v = ((MeshComponent*)component)->GetAABBMin(); *x = v.x; *y = v.y; *z = v.z;
}

void tramsdk_components_mesh_get_aabb_max(void* component, float* x, float* y, float* z) {
	vec3 v = ((MeshComponent*)component)->GetAABBMax(); *x = v.x; *y = v.y; *z = v.z;
}

void tramsdk_components_mesh_draw_aabb(void* component) {
	/*((MeshComponent*)component)->DrawAABB();*/
}

int tramsdk_components_mesh_find_all_from_ray(void* component,
										  float p_x, float p_y, float p_z,
										  float d_x, float d_y, float d_z,
										  TSDKAABBTriangle* tris, int tri_size)
{
    /*std::vector<Render::AABBTriangle> result;
    ((MeshComponent*)component)->FindAllFromRay({p_x, p_y, p_z}, {d_x, d_y, d_z}, result);
    int count = result.size();
	if (tri_size < count) count = tri_size;
    std::memcpy(tris, result.data(), count * sizeof(TSDKAABBTriangle));
    return count;*/
}

int tramsdk_components_mesh_find_all_from_aabb(void* component,
										   float min_x, float min_y, float min_z,
										   float max_x, float max_y, float max_z,
										   TSDKAABBTriangle* tris, int tri_size)
{
    /*std::vector<Render::AABBTriangle> result;
    ((MeshComponent*)component)->FindAllFromAABB({min_x, min_y, min_z}, {max_x, max_y, max_z}, result);
    int count = result.size();
	if (tri_size < count) count = tri_size;
    std::memcpy(tris, result.data(), count * sizeof(TSDKAABBTriangle));
    return count;*/
}

