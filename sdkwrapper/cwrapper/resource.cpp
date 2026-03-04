#include "resource.h"

#include <framework/resource.h>

using namespace tram;

int tramsdk_framework_resource_get_status(void* resource) {
	return ((Resource*)resource)->GetStatus();
}

const char* tramsdk_framework_resource_get_name(void* resource) {
	return ((Resource*)resource)->GetName();
}

int tramsdk_framework_resource_get_references(void* resource) {
	return ((Resource*)resource)->GetReferences();
}

void tramsdk_framework_resource_add_reference(void* resource) {
	((Resource*)resource)->AddReference();
}

void tramsdk_framework_resource_remove_reference(void* resource) {
	((Resource*)resource)->RemoveReference();
}

void tramsdk_framework_resource_load(void* resource) {
	((Resource*)resource)->Load();
}

void tramsdk_framework_resource_unload(void* resource) {
	((Resource*)resource)->Unload();
}