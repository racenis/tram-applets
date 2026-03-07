#include "render.h"

#include <render/render.h>
#include <render/api.h>

using namespace tram;

void tramsdk_render_project(float x, float y, float z, float* p_x, float* p_y, float* p_z, int layer) {
	vec3 result; Render::Project({x, y, z}, result, layer); *p_x = result.x; *p_y = result.y; *p_z = result.z;
}

void tramsdk_render_project_inverse(float p_x, float p_y, float p_z, float* x, float* y, float* z, int layer) {
	vec3 r = Render::ProjectInverse({p_x, p_y, p_z}, layer); *x = r.x; *y = r.y; *z = r.z;
}

void tramsdk_render_set_sun_direction(float x, float y, float z, int layer) {
	Render::SetSunDirection({x, y, z}, layer);
}

void tramsdk_render_set_sun_color(float r, float g, float b, int layer) {
	Render::SetSunColor({r, g, b}, layer);
}

void tramsdk_render_set_sun_ambient_color(float r, float g, float b, int layer) {
	Render::SetAmbientColor({r, g, b}, layer);
}

void tramsdk_render_set_background_color(float r, float g, float b) {
	Render::API::SetScreenClear({r, g, b}, true);
}

void tramsdk_render_set_fog_distance(float near, float far, int layer) {
	Render::SetFogDistance(near, far, layer);
}

void tramsdk_render_set_fog_color(float r, float g, float b, int layer) {
	Render::SetFogColor({r, g, b}, layer);
}

void tramsdk_render_set_ortho_ratio(float ratio, int layer) {
	Render::SetOrthoRatio(ratio, layer);
}

void tramsdk_render_set_view_fov(float fov, int layer) {
	Render::SetViewFov(fov, layer);
}

float tramsdk_render_get_view_fov(int layer) {
	return Render::GetViewFov(layer);
}

void tramsdk_render_set_view_distance(float dist, int layer) {
	Render::SetViewDistance(dist, layer);
}

float tramsdk_render_get_view_distance(int layer) {
	return Render::GetViewDistance(layer);
}

void tramsdk_render_set_view_position(float x, float y, float z, int layer) {
	Render::SetViewPosition({x, y, z}, layer);
}

void tramsdk_render_set_view_rotation(float x, float y, float z, int layer) {
Render::SetViewRotation(vec3(x, y, z), layer);
}

void tramsdk_render_get_view_position(float* x, float* y, float* z, int layer) {
	vec3 v = Render::GetViewPosition(layer); *x = v.x; *y = v.y; *z = v.z;
}

void tramsdk_render_get_view_rotation(float* x, float* y, float* z, int layer) {
	vec3 r = glm::eulerAngles(Render::GetViewRotation(layer)); *x = r.x; *y = r.y; *z = r.z;
}

void tramsdk_render_add_line(float f_x, float f_y, float f_z, float t_x, float t_y, float t_z, float r, float g, float b) {
	Render::AddLine({f_x, f_y, f_z}, {t_x, t_y, t_z}, {r, g, b});
}

void tramsdk_render_add_line_marker(float x, float y, float z, float r, float g, float b) {
	Render::AddLineMarker({x, y, z}, {r, g, b});
}

void tramsdk_render_add_aabb(float min_x, float min_y, float min_z, float max_x, float max_y, float max_z, float c_x, float c_y, float c_z, float r_x, float r_y, float r_z, float r, float g, float b) {
	Render::AddLineAABB({min_x, min_y, min_z}, {max_x, max_y, max_z}, {c_x, c_y, c_z}, vec3(r_x, r_y, r_z), {r, g, b});
}

void tramsdk_render_add_sphere(float x, float y, float z, float radius, float r, float g, float b) {
	Render::AddSphere({x, y, z}, radius, {r, g, b});
}

void tramsdk_render_add_cylinder(float x, float y, float z, float height, float radius, float r, float g, float b) {
	Render::AddCylinder({x, y, z}, height, radius, {r, g, b});
}

void tramsdk_render_add_cube(float x, float y, float z, float extent, float r, float g, float b) {
	// TODO: fix signature first
	//Render::AddCube({x, y, z}, extent, {r, g, b});
}

void tramsdk_render_add_text(float x, float y, float z, const char* text, float r, float g, float b) {
	Render::AddText({x, y, z}, text, {r, g, b});
}

void tramsdk_render_add_text_2d(float x, float y, const char* text, float r, float g, float b) {
	Render::AddText(x, y, text, {r, g, b});
}