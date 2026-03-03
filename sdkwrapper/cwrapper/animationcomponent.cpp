#include "animationcomponent.h"

#include <components/animation.h>

#include <map>

using namespace tram;

void sdk_component_animation_set_model(void* component, void* model) {
	((AnimationComponent*)component)->SetModel((Render::Model*)model);
}

void* sdk_component_animation_get_model(void* component) {
	return ((AnimationComponent*)component)->GetModel();
}

void* sdk_component_animation_get_pose(void* component) {
	return ((AnimationComponent*)component)->GetPose();
}

void sdk_component_animation_set_keyframe(void* component,
										  const char* bone, float frame,
										  float l_x, float l_y, float l_z,
										  float r_x, float r_y, float r_z,
										  float s_x, float s_y, float s_z
) {
	Render::Keyframe kf;
	kf.frame = frame;
	kf.location = {l_x, l_y, l_z};
	kf.rotation = vec3(r_x, r_y, r_z);
	kf.scale = {s_x, s_y, s_z};
	((AnimationComponent*)component)->SetKeyframe(bone, kf);
}

typedef void (*anim_finish_callback_t)(void*, const char*);
static std::map<void*, anim_finish_callback_t> anim_finish_callbacks;

static void anim_finish_thunk(AnimationComponent* comp, name_t name) {
	auto callback = anim_finish_callbacks[comp];
	if (!callback) callback(comp, name);
}

void sdk_component_animation_set_on_animation_finish_callback(void* component, void (*callback)(void*, const char*)) {
	anim_finish_callbacks[component] = callback;
	((AnimationComponent*)component)->SetOnAnimationFinishCallback(anim_finish_thunk);
}

void sdk_component_animation_play(void* component, const char* name,
								  int repeats, float weight, float speed,
								  int interpolate, int pause_on_last_frame
) {
	((AnimationComponent*)component)->Play(name, repeats, weight, speed, interpolate, pause_on_last_frame);
}

int sdk_component_animation_is_playing(void* component, const char* name) {
	return ((AnimationComponent*)component)->IsPlaying(name);
}

void sdk_component_animation_stop(void* component, const char* name) {
	((AnimationComponent*)component)->Stop(name);
}

void sdk_component_animation_pause(void* component, const char* name) {
	((AnimationComponent*)component)->Pause(name);
}

void sdk_component_animation_continue(void* component, const char* name) {
	((AnimationComponent*)component)->Continue(name);
}

void sdk_component_animation_set_weight(void* component, const char* name, float weight) {
	((AnimationComponent*)component)->SetWeight(name, weight);
}

void sdk_component_animation_set_speed(void* component, const char* name, float speed) {
	((AnimationComponent*)component)->SetSpeed(name, speed);
}

void sdk_component_animation_set_repeats(void* component, const char* name, int repeats) {
	((AnimationComponent*)component)->SetRepeats(name, repeats);
}

void sdk_component_animation_fade_in(void* component, const char* name, float length) {
	((AnimationComponent*)component)->FadeIn(name, length);
}

void sdk_component_animation_fade_out(void* component, const char* name, float length) {
	((AnimationComponent*)component)->FadeOut(name, length);
}

void sdk_component_animation_set_pause(void* component, const char* name, int pause) {
	((AnimationComponent*)component)->SetPause(name, pause);
}

void sdk_component_animation_set_fade(void* component, const char* name, int fade_in, float fade_length) {
	(((AnimationComponent*)component))->SetFade(name, fade_in, fade_length);
}

void sdk_component_animation_reparent(void* component, const char* name, const char* new_parent) {
	(((AnimationComponent*)component))->Reparent(name, new_parent);
}

void* sdk_component_animation_make() {
	return AnimationComponent::Make();
}

void sdk_component_animation_yeet(void* component) {
	AnimationComponent::Yeet(((AnimationComponent*)component));
}

int sdk_component_animation_is_debug_info_draw() {
	return AnimationComponent::IsDebugInfoDraw();
}

void sdk_component_animation_set_debug_info_draw(int draw) {
	AnimationComponent::SetDebugInfoDraw(draw);
}