#include <render/particle.h>
#include <components/particle.h>

#include "particle.h"
#include "particlecomponent.h"

using namespace tram;
using namespace tram::Render;

static Particle::DataType data_type_from_int(int type) {
	switch (type) {
		case 0:  return Particle::DataType::SCALAR;
		case 1:  return Particle::DataType::VECTOR;
		default: return Particle::DataType::SCALAR;
	}
}

static Particle::OperationType operation_type_from_int(int type) {
	switch (type) {
		case OPERATION_COPY:       return Particle::OperationType::COPY;
		case OPERATION_OSCILLATOR: return Particle::OperationType::OSCILLATOR;
		case OPERATION_NOISE:      return Particle::OperationType::NOISE;
		case OPERATION_CLAMP:      return Particle::OperationType::CLAMP;
		case OPERATION_NORMALIZE:  return Particle::OperationType::NORMALIZE;
		default:                   return Particle::OperationType::COPY;
	}
}

static Particle::MergeType merge_type_from_int(int type) {
	switch (type) {
		case MERGE_SET:      return Particle::MergeType::SET;
		case MERGE_ADD:      return Particle::MergeType::ADD;
		case MERGE_SUBTRACT: return Particle::MergeType::SUBTRACT;
		case MERGE_MULTIPLY: return Particle::MergeType::MULTIPLY;
		case MERGE_DIVIDE:   return Particle::MergeType::DIVIDE;
		default:             return Particle::MergeType::SET;
	}
}

static Particle::MergeDest merge_dest_from_int(int dest) {
	switch (dest) {
		case MERGE_ANY: return Particle::MergeDest::ANY;
		case MERGE_X:   return Particle::MergeDest::X;
		case MERGE_Y:   return Particle::MergeDest::Y;
		case MERGE_Z:   return Particle::MergeDest::Z;
		default:        return Particle::MergeDest::ANY;
	}
}

static Particle::ConstraintType constraint_type_from_int(int type) {
	switch (type) {
		case CONSTRAINT_GREATER_THAN: return Particle::ConstraintType::GREATER_THAN;
		case CONSTRAINT_LESSER_THAN:  return Particle::ConstraintType::LESSER_THAN;
		default:                      return Particle::ConstraintType::GREATER_THAN;
	}
}

void* tramsdk_render_particle_parameter_make() {
	return new Particle::Parameter();
}

void tramsdk_render_particle_parameter_yeet(void* param) {
	delete (Particle::Parameter*)param;
}

void tramsdk_render_particle_parameter_set_none(void* param) {
	((Particle::Parameter*)param)->type = Particle::ParamType::NONE;
}

void tramsdk_render_particle_parameter_set_data(void* param, const char* data) {
	auto p = (Particle::Parameter*)param;
	p->type = Particle::ParamType::DATA;
	p->data = data;
}

void tramsdk_render_particle_parameter_set_scalar(void* param, float value) {
	auto p = (Particle::Parameter*)param;
	p->type = Particle::ParamType::SCALAR;
	p->scalar = value;
}

void tramsdk_render_particle_parameter_set_vector(void* param, float x, float y, float z) {
	auto p = (Particle::Parameter*)param;
	p->type = Particle::ParamType::VECTOR;
	p->vector = {x, y, z};
}

void* tramsdk_render_particle_operation_make() {
	return new Particle::Operation();
}

void tramsdk_render_particle_operation_yeet(void* op) {
	delete (Particle::Operation*)op;
}

void tramsdk_render_particle_operation_set_type(void* op, int type) {
	((Particle::Operation*)op)->type = operation_type_from_int(type);
}

void tramsdk_render_particle_operation_set_merge(void* op, int merge) {
	((Particle::Operation*)op)->merge = merge_type_from_int(merge);
}

void tramsdk_render_particle_operation_set_dest(void* op, int dest) {
	((Particle::Operation*)op)->dest = merge_dest_from_int(dest);
}

void tramsdk_render_particle_operation_set_target(void* op, const char* target) {
	((Particle::Operation*)op)->target = target;
}

void tramsdk_render_particle_operation_set_param(void* op, int index, void* param) {
	auto o = (Particle::Operation*)op;
	auto p = (Particle::Parameter*)param;
	switch (index) {
		case 0: o->param1 = *p; break;
		case 1: o->param2 = *p; break;
		case 2: o->param3 = *p; break;
		case 3: o->param4 = *p; break;
	}
}

void* tramsdk_render_particle_constraint_make() {
	return new Particle::Constraint();
}

void tramsdk_render_particle_constraint_yeet(void* data) {
	delete (Particle::Constraint*)data;
}

void tramsdk_render_particle_constraint_set_type(void* op, int type) {
	((Particle::Constraint*)op)->type = constraint_type_from_int(type);
}

void tramsdk_render_particle_constraint_set_dest(void* op, int dest) {
	((Particle::Constraint*)op)->dest = merge_dest_from_int(dest);
}

void tramsdk_render_particle_constraint_set_property(void* op, const char* property) {
	((Particle::Constraint*)op)->property = property;
}

void tramsdk_render_particle_constraint_set_param(void* op, int index, void* param) {
	auto ct = (Particle::Constraint*)op;
	auto p = *(Particle::Parameter*)param;
	switch (index) {
		case 0: ct->param1 = p; break;
		case 1: ct->param2 = p; break;
		case 2: ct->param3 = p; break;
		case 3: ct->param4 = p; break;
	}
}

void tramsdk_render_particle_system_set_sprite(void* sys, void* sprite) {
	((Particle::System*)sys)->SetSprite((Sprite*)sprite);
}

void tramsdk_render_particle_system_set_wire(void* sys, void* material) {
	((Particle::System*)sys)->SetWire((Material*)material);
}

void tramsdk_render_particle_system_set_model(void* sys, void* model) {
	((Particle::System*)sys)->SetModel((Model*)model);
}

void tramsdk_render_particle_system_add_value(void* sys, const char* name, int type) {
	Particle::Data data;
	data.name = name;
	data.type = data_type_from_int(type);
	((Particle::System*)sys)->AddValue(data);
}

void tramsdk_render_particle_system_add_operation(void* sys, void* operation) {
	((Particle::System*)sys)->AddOperation(*(Particle::Operation*)operation);
}

void tramsdk_render_particle_system_add_initializer(void* sys, void* initializer) {
	((Particle::System*)sys)->AddInitializer(*(Particle::Operation*)initializer);
}

void tramsdk_render_particle_system_add_constraint(void* sys, void* constraint) {
	((Particle::System*)sys)->AddConstraint(*(Particle::Constraint*)constraint);
}

void tramsdk_render_particle_system_add_emitter(void* sys, void* rate, void* delay) {
	((Particle::System*)sys)->AddEmitter(*(Particle::Parameter*)rate,
										 *(Particle::Parameter*)delay);
}

void tramsdk_render_particle_system_set_particle_limit(void* sys, int limit) {
	((Particle::System*)sys)->SetParticleLimit(limit);
}

void* tramsdk_render_particle_create_system(void* particle) {
	return ((Particle*)particle)->CreateSystem();
}

void* tramsdk_render_particle_get_base_system(void* particle) {
	return ((Particle*)particle)->GetBaseSystem();
}

void tramsdk_render_particle_add_control(void* particle, const char* name, int type) {
	((Particle*)particle)->AddControl(name, data_type_from_int(type));
}

void* tramsdk_render_particle_find(const char* name) {
	return Particle::Find(name);
}
