#include "rendercomponent.h"

#include <components/render.h>

using namespace tram;

void* sdk_components_render_make() {
	return new RenderComponent();
}

void sdk_components_render_yeet(void* component) {
	delete ((RenderComponent*)component);
}

void* sdk_components_render_get_model(void* component) {
	return ((RenderComponent*)component)->GetModel();
}

void* sdk_components_render_get_light_map(void* component) {
	return Render::Material::Find(((RenderComponent*)component)->GetLightmap());
}

void sdk_components_render_set_model(void* component, void* model) {
	((RenderComponent*)component)->SetModel((Render::Model*)model);
}

void sdk_components_render_set_light_map(void* component, void* light_map) {
	((RenderComponent*)component)->SetLightmap(((Render::Material*)light_map)->GetName());
}

void sdk_components_render_set_environment_map(void* component, void* material) {
	((RenderComponent*)component)->SetEnvironmentMap((Render::Material*)material);
}

void sdk_components_render_set_armature(void* component, void* armature) {
	((RenderComponent*)component)->SetArmature((AnimationComponent*)armature);
}

void sdk_components_render_get_location(void* component, float* x, float* y, float* z) {
	vec3 v = ((RenderComponent*)component)->GetLocation(); *x = v.x; *y = v.y; *z = v.z;
}

void sdk_components_render_get_rotation(void* component, float* x, float* y, float* z) {
	vec3 euler = glm::eulerAngles(((RenderComponent*)component)->GetRotation());
	*x = euler.x; *y = euler.y; *z = euler.z;
}

void sdk_components_render_get_scale(void* component, float* x, float* y, float* z) {
	vec3 v = ((RenderComponent*)component)->GetScale(); *x = v.x; *y = v.y; *z = v.z;
}

void sdk_components_render_set_location(void* component, float x, float y, float z) {
	((RenderComponent*)component)->SetLocation({x, y, z});
}

void sdk_components_render_set_rotation(void* component, float x, float y, float z) {
	((RenderComponent*)component)->SetRotation(vec3(x, y, z));
}

void sdk_components_render_set_scale(void* component, float x, float y, float z) {
	((RenderComponent*)component)->SetScale({x, y, z});
}

void sdk_components_render_set_color(void* component, float r, float g, float b) {
	((RenderComponent*)component)->SetColor({r, g, b});
}

void sdk_components_render_set_layer(void* component, int layer) {
	((RenderComponent*)component)->SetLayer(layer);
}

void sdk_components_render_set_texture_offset(void* component, const char* material,
											  float x, float y, float z, float w) {
((RenderComponent*)component)->SetTextureOffset(material, {x, y, z, w});
}

void sdk_components_render_set_line_drawing_mode(void* component, int enabled) {
	((RenderComponent*)component)->SetLineDrawingMode(enabled);
}

void sdk_components_render_set_directional_light(void* component, int enabled) {
	((RenderComponent*)component)->SetDirectionaLight(enabled);
}

void sdk_components_render_set_render_debug(void* component, int enabled) {
	((RenderComponent*)component)->SetRenderDebug(enabled);
}