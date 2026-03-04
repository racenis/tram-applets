#include "material.h"

#include <render/material.h>

using namespace tram;
using namespace tram::Render;

void* tramsdk_render_material_get_texture(void* material) {
	return ((Material*)material)->GetTexture().generic;
}

void* tramsdk_render_material_get_normal_map(void* material) {
	return ((Material*)material)->GetNormalMap().generic;
}

void* tramsdk_render_material_get_material(void* material) {
	return ((Material*)material)->GetMaterial().generic;
}

int tramsdk_render_material_get_width(void* material) {
	return ((Material*)material)->GetWidth();
}

int tramsdk_render_material_get_height(void* material) {
	return ((Material*)material)->GetHeight();
}

int tramsdk_render_material_get_type(void* material) {
	return ((Material*)material)->GetType();
}

int tramsdk_render_material_get_property(void* material) {
	return ((Material*)material)->GetProperty();
}

void tramsdk_render_material_get_color(void* material, float* r, float* g, float* b) {
	vec3 c = ((Material*)material)->GetColor(); *r = c.x; *g = c.y; *b = c.z;
}

float tramsdk_render_material_get_specular_weight(void* material) {
	return ((Material*)material)->GetSpecularWeight();
}

float tramsdk_render_material_get_specular_exponent(void* material) {
	return ((Material*)material)->GetSpecularExponent();
}

float tramsdk_render_material_get_specular_transparency(void* material) {
	return ((Material*)material)->GetSpecularTransparency();
}

float tramsdk_render_material_get_reflectivity(void* material) {
	return ((Material*)material)->GetReflectivity();
}

void tramsdk_render_material_set_material_type(void* material, int type) {
	((Material*)material)->SetMaterialType((materialtype_t)type);
}

void tramsdk_render_material_set_material_filter(void* material, int filter) {
	((Material*)material)->SetMaterialFilter((MaterialFilter)filter);
}

void tramsdk_render_material_set_material_property(void* material, int property) {
	((Material*)material)->SetMaterialProperty((MaterialProperty)property);
}

void tramsdk_render_material_set_color(void* material, float r, float g, float b) {
	((Material*)material)->SetColor({r, g, b});
}

void tramsdk_render_material_set_specular(void* material, float weight, float exponent, float transparency) {
	((Material*)material)->SetSpecular(weight, exponent, transparency);
}

void tramsdk_render_material_set_reflectivity(void* material, float reflectivity) {
	((Material*)material)->SetReflectivity(reflectivity);
}

void tramsdk_render_material_set_texture_type(void* material, int texture_type) {
	((Material*)material)->SetTextureType((TextureType)texture_type);
}

void tramsdk_render_material_set_source(void* material, void* source) {
	((Material*)material)->SetSource((Material*)source);
}

void tramsdk_render_material_set_texture_image(void* material, char* data, char channels, short width, short height) {
	((Material*)material)->SetTextureImage((unsigned char*)data, channels, width, height);
}

void* tramsdk_render_material_find(const char* name) {
	return Material::Find(name);
}

void* tramsdk_render_material_make(const char* name, int type) {
	return Material::Make(name, (materialtype_t)type);
}

void tramsdk_render_material_load_material_info(const char* filename) {
	Material::LoadMaterialInfo(filename);
}