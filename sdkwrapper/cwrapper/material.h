#pragma once

#ifdef __cplusplus
extern "C" {
#endif

// MaterialProperty
enum {
	TEXTURE_PROPERTY_METAL,
	TEXTURE_PROPERTY_METAL_THIN,
	TEXTURE_PROPERTY_SLIME,
	TEXTURE_PROPERTY_TILE,
	TEXTURE_PROPERTY_GRATE,
	TEXTURE_PROPERTY_WOOD,
	TEXTURE_PROPERTY_COMPUTER,
	TEXTURE_PROPERTY_GLASS,
	TEXTURE_PROPERTY_SNOW,
	TEXTURE_PROPERTY_GRASS,
	TEXTURE_PROPERTY_CONCRETE,
	TEXTURE_PROPERTY_FLESH
};

// TextureType
enum {
	TEXTURE_NONE,
	TEXTURE_SAME,
	TEXTURE_SOURCE,
	TEXTURE_SAME_NORMAL
};

// vertexformat_t
enum {
    VERTEX_STATIC,
    VERTEX_DYNAMIC,
    VERTEX_SPRITE,
    VERTEX_LINE,
    VERTEX_LAST
};

// materialtype_t
enum {
    MATERIAL_TEXTURE,
    MATERIAL_TEXTURE_ALPHA,
    MATERIAL_TEXTURE_BLEND,
    MATERIAL_LIGHTMAP,
    MATERIAL_ENVIRONMENTMAP,
    MATERIAL_MSDF,
    MATERIAL_GLYPH,
    MATERIAL_WATER,
    MATERIAL_FLAT_COLOR,
    MATERIAL_LAST
};

// MaterialFilter
enum {
    FILTER_NEAREST,
    FILTER_LINEAR
};

__declspec(dllexport) void* tramsdk_render_material_get_texture(void* material);
__declspec(dllexport) void* tramsdk_render_material_get_normal_map(void* material);
__declspec(dllexport) void* tramsdk_render_material_get_material(void* material);

__declspec(dllexport) int tramsdk_render_material_get_width(void* material);
__declspec(dllexport) int tramsdk_render_material_get_height(void* material);

__declspec(dllexport) int tramsdk_render_material_get_type(void* material);
__declspec(dllexport) int tramsdk_render_material_get_property(void* material);
__declspec(dllexport) void tramsdk_render_material_get_color(void* material, float* r, float* g, float* b);
__declspec(dllexport) float tramsdk_render_material_get_specular_weight(void* material);
__declspec(dllexport) float tramsdk_render_material_get_specular_exponent(void* material);
__declspec(dllexport) float tramsdk_render_material_get_specular_transparency(void* material);
__declspec(dllexport) float tramsdk_render_material_get_reflectivity(void* material);

__declspec(dllexport) void tramsdk_render_material_set_material_type(void* material, int type);
__declspec(dllexport) void tramsdk_render_material_set_material_filter(void* material, int filter);
__declspec(dllexport) void tramsdk_render_material_set_material_property(void* material, int property);
__declspec(dllexport) void tramsdk_render_material_set_color(void* material, float r, float g, float b);
__declspec(dllexport) void tramsdk_render_material_set_specular(void* material, float weight,
                                                                float exponent, float transparency);
__declspec(dllexport) void tramsdk_render_material_set_reflectivity(void* material, float reflectivity);
__declspec(dllexport) void tramsdk_render_material_set_texture_type(void* material, int texture_type);
__declspec(dllexport) void tramsdk_render_material_set_source(void* material, void* source);
__declspec(dllexport) void tramsdk_render_material_set_texture_image(void* material, char* data,
                                                                     char channels, short width, short height);
__declspec(dllexport) void* tramsdk_render_material_find(const char* name);
__declspec(dllexport) void* tramsdk_render_material_make(const char* name, int type);

__declspec(dllexport) void tramsdk_render_material_load_material_info(const char* filename);

#ifdef __cplusplus
}
#endif