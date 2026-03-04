unit CFunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, dynlibs;

const
  // TextureProperty
  TEXTURE_PROPERTY_METAL = 0;
  TEXTURE_PROPERTY_METAL_THIN = 1;
  TEXTURE_PROPERTY_SLIME = 2;
  TEXTURE_PROPERTY_TILE = 3;
  TEXTURE_PROPERTY_GRATE = 4;
  TEXTURE_PROPERTY_WOOD = 5;
  TEXTURE_PROPERTY_COMPUTER = 6;
  TEXTURE_PROPERTY_GLASS = 7;
  TEXTURE_PROPERTY_SNOW = 8;
  TEXTURE_PROPERTY_GRASS = 9;
  TEXTURE_PROPERTY_CONCRETE = 10;
  TEXTURE_PROPERTY_FLESH = 11;

  // TextureType
  TEXTURE_NONE = 0;
  TEXTURE_SAME = 1;
  TEXTURE_SOURCE = 2;
  TEXTURE_SAME_NORMAL = 3;

  // vertexformat_t
  VERTEX_STATIC = 0;
  VERTEX_DYNAMIC = 1;
  VERTEX_SPRITE = 2;
  VERTEX_LINE = 3;
  VERTEX_LAST = 4;

  // materialtype_t
  MATERIAL_TEXTURE = 0;
  MATERIAL_TEXTURE_ALPHA = 1;
  MATERIAL_TEXTURE_BLEND = 2;
  MATERIAL_LIGHTMAP = 3;
  MATERIAL_ENVIRONMENTMAP = 4;
  MATERIAL_MSDF = 5;
  MATERIAL_GLYPH = 6;
  MATERIAL_WATER = 7;
  MATERIAL_FLAT_COLOR = 8;
  MATERIAL_LAST = 9;

  // MaterialFilter
  FILTER_NEAREST = 0;
  FILTER_LINEAR = 1;

  // ResourceStatus
  RESOURCE_UNLOADED = 0;
  RESOURCE_LOADED = 1;
  RESOURCE_READY = 2;


type
  TAABBTriangle = packed record
    p1_x, p1_y, p1_z : Single;
    p2_x, p2_y, p2_z : Single;
    p3_x, p3_y, p3_z : Single;
    n_x, n_y, n_z : Single;
    material : Integer;
  end;
  PAABBTriangle = ^TAABBTriangle;

  // INITIALIZATION AND PLATFORM WRAPPER
  TSDKInit = procedure(); cdecl;
  TSDKYeet = procedure(); cdecl;
  TSDKUpdate = procedure(); cdecl;
  TSDKPlatformWindowScreenResize = procedure(width, height: Integer); cdecl;

  // RESOURCE SHARED
  TSDKResourceGetStatus = function(resource: Pointer): Integer; cdecl;
  TSDKResourceGetName = function(resource: Pointer): PAnsiChar; cdecl;
  TSDKResourceGetReferences = function(resource: Pointer): Integer; cdecl;
  TSDKResourceAddReference = procedure(resource: Pointer); cdecl;
  TSDKResourceRemoveReference = procedure(resource: Pointer); cdecl;
  TSDKResourceLoad = procedure(resource: Pointer); cdecl;
  TSDKResourceUnload = procedure(resource: Pointer); cdecl;

  // ANIMATION RESOURCE
  TSDKAnimSetModel = procedure(component, model: Pointer); cdecl;
  TSDKAnimGetModel = function(component: Pointer): Pointer; cdecl;
  TSDKAnimGetPose = function(component: Pointer): Pointer; cdecl;
  TSDKAnimSetKeyframe = procedure(component: Pointer; frame, l_x, l_y, l_z, r_x, r_y, r_z, s_x, s_y, s_z: Single); cdecl;
  TSDKAnimSetCallback = procedure(component: Pointer; callback: Pointer); cdecl; // >_< callback is procedure(component: Pointer; name: PAnsiChar) cdecl
  TSDKAnimPlay = procedure(component: Pointer; name: PAnsiChar; repeats: Integer; weight, speed: Single; interpolate, pause_on_last_frame: Integer); cdecl;
  TSDKAnimIsPlaying = function(component: Pointer; name: PAnsiChar): Integer; cdecl;
  TSDKAnimStop = procedure(component: Pointer; name: PAnsiChar); cdecl;
  TSDKAnimPause = procedure(component: Pointer; name: PAnsiChar); cdecl;
  TSDKAnimContinue = procedure(component: Pointer; name: PAnsiChar); cdecl;
  TSDKAnimSetWeight = procedure(component: Pointer; name: PAnsiChar; weight: Single); cdecl;
  TSDKAnimSetSpeed = procedure(component: Pointer; name: PAnsiChar; speed: Single); cdecl;
  TSDKAnimSetRepeats = procedure(component: Pointer; name: PAnsiChar; repeats: Integer); cdecl;
  TSDKAnimFadeIn = procedure(component: Pointer; name: PAnsiChar; length: Single); cdecl;
  TSDKAnimFadeOut = procedure(component: Pointer; name: PAnsiChar; length: Single); cdecl;
  TSDKAnimSetPause = procedure(component: Pointer; name: PAnsiChar; pause: Integer); cdecl;
  TSDKAnimSetFade = procedure(component: Pointer; name: PAnsiChar; fade_in: Integer; fade_length: Single); cdecl;
  TSDKAnimReparent = procedure(component: Pointer; name, new_parent: PAnsiChar); cdecl;
  TSDKAnimMake = function(): Pointer; cdecl;
  TSDKAnimYeet = procedure(component: Pointer); cdecl;
  TSDKAnimIsDebugDraw = function(component: Pointer): Integer; cdecl;
  TSDKAnimSetDebugDraw = procedure(component: Pointer; draw: Integer); cdecl;

  // MATERIAL RESOURCE
  TSDKMaterialGetTexture = function(material: Pointer): Pointer; cdecl;
  TSDKMaterialGetNormalMap = function(material: Pointer): Pointer; cdecl;
  TSDKMaterialGetMaterial = function(material: Pointer): Pointer; cdecl;
  TSDKMaterialGetWidth = function(material: Pointer): Integer; cdecl;
  TSDKMaterialGetHeight = function(material: Pointer): Integer; cdecl;
  TSDKMaterialGetType = function(material: Pointer): Integer; cdecl;
  TSDKMaterialGetProperty = function(material: Pointer): Integer; cdecl;
  TSDKMaterialGetColor = procedure(material: Pointer; r, g, b: PSingle); cdecl;
  TSDKMaterialGetSpecularWeight = function(material: Pointer): Single; cdecl;
  TSDKMaterialGetSpecularExponent = function(material: Pointer): Single; cdecl;
  TSDKMaterialGetSpecularTransparency = function(material: Pointer): Single; cdecl;
  TSDKMaterialGetReflectivity = function(material: Pointer): Single; cdecl;
  TSDKMaterialSetMaterialType = procedure(material: Pointer; type_: Integer); cdecl;
  TSDKMaterialSetMaterialFilter = procedure(material: Pointer; filter: Integer); cdecl;
  TSDKMaterialSetMaterialProperty = procedure(material: Pointer; property_: Integer); cdecl;
  TSDKMaterialSetColor = procedure(material: Pointer; r, g, b: Single); cdecl;
  TSDKMaterialSetSpecular = procedure(material: Pointer; weight, exponent, transparency: Single); cdecl;
  TSDKMaterialSetReflectivity = procedure(material: Pointer; reflectivity: Single); cdecl;
  TSDKMaterialSetTextureType = procedure(material: Pointer; texture_type: Integer); cdecl;
  TSDKMaterialSetSource = procedure(material, source: Pointer); cdecl;
  TSDKMaterialSetTextureImage = procedure(material: Pointer; data: PAnsiChar; channels: ShortInt; width, height: SmallInt); cdecl;
  TSDKMaterialFind = function(name: PAnsiChar): Pointer; cdecl;
  TSDKMaterialMake = function(name: PAnsiChar; type_: Integer): Pointer; cdecl;
  TSDKMaterialLoadMaterialInfo = procedure(filename: PAnsiChar); cdecl;

  // MODEL RESOURCE
  TSDKModelGetVertexFormat = function(component: Pointer): Integer; cdecl;
  TSDKModelGetAABBMin = procedure(component: Pointer; x, y, z: PSingle); cdecl;
  TSDKModelGetAABBMax = procedure(component: Pointer; x, y, z: PSingle); cdecl;
  TSDKModelDrawAABB = procedure(component: Pointer); cdecl;
  TSDKModelFindAllFromRay = function(component: Pointer; p_x, p_y, p_z, d_x, d_y, d_z: Single; tris: PAABBTriangle; tri_size: Integer): Integer; cdecl;
  TSDKModelFindAllFromAABB = function(component: Pointer; min_x, min_y, min_z, max_x, max_y, max_z: Single; tris: PAABBTriangle; tri_size: Integer): Integer; cdecl;
  TSDKModelGetMaterials = function(component: Pointer; materials: PPointer; material_size: Integer): Integer; cdecl;
  TSDKModelGetOrigin = procedure(component: Pointer; x, y, z: PSingle); cdecl;
  TSDKModelGetNearDistance = function(component: Pointer): Single; cdecl;
  TSDKModelGetFarDistance = function(component: Pointer): Single; cdecl;
  TSDKModelSetNearDistance = procedure(component: Pointer; dist: Single); cdecl;
  TSDKModelSetFarDistance = procedure(component: Pointer; dist: Single); cdecl;
  TSDKModelLoadAsModificationModel = procedure(component, source: Pointer; mapping: PPointer; size: Integer); cdecl;
  TSDKModelFind = function(name: PAnsiChar): Pointer; cdecl;

  // ANIMATION RESOURCE
  TSDKAnimationFind = function(name: PAnsiChar): Pointer; cdecl;
  TSDKAnimationLoadAll = procedure(); cdecl;

  // ENITTY COMPONENT SHARED
  TSDKComponentInit = procedure(component: Pointer); cdecl;
  TSDKComponentIsReady = function(component: Pointer): Integer; cdecl;
  TSDKComponentIsInit = function(component: Pointer): Integer; cdecl;
  TSDKComponentGetParent = function(component: Pointer): Pointer; cdecl;
  TSDKComponentSetParent = procedure(component, entity: Pointer); cdecl;

  // RENDER COMPONENT
  TSDKRenderMake = function(): Pointer; cdecl;
  TSDKRenderYeet = procedure(component: Pointer); cdecl;
  TSDKRenderGetModel = function(component: Pointer): Pointer; cdecl;
  TSDKRenderGetLightMap = function(component: Pointer): Pointer; cdecl;
  TSDKRenderSetModel = procedure(component, model: Pointer); cdecl;
  TSDKRenderSetLightMap = procedure(component, light_map: Pointer); cdecl;
  TSDKRenderSetEnvironmentMap = procedure(component, material: Pointer); cdecl;
  TSDKRenderSetArmature = procedure(component, armature: Pointer); cdecl;
  TSDKRenderGetLocation = procedure(component: Pointer; x, y, z: PSingle); cdecl;
  TSDKRenderGetRotation = procedure(component: Pointer; x, y, z: PSingle); cdecl;
  TSDKRenderGetScale = procedure(component: Pointer; x, y, z: PSingle); cdecl;
  TSDKRenderSetLocation = procedure(component: Pointer; x, y, z: Single); cdecl;
  TSDKRenderSetRotation = procedure(component: Pointer; x, y, z: Single); cdecl;
  TSDKRenderSetScale = procedure(component: Pointer; x, y, z: Single); cdecl;
  TSDKRenderSetColor = procedure(component: Pointer; r, g, b: Single); cdecl;
  TSDKRenderSetLayer = procedure(component: Pointer; layer: Integer); cdecl;
  TSDKRenderSetTextureOffset = procedure(component: Pointer; material: PAnsiChar; x, y, z, w: Single); cdecl;
  TSDKRenderSetLineDrawingMode = procedure(component: Pointer; enabled: Integer); cdecl;
  TSDKRenderSetDirectionalLight = procedure(component: Pointer; enabled: Integer); cdecl;
  TSDKRenderSetRenderDebug = procedure(component: Pointer; enabled: Integer); cdecl;

  // MESH VERTEX
  TSDKMeshVertexMake = function(): Pointer; cdecl;
  TSDKMeshVertexYeet = procedure(vertex: Pointer); cdecl;
  TSDKMeshVertexSetPosition = procedure(vertex: Pointer; x, y, z: Single); cdecl;
  TSDKMeshVertexSetNormal = procedure(vertex: Pointer; x, y, z: Single); cdecl;
  TSDKMeshVertexSetColor = procedure(vertex: Pointer; r, g, b: Single); cdecl;
  TSDKMeshVertexSetTextureUV = procedure(vertex: Pointer; u, v: Single); cdecl;
  TSDKMeshVertexSetLightmapUV = procedure(vertex: Pointer; u, v: Single); cdecl;
  TSDKMeshVertexSetAttrName = procedure(vertex: Pointer; index: Integer; value: PAnsiChar); cdecl;
  TSDKMeshVertexSetAttrBool = procedure(vertex: Pointer; index: Integer; value: Boolean); cdecl;
  TSDKMeshVertexSetAttrInt = procedure(vertex: Pointer; index, value: Integer); cdecl;
  TSDKMeshVertexSetAttrFloat = procedure(vertex: Pointer; index: Integer; value: Single); cdecl;
  TSDKMeshVertexSetAttrVec2 = procedure(vertex: Pointer; index: Integer; x, y: Single); cdecl;
  TSDKMeshVertexSetAttrVec3 = procedure(vertex: Pointer; index: Integer; x, y, z: Single); cdecl;
  TSDKMeshVertexSetAttrVec4 = procedure(vertex: Pointer; index: Integer; x, y, z, w: Single); cdecl;
  TSDKMeshVertexSetAttrQuat = procedure(vertex: Pointer; index: Integer; x, y, z, w: Single); cdecl;
  TSDKMeshVertexSetAttrIVec2 = procedure(vertex: Pointer; index, x, y: Integer); cdecl;
  TSDKMeshVertexSetAttrIVec3 = procedure(vertex: Pointer; index, x, y, z: Integer); cdecl;
  TSDKMeshVertexSetAttrIVec4 = procedure(vertex: Pointer; index, x, y, z, w: Integer); cdecl;
  TSDKMeshVertexSetAttrUVec2 = procedure(vertex: Pointer; index, x, y: Integer); cdecl;
  TSDKMeshVertexSetAttrUVec3 = procedure(vertex: Pointer; index, x, y, z: Integer); cdecl;
  TSDKMeshVertexSetAttrUVec4 = procedure(vertex: Pointer; index, x, y, z, w: Integer); cdecl;

  // MESH COMPONENT
  TSDKMeshMake = function(): Pointer; cdecl;
  TSDKMeshYeet = procedure(component: Pointer); cdecl;
  TSDKMeshAdd2 = procedure(component, vertex1, vertex2: Pointer); cdecl;
  TSDKMeshAdd3 = procedure(component, vertex1, vertex2, vertex3: Pointer); cdecl;
  TSDKMeshClear = procedure(component: Pointer); cdecl;
  TSDKMeshReserve = procedure(component: Pointer; format, vertex_count: Integer); cdecl;
  TSDKMeshCommit = procedure(component: Pointer); cdecl;
  TSDKMeshSetMaterial = procedure(component, material: Pointer; index: Integer); cdecl;
  TSDKMeshGetLocation = procedure(component: Pointer; x, y, z: PSingle); cdecl;
  TSDKMeshGetRotation = procedure(component: Pointer; x, y, z: PSingle); cdecl;
  TSDKMeshGetScale = procedure(component: Pointer; x, y, z: PSingle); cdecl;
  TSDKMeshSetLocation = procedure(component: Pointer; x, y, z: Single); cdecl;
  TSDKMeshSetRotation = procedure(component: Pointer; x, y, z: Single); cdecl;
  TSDKMeshSetScale = procedure(component: Pointer; x, y, z: Single); cdecl;
  TSDKMeshSetColor = procedure(component: Pointer; r, g, b: Single); cdecl;
  TSDKMeshSetLayer = procedure(component: Pointer; layer: Integer); cdecl;
  TSDKMeshSetTextureOffset = procedure(component: Pointer; material: PAnsiChar; x, y, z, w: Single); cdecl;
  TSDKMeshSetLineDrawingMode = procedure(component: Pointer; enabled: Integer); cdecl;
  TSDKMeshSetDirectionalLight = procedure(component: Pointer; enabled: Integer); cdecl;
  TSDKMeshSetRenderDebug = procedure(component: Pointer; enabled: Integer); cdecl;
  TSDKMeshGetAABBMin = procedure(component: Pointer; x, y, z: PSingle); cdecl;
  TSDKMeshGetAABBMax = procedure(component: Pointer; x, y, z: PSingle); cdecl;
  TSDKMeshDrawAABB = procedure(component: Pointer); cdecl;
  TSDKMeshFindFromRay = function(component: Pointer; p_x, p_y, p_z, d_x, d_y, d_z: Single; tris: Pointer; tri_size: Integer): Integer; cdecl;
  TSDKMeshFindFromAABB = function(component: Pointer; min_x, min_y, min_z, max_x, max_y, max_z: Single; tris: Pointer; tri_size: Integer): Integer; cdecl;

  // LIGHT COMPONENT
  TSDKLightMake = function(): Pointer; cdecl;
  TSDKLightYeet = procedure(component: Pointer); cdecl;
  TSDKLightSetLocation = procedure(component: Pointer; x, y, z: Single); cdecl;
  TSDKLightSetColor = procedure(component: Pointer; r, g, b: Single); cdecl;
  TSDKLightSetDistance = procedure(component: Pointer; dist: Single); cdecl;
  TSDKLightSetDirection = procedure(component: Pointer; x, y, z: Single); cdecl;
  TSDKLightSetExponent = procedure(component: Pointer; exponent: Single); cdecl;
  TSDKLightGetColor = procedure(component: Pointer; r, g, b: PSingle); cdecl;
  TSDKLightGetDistance = function(component: Pointer): Single; cdecl;
  TSDKLightIsLightDraw = function(component: Pointer): Integer; cdecl;   // >_< C header had void return - fixed to Integer nyaa~
  TSDKLightSetLightDraw = procedure(component: Pointer; value: Integer); cdecl;

  // MESHTOOLS
  TSDKMakeCubeSphere = procedure(mesh: Pointer; subdivisions: Integer; radius: Single); cdecl;

var

  // INITIALIZATION AND PLATFORM WRAPPER
  sdk_init : TSDKInit;
  sdk_yeet : TSDKYeet;
  sdk_update : TSDKUpdate;
  sdk_platform_window_screen_resize : TSDKPlatformWindowScreenResize;

  // RESOURCE SHARED
  sdk_framework_resource_get_status : TSDKResourceGetStatus;
  sdk_framework_resource_get_name : TSDKResourceGetName;
  sdk_framework_resource_get_references : TSDKResourceGetReferences;
  sdk_framework_resource_add_reference : TSDKResourceAddReference;
  sdk_framework_resource_remove_reference : TSDKResourceRemoveReference;
  sdk_framework_resource_load : TSDKResourceLoad;
  sdk_framework_resource_unload : TSDKResourceUnload;

  // MATERIAL RESOURCE
  sdk_render_material_get_texture : TSDKMaterialGetTexture;
  sdk_render_material_get_normal_map : TSDKMaterialGetNormalMap;
  sdk_render_material_get_material : TSDKMaterialGetMaterial;
  sdk_render_material_get_width : TSDKMaterialGetWidth;
  sdk_render_material_get_height : TSDKMaterialGetHeight;
  sdk_render_material_get_type : TSDKMaterialGetType;
  sdk_render_material_get_property : TSDKMaterialGetProperty;
  sdk_render_material_get_color : TSDKMaterialGetColor;
  sdk_render_material_get_specular_weight : TSDKMaterialGetSpecularWeight;
  sdk_render_material_get_specular_exponent : TSDKMaterialGetSpecularExponent;
  sdk_render_material_get_specular_transparency : TSDKMaterialGetSpecularTransparency;
  sdk_render_material_get_reflectivity : TSDKMaterialGetReflectivity;
  sdk_render_material_set_material_type : TSDKMaterialSetMaterialType;
  sdk_render_material_set_material_filter : TSDKMaterialSetMaterialFilter;
  sdk_render_material_set_material_property : TSDKMaterialSetMaterialProperty;
  sdk_render_material_set_color : TSDKMaterialSetColor;
  sdk_render_material_set_specular : TSDKMaterialSetSpecular;
  sdk_render_material_set_reflectivity : TSDKMaterialSetReflectivity;
  sdk_render_material_set_texture_type : TSDKMaterialSetTextureType;
  sdk_render_material_set_source : TSDKMaterialSetSource;
  sdk_render_material_set_texture_image : TSDKMaterialSetTextureImage;
  sdk_render_material_find : TSDKMaterialFind;
  sdk_render_material_make : TSDKMaterialMake;
  sdk_render_material_load_material_info : TSDKMaterialLoadMaterialInfo;

  // MODEL RESOURCE
  sdk_render_model_get_vertex_format : TSDKModelGetVertexFormat;
  sdk_render_model_get_aabb_min : TSDKModelGetAABBMin;
  sdk_render_model_get_aabb_max : TSDKModelGetAABBMax;
  sdk_render_model_draw_aabb : TSDKModelDrawAABB;
  sdk_render_model_find_all_from_ray : TSDKModelFindAllFromRay;
  sdk_render_model_find_all_from_aabb : TSDKModelFindAllFromAABB;
  sdk_render_model_get_materials : TSDKModelGetMaterials;
  sdk_render_model_get_origin : TSDKModelGetOrigin;
  sdk_render_model_get_near_distance : TSDKModelGetNearDistance;
  sdk_render_model_get_far_distance : TSDKModelGetFarDistance;
  sdk_render_model_set_near_distance : TSDKModelSetNearDistance;
  sdk_render_model_set_far_distance : TSDKModelSetFarDistance;
  sdk_render_model_load_as_modification_model: TSDKModelLoadAsModificationModel;
  sdk_render_model_find  : TSDKModelFind;

  // ANIMATION RESOURCE
  sdk_render_animation_find : TSDKAnimationFind;
  sdk_render_animation_load_all : TSDKAnimationLoadAll;

  // ENITITY COMPONENT SHARED
  sdk_framework_component_init : TSDKComponentInit;
  sdk_framework_component_is_ready : TSDKComponentIsReady;
  sdk_framework_component_is_init : TSDKComponentIsInit;
  sdk_framework_component_get_parent: TSDKComponentGetParent;
  sdk_framework_component_set_parent: TSDKComponentSetParent;

  // ANIMATION COMPONENT
  sdk_component_animation_set_model : TSDKAnimSetModel;
  sdk_component_animation_get_model : TSDKAnimGetModel;
  sdk_component_animation_get_pose : TSDKAnimGetPose;
  sdk_component_animation_set_keyframe : TSDKAnimSetKeyframe;
  sdk_component_animation_set_on_animation_finish_callback : TSDKAnimSetCallback;
  sdk_component_animation_play : TSDKAnimPlay;
  sdk_component_animation_is_playing : TSDKAnimIsPlaying;
  sdk_component_animation_stop : TSDKAnimStop;
  sdk_component_animation_pause : TSDKAnimPause;
  sdk_component_animation_continue : TSDKAnimContinue;
  sdk_component_animation_set_weight : TSDKAnimSetWeight;
  sdk_component_animation_set_speed : TSDKAnimSetSpeed;
  sdk_component_animation_set_repeats : TSDKAnimSetRepeats;
  sdk_component_animation_fade_in : TSDKAnimFadeIn;
  sdk_component_animation_fade_out : TSDKAnimFadeOut;
  sdk_component_animation_set_pause : TSDKAnimSetPause;
  sdk_component_animation_set_fade : TSDKAnimSetFade;
  sdk_component_animation_reparent : TSDKAnimReparent;
  sdk_component_animation_make : TSDKAnimMake;
  sdk_component_animation_yeet : TSDKAnimYeet;
  sdk_component_animation_is_debug_info_draw : TSDKAnimIsDebugDraw;
  sdk_component_animation_set_debug_info_draw : TSDKAnimSetDebugDraw;

  // RENDER COMPONENT
  sdk_components_render_make : TSDKRenderMake;
  sdk_components_render_yeet : TSDKRenderYeet;
  sdk_components_render_get_model : TSDKRenderGetModel;
  sdk_components_render_get_light_map : TSDKRenderGetLightMap;
  sdk_components_render_set_model : TSDKRenderSetModel;
  sdk_components_render_set_light_map : TSDKRenderSetLightMap;
  sdk_components_render_set_environment_map : TSDKRenderSetEnvironmentMap;
  sdk_components_render_set_armature : TSDKRenderSetArmature;
  sdk_components_render_get_location : TSDKRenderGetLocation;
  sdk_components_render_get_rotation : TSDKRenderGetRotation;
  sdk_components_render_get_scale : TSDKRenderGetScale;
  sdk_components_render_set_location : TSDKRenderSetLocation;
  sdk_components_render_set_rotation : TSDKRenderSetRotation;
  sdk_components_render_set_scale : TSDKRenderSetScale;
  sdk_components_render_set_color : TSDKRenderSetColor;
  sdk_components_render_set_layer : TSDKRenderSetLayer;
  sdk_components_render_set_texture_offset : TSDKRenderSetTextureOffset;
  sdk_components_render_set_line_drawing_mode : TSDKRenderSetLineDrawingMode;
  sdk_components_render_set_directional_light : TSDKRenderSetDirectionalLight;
  sdk_components_render_set_render_debug : TSDKRenderSetRenderDebug;

  // MESH VERTEX
  sdk_components_mesh_vertex_make : TSDKMeshVertexMake;
  sdk_components_mesh_vertex_yeet : TSDKMeshVertexYeet;
  sdk_components_mesh_vertex_set_position : TSDKMeshVertexSetPosition;
  sdk_components_mesh_vertex_set_normal : TSDKMeshVertexSetNormal;
  sdk_components_mesh_vertex_set_color : TSDKMeshVertexSetColor;
  sdk_components_mesh_vertex_set_texture_uv : TSDKMeshVertexSetTextureUV;
  sdk_components_mesh_vertex_set_lightmap_uv : TSDKMeshVertexSetLightmapUV;
  sdk_components_mesh_vertex_set_attribute_name : TSDKMeshVertexSetAttrName;
  sdk_components_mesh_vertex_set_attribute_bool : TSDKMeshVertexSetAttrBool;
  sdk_components_mesh_vertex_set_attribute_int : TSDKMeshVertexSetAttrInt;
  sdk_components_mesh_vertex_set_attribute_float : TSDKMeshVertexSetAttrFloat;
  sdk_components_mesh_vertex_set_attribute_vec2 : TSDKMeshVertexSetAttrVec2;
  sdk_components_mesh_vertex_set_attribute_vec3 : TSDKMeshVertexSetAttrVec3;
  sdk_components_mesh_vertex_set_attribute_vec4 : TSDKMeshVertexSetAttrVec4;
  sdk_components_mesh_vertex_set_attribute_quat : TSDKMeshVertexSetAttrQuat;
  sdk_components_mesh_vertex_set_attribute_ivec2 : TSDKMeshVertexSetAttrIVec2;
  sdk_components_mesh_vertex_set_attribute_ivec3 : TSDKMeshVertexSetAttrIVec3;
  sdk_components_mesh_vertex_set_attribute_ivec4 : TSDKMeshVertexSetAttrIVec4;
  sdk_components_mesh_vertex_set_attribute_uvec2 : TSDKMeshVertexSetAttrUVec2;
  sdk_components_mesh_vertex_set_attribute_uvec3 : TSDKMeshVertexSetAttrUVec3;
  sdk_components_mesh_vertex_set_attribute_uvec4 : TSDKMeshVertexSetAttrUVec4;

  // MESH COMPONENT
  sdk_components_mesh_make : TSDKMeshMake;
  sdk_components_mesh_yeet : TSDKMeshYeet;
  sdk_components_mesh_add2 : TSDKMeshAdd2;
  sdk_components_mesh_add3 : TSDKMeshAdd3;
  sdk_components_mesh_clear : TSDKMeshClear;
  sdk_components_mesh_reserve : TSDKMeshReserve;
  sdk_components_mesh_commit : TSDKMeshCommit;
  sdk_components_mesh_set_material : TSDKMeshSetMaterial;
  sdk_components_mesh_get_location : TSDKMeshGetLocation;
  sdk_components_mesh_get_rotation : TSDKMeshGetRotation;
  sdk_components_mesh_get_scale : TSDKMeshGetScale;
  sdk_components_mesh_set_location : TSDKMeshSetLocation;
  sdk_components_mesh_set_rotation : TSDKMeshSetRotation;
  sdk_components_mesh_set_scale : TSDKMeshSetScale;
  sdk_components_mesh_set_color : TSDKMeshSetColor;
  sdk_components_mesh_set_layer : TSDKMeshSetLayer;
  sdk_components_mesh_set_texture_offset : TSDKMeshSetTextureOffset;
  sdk_components_mesh_set_line_drawing_mode : TSDKMeshSetLineDrawingMode;
  sdk_components_mesh_set_directional_light : TSDKMeshSetDirectionalLight;
  sdk_components_mesh_set_render_debug : TSDKMeshSetRenderDebug;
  sdk_components_mesh_get_aabb_min : TSDKMeshGetAABBMin;
  sdk_components_mesh_get_aabb_max : TSDKMeshGetAABBMax;
  sdk_components_mesh_draw_aabb : TSDKMeshDrawAABB;
  sdk_components_mesh_find_all_from_ray : TSDKMeshFindFromRay;
  sdk_components_mesh_find_all_from_aabb : TSDKMeshFindFromAABB;

  // LIGHT COMPONENT
  sdk_component_light_make : TSDKLightMake;
  sdk_component_light_yeet : TSDKLightYeet;
  sdk_component_light_set_location : TSDKLightSetLocation;
  sdk_component_light_set_color : TSDKLightSetColor;
  sdk_component_light_set_distance : TSDKLightSetDistance;
  sdk_component_light_set_direction: TSDKLightSetDirection;
  sdk_component_light_set_exponent : TSDKLightSetExponent;
  sdk_component_light_get_color : TSDKLightGetColor;
  sdk_component_light_get_distance : TSDKLightGetDistance;
  sdk_component_light_is_light_draw: TSDKLightIsLightDraw;
  sdk_component_light_set_light_draw: TSDKLightSetLightDraw;

  // MESHTOOLS
  sdk_ext_meshtools_make_cube_sphere: TSDKMakeCubeSphere;

procedure SDKLoadLibs(const DLLPath: string);

implementation

var
  DLLHandle: TLibHandle = NilHandle;

procedure SDKLoadLibs(const DLLPath: string);
function LoadFunc(const funcName: string): Pointer;
  begin
    Result := GetProcedureAddress(DLLHandle, funcName);
    if Result = nil then
      raise Exception.CreateFmt(
        'Could not find "%s" in "%s"', [funcName, DLLPath]);
  end;
begin
  DLLHandle := LoadLibrary(DLLPath);
  if DLLHandle = NilHandle then
    raise Exception.CreateFmt(
      'Failed to load "%s" with error "%s"',
      [DLLPath, SysErrorMessage(GetLastOSError)]);

  // INITIALIZATION AND PLATFORM WRAPPER
  sdk_init := TSDKInit(LoadFunc('tramsdk_init'));
  sdk_yeet := TSDKYeet(LoadFunc('tramsdk_yeet'));
  sdk_update := TSDKUpdate(LoadFunc('tramsdk_update'));
  sdk_platform_window_screen_resize := TSDKPlatformWindowScreenResize(LoadFunc('tramsdk_platform_window_screen_resize'));

  // RESOURCE SHARED
  sdk_framework_resource_get_status := TSDKResourceGetStatus(LoadFunc('tramsdk_framework_resource_get_status'));
  sdk_framework_resource_get_name := TSDKResourceGetName(LoadFunc('tramsdk_framework_resource_get_name'));
  sdk_framework_resource_get_references := TSDKResourceGetReferences(LoadFunc('tramsdk_framework_resource_get_references'));
  sdk_framework_resource_add_reference := TSDKResourceAddReference(LoadFunc('tramsdk_framework_resource_add_reference'));
  sdk_framework_resource_remove_reference := TSDKResourceRemoveReference(LoadFunc('tramsdk_framework_resource_remove_reference'));
  sdk_framework_resource_load := TSDKResourceLoad(LoadFunc('tramsdk_framework_resource_load'));
  sdk_framework_resource_unload := TSDKResourceUnload(LoadFunc('tramsdk_framework_resource_unload'));

  // MATERIAL RESOURCE
  sdk_render_material_get_texture := TSDKMaterialGetTexture(LoadFunc('tramsdk_render_material_get_texture'));
  sdk_render_material_get_normal_map := TSDKMaterialGetNormalMap(LoadFunc('tramsdk_render_material_get_normal_map'));
  sdk_render_material_get_material := TSDKMaterialGetMaterial(LoadFunc('tramsdk_render_material_get_material'));
  sdk_render_material_get_width := TSDKMaterialGetWidth(LoadFunc('tramsdk_render_material_get_width'));
  sdk_render_material_get_height := TSDKMaterialGetHeight(LoadFunc('tramsdk_render_material_get_height'));
  sdk_render_material_get_type := TSDKMaterialGetType(LoadFunc('tramsdk_render_material_get_type'));
  sdk_render_material_get_property := TSDKMaterialGetProperty(LoadFunc('tramsdk_render_material_get_property'));
  sdk_render_material_get_color := TSDKMaterialGetColor(LoadFunc('tramsdk_render_material_get_color'));
  sdk_render_material_get_specular_weight := TSDKMaterialGetSpecularWeight(LoadFunc('tramsdk_render_material_get_specular_weight'));
  sdk_render_material_get_specular_exponent := TSDKMaterialGetSpecularExponent(LoadFunc('tramsdk_render_material_get_specular_exponent'));
  sdk_render_material_get_specular_transparency := TSDKMaterialGetSpecularTransparency(LoadFunc('tramsdk_render_material_get_specular_transparency'));
  sdk_render_material_get_reflectivity := TSDKMaterialGetReflectivity(LoadFunc('tramsdk_render_material_get_reflectivity'));
  sdk_render_material_set_material_type := TSDKMaterialSetMaterialType(LoadFunc('tramsdk_render_material_set_material_type'));
  sdk_render_material_set_material_filter := TSDKMaterialSetMaterialFilter(LoadFunc('tramsdk_render_material_set_material_filter'));
  sdk_render_material_set_material_property := TSDKMaterialSetMaterialProperty(LoadFunc('tramsdk_render_material_set_material_property'));
  sdk_render_material_set_color := TSDKMaterialSetColor(LoadFunc('tramsdk_render_material_set_color'));
  sdk_render_material_set_specular := TSDKMaterialSetSpecular(LoadFunc('tramsdk_render_material_set_specular'));
  sdk_render_material_set_reflectivity := TSDKMaterialSetReflectivity(LoadFunc('tramsdk_render_material_set_reflectivity'));
  sdk_render_material_set_texture_type := TSDKMaterialSetTextureType(LoadFunc('tramsdk_render_material_set_texture_type'));
  sdk_render_material_set_source := TSDKMaterialSetSource(LoadFunc('tramsdk_render_material_set_source'));
  sdk_render_material_set_texture_image := TSDKMaterialSetTextureImage(LoadFunc('tramsdk_render_material_set_texture_image'));
  sdk_render_material_find := TSDKMaterialFind(LoadFunc('tramsdk_render_material_find'));
  sdk_render_material_make := TSDKMaterialMake(LoadFunc('tramsdk_render_material_make'));
  sdk_render_material_load_material_info := TSDKMaterialLoadMaterialInfo(LoadFunc('tramsdk_render_material_load_material_info'));

  // MODEL RESOURCE
  sdk_render_model_get_vertex_format := TSDKModelGetVertexFormat(LoadFunc('tramsdk_render_model_get_vertex_format'));
  sdk_render_model_get_aabb_min := TSDKModelGetAABBMin(LoadFunc('tramsdk_render_model_get_aabb_min'));
  sdk_render_model_get_aabb_max := TSDKModelGetAABBMax(LoadFunc('tramsdk_render_model_get_aabb_max'));
  sdk_render_model_draw_aabb := TSDKModelDrawAABB(LoadFunc('tramsdk_render_model_draw_aabb'));
  sdk_render_model_find_all_from_ray := TSDKModelFindAllFromRay(LoadFunc('tramsdk_render_model_find_all_from_ray'));
  sdk_render_model_find_all_from_aabb := TSDKModelFindAllFromAABB(LoadFunc('tramsdk_render_model_find_all_from_aabb'));
  sdk_render_model_get_materials := TSDKModelGetMaterials(LoadFunc('tramsdk_render_model_get_materials'));
  sdk_render_model_get_origin := TSDKModelGetOrigin(LoadFunc('tramsdk_render_model_get_origin'));
  sdk_render_model_get_near_distance := TSDKModelGetNearDistance(LoadFunc('tramsdk_render_model_get_near_distance'));
  sdk_render_model_get_far_distance := TSDKModelGetFarDistance(LoadFunc('tramsdk_render_model_get_far_distance'));
  sdk_render_model_set_near_distance := TSDKModelSetNearDistance(LoadFunc('tramsdk_render_model_set_near_distance'));
  sdk_render_model_set_far_distance := TSDKModelSetFarDistance(LoadFunc('tramsdk_render_model_set_far_distance'));
  sdk_render_model_load_as_modification_model:= TSDKModelLoadAsModificationModel(LoadFunc('tramsdk_render_model_load_as_modification_model'));
  sdk_render_model_find := TSDKModelFind(LoadFunc('tramsdk_render_model_find'));

  // ANIMATION RESOURCE
  sdk_render_animation_find := TSDKAnimationFind(LoadFunc('tramsdk_render_animation_find'));
  sdk_render_animation_load_all := TSDKAnimationLoadAll(LoadFunc('tramsdk_render_animation_load_all'));

  // ENTITY COMPONENT SHARED
  sdk_framework_component_init := TSDKComponentInit(LoadFunc('tramsdk_framework_component_init'));
  sdk_framework_component_is_ready := TSDKComponentIsReady(LoadFunc('tramsdk_framework_component_is_ready'));
  sdk_framework_component_is_init := TSDKComponentIsInit(LoadFunc('tramsdk_framework_component_is_init'));
  sdk_framework_component_get_parent := TSDKComponentGetParent(LoadFunc('tramsdk_framework_component_get_parent'));
  sdk_framework_component_set_parent := TSDKComponentSetParent(LoadFunc('tramsdk_framework_component_set_parent'));

  // ANIMATION COMPONENT
  sdk_component_animation_set_model := TSDKAnimSetModel(LoadFunc('tramsdk_component_animation_set_model'));
  sdk_component_animation_get_model := TSDKAnimGetModel(LoadFunc('tramsdk_component_animation_get_model'));
  sdk_component_animation_get_pose := TSDKAnimGetPose(LoadFunc('tramsdk_component_animation_get_pose'));
  sdk_component_animation_set_keyframe := TSDKAnimSetKeyframe(LoadFunc('tramsdk_component_animation_set_keyframe'));
  sdk_component_animation_set_on_animation_finish_callback := TSDKAnimSetCallback(LoadFunc('tramsdk_component_animation_set_on_animation_finish_callback'));
  sdk_component_animation_play := TSDKAnimPlay(LoadFunc('tramsdk_component_animation_play'));
  sdk_component_animation_is_playing := TSDKAnimIsPlaying(LoadFunc('tramsdk_component_animation_is_playing'));
  sdk_component_animation_stop := TSDKAnimStop(LoadFunc('tramsdk_component_animation_stop'));
  sdk_component_animation_pause := TSDKAnimPause(LoadFunc('tramsdk_component_animation_pause'));
  sdk_component_animation_continue := TSDKAnimContinue(LoadFunc('tramsdk_component_animation_continue'));
  sdk_component_animation_set_weight := TSDKAnimSetWeight(LoadFunc('tramsdk_component_animation_set_weight'));
  sdk_component_animation_set_speed := TSDKAnimSetSpeed(LoadFunc('tramsdk_component_animation_set_speed'));
  sdk_component_animation_set_repeats := TSDKAnimSetRepeats(LoadFunc('tramsdk_component_animation_set_repeats'));
  sdk_component_animation_fade_in := TSDKAnimFadeIn(LoadFunc('tramsdk_component_animation_fade_in'));
  sdk_component_animation_fade_out := TSDKAnimFadeOut(LoadFunc('tramsdk_component_animation_fade_out'));
  sdk_component_animation_set_pause := TSDKAnimSetPause(LoadFunc('tramsdk_component_animation_set_pause'));
  sdk_component_animation_set_fade := TSDKAnimSetFade(LoadFunc('tramsdk_component_animation_set_fade'));
  sdk_component_animation_reparent := TSDKAnimReparent(LoadFunc('tramsdk_component_animation_reparent'));
  sdk_component_animation_make := TSDKAnimMake(LoadFunc('tramsdk_component_animation_make'));
  sdk_component_animation_yeet := TSDKAnimYeet(LoadFunc('tramsdk_component_animation_yeet'));
  sdk_component_animation_is_debug_info_draw := TSDKAnimIsDebugDraw(LoadFunc('tramsdk_component_animation_is_debug_info_draw'));
  sdk_component_animation_set_debug_info_draw := TSDKAnimSetDebugDraw(LoadFunc('tramsdk_component_animation_set_debug_info_draw'));

  // RENDER COMPONENT
  sdk_components_render_make := TSDKRenderMake(LoadFunc('tramsdk_components_render_make'));
  sdk_components_render_yeet := TSDKRenderYeet(LoadFunc('tramsdk_components_render_yeet'));
  sdk_components_render_get_model := TSDKRenderGetModel(LoadFunc('tramsdk_components_render_get_model'));
  sdk_components_render_get_light_map := TSDKRenderGetLightMap(LoadFunc('tramsdk_components_render_get_light_map'));
  sdk_components_render_set_model := TSDKRenderSetModel(LoadFunc('tramsdk_components_render_set_model'));
  sdk_components_render_set_light_map := TSDKRenderSetLightMap(LoadFunc('tramsdk_components_render_set_light_map'));
  sdk_components_render_set_environment_map := TSDKRenderSetEnvironmentMap(LoadFunc('tramsdk_components_render_set_environment_map'));
  sdk_components_render_set_armature := TSDKRenderSetArmature(LoadFunc('tramsdk_components_render_set_armature'));
  sdk_components_render_get_location := TSDKRenderGetLocation(LoadFunc('tramsdk_components_render_get_location'));
  sdk_components_render_get_rotation := TSDKRenderGetRotation(LoadFunc('tramsdk_components_render_get_rotation'));
  sdk_components_render_get_scale := TSDKRenderGetScale(LoadFunc('tramsdk_components_render_get_scale'));
  sdk_components_render_set_location := TSDKRenderSetLocation(LoadFunc('tramsdk_components_render_set_location'));
  sdk_components_render_set_rotation := TSDKRenderSetRotation(LoadFunc('tramsdk_components_render_set_rotation'));
  sdk_components_render_set_scale := TSDKRenderSetScale(LoadFunc('tramsdk_components_render_set_scale'));
  sdk_components_render_set_color := TSDKRenderSetColor(LoadFunc('tramsdk_components_render_set_color'));
  sdk_components_render_set_layer := TSDKRenderSetLayer(LoadFunc('tramsdk_components_render_set_layer'));
  sdk_components_render_set_texture_offset := TSDKRenderSetTextureOffset(LoadFunc('tramsdk_components_render_set_texture_offset'));
  sdk_components_render_set_line_drawing_mode := TSDKRenderSetLineDrawingMode(LoadFunc('tramsdk_components_render_set_line_drawing_mode'));
  sdk_components_render_set_directional_light := TSDKRenderSetDirectionalLight(LoadFunc('tramsdk_components_render_set_directional_light'));
  sdk_components_render_set_render_debug := TSDKRenderSetRenderDebug(LoadFunc('tramsdk_components_render_set_render_debug'));

  // MESH VERTEX
  sdk_components_mesh_vertex_make := TSDKMeshVertexMake(LoadFunc('tramsdk_components_mesh_vertex_make'));
  sdk_components_mesh_vertex_yeet := TSDKMeshVertexYeet(LoadFunc('tramsdk_components_mesh_vertex_yeet'));
  sdk_components_mesh_vertex_set_position := TSDKMeshVertexSetPosition(LoadFunc('tramsdk_components_mesh_vertex_set_position'));
  sdk_components_mesh_vertex_set_normal := TSDKMeshVertexSetNormal(LoadFunc('tramsdk_components_mesh_vertex_set_normal'));
  sdk_components_mesh_vertex_set_color := TSDKMeshVertexSetColor(LoadFunc('tramsdk_components_mesh_vertex_set_color'));
  sdk_components_mesh_vertex_set_texture_uv := TSDKMeshVertexSetTextureUV(LoadFunc('tramsdk_components_mesh_vertex_set_texture_uv'));
  sdk_components_mesh_vertex_set_lightmap_uv := TSDKMeshVertexSetLightmapUV(LoadFunc('tramsdk_components_mesh_vertex_set_lightmap_uv'));
  sdk_components_mesh_vertex_set_attribute_name := TSDKMeshVertexSetAttrName(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_name'));
  sdk_components_mesh_vertex_set_attribute_bool := TSDKMeshVertexSetAttrBool(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_bool'));
  sdk_components_mesh_vertex_set_attribute_int := TSDKMeshVertexSetAttrInt(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_int'));
  sdk_components_mesh_vertex_set_attribute_float := TSDKMeshVertexSetAttrFloat(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_float'));
  sdk_components_mesh_vertex_set_attribute_vec2 := TSDKMeshVertexSetAttrVec2(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_vec2'));
  sdk_components_mesh_vertex_set_attribute_vec3 := TSDKMeshVertexSetAttrVec3(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_vec3'));
  sdk_components_mesh_vertex_set_attribute_vec4 := TSDKMeshVertexSetAttrVec4(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_vec4'));
  sdk_components_mesh_vertex_set_attribute_quat := TSDKMeshVertexSetAttrQuat(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_quat'));
  sdk_components_mesh_vertex_set_attribute_ivec2 := TSDKMeshVertexSetAttrIVec2(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_ivec2'));
  sdk_components_mesh_vertex_set_attribute_ivec3 := TSDKMeshVertexSetAttrIVec3(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_ivec3'));
  sdk_components_mesh_vertex_set_attribute_ivec4 := TSDKMeshVertexSetAttrIVec4(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_ivec4'));
  sdk_components_mesh_vertex_set_attribute_uvec2 := TSDKMeshVertexSetAttrUVec2(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_uvec2'));
  sdk_components_mesh_vertex_set_attribute_uvec3 := TSDKMeshVertexSetAttrUVec3(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_uvec3'));
  sdk_components_mesh_vertex_set_attribute_uvec4 := TSDKMeshVertexSetAttrUVec4(LoadFunc('tramsdk_components_mesh_vertex_set_attribute_uvec4'));

  // MESH COMPONENT
  sdk_components_mesh_make := TSDKMeshMake(LoadFunc('tramsdk_components_mesh_make'));
  sdk_components_mesh_yeet := TSDKMeshYeet(LoadFunc('tramsdk_components_mesh_yeet'));
  sdk_components_mesh_add2 := TSDKMeshAdd2(LoadFunc('tramsdk_components_mesh_add2'));
  sdk_components_mesh_add3 := TSDKMeshAdd3(LoadFunc('tramsdk_components_mesh_add3'));
  sdk_components_mesh_clear := TSDKMeshClear(LoadFunc('tramsdk_components_mesh_clear'));
  sdk_components_mesh_reserve := TSDKMeshReserve(LoadFunc('tramsdk_components_mesh_reserve'));
  sdk_components_mesh_commit := TSDKMeshCommit(LoadFunc('tramsdk_components_mesh_commit'));
  sdk_components_mesh_set_material := TSDKMeshSetMaterial(LoadFunc('tramsdk_components_mesh_set_material'));
  sdk_components_mesh_get_location := TSDKMeshGetLocation(LoadFunc('tramsdk_components_mesh_get_location'));
  sdk_components_mesh_get_rotation := TSDKMeshGetRotation(LoadFunc('tramsdk_components_mesh_get_rotation'));
  sdk_components_mesh_get_scale := TSDKMeshGetScale(LoadFunc('tramsdk_components_mesh_get_scale'));
  sdk_components_mesh_set_location := TSDKMeshSetLocation(LoadFunc('tramsdk_components_mesh_set_location'));
  sdk_components_mesh_set_rotation := TSDKMeshSetRotation(LoadFunc('tramsdk_components_mesh_set_rotation'));
  sdk_components_mesh_set_scale := TSDKMeshSetScale(LoadFunc('tramsdk_components_mesh_set_scale'));
  sdk_components_mesh_set_color := TSDKMeshSetColor(LoadFunc('tramsdk_components_mesh_set_color'));
  sdk_components_mesh_set_layer := TSDKMeshSetLayer(LoadFunc('tramsdk_components_mesh_set_layer'));
  sdk_components_mesh_set_texture_offset := TSDKMeshSetTextureOffset(LoadFunc('tramsdk_components_mesh_set_texture_offset'));
  sdk_components_mesh_set_line_drawing_mode := TSDKMeshSetLineDrawingMode(LoadFunc('tramsdk_components_mesh_set_line_drawing_mode'));
  sdk_components_mesh_set_directional_light := TSDKMeshSetDirectionalLight(LoadFunc('tramsdk_components_mesh_set_directional_light'));
  sdk_components_mesh_set_render_debug := TSDKMeshSetRenderDebug(LoadFunc('tramsdk_components_mesh_set_render_debug'));
  sdk_components_mesh_get_aabb_min := TSDKMeshGetAABBMin(LoadFunc('tramsdk_components_mesh_get_aabb_min'));
  sdk_components_mesh_get_aabb_max := TSDKMeshGetAABBMax(LoadFunc('tramsdk_components_mesh_get_aabb_max'));
  sdk_components_mesh_draw_aabb := TSDKMeshDrawAABB(LoadFunc('tramsdk_components_mesh_draw_aabb'));
  sdk_components_mesh_find_all_from_ray := TSDKMeshFindFromRay(LoadFunc('tramsdk_components_mesh_find_all_from_ray'));
  sdk_components_mesh_find_all_from_aabb := TSDKMeshFindFromAABB(LoadFunc('tramsdk_components_mesh_find_all_from_aabb'));

  // LIGHT COMPONENT
  sdk_component_light_make := TSDKLightMake(LoadFunc('tramsdk_component_light_make'));
  sdk_component_light_yeet := TSDKLightYeet(LoadFunc('tramsdk_component_light_yeet'));
  sdk_component_light_set_location := TSDKLightSetLocation(LoadFunc('tramsdk_component_light_set_location'));
  sdk_component_light_set_color := TSDKLightSetColor(LoadFunc('tramsdk_component_light_set_color'));
  sdk_component_light_set_distance := TSDKLightSetDistance(LoadFunc('tramsdk_component_light_set_distance'));
  sdk_component_light_set_direction := TSDKLightSetDirection(LoadFunc('tramsdk_component_light_set_direction'));
  sdk_component_light_set_exponent := TSDKLightSetExponent(LoadFunc('tramsdk_component_light_set_exponent'));
  sdk_component_light_get_color := TSDKLightGetColor(LoadFunc('tramsdk_component_light_get_color'));
  sdk_component_light_get_distance := TSDKLightGetDistance(LoadFunc('tramsdk_component_light_get_distance'));
  sdk_component_light_is_light_draw := TSDKLightIsLightDraw(LoadFunc('tramsdk_component_light_is_light_draw'));
  sdk_component_light_set_light_draw:= TSDKLightSetLightDraw(LoadFunc('tramsdk_component_light_set_light_draw'));

  // MESHTOOLS
  sdk_ext_meshtools_make_cube_sphere := TSDKMakeCubeSphere(LoadFunc('tramsdk_ext_meshtools_make_cube_sphere'));

end;

end.

