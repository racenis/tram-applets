#include "resource.h"

#include <framework/resource.h>

using namespace tram;

int sdk_framework_resource_get_status(void* resource) {
	return ((Resource*)resource)->GetStatus();
}

const char* sdk_framework_resource_get_name(void* resource) {
	return ((Resource*)resource)->GetName();
}

int sdk_framework_resource_get_references(void* resource) {
	return ((Resource*)resource)->GetReferences();
}

void sdk_framework_resource_add_reference(void* resource) {
	((Resource*)resource)->AddReference();
}

void sdk_framework_resource_remove_reference(void* resource) {
	((Resource*)resource)->RemoveReference();
}

void sdk_framework_resource_load(void* resource) {
	((Resource*)resource)->Load();
}

void sdk_framework_resource_unload(void* resource) {
	((Resource*)resource)->Unload();
}