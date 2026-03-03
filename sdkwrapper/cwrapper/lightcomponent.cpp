#include "lightcomponent.h"

#include <components/light.h>

using namespace tram;

void* sdk_component_light_make() {
	return new LightComponent();
}

void sdk_component_light_yeet(void* component) {
	delete ((LightComponent*)component);
}

void sdk_component_light_set_location(void* component, float x, float y, float z) {
	((LightComponent*)component)->SetLocation({x, y, z});
}

void sdk_component_light_set_color(void* component, float r, float g, float b) {
	((LightComponent*)component)->SetColor({r, g, b});
}

void sdk_component_light_set_distance(void* component, float dist) {
	((LightComponent*)component)->SetDistance(dist);
}

void sdk_component_light_set_direction(void* component, float x, float y, float z) {
	((LightComponent*)component)->SetDirection({x, y, z});
}

void sdk_component_light_set_exponent(void* component, float exponent) {
	((LightComponent*)component)->SetExponent(exponent);
}

void sdk_component_light_get_color(void* component, float* r, float* g, float* b) {
	vec3 c = ((LightComponent*)component)->GetColor(); *r = c.x; *g = c.y; *b = c.z;
}

float sdk_component_light_get_distance(void* component) {
	return ((LightComponent*)component)->GetDistance();
}

int sdk_component_light_is_light_draw() {
	return LightComponent::IsLightDraw();
}

void sdk_component_light_set_light_draw(int value) {
	LightComponent::SetLightDraw(value);
}
