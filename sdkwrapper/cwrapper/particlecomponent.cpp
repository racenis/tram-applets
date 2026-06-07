#include "particlecomponent.h"

#include <components/particle.h>

using namespace tram;
using namespace tram::Render;

void* tramsdk_components_particle_make() {
	return PoolProxy<ParticleComponent>::New();
}

void tramsdk_components_particle_yeet(void* component) {
	PoolProxy<ParticleComponent>::Delete((ParticleComponent*)component);
}

void tramsdk_components_particle_update_location(void* component, float x, float y, float z) {
	((ParticleComponent*)component)->UpdateLocation({x, y, z});
}

void tramsdk_components_particle_set_particle(void* component, void* particle) {
	((ParticleComponent*)component)->SetParticle(static_cast<Particle*>(particle));
}

void tramsdk_components_particle_set_control_scalar(void* component, const char* control, float value) {
	// TODO: (ParticleComponent*)component->SetControl(control, value);
}

void tramsdk_components_particle_set_control_vector(void* component, const char* control, float x, float y, float z) {
	// TODO: (ParticleComponent*)component->SetControl(control, {x, y, z});
}