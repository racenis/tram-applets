#include "sprite.h"

#include <render/sprite.h>

using namespace tram;

void* tramsdk_render_sprite_find(const char* name) {
	return Render::Sprite::Find(name);
}

