#include "model.h"

#include <render/model.h>

#include <cstring>

using namespace tram;
using namespace tram::Render;

int sdk_render_model_get_vertex_format(void* component) {
	return ((Model*)component)->GetVertexFormat();
}

void sdk_render_model_get_aabb_min(void* component, float* x, float* y, float* z) {
	vec3 v = ((Model*)component)->GetAABBMin(); *x = v.x; *y = v.y; *z = v.z;
}

void sdk_render_model_get_aabb_max(void* component, float* x, float* y, float* z) {
	vec3 v = ((Model*)component)->GetAABBMax(); *x = v.x; *y = v.y; *z = v.z;
}

void sdk_render_model_get_origin(void* component, float* x, float* y, float* z) {
	vec3 v = ((Model*)component)->GetOrigin(); *x = v.x; *y = v.y; *z = v.z;
}

void sdk_render_model_draw_aabb(void* component, float p_x, float p_y, float p_z, float r_x, float r_y, float r_z) {
	((Model*)component)->DrawAABB(vec3(p_x, p_y, p_z), vec3(r_x, r_y, r_z));
}

int sdk_render_model_find_all_from_ray(void* component,
									   float p_x, float p_y, float p_z,
									   float d_x, float d_y, float d_z,
									   AABBTriangle* tris, int tri_size
) {
	std::vector<AABBTriangle> result;
	((Model*)component)->FindAllFromRay({p_x, p_y, p_z}, {d_x, d_y, d_z}, result);
	int count = result.size();
	if (count > tri_size) count = tri_size;
	memcpy(tris, result.data(), count * sizeof(AABBTriangle));
	return count;
}

int sdk_render_model_find_all_from_aabb(void* component,
									    float min_x, float min_y, float min_z,
									    float max_x, float max_y, float max_z,
									    AABBTriangle* tris, int tri_size
) {
	std::vector<AABBTriangle> result;
	((Model*)component)->FindAllFromAABB({min_x, min_y, min_z}, {max_x, max_y, max_z}, result);
	int count = result.size();
	if (count > tri_size) count = tri_size;
	memcpy(tris, result.data(), count * sizeof(AABBTriangle));
	return count;
}

int sdk_render_model_get_materials(void* component, void** materials, int material_size) {
	const auto& mats = ((Model*)component)->GetMaterials();
	int count = mats.size();
	if (material_size < count) count = material_size;
	for (int i = 0; i < count; i++) materials[i] = mats[i];
	return count;
}

float sdk_render_model_get_near_distance(void* component) {
	return ((Model*)component)->GetNearDistance();
}

float sdk_render_model_get_far_distance(void* component) {
	return ((Model*)component)->GetFarDistance();
}

void sdk_render_model_set_near_distance(void* component, float dist) {
	((Model*)component)->SetNearDistance(dist);
}

void sdk_render_model_set_far_distance(void* component, float dist) {
	((Model*)component)->SetFarDistance(dist);
}

void sdk_render_model_load_as_modification_model(void* component, void* source, void** mapping, int size) {
	std::vector<std::pair<Material*, Material*>> pairs;
	pairs.reserve(size / 2);
	for (int i = 0; i < size - 1; i += 2)
		pairs.push_back({(Material*)mapping[i], (Material*)mapping[i+1]});

	((Model*)component)->LoadAsModificationModel((Model*)source, {});
}

void* sdk_render_model_find(const char* name){
	return Model::Find(name);
}