#pragma once

#ifdef __cplusplus
extern "C" {
#endif

// DataType
enum {
	DATA_SCALAR,
	DATA_VECTOR
};

// OperationType
enum {
	OPERATION_COPY,
	OPERATION_OSCILLATOR,
	OPERATION_NOISE,
	OPERATION_CLAMP,
	OPERATION_NORMALIZE
};

// MergeType
enum {
	MERGE_SET,
	MERGE_ADD,
	MERGE_SUBTRACT,
	MERGE_MULTIPLY,
	MERGE_DIVIDE
};

// MergeDest
enum {
	MERGE_ANY,
	MERGE_X,
	MERGE_Y,
	MERGE_Z
};

// ConstraintType
enum {
	CONSTRAINT_GREATER_THAN,
	CONSTRAINT_LESSER_THAN,
};

__declspec(dllexport) void* tramsdk_render_particle_parameter_make();
__declspec(dllexport) void tramsdk_render_particle_parameter_yeet(void* param);
__declspec(dllexport) void tramsdk_render_particle_parameter_set_none(void* param);
__declspec(dllexport) void tramsdk_render_particle_parameter_set_data(void* param, const char* data);
__declspec(dllexport) void tramsdk_render_particle_parameter_set_scalar(void* param, float value);
__declspec(dllexport) void tramsdk_render_particle_parameter_set_vector(void* param, float x, float y, float z);

__declspec(dllexport) void* tramsdk_render_particle_operation_make();
__declspec(dllexport) void tramsdk_render_particle_operation_yeet(void* op);
__declspec(dllexport) void tramsdk_render_particle_operation_set_type(void* op, int type);
__declspec(dllexport) void tramsdk_render_particle_operation_set_merge(void* op, int merge);
__declspec(dllexport) void tramsdk_render_particle_operation_set_dest(void* op, int dest);
__declspec(dllexport) void tramsdk_render_particle_operation_set_target(void* op, const char* target);
__declspec(dllexport) void tramsdk_render_particle_operation_set_param(void* op, int index, void* param);

__declspec(dllexport) void* tramsdk_render_particle_constraint_make();
__declspec(dllexport) void tramsdk_render_particle_constraint_yeet(void* data);
__declspec(dllexport) void tramsdk_render_particle_constraint_set_type(void* op, int type);
__declspec(dllexport) void tramsdk_render_particle_constraint_set_dest(void* op, int dest);
__declspec(dllexport) void tramsdk_render_particle_constraint_set_property(void* op, const char* property);
__declspec(dllexport) void tramsdk_render_particle_constraint_set_param(void* op, int index, void* param);

__declspec(dllexport) void tramsdk_render_particle_system_set_sprite(void* sys, void* sprite);
__declspec(dllexport) void tramsdk_render_particle_system_set_wire(void* sys, void* material);
__declspec(dllexport) void tramsdk_render_particle_system_set_model(void* sys, void* model);

__declspec(dllexport) void tramsdk_render_particle_system_add_value(void* sys, const char* name, int type);
__declspec(dllexport) void tramsdk_render_particle_system_add_operation(void* sys, void* operation);
__declspec(dllexport) void tramsdk_render_particle_system_add_initializer(void* sys, void* initializer);
__declspec(dllexport) void tramsdk_render_particle_system_add_constraint(void* sys, void* constraint);
__declspec(dllexport) void tramsdk_render_particle_system_add_emitter(void* sys, void* rate, void* delay);
__declspec(dllexport) void tramsdk_render_particle_system_set_particle_limit(void* sys, int limit);

__declspec(dllexport) void* tramsdk_render_particle_create_system(void* particle);
__declspec(dllexport) void* tramsdk_render_particle_get_base_system(void* particle);

__declspec(dllexport) void tramsdk_render_particle_add_control(void* particle, const char* name, int type);

__declspec(dllexport) void* tramsdk_render_particle_find(const char* name);

#ifdef __cplusplus
}
#endif