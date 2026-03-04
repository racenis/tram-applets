#include "animation.h"

#include <render/animation.h>

using namespace tram;

void* tramsdk_render_animation_find(const char* name) {
	return Render::Animation::Find(name);
}

void tramsdk_render_animation_load_all() {
	/*Render::Animation::LoadAll();*/
}
