#pragma once

#ifdef __cplusplus
extern "C" {
#endif

__declspec(dllexport) void tramsdk_framework_component_init(void* component);
__declspec(dllexport) int tramsdk_framework_component_is_ready(void* component);
__declspec(dllexport) int tramsdk_framework_component_is_init(void* component);
__declspec(dllexport) void* tramsdk_framework_component_get_parent(void* component);
__declspec(dllexport) void* tramsdk_framework_component_set_parent(void* component, void* entity);

#ifdef __cplusplus
}
#endif