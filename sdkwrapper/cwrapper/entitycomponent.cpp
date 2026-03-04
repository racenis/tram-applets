#include "entitycomponent.h"

#include <framework/entitycomponent.h>

using namespace tram;

void tramsdk_framework_component_init(void* component) {
	((EntityComponent*)component)->Init();
}

int tramsdk_framework_component_is_ready(void* component) {
	return ((EntityComponent*)component)->IsReady();
}

int tramsdk_framework_component_is_init(void* component) {
	return ((EntityComponent*)component)->IsInit();
}

void* tramsdk_framework_component_get_parent(void* component) {
	return ((EntityComponent*)component)->GetParent();
}

void tramsdk_framework_component_set_parent(void* component, void* entity) {
	((EntityComponent*)component)->SetParent((Entity*)(entity));
}