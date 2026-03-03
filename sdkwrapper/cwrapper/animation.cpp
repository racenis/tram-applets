#include "animation.h"

#include <render/animation.h>

using namespace tram;

void* sdk_render_animation_find(const char* name) {
	return Render::Animation::Find(name);
}

void sdk_render_animation_load_all() {
	Render::Animation::LoadAll();
}
