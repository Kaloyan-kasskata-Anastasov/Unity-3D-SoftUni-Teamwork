//same like HIGH + self shadow enabled

Shader "RedDotGames/Mobile/Car Paint Ultra Detail Bump" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 1
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
	  _BumpMap ("Normalmap", 2D) = "bump" {}
	  _Cube("Reflection Map", Cube) = "" {}
	  _Reflection("Reflection Power", Range (0.00, 1)) = 0
	  _FrezPow("Fresnel Power",Range(0,2)) = .25
	  _FrezFalloff("Fresnal Falloff",Range(0,10)) = 4	  
	  
	  _SparkleTex ("Sparkle Texture", 2D) = "white" {} 

	  _FlakeScale ("Flake Scale", float) = 1
	  _FlakePower ("Flake Alpha",Range(0,1)) = 0

	  _OuterFlakePower ("Flake Outer Power",Range(1,16)) = 2

	  _paintColor2 ("Outer Flake Color (RGB)", Color) = (1,1,1,1) 

	  
   }
SubShader {
   Tags { "QUEUE"="Geometry" "RenderType"="Opaque" " IgnoreProjector"="True"}	  
      Pass {  
      
         Tags { "LightMode" = "ForwardBase" } // pass for 
            // 4 vertex lights, ambient light & first pixel light
 
         Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 35 to 40
//   d3d9 - ALU: 35 to 40
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c13.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c13.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c13.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((modelMatrix * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((modelMatrix * tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_1;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (tmpvar_21.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (paintColor * _FlakePower));
  color = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = ((color + reflTex) + (tmpvar_24 * reflTex));
  color = tmpvar_27;
  gl_FragData[0] = tmpvar_27;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((modelMatrix * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((modelMatrix * tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_1;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (tmpvar_21.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (paintColor * _FlakePower));
  color = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = ((color + reflTex) + (tmpvar_24 * reflTex));
  color = tmpvar_27;
  gl_FragData[0] = tmpvar_27;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c13.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c13.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c13.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((modelMatrix * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((modelMatrix * tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_1;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (tmpvar_21.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (paintColor * _FlakePower));
  color = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = ((color + reflTex) + (tmpvar_24 * reflTex));
  color = tmpvar_27;
  gl_FragData[0] = tmpvar_27;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((modelMatrix * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((modelMatrix * tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_1;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (tmpvar_21.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (paintColor * _FlakePower));
  color = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = ((color + reflTex) + (tmpvar_24 * reflTex));
  color = tmpvar_27;
  gl_FragData[0] = tmpvar_27;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c13.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c13.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c13.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((modelMatrix * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((modelMatrix * tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_1;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (tmpvar_21.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (paintColor * _FlakePower));
  color = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = ((color + reflTex) + (tmpvar_24 * reflTex));
  color = tmpvar_27;
  gl_FragData[0] = tmpvar_27;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((modelMatrix * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((modelMatrix * tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_1;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (tmpvar_21.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (paintColor * _FlakePower));
  color = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = ((color + reflTex) + (tmpvar_24 * reflTex));
  color = tmpvar_27;
  gl_FragData[0] = tmpvar_27;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 40 ALU
PARAM c[15] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[7].xy, R1, R1.z;
ADD R1.xyz, R0, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 40 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c15.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o8.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c15.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  highp vec4 o_i0;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14.x;
  tmpvar_15.y = (tmpvar_14.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_15 + tmpvar_14.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (normalDirection, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = (((tmpvar_9.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_1;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = (paintColor * tmpvar_9.x);
  paintColor = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = (frez * _FrezPow);
  frez = tmpvar_26;
  reflTex.xyz = (tmpvar_23.xyz * clamp (((_Reflection + tmpvar_26) * tmpvar_9.x), 0.0, 1.0));
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_27 + (tmpvar_21 * _FlakePower));
  color = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = ((color + reflTex) + (tmpvar_26 * reflTex));
  color = tmpvar_29;
  gl_FragData[0] = tmpvar_29;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  highp vec4 o_i0;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14.x;
  tmpvar_15.y = (tmpvar_14.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_15 + tmpvar_14.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (normalDirection, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = (((tmpvar_9.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_1;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = (paintColor * tmpvar_9.x);
  paintColor = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = (frez * _FrezPow);
  frez = tmpvar_26;
  reflTex.xyz = (tmpvar_23.xyz * clamp (((_Reflection + tmpvar_26) * tmpvar_9.x), 0.0, 1.0));
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_27 + (tmpvar_21 * _FlakePower));
  color = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = ((color + reflTex) + (tmpvar_26 * reflTex));
  color = tmpvar_29;
  gl_FragData[0] = tmpvar_29;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 40 ALU
PARAM c[15] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[7].xy, R1, R1.z;
ADD R1.xyz, R0, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 40 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c15.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o8.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c15.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  highp vec4 o_i0;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14.x;
  tmpvar_15.y = (tmpvar_14.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_15 + tmpvar_14.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (normalDirection, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = (((tmpvar_9.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_1;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = (paintColor * tmpvar_9.x);
  paintColor = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = (frez * _FrezPow);
  frez = tmpvar_26;
  reflTex.xyz = (tmpvar_23.xyz * clamp (((_Reflection + tmpvar_26) * tmpvar_9.x), 0.0, 1.0));
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_27 + (tmpvar_21 * _FlakePower));
  color = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = ((color + reflTex) + (tmpvar_26 * reflTex));
  color = tmpvar_29;
  gl_FragData[0] = tmpvar_29;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  highp vec4 o_i0;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14.x;
  tmpvar_15.y = (tmpvar_14.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_15 + tmpvar_14.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (normalDirection, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = (((tmpvar_9.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_1;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = (paintColor * tmpvar_9.x);
  paintColor = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = (frez * _FrezPow);
  frez = tmpvar_26;
  reflTex.xyz = (tmpvar_23.xyz * clamp (((_Reflection + tmpvar_26) * tmpvar_9.x), 0.0, 1.0));
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_27 + (tmpvar_21 * _FlakePower));
  color = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = ((color + reflTex) + (tmpvar_26 * reflTex));
  color = tmpvar_29;
  gl_FragData[0] = tmpvar_29;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 40 ALU
PARAM c[15] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[7].xy, R1, R1.z;
ADD R1.xyz, R0, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 40 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c15.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o8.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c15.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  highp vec4 o_i0;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14.x;
  tmpvar_15.y = (tmpvar_14.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_15 + tmpvar_14.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (normalDirection, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = (((tmpvar_9.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_1;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = (paintColor * tmpvar_9.x);
  paintColor = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = (frez * _FrezPow);
  frez = tmpvar_26;
  reflTex.xyz = (tmpvar_23.xyz * clamp (((_Reflection + tmpvar_26) * tmpvar_9.x), 0.0, 1.0));
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_27 + (tmpvar_21 * _FlakePower));
  color = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = ((color + reflTex) + (tmpvar_26 * reflTex));
  color = tmpvar_29;
  gl_FragData[0] = tmpvar_29;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  highp vec4 o_i0;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14.x;
  tmpvar_15.y = (tmpvar_14.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_15 + tmpvar_14.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (normalDirection, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = (((tmpvar_9.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_1;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = (paintColor * tmpvar_9.x);
  paintColor = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = (frez * _FrezPow);
  frez = tmpvar_26;
  reflTex.xyz = (tmpvar_23.xyz * clamp (((_Reflection + tmpvar_26) * tmpvar_9.x), 0.0, 1.0));
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_27 + (tmpvar_21 * _FlakePower));
  color = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = ((color + reflTex) + (tmpvar_26 * reflTex));
  color = tmpvar_29;
  gl_FragData[0] = tmpvar_29;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c13.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c13.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c13.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((modelMatrix * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((modelMatrix * tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_1;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (tmpvar_21.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (paintColor * _FlakePower));
  color = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = ((color + reflTex) + (tmpvar_24 * reflTex));
  color = tmpvar_27;
  gl_FragData[0] = tmpvar_27;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((modelMatrix * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((modelMatrix * tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (normalDirection, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_12;
    tmpvar_12 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = tmpvar_1;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (tmpvar_21.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (paintColor * _FlakePower));
  color = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = ((color + reflTex) + (tmpvar_24 * reflTex));
  color = tmpvar_27;
  gl_FragData[0] = tmpvar_27;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 40 ALU
PARAM c[15] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[7].xy, R1, R1.z;
ADD R1.xyz, R0, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 40 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c15.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o8.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c15.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  highp vec4 o_i0;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14.x;
  tmpvar_15.y = (tmpvar_14.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_15 + tmpvar_14.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (normalDirection, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = (((tmpvar_9.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_1;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = (paintColor * tmpvar_9.x);
  paintColor = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = (frez * _FrezPow);
  frez = tmpvar_26;
  reflTex.xyz = (tmpvar_23.xyz * clamp (((_Reflection + tmpvar_26) * tmpvar_9.x), 0.0, 1.0));
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_27 + (tmpvar_21 * _FlakePower));
  color = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = ((color + reflTex) + (tmpvar_26 * reflTex));
  color = tmpvar_29;
  gl_FragData[0] = tmpvar_29;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  highp vec4 o_i0;
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = tmpvar_14.x;
  tmpvar_15.y = (tmpvar_14.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_15 + tmpvar_14.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = o_i0;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 normalDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_2;
  tmpvar_2[0] = xlv_TEXCOORD6;
  tmpvar_2[1] = tmpvar_1;
  tmpvar_2[2] = xlv_TEXCOORD5;
  mat3 tmpvar_3;
  tmpvar_3[0].x = tmpvar_2[0].x;
  tmpvar_3[0].y = tmpvar_2[1].x;
  tmpvar_3[0].z = tmpvar_2[2].x;
  tmpvar_3[1].x = tmpvar_2[0].y;
  tmpvar_3[1].y = tmpvar_2[1].y;
  tmpvar_3[1].z = tmpvar_2[2].y;
  tmpvar_3[2].x = tmpvar_2[0].z;
  tmpvar_3[2].y = tmpvar_2[1].z;
  tmpvar_3[2].z = tmpvar_2[2].z;
  lowp vec3 tmpvar_4;
  tmpvar_4 = normalize ((((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).xyz) - vec3(1.0, 1.0, 1.0)) * tmpvar_3));
  normalDirection = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_5;
  mediump vec2 tmpvar_6;
  tmpvar_6 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_6);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (((tmpvar_9.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (normalDirection, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (normalDirection, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = (((tmpvar_9.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_1;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = (paintColor * tmpvar_9.x);
  paintColor = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = reflect (xlv_TEXCOORD4, normalDirection);
  reflectedDir = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = clamp (abs (dot (reflectedDir, normalDirection)), 0.0, 1.0);
  SurfAngle = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = (frez * _FrezPow);
  frez = tmpvar_26;
  reflTex.xyz = (tmpvar_23.xyz * clamp (((_Reflection + tmpvar_26) * tmpvar_9.x), 0.0, 1.0));
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = ((tmpvar_7.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_27 + (tmpvar_21 * _FlakePower));
  color = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = ((color + reflTex) + (tmpvar_26 * reflTex));
  color = tmpvar_29;
  gl_FragData[0] = tmpvar_29;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 92 to 96, TEX: 4 to 5
//   d3d9 - ALU: 95 to 96, TEX: 4 to 5
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 92 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
		{ 2, 1, 20, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R1.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R1.xyz, R1, texture[0], 2D;
DP3 R2.w, c[2], c[2];
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MAD R3.xyz, R1, c[16].x, -c[16].y;
MUL R1.xyz, R3.y, R0;
MAD R2.xyz, R3.x, fragment.texcoord[6], R1;
MAD R2.xyz, R3.z, fragment.texcoord[5], R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R1, R1;
DP3 R0.w, R2, R2;
RSQ R1.w, R1.w;
RSQ R0.w, R0.w;
MUL R1.xyz, R1.w, R1;
RSQ R2.w, R2.w;
ABS R1.w, -c[2];
CMP R1.w, -R1, c[16], c[16].y;
ABS R1.w, R1;
MUL R2.xyz, R0.w, R2;
MUL R3.xyz, R2.w, c[2];
CMP R1.w, -R1, c[16], c[16].y;
CMP R1.xyz, -R1.w, R1, R3;
DP3 R1.w, R2, R1;
SLT R0.w, R1, c[16];
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
DP3 R2.w, R2, -R1;
MUL R3.xyz, R2, R2.w;
ABS R0.w, R0;
MUL R4.xyz, R3.w, R4;
MAD R1.xyz, -R3, c[16].x, -R1;
DP3 R1.x, R1, R4;
MAX R2.w, R1.x, c[16];
MOV R1.xyz, c[6];
MUL R4.xy, fragment.texcoord[3], c[9].x;
MUL R4.xy, R4, c[16].z;
POW R2.w, R2.w, c[7].x;
MUL R1.xyz, R1, c[15];
MUL R1.xyz, R1, R2.w;
CMP R0.w, -R0, c[16], c[16].y;
CMP R3.xyz, -R0.w, R1, c[16].w;
MOV R1.y, R0.z;
MOV R0.zw, c[17].xyxy;
TEX R4.xyz, R4, texture[2], 2D;
MAD R4.xyz, R4, c[16].x, R0.zzww;
MOV R0.z, R0.x;
MOV R1.x, fragment.texcoord[6].z;
MOV R1.z, fragment.texcoord[5];
DP3 R1.z, R1, -R4;
MOV R0.w, fragment.texcoord[5].x;
MOV R0.x, fragment.texcoord[6];
DP3 R1.x, -R4, R0.xzww;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.x, fragment.texcoord[6].y;
DP3 R1.y, -R4, R0;
DP3 R0.x, R1, R1;
RSQ R0.w, R0.x;
MOV R0.xyz, c[4];
MUL R4.xyz, R0, c[15];
MAX R1.w, R1, c[16];
MUL R4.xyz, R4, R1.w;
MAD R0.xyz, R0, c[0], fragment.texcoord[2];
ADD_SAT R4.xyz, R0, R4;
MUL R3.xyz, R3, c[8].x;
TEX R0.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R4, R3;
MUL R3.xyz, R0.w, R1;
DP3 R1.x, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.x;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R1.xyz, R2, R0.w;
MAD R1.xyz, -R1, c[16].x, fragment.texcoord[4];
DP3 R0.w, R1, R2;
MUL R4.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R3, R4;
MUL R1.w, R1, R1;
POW R1.w, R1.w, c[11].x;
ABS_SAT R0.w, R0;
MUL R2, R1.w, c[12];
ADD R0.w, -R0, c[16].y;
POW R1.w, R0.w, c[14].x;
MUL R3.x, R1.w, c[13];
MOV R0.w, c[16].y;
MAD R0, R2, c[10].x, R0;
TEX R1, R1, texture[3], CUBE;
ADD_SAT R2.x, R3, c[5];
MUL R1.xyz, R1, R2.x;
ADD R0, R1, R0;
MAD result.color, R3.x, R1, R0;
END
# 92 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 95 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c16, 2.00000000, -1.00000000, 1.00000000, 20.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0.00000000
def c18, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
mov_pp r1.xyz, v6
mul_pp r2.xyz, v1.zxyw, r1.yzxw
mov_pp r1.xyz, v6
mad_pp r0.xy, v3, c3, c3.zwzw
texld r0.xyz, r0, s0
mad_pp r2.xyz, v1.yzxw, r1.zxyw, -r2
mad_pp r0.xyz, r0, c16.x, c16.y
mul_pp r1.xyz, r0.y, r2
mad_pp r1.xyz, r0.x, v6, r1
mad_pp r1.xyz, r0.z, v5, r1
dp3_pp r0.w, r1, r1
add r0.xyz, -v0, c2
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r1
dp3_pp r1.w, r0, r0
rsq_pp r1.x, r1.w
mul_pp r1.xyz, r1.x, r0
dp3_pp r0.w, c2, c2
rsq_pp r0.x, r0.w
add r4.xyz, -v0, c1
abs_pp r0.w, -c2
mul_pp r0.xyz, r0.x, c2
cmp_pp r0.xyz, -r0.w, r0, r1
dp3 r1.x, r4, r4
rsq r1.w, r1.x
dp3_pp r0.w, r3, -r0
mul_pp r1.xyz, r3, r0.w
mul r4.xyz, r1.w, r4
mad_pp r1.xyz, -r1, c16.x, -r0
dp3_pp r0.w, r1, r4
dp3 r1.w, r3, r0
max_pp r1.x, r0.w, c17.w
pow_pp r0, r1.x, c7.x
cmp r0.w, r1, c18.x, c18.y
mov_pp r2.w, r0.x
mov_pp r1.xyz, c15
mul_pp r0.xyz, c6, r1
mul_pp r0.xyz, r0, r2.w
abs_pp r0.w, r0
cmp_pp r0.xyz, -r0.w, r0, c17.w
mul_pp r5.xyz, r0, c8.x
mov_pp r0.xyz, c15
mov_pp r1.xyz, c0
dp3_pp r2.w, v4, v4
mul_pp r0.xyz, c4, r0
max r0.w, r1, c17
mul r4.xyz, r0, r0.w
dp3_pp r0.x, r3, v4
mul_pp r0.xyz, r3, r0.x
mad_pp r1.xyz, c4, r1, v2
add_pp_sat r4.xyz, r1, r4
mad_pp r0.xyz, -r0, c16.x, v4
dp3_pp r0.w, r0, r3
texld r1.xyz, v3, s1
mad_pp r1.xyz, r1, r4, r5
mul_pp r3.xy, v3, c9.x
abs_pp_sat r0.w, r0
mul_pp r3.xy, r3, c16.w
texld r3.xyz, r3, s2
mad_pp r3.xyz, r3, c17.x, c17.yyzw
mov r4.y, r2.z
add_pp r0.w, -r0, c16.z
mov r4.x, v6.z
mov r4.z, v5
dp3_pp r2.z, r4, -r3
mov r4.y, r2
mov r4.z, v5.y
mov r4.x, v6.y
dp3_pp r2.y, -r3, r4
rsq_pp r2.w, r2.w
mov r4.y, r2.x
mov r4.z, v5.x
mov r4.x, v6
dp3_pp r2.x, -r3, r4
dp3_pp r1.w, r2, r2
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r2.w, v4
mul_pp r2.xyz, r1.w, r2
dp3_pp_sat r1.w, r2, r3
pow_pp r3, r0.w, c14.x
mul_pp r0.w, r1, r1
pow_pp r2, r0.w, c11.x
mov_pp r0.w, r3.x
mul_pp r3.x, r0.w, c13
mov_pp r0.w, r2.x
mul_pp r2, r0.w, c12
mov_pp r1.w, c16.z
mad_pp r1, r2, c10.x, r1
texld r0, r0, s3
add_pp_sat r2.x, r3, c5
mul_pp r0.xyz, r0, r2.x
add_pp r1, r0, r1
mad_pp oC0, r3.x, r0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 92 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
		{ 2, 1, 20, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R1.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R1.xyz, R1, texture[0], 2D;
DP3 R2.w, c[2], c[2];
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MAD R3.xyz, R1, c[16].x, -c[16].y;
MUL R1.xyz, R3.y, R0;
MAD R2.xyz, R3.x, fragment.texcoord[6], R1;
MAD R2.xyz, R3.z, fragment.texcoord[5], R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R1, R1;
DP3 R0.w, R2, R2;
RSQ R1.w, R1.w;
RSQ R0.w, R0.w;
MUL R1.xyz, R1.w, R1;
RSQ R2.w, R2.w;
ABS R1.w, -c[2];
CMP R1.w, -R1, c[16], c[16].y;
ABS R1.w, R1;
MUL R2.xyz, R0.w, R2;
MUL R3.xyz, R2.w, c[2];
CMP R1.w, -R1, c[16], c[16].y;
CMP R1.xyz, -R1.w, R1, R3;
DP3 R1.w, R2, R1;
SLT R0.w, R1, c[16];
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
DP3 R2.w, R2, -R1;
MUL R3.xyz, R2, R2.w;
ABS R0.w, R0;
MUL R4.xyz, R3.w, R4;
MAD R1.xyz, -R3, c[16].x, -R1;
DP3 R1.x, R1, R4;
MAX R2.w, R1.x, c[16];
MOV R1.xyz, c[6];
MUL R4.xy, fragment.texcoord[3], c[9].x;
MUL R4.xy, R4, c[16].z;
POW R2.w, R2.w, c[7].x;
MUL R1.xyz, R1, c[15];
MUL R1.xyz, R1, R2.w;
CMP R0.w, -R0, c[16], c[16].y;
CMP R3.xyz, -R0.w, R1, c[16].w;
MOV R1.y, R0.z;
MOV R0.zw, c[17].xyxy;
TEX R4.xyz, R4, texture[2], 2D;
MAD R4.xyz, R4, c[16].x, R0.zzww;
MOV R0.z, R0.x;
MOV R1.x, fragment.texcoord[6].z;
MOV R1.z, fragment.texcoord[5];
DP3 R1.z, R1, -R4;
MOV R0.w, fragment.texcoord[5].x;
MOV R0.x, fragment.texcoord[6];
DP3 R1.x, -R4, R0.xzww;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.x, fragment.texcoord[6].y;
DP3 R1.y, -R4, R0;
DP3 R0.x, R1, R1;
RSQ R0.w, R0.x;
MOV R0.xyz, c[4];
MUL R4.xyz, R0, c[15];
MAX R1.w, R1, c[16];
MUL R4.xyz, R4, R1.w;
MAD R0.xyz, R0, c[0], fragment.texcoord[2];
ADD_SAT R4.xyz, R0, R4;
MUL R3.xyz, R3, c[8].x;
TEX R0.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R4, R3;
MUL R3.xyz, R0.w, R1;
DP3 R1.x, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.x;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R1.xyz, R2, R0.w;
MAD R1.xyz, -R1, c[16].x, fragment.texcoord[4];
DP3 R0.w, R1, R2;
MUL R4.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R3, R4;
MUL R1.w, R1, R1;
POW R1.w, R1.w, c[11].x;
ABS_SAT R0.w, R0;
MUL R2, R1.w, c[12];
ADD R0.w, -R0, c[16].y;
POW R1.w, R0.w, c[14].x;
MUL R3.x, R1.w, c[13];
MOV R0.w, c[16].y;
MAD R0, R2, c[10].x, R0;
TEX R1, R1, texture[3], CUBE;
ADD_SAT R2.x, R3, c[5];
MUL R1.xyz, R1, R2.x;
ADD R0, R1, R0;
MAD result.color, R3.x, R1, R0;
END
# 92 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 95 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c16, 2.00000000, -1.00000000, 1.00000000, 20.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0.00000000
def c18, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
mov_pp r1.xyz, v6
mul_pp r2.xyz, v1.zxyw, r1.yzxw
mov_pp r1.xyz, v6
mad_pp r0.xy, v3, c3, c3.zwzw
texld r0.xyz, r0, s0
mad_pp r2.xyz, v1.yzxw, r1.zxyw, -r2
mad_pp r0.xyz, r0, c16.x, c16.y
mul_pp r1.xyz, r0.y, r2
mad_pp r1.xyz, r0.x, v6, r1
mad_pp r1.xyz, r0.z, v5, r1
dp3_pp r0.w, r1, r1
add r0.xyz, -v0, c2
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r1
dp3_pp r1.w, r0, r0
rsq_pp r1.x, r1.w
mul_pp r1.xyz, r1.x, r0
dp3_pp r0.w, c2, c2
rsq_pp r0.x, r0.w
add r4.xyz, -v0, c1
abs_pp r0.w, -c2
mul_pp r0.xyz, r0.x, c2
cmp_pp r0.xyz, -r0.w, r0, r1
dp3 r1.x, r4, r4
rsq r1.w, r1.x
dp3_pp r0.w, r3, -r0
mul_pp r1.xyz, r3, r0.w
mul r4.xyz, r1.w, r4
mad_pp r1.xyz, -r1, c16.x, -r0
dp3_pp r0.w, r1, r4
dp3 r1.w, r3, r0
max_pp r1.x, r0.w, c17.w
pow_pp r0, r1.x, c7.x
cmp r0.w, r1, c18.x, c18.y
mov_pp r2.w, r0.x
mov_pp r1.xyz, c15
mul_pp r0.xyz, c6, r1
mul_pp r0.xyz, r0, r2.w
abs_pp r0.w, r0
cmp_pp r0.xyz, -r0.w, r0, c17.w
mul_pp r5.xyz, r0, c8.x
mov_pp r0.xyz, c15
mov_pp r1.xyz, c0
dp3_pp r2.w, v4, v4
mul_pp r0.xyz, c4, r0
max r0.w, r1, c17
mul r4.xyz, r0, r0.w
dp3_pp r0.x, r3, v4
mul_pp r0.xyz, r3, r0.x
mad_pp r1.xyz, c4, r1, v2
add_pp_sat r4.xyz, r1, r4
mad_pp r0.xyz, -r0, c16.x, v4
dp3_pp r0.w, r0, r3
texld r1.xyz, v3, s1
mad_pp r1.xyz, r1, r4, r5
mul_pp r3.xy, v3, c9.x
abs_pp_sat r0.w, r0
mul_pp r3.xy, r3, c16.w
texld r3.xyz, r3, s2
mad_pp r3.xyz, r3, c17.x, c17.yyzw
mov r4.y, r2.z
add_pp r0.w, -r0, c16.z
mov r4.x, v6.z
mov r4.z, v5
dp3_pp r2.z, r4, -r3
mov r4.y, r2
mov r4.z, v5.y
mov r4.x, v6.y
dp3_pp r2.y, -r3, r4
rsq_pp r2.w, r2.w
mov r4.y, r2.x
mov r4.z, v5.x
mov r4.x, v6
dp3_pp r2.x, -r3, r4
dp3_pp r1.w, r2, r2
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r2.w, v4
mul_pp r2.xyz, r1.w, r2
dp3_pp_sat r1.w, r2, r3
pow_pp r3, r0.w, c14.x
mul_pp r0.w, r1, r1
pow_pp r2, r0.w, c11.x
mov_pp r0.w, r3.x
mul_pp r3.x, r0.w, c13
mov_pp r0.w, r2.x
mul_pp r2, r0.w, c12
mov_pp r1.w, c16.z
mad_pp r1, r2, c10.x, r1
texld r0, r0, s3
add_pp_sat r2.x, r3, c5
mul_pp r0.xyz, r0, r2.x
add_pp r1, r0, r1
mad_pp oC0, r3.x, r0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 92 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
		{ 2, 1, 20, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R1.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R1.xyz, R1, texture[0], 2D;
DP3 R2.w, c[2], c[2];
MAD R0.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R2;
MAD R3.xyz, R1, c[16].x, -c[16].y;
MUL R1.xyz, R3.y, R0;
MAD R2.xyz, R3.x, fragment.texcoord[6], R1;
MAD R2.xyz, R3.z, fragment.texcoord[5], R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R1, R1;
DP3 R0.w, R2, R2;
RSQ R1.w, R1.w;
RSQ R0.w, R0.w;
MUL R1.xyz, R1.w, R1;
RSQ R2.w, R2.w;
ABS R1.w, -c[2];
CMP R1.w, -R1, c[16], c[16].y;
ABS R1.w, R1;
MUL R2.xyz, R0.w, R2;
MUL R3.xyz, R2.w, c[2];
CMP R1.w, -R1, c[16], c[16].y;
CMP R1.xyz, -R1.w, R1, R3;
DP3 R1.w, R2, R1;
SLT R0.w, R1, c[16];
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
DP3 R2.w, R2, -R1;
MUL R3.xyz, R2, R2.w;
ABS R0.w, R0;
MUL R4.xyz, R3.w, R4;
MAD R1.xyz, -R3, c[16].x, -R1;
DP3 R1.x, R1, R4;
MAX R2.w, R1.x, c[16];
MOV R1.xyz, c[6];
MUL R4.xy, fragment.texcoord[3], c[9].x;
MUL R4.xy, R4, c[16].z;
POW R2.w, R2.w, c[7].x;
MUL R1.xyz, R1, c[15];
MUL R1.xyz, R1, R2.w;
CMP R0.w, -R0, c[16], c[16].y;
CMP R3.xyz, -R0.w, R1, c[16].w;
MOV R1.y, R0.z;
MOV R0.zw, c[17].xyxy;
TEX R4.xyz, R4, texture[2], 2D;
MAD R4.xyz, R4, c[16].x, R0.zzww;
MOV R0.z, R0.x;
MOV R1.x, fragment.texcoord[6].z;
MOV R1.z, fragment.texcoord[5];
DP3 R1.z, R1, -R4;
MOV R0.w, fragment.texcoord[5].x;
MOV R0.x, fragment.texcoord[6];
DP3 R1.x, -R4, R0.xzww;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.x, fragment.texcoord[6].y;
DP3 R1.y, -R4, R0;
DP3 R0.x, R1, R1;
RSQ R0.w, R0.x;
MOV R0.xyz, c[4];
MUL R4.xyz, R0, c[15];
MAX R1.w, R1, c[16];
MUL R4.xyz, R4, R1.w;
MAD R0.xyz, R0, c[0], fragment.texcoord[2];
ADD_SAT R4.xyz, R0, R4;
MUL R3.xyz, R3, c[8].x;
TEX R0.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R4, R3;
MUL R3.xyz, R0.w, R1;
DP3 R1.x, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.x;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R1.xyz, R2, R0.w;
MAD R1.xyz, -R1, c[16].x, fragment.texcoord[4];
DP3 R0.w, R1, R2;
MUL R4.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R3, R4;
MUL R1.w, R1, R1;
POW R1.w, R1.w, c[11].x;
ABS_SAT R0.w, R0;
MUL R2, R1.w, c[12];
ADD R0.w, -R0, c[16].y;
POW R1.w, R0.w, c[14].x;
MUL R3.x, R1.w, c[13];
MOV R0.w, c[16].y;
MAD R0, R2, c[10].x, R0;
TEX R1, R1, texture[3], CUBE;
ADD_SAT R2.x, R3, c[5];
MUL R1.xyz, R1, R2.x;
ADD R0, R1, R0;
MAD result.color, R3.x, R1, R0;
END
# 92 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 95 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c16, 2.00000000, -1.00000000, 1.00000000, 20.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0.00000000
def c18, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
mov_pp r1.xyz, v6
mul_pp r2.xyz, v1.zxyw, r1.yzxw
mov_pp r1.xyz, v6
mad_pp r0.xy, v3, c3, c3.zwzw
texld r0.xyz, r0, s0
mad_pp r2.xyz, v1.yzxw, r1.zxyw, -r2
mad_pp r0.xyz, r0, c16.x, c16.y
mul_pp r1.xyz, r0.y, r2
mad_pp r1.xyz, r0.x, v6, r1
mad_pp r1.xyz, r0.z, v5, r1
dp3_pp r0.w, r1, r1
add r0.xyz, -v0, c2
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r1
dp3_pp r1.w, r0, r0
rsq_pp r1.x, r1.w
mul_pp r1.xyz, r1.x, r0
dp3_pp r0.w, c2, c2
rsq_pp r0.x, r0.w
add r4.xyz, -v0, c1
abs_pp r0.w, -c2
mul_pp r0.xyz, r0.x, c2
cmp_pp r0.xyz, -r0.w, r0, r1
dp3 r1.x, r4, r4
rsq r1.w, r1.x
dp3_pp r0.w, r3, -r0
mul_pp r1.xyz, r3, r0.w
mul r4.xyz, r1.w, r4
mad_pp r1.xyz, -r1, c16.x, -r0
dp3_pp r0.w, r1, r4
dp3 r1.w, r3, r0
max_pp r1.x, r0.w, c17.w
pow_pp r0, r1.x, c7.x
cmp r0.w, r1, c18.x, c18.y
mov_pp r2.w, r0.x
mov_pp r1.xyz, c15
mul_pp r0.xyz, c6, r1
mul_pp r0.xyz, r0, r2.w
abs_pp r0.w, r0
cmp_pp r0.xyz, -r0.w, r0, c17.w
mul_pp r5.xyz, r0, c8.x
mov_pp r0.xyz, c15
mov_pp r1.xyz, c0
dp3_pp r2.w, v4, v4
mul_pp r0.xyz, c4, r0
max r0.w, r1, c17
mul r4.xyz, r0, r0.w
dp3_pp r0.x, r3, v4
mul_pp r0.xyz, r3, r0.x
mad_pp r1.xyz, c4, r1, v2
add_pp_sat r4.xyz, r1, r4
mad_pp r0.xyz, -r0, c16.x, v4
dp3_pp r0.w, r0, r3
texld r1.xyz, v3, s1
mad_pp r1.xyz, r1, r4, r5
mul_pp r3.xy, v3, c9.x
abs_pp_sat r0.w, r0
mul_pp r3.xy, r3, c16.w
texld r3.xyz, r3, s2
mad_pp r3.xyz, r3, c17.x, c17.yyzw
mov r4.y, r2.z
add_pp r0.w, -r0, c16.z
mov r4.x, v6.z
mov r4.z, v5
dp3_pp r2.z, r4, -r3
mov r4.y, r2
mov r4.z, v5.y
mov r4.x, v6.y
dp3_pp r2.y, -r3, r4
rsq_pp r2.w, r2.w
mov r4.y, r2.x
mov r4.z, v5.x
mov r4.x, v6
dp3_pp r2.x, -r3, r4
dp3_pp r1.w, r2, r2
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r2.w, v4
mul_pp r2.xyz, r1.w, r2
dp3_pp_sat r1.w, r2, r3
pow_pp r3, r0.w, c14.x
mul_pp r0.w, r1, r1
pow_pp r2, r0.w, c11.x
mov_pp r0.w, r3.x
mul_pp r3.x, r0.w, c13
mov_pp r0.w, r2.x
mul_pp r2, r0.w, c12
mov_pp r1.w, c16.z
mad_pp r1, r2, c10.x, r1
texld r0, r0, s3
add_pp_sat r2.x, r3, c5
mul_pp r0.xyz, r0, r2.x
add_pp r1, r0, r1
mad_pp oC0, r3.x, r0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 96 ALU, 5 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
		{ 2, 1, 20, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MOV R1.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R1.yzxw;
MAD R3.xyz, fragment.texcoord[1].yzxw, R1.zxyw, -R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R1, R1;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0.xyz, R0, texture[0], 2D;
MAD R2.xyz, R0, c[16].x, -c[16].y;
MUL R0.xyz, R2.y, R3;
MAD R0.xyz, R2.x, fragment.texcoord[6], R0;
MAD R0.xyz, R2.z, fragment.texcoord[5], R0;
DP3 R0.w, R0, R0;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R1;
ABS R1.x, -c[2].w;
CMP R1.x, -R1, c[16].w, c[16].y;
ABS R1.w, R1.x;
DP3 R1.y, c[2], c[2];
RSQ R1.y, R1.y;
MOV R5.y, R3.z;
RSQ R0.w, R0.w;
MUL R1.xyz, R1.y, c[2];
CMP R1.w, -R1, c[16], c[16].y;
CMP R4.xyz, -R1.w, R2, R1;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, R1, R4;
SLT R1.w, R0, c[16];
ADD R0.xyz, -fragment.texcoord[0], c[1];
DP3 R2.y, R0, R0;
RSQ R2.w, R2.y;
DP3 R2.x, R1, -R4;
MUL R2.xyz, R1, R2.x;
ABS R1.w, R1;
MAD R2.xyz, -R2, c[16].x, -R4;
MUL R0.xyz, R2.w, R0;
DP3 R0.x, R2, R0;
TXP R2.x, fragment.texcoord[7], texture[2], 2D;
MAX R0.x, R0, c[16].w;
MUL R2.yzw, R2.x, c[15].xxyz;
POW R3.w, R0.x, c[7].x;
MUL R0.xyz, R2.yzww, c[6];
MUL R0.xyz, R0, R3.w;
CMP R1.w, -R1, c[16], c[16].y;
CMP R4.xyz, -R1.w, R0, c[16].w;
MUL R0.xy, fragment.texcoord[3], c[9].x;
MUL R0.xy, R0, c[16].z;
MOV R3.zw, c[17].xyxy;
TEX R0.xyz, R0, texture[3], 2D;
MAD R0.xyz, R0, c[16].x, R3.zzww;
MOV R5.x, fragment.texcoord[6].z;
MOV R5.z, fragment.texcoord[5];
DP3 R3.z, R5, -R0;
MOV R5.y, R3.x;
MOV R5.z, fragment.texcoord[5].x;
MOV R5.x, fragment.texcoord[6];
DP3 R3.x, -R0, R5;
MOV R5.y, R3;
MOV R5.z, fragment.texcoord[5].y;
MOV R5.x, fragment.texcoord[6].y;
DP3 R3.y, -R0, R5;
DP3 R0.x, R3, R3;
RSQ R1.w, R0.x;
MOV R0.xyz, c[4];
MUL R5.xyz, R2.yzww, c[4];
MAX R0.w, R0, c[16];
MUL R5.xyz, R5, R0.w;
MAD R0.xyz, R0, c[0], fragment.texcoord[2];
ADD_SAT R5.xyz, R0, R5;
DP3 R0.w, R1, fragment.texcoord[4];
MUL R4.xyz, R4, c[8].x;
TEX R0.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R5, R4;
MUL R5.xyz, R1.w, R3;
MUL R3.xyz, R1, R0.w;
MAD R3.xyz, -R3, c[16].x, fragment.texcoord[4];
DP3 R0.w, R3, R1;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R4.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R5, R4;
MUL R1.x, R1.w, R1.w;
ABS_SAT R0.w, R0;
POW R1.x, R1.x, c[11].x;
ADD R0.w, -R0, c[16].y;
POW R0.w, R0.w, c[14].x;
MUL R2.y, R0.w, c[13].x;
MUL R1, R1.x, c[12];
MUL R1, R2.x, R1;
MOV R0.w, c[16].y;
MAD R1, R1, c[10].x, R0;
ADD R2.z, R2.y, c[5].x;
TEX R0, R3, texture[4], CUBE;
MUL_SAT R2.x, R2.z, R2;
MUL R0.xyz, R0, R2.x;
ADD R1, R0, R1;
MAD result.color, R2.y, R0, R1;
END
# 96 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 96 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c16, 2.00000000, -1.00000000, 1.00000000, 20.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0.00000000
def c18, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
mad_pp r0.xy, v3, c3, c3.zwzw
mov_pp r1.xyz, v6
mov_pp r5.xyz, c0
texld r0.xyz, r0, s0
mov_pp r2.xyz, v6
mul_pp r1.xyz, v1.zxyw, r1.yzxw
mad_pp r1.xyz, v1.yzxw, r2.zxyw, -r1
mad_pp r2.xyz, r0, c16.x, c16.y
mul_pp r0.xyz, r2.y, r1
mad_pp r0.xyz, r2.x, v6, r0
mad_pp r2.xyz, r2.z, v5, r0
dp3_pp r0.w, r2, r2
rsq_pp r1.w, r0.w
mul_pp r2.xyz, r1.w, r2
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r0
dp3_pp r1.w, c2, c2
rsq_pp r0.w, r1.w
mul_pp r4.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp_pp r3.xyz, -r0.w, r4, r3
dp3_pp r1.w, r2, -r3
mul_pp r4.xyz, r2, r1.w
add r0.xyz, -v0, c1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mad_pp r4.xyz, -r4, c16.x, -r3
dp3_pp r0.x, r4, r0
dp3 r0.w, r2, r3
cmp r1.w, r0, c18.x, c18.y
max_pp r0.x, r0, c17.w
pow_pp r3, r0.x, c7.x
texldp r4.x, v7, s2
mov_pp r2.w, r3.x
mul_pp r0.xyz, r4.x, c15
mul_pp r3.xyz, r0, c6
mul_pp r0.xyz, r0, c4
max r0.w, r0, c17
mul r4.yzw, r0.xxyz, r0.w
dp3_pp r0.x, r2, v4
mul_pp r0.xyz, r2, r0.x
mad_pp r5.xyz, c4, r5, v2
add_pp_sat r4.yzw, r5.xxyz, r4
mad_pp r0.xyz, -r0, c16.x, v4
dp3_pp r0.w, r0, r2
mul_pp r2.xy, v3, c9.x
abs_pp_sat r0.w, r0
mul_pp r2.xy, r2, c16.w
texld r2.xyz, r2, s3
mad_pp r2.xyz, r2, c17.x, c17.yyzw
texld r5.xyz, v3, s1
mul_pp r3.xyz, r3, r2.w
abs_pp r1.w, r1
cmp_pp r3.xyz, -r1.w, r3, c17.w
mul_pp r3.xyz, r3, c8.x
mad_pp r3.xyz, r5, r4.yzww, r3
dp3_pp r1.w, v4, v4
mov r5.y, r1.z
add_pp r0.w, -r0, c16.z
mov r5.x, v6.z
mov r5.z, v5
dp3_pp r1.z, r5, -r2
mov r5.y, r1
mov r5.z, v5.y
mov r5.x, v6.y
dp3_pp r1.y, -r2, r5
rsq_pp r1.w, r1.w
mov r5.y, r1.x
mov r5.z, v5.x
mov r5.x, v6
dp3_pp r1.x, -r2, r5
dp3_pp r2.x, r1, r1
rsq_pp r2.w, r2.x
mul_pp r2.xyz, r1.w, v4
mul_pp r1.xyz, r2.w, r1
dp3_pp_sat r2.x, r1, r2
pow_pp r1, r0.w, c14.x
mul_pp r0.w, r2.x, r2.x
pow_pp r2, r0.w, c11.x
mov_pp r0.w, r1.x
mul_pp r2.y, r0.w, c13.x
mov_pp r1.x, r2
add_pp r0.w, r2.y, c5.x
mul_pp_sat r2.x, r0.w, r4
texld r0, r0, s4
mul_pp r1, r1.x, c12
mul_pp r0.xyz, r0, r2.x
mov_pp r3.w, c16.z
mul_pp r1, r4.x, r1
mad_pp r1, r1, c10.x, r3
add_pp r1, r0, r1
mad_pp oC0, r2.y, r0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 96 ALU, 5 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
		{ 2, 1, 20, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MOV R1.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R1.yzxw;
MAD R3.xyz, fragment.texcoord[1].yzxw, R1.zxyw, -R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R1, R1;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0.xyz, R0, texture[0], 2D;
MAD R2.xyz, R0, c[16].x, -c[16].y;
MUL R0.xyz, R2.y, R3;
MAD R0.xyz, R2.x, fragment.texcoord[6], R0;
MAD R0.xyz, R2.z, fragment.texcoord[5], R0;
DP3 R0.w, R0, R0;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R1;
ABS R1.x, -c[2].w;
CMP R1.x, -R1, c[16].w, c[16].y;
ABS R1.w, R1.x;
DP3 R1.y, c[2], c[2];
RSQ R1.y, R1.y;
MOV R5.y, R3.z;
RSQ R0.w, R0.w;
MUL R1.xyz, R1.y, c[2];
CMP R1.w, -R1, c[16], c[16].y;
CMP R4.xyz, -R1.w, R2, R1;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, R1, R4;
SLT R1.w, R0, c[16];
ADD R0.xyz, -fragment.texcoord[0], c[1];
DP3 R2.y, R0, R0;
RSQ R2.w, R2.y;
DP3 R2.x, R1, -R4;
MUL R2.xyz, R1, R2.x;
ABS R1.w, R1;
MAD R2.xyz, -R2, c[16].x, -R4;
MUL R0.xyz, R2.w, R0;
DP3 R0.x, R2, R0;
TXP R2.x, fragment.texcoord[7], texture[2], 2D;
MAX R0.x, R0, c[16].w;
MUL R2.yzw, R2.x, c[15].xxyz;
POW R3.w, R0.x, c[7].x;
MUL R0.xyz, R2.yzww, c[6];
MUL R0.xyz, R0, R3.w;
CMP R1.w, -R1, c[16], c[16].y;
CMP R4.xyz, -R1.w, R0, c[16].w;
MUL R0.xy, fragment.texcoord[3], c[9].x;
MUL R0.xy, R0, c[16].z;
MOV R3.zw, c[17].xyxy;
TEX R0.xyz, R0, texture[3], 2D;
MAD R0.xyz, R0, c[16].x, R3.zzww;
MOV R5.x, fragment.texcoord[6].z;
MOV R5.z, fragment.texcoord[5];
DP3 R3.z, R5, -R0;
MOV R5.y, R3.x;
MOV R5.z, fragment.texcoord[5].x;
MOV R5.x, fragment.texcoord[6];
DP3 R3.x, -R0, R5;
MOV R5.y, R3;
MOV R5.z, fragment.texcoord[5].y;
MOV R5.x, fragment.texcoord[6].y;
DP3 R3.y, -R0, R5;
DP3 R0.x, R3, R3;
RSQ R1.w, R0.x;
MOV R0.xyz, c[4];
MUL R5.xyz, R2.yzww, c[4];
MAX R0.w, R0, c[16];
MUL R5.xyz, R5, R0.w;
MAD R0.xyz, R0, c[0], fragment.texcoord[2];
ADD_SAT R5.xyz, R0, R5;
DP3 R0.w, R1, fragment.texcoord[4];
MUL R4.xyz, R4, c[8].x;
TEX R0.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R5, R4;
MUL R5.xyz, R1.w, R3;
MUL R3.xyz, R1, R0.w;
MAD R3.xyz, -R3, c[16].x, fragment.texcoord[4];
DP3 R0.w, R3, R1;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R4.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R5, R4;
MUL R1.x, R1.w, R1.w;
ABS_SAT R0.w, R0;
POW R1.x, R1.x, c[11].x;
ADD R0.w, -R0, c[16].y;
POW R0.w, R0.w, c[14].x;
MUL R2.y, R0.w, c[13].x;
MUL R1, R1.x, c[12];
MUL R1, R2.x, R1;
MOV R0.w, c[16].y;
MAD R1, R1, c[10].x, R0;
ADD R2.z, R2.y, c[5].x;
TEX R0, R3, texture[4], CUBE;
MUL_SAT R2.x, R2.z, R2;
MUL R0.xyz, R0, R2.x;
ADD R1, R0, R1;
MAD result.color, R2.y, R0, R1;
END
# 96 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 96 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c16, 2.00000000, -1.00000000, 1.00000000, 20.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0.00000000
def c18, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
mad_pp r0.xy, v3, c3, c3.zwzw
mov_pp r1.xyz, v6
mov_pp r5.xyz, c0
texld r0.xyz, r0, s0
mov_pp r2.xyz, v6
mul_pp r1.xyz, v1.zxyw, r1.yzxw
mad_pp r1.xyz, v1.yzxw, r2.zxyw, -r1
mad_pp r2.xyz, r0, c16.x, c16.y
mul_pp r0.xyz, r2.y, r1
mad_pp r0.xyz, r2.x, v6, r0
mad_pp r2.xyz, r2.z, v5, r0
dp3_pp r0.w, r2, r2
rsq_pp r1.w, r0.w
mul_pp r2.xyz, r1.w, r2
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r0
dp3_pp r1.w, c2, c2
rsq_pp r0.w, r1.w
mul_pp r4.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp_pp r3.xyz, -r0.w, r4, r3
dp3_pp r1.w, r2, -r3
mul_pp r4.xyz, r2, r1.w
add r0.xyz, -v0, c1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mad_pp r4.xyz, -r4, c16.x, -r3
dp3_pp r0.x, r4, r0
dp3 r0.w, r2, r3
cmp r1.w, r0, c18.x, c18.y
max_pp r0.x, r0, c17.w
pow_pp r3, r0.x, c7.x
texldp r4.x, v7, s2
mov_pp r2.w, r3.x
mul_pp r0.xyz, r4.x, c15
mul_pp r3.xyz, r0, c6
mul_pp r0.xyz, r0, c4
max r0.w, r0, c17
mul r4.yzw, r0.xxyz, r0.w
dp3_pp r0.x, r2, v4
mul_pp r0.xyz, r2, r0.x
mad_pp r5.xyz, c4, r5, v2
add_pp_sat r4.yzw, r5.xxyz, r4
mad_pp r0.xyz, -r0, c16.x, v4
dp3_pp r0.w, r0, r2
mul_pp r2.xy, v3, c9.x
abs_pp_sat r0.w, r0
mul_pp r2.xy, r2, c16.w
texld r2.xyz, r2, s3
mad_pp r2.xyz, r2, c17.x, c17.yyzw
texld r5.xyz, v3, s1
mul_pp r3.xyz, r3, r2.w
abs_pp r1.w, r1
cmp_pp r3.xyz, -r1.w, r3, c17.w
mul_pp r3.xyz, r3, c8.x
mad_pp r3.xyz, r5, r4.yzww, r3
dp3_pp r1.w, v4, v4
mov r5.y, r1.z
add_pp r0.w, -r0, c16.z
mov r5.x, v6.z
mov r5.z, v5
dp3_pp r1.z, r5, -r2
mov r5.y, r1
mov r5.z, v5.y
mov r5.x, v6.y
dp3_pp r1.y, -r2, r5
rsq_pp r1.w, r1.w
mov r5.y, r1.x
mov r5.z, v5.x
mov r5.x, v6
dp3_pp r1.x, -r2, r5
dp3_pp r2.x, r1, r1
rsq_pp r2.w, r2.x
mul_pp r2.xyz, r1.w, v4
mul_pp r1.xyz, r2.w, r1
dp3_pp_sat r2.x, r1, r2
pow_pp r1, r0.w, c14.x
mul_pp r0.w, r2.x, r2.x
pow_pp r2, r0.w, c11.x
mov_pp r0.w, r1.x
mul_pp r2.y, r0.w, c13.x
mov_pp r1.x, r2
add_pp r0.w, r2.y, c5.x
mul_pp_sat r2.x, r0.w, r4
texld r0, r0, s4
mul_pp r1, r1.x, c12
mul_pp r0.xyz, r0, r2.x
mov_pp r3.w, c16.z
mul_pp r1, r4.x, r1
mad_pp r1, r1, c10.x, r3
add_pp r1, r0, r1
mad_pp oC0, r2.y, r0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 96 ALU, 5 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
		{ 2, 1, 20, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MOV R1.xyz, fragment.texcoord[6];
MUL R2.xyz, fragment.texcoord[1].zxyw, R1.yzxw;
MAD R3.xyz, fragment.texcoord[1].yzxw, R1.zxyw, -R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R1, R1;
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R0.xyz, R0, texture[0], 2D;
MAD R2.xyz, R0, c[16].x, -c[16].y;
MUL R0.xyz, R2.y, R3;
MAD R0.xyz, R2.x, fragment.texcoord[6], R0;
MAD R0.xyz, R2.z, fragment.texcoord[5], R0;
DP3 R0.w, R0, R0;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R1;
ABS R1.x, -c[2].w;
CMP R1.x, -R1, c[16].w, c[16].y;
ABS R1.w, R1.x;
DP3 R1.y, c[2], c[2];
RSQ R1.y, R1.y;
MOV R5.y, R3.z;
RSQ R0.w, R0.w;
MUL R1.xyz, R1.y, c[2];
CMP R1.w, -R1, c[16], c[16].y;
CMP R4.xyz, -R1.w, R2, R1;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, R1, R4;
SLT R1.w, R0, c[16];
ADD R0.xyz, -fragment.texcoord[0], c[1];
DP3 R2.y, R0, R0;
RSQ R2.w, R2.y;
DP3 R2.x, R1, -R4;
MUL R2.xyz, R1, R2.x;
ABS R1.w, R1;
MAD R2.xyz, -R2, c[16].x, -R4;
MUL R0.xyz, R2.w, R0;
DP3 R0.x, R2, R0;
TXP R2.x, fragment.texcoord[7], texture[2], 2D;
MAX R0.x, R0, c[16].w;
MUL R2.yzw, R2.x, c[15].xxyz;
POW R3.w, R0.x, c[7].x;
MUL R0.xyz, R2.yzww, c[6];
MUL R0.xyz, R0, R3.w;
CMP R1.w, -R1, c[16], c[16].y;
CMP R4.xyz, -R1.w, R0, c[16].w;
MUL R0.xy, fragment.texcoord[3], c[9].x;
MUL R0.xy, R0, c[16].z;
MOV R3.zw, c[17].xyxy;
TEX R0.xyz, R0, texture[3], 2D;
MAD R0.xyz, R0, c[16].x, R3.zzww;
MOV R5.x, fragment.texcoord[6].z;
MOV R5.z, fragment.texcoord[5];
DP3 R3.z, R5, -R0;
MOV R5.y, R3.x;
MOV R5.z, fragment.texcoord[5].x;
MOV R5.x, fragment.texcoord[6];
DP3 R3.x, -R0, R5;
MOV R5.y, R3;
MOV R5.z, fragment.texcoord[5].y;
MOV R5.x, fragment.texcoord[6].y;
DP3 R3.y, -R0, R5;
DP3 R0.x, R3, R3;
RSQ R1.w, R0.x;
MOV R0.xyz, c[4];
MUL R5.xyz, R2.yzww, c[4];
MAX R0.w, R0, c[16];
MUL R5.xyz, R5, R0.w;
MAD R0.xyz, R0, c[0], fragment.texcoord[2];
ADD_SAT R5.xyz, R0, R5;
DP3 R0.w, R1, fragment.texcoord[4];
MUL R4.xyz, R4, c[8].x;
TEX R0.xyz, fragment.texcoord[3], texture[1], 2D;
MAD R0.xyz, R0, R5, R4;
MUL R5.xyz, R1.w, R3;
MUL R3.xyz, R1, R0.w;
MAD R3.xyz, -R3, c[16].x, fragment.texcoord[4];
DP3 R0.w, R3, R1;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R4.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R5, R4;
MUL R1.x, R1.w, R1.w;
ABS_SAT R0.w, R0;
POW R1.x, R1.x, c[11].x;
ADD R0.w, -R0, c[16].y;
POW R0.w, R0.w, c[14].x;
MUL R2.y, R0.w, c[13].x;
MUL R1, R1.x, c[12];
MUL R1, R2.x, R1;
MOV R0.w, c[16].y;
MAD R1, R1, c[10].x, R0;
ADD R2.z, R2.y, c[5].x;
TEX R0, R3, texture[4], CUBE;
MUL_SAT R2.x, R2.z, R2;
MUL R0.xyz, R0, R2.x;
ADD R1, R0, R1;
MAD result.color, R2.y, R0, R1;
END
# 96 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 96 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c16, 2.00000000, -1.00000000, 1.00000000, 20.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0.00000000
def c18, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
mad_pp r0.xy, v3, c3, c3.zwzw
mov_pp r1.xyz, v6
mov_pp r5.xyz, c0
texld r0.xyz, r0, s0
mov_pp r2.xyz, v6
mul_pp r1.xyz, v1.zxyw, r1.yzxw
mad_pp r1.xyz, v1.yzxw, r2.zxyw, -r1
mad_pp r2.xyz, r0, c16.x, c16.y
mul_pp r0.xyz, r2.y, r1
mad_pp r0.xyz, r2.x, v6, r0
mad_pp r2.xyz, r2.z, v5, r0
dp3_pp r0.w, r2, r2
rsq_pp r1.w, r0.w
mul_pp r2.xyz, r1.w, r2
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r0
dp3_pp r1.w, c2, c2
rsq_pp r0.w, r1.w
mul_pp r4.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp_pp r3.xyz, -r0.w, r4, r3
dp3_pp r1.w, r2, -r3
mul_pp r4.xyz, r2, r1.w
add r0.xyz, -v0, c1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mad_pp r4.xyz, -r4, c16.x, -r3
dp3_pp r0.x, r4, r0
dp3 r0.w, r2, r3
cmp r1.w, r0, c18.x, c18.y
max_pp r0.x, r0, c17.w
pow_pp r3, r0.x, c7.x
texldp r4.x, v7, s2
mov_pp r2.w, r3.x
mul_pp r0.xyz, r4.x, c15
mul_pp r3.xyz, r0, c6
mul_pp r0.xyz, r0, c4
max r0.w, r0, c17
mul r4.yzw, r0.xxyz, r0.w
dp3_pp r0.x, r2, v4
mul_pp r0.xyz, r2, r0.x
mad_pp r5.xyz, c4, r5, v2
add_pp_sat r4.yzw, r5.xxyz, r4
mad_pp r0.xyz, -r0, c16.x, v4
dp3_pp r0.w, r0, r2
mul_pp r2.xy, v3, c9.x
abs_pp_sat r0.w, r0
mul_pp r2.xy, r2, c16.w
texld r2.xyz, r2, s3
mad_pp r2.xyz, r2, c17.x, c17.yyzw
texld r5.xyz, v3, s1
mul_pp r3.xyz, r3, r2.w
abs_pp r1.w, r1
cmp_pp r3.xyz, -r1.w, r3, c17.w
mul_pp r3.xyz, r3, c8.x
mad_pp r3.xyz, r5, r4.yzww, r3
dp3_pp r1.w, v4, v4
mov r5.y, r1.z
add_pp r0.w, -r0, c16.z
mov r5.x, v6.z
mov r5.z, v5
dp3_pp r1.z, r5, -r2
mov r5.y, r1
mov r5.z, v5.y
mov r5.x, v6.y
dp3_pp r1.y, -r2, r5
rsq_pp r1.w, r1.w
mov r5.y, r1.x
mov r5.z, v5.x
mov r5.x, v6
dp3_pp r1.x, -r2, r5
dp3_pp r2.x, r1, r1
rsq_pp r2.w, r2.x
mul_pp r2.xyz, r1.w, v4
mul_pp r1.xyz, r2.w, r1
dp3_pp_sat r2.x, r1, r2
pow_pp r1, r0.w, c14.x
mul_pp r0.w, r2.x, r2.x
pow_pp r2, r0.w, c11.x
mov_pp r0.w, r1.x
mul_pp r2.y, r0.w, c13.x
mov_pp r1.x, r2
add_pp r0.w, r2.y, c5.x
mul_pp_sat r2.x, r0.w, r4
texld r0, r0, s4
mul_pp r1, r1.x, c12
mul_pp r0.xyz, r0, r2.x
mov_pp r3.w, c16.z
mul_pp r1, r4.x, r1
mad_pp r1, r1, c10.x, r3
add_pp r1, r0, r1
mad_pp oC0, r2.y, r0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

}

#LINE 295

      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Mobile/Diffuse"
}