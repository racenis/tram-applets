#pragma once

#ifdef __cplusplus
extern "C" {
#endif

// Resource::Status
enum {
	RESOURCE_UNLOADED,
	RESOURCE_LOADED,
	RESOURCE_READY
};

__declspec(dllexport) int tramsdk_framework_resource_get_status(void* resource);
__declspec(dllexport) const char* tramsdk_framework_resource_get_name(void* resource);
__declspec(dllexport) int tramsdk_framework_resource_get_references(void* resource);
__declspec(dllexport) void tramsdk_framework_resource_add_reference(void* resource);
__declspec(dllexport) void tramsdk_framework_resource_remove_reference(void* resource);
__declspec(dllexport) void tramsdk_framework_resource_load(void* resource);
__declspec(dllexport) void tramsdk_framework_resource_unload(void* resource);

#ifdef __cplusplus
}
#endif