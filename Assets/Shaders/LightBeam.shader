// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LightBeam"
{
	Properties
	{
		_Transparency("Transparency", Float) = 0
		_FalloffStrength("Falloff Strength", Float) = 1
		_Sparklies("Sparklies", Range( 0 , 1)) = 1
		_Dust("Dust", Range( 0 , 1)) = 1
		_Color("Color", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
		};

		uniform float4 _Color;
		uniform float _Sparklies;
		uniform float _Transparency;
		uniform float _FalloffStrength;
		uniform float _Dust;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_output_147_0 = _Color;
			o.Albedo = temp_output_147_0.rgb;
			o.Emission = temp_output_147_0.rgb;
			float3 ase_worldPos = i.worldPos;
			float mulTime104 = _Time.y * 0.7;
			float2 appendResult101 = (float2(( ase_worldPos.x + mulTime104 ) , ase_worldPos.z));
			float simplePerlin3D98 = snoise( float3( appendResult101 ,  0.0 )*2.0 );
			simplePerlin3D98 = simplePerlin3D98*0.5 + 0.5;
			float clampResult110 = clamp( ( 1.0 - (0.0 + (simplePerlin3D98 - 0.0) * (1.0 - 0.0) / (0.1 - 0.0)) ) , 0.0 , 1.0 );
			float3 objToWorld4 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float clampResult10 = clamp( ( 1.0 - ( distance( objToWorld4 , ase_worldPos ) / _FalloffStrength ) ) , 0.0 , 1.0 );
			float mulTime121 = _Time.y * 0.5;
			float2 appendResult123 = (float2(( ase_worldPos.x + mulTime121 ) , ase_worldPos.z));
			float simplePerlin3D124 = snoise( float3( appendResult123 ,  0.0 )*5.0 );
			simplePerlin3D124 = simplePerlin3D124*0.5 + 0.5;
			float clampResult118 = clamp( simplePerlin3D124 , 0.0 , 1.0 );
			float clampResult112 = clamp( ( ( ( clampResult110 * _Sparklies ) + ( _Transparency * clampResult10 ) ) * (( 1.0 - _Dust ) + (clampResult118 - 0.0) * (1.0 - ( 1.0 - _Dust )) / (1.0 - 0.0)) ) , 0.0 , 1.0 );
			float mulTime199 = _Time.y * 0.001;
			float3 objToWorld188 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float smoothstepResult187 = smoothstep( -0.01 , 0.01 , ( ase_worldPos - objToWorld188 ).z);
			float3 objToWorld173 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float3 normalizeResult23 = normalize( ( ase_worldPos - objToWorld173 ) );
			float dotResult18 = dot( normalizeResult23 , float3(1,0,0) );
			float temp_output_195_0 = (0.0 + (( ( smoothstepResult187 * 2.0 ) + ( ( (-1.0 + (smoothstepResult187 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * dotResult18 ) + 1.0 ) ) - 0.0) * (1.0 - 0.0) / (4.0 - 0.0));
			float2 appendResult131 = (float2(( mulTime199 + temp_output_195_0 ) , 0.0));
			float simplePerlin2D129 = snoise( appendResult131*100.0 );
			simplePerlin2D129 = simplePerlin2D129*0.5 + 0.5;
			float smoothstepResult139 = smoothstep( ( 0.12 - 0.001 ) , ( 0.12 + 0.001 ) , simplePerlin2D129);
			float clampResult145 = clamp( ( 1.0 - smoothstepResult139 ) , 0.0 , 1.0 );
			float2 appendResult154 = (float2(temp_output_195_0 , 0.0));
			float simplePerlin2D153 = snoise( appendResult154*10.0 );
			simplePerlin2D153 = simplePerlin2D153*0.5 + 0.5;
			float temp_output_163_0 = (20.0 + (simplePerlin2D153 - 0.0) * (60.0 - 20.0) / (1.0 - 0.0));
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float smoothstepResult159 = smoothstep( ( temp_output_163_0 - 0.01 ) , ( temp_output_163_0 + 0.01 ) , length( ( ase_vertex3Pos * ase_objectScale ) ));
			float clampResult169 = clamp( ( clampResult145 - ( 1.0 - smoothstepResult159 ) ) , 0.0 , 1.0 );
			float clampResult203 = clamp( ( clampResult112 - clampResult169 ) , 0.0 , 1.0 );
			o.Alpha = clampResult203;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
-1920;0;1920;1019;-147.5936;1073.999;1.6;True;True
Node;AmplifyShaderEditor.TransformPositionNode;188;-1351.166,-1782.917;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;189;-1262.766,-2028.617;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;190;-1088.566,-1814.117;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformPositionNode;173;-1374.958,-1351.583;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;172;-1286.558,-1597.283;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;191;-927.3662,-1759.518;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleSubtractOpNode;174;-1112.358,-1382.783;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;23;-944.9713,-1377.735;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;187;-652.5517,-1642.602;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.01;False;2;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;13;-913.1711,-1221.838;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;18;-697.0381,-1302.118;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;197;-508.4031,-1509.988;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;-391.9146,-1311.427;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;104;-24.21267,-219.6444;Inherit;False;1;0;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;192;-245.4644,-1334.42;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;74;-62.38415,-133.6492;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;-302.6934,-1625.983;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;194;-163.6883,-1499.147;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;156.4865,-197.5444;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;101;217.7935,-82.75223;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TransformPositionNode;4;203.5798,878.744;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;199;568.9277,-1550.856;Inherit;False;1;0;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;195;-7.0828,-1495.707;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;4;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;5;237.5798,1059.744;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;154;569.7361,-632.6813;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;200;593.6096,-1408.46;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;120;-116.9606,243.7162;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;121;-78.78919,157.7209;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;6;465.5797,959.744;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;439.5797,1145.744;Inherit;False;Property;_FalloffStrength;Falloff Strength;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;98;376.7859,-39.93684;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;7;677.5798,971.744;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectScaleNode;164;812.4601,-593.0729;Inherit;False;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NoiseGeneratorNode;153;640.6628,-472.4866;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;131;874.7566,-1276.396;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;140;325.2307,-879.129;Inherit;False;Constant;_Cutoff;Cutoff;4;0;Create;True;0;0;0;False;0;False;0.12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;102;574.925,-44.04717;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;344.3134,-781.8284;Inherit;False;Constant;_Threshold;Threshold;4;0;Create;True;0;0;0;False;0;False;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;122;113.61,168.1209;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;161;817.9506,-750.9198;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;815.5793,894.744;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;129;1019.802,-1134.046;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;103;780.9581,-87.31184;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;123;163.2169,294.6131;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;141;569.7921,-824.1837;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;163;834.4205,-409.1482;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;20;False;4;FLOAT;60;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;995.0115,-610.9165;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;155;815.2626,-204.3131;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;142;1042.853,-999.9166;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;364.5797,755.7441;Inherit;False;Property;_Transparency;Transparency;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;157;1048.343,-351.3105;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;124;322.2094,337.4285;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;110;907.3881,28.05626;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;139;1283.281,-1065.942;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;10;973.5804,934.744;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;158;1040.741,-246.6684;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;162;1129.524,-579.3479;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;552.7839,182.3607;Inherit;False;Property;_Sparklies;Sparklies;2;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;638.6072,615.626;Inherit;False;Property;_Dust;Dust;3;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;144;1525.782,-1096.856;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;159;1270.926,-362.4318;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;927.7841,183.3607;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;1128.58,845.744;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;118;852.8115,405.4216;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;128;766.2543,515.6562;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;167;1549.493,-378.1546;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;127;1043.154,418.1559;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;1486.946,185.5364;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;145;1733.16,-1001.572;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;168;1748.672,-437.6174;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;1671.554,311.5558;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;169;1887.334,-353.1197;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;112;1813.346,76.1364;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;202;2065.993,77.99951;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;150;94.85612,-563.8967;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;151;-378.23,-602.326;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;148;-118.5879,-562.9241;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;149;-142.013,-450.6614;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;116;726.3817,290.0535;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;152;349.949,-530.9465;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;201;2075.371,-563.9164;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;147;2087.333,-437.6591;Inherit;False;Property;_Color;Color;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;203;2320.394,44.40073;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2503.88,-268.6873;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;LightBeam;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;190;0;189;0
WireConnection;190;1;188;0
WireConnection;191;0;190;0
WireConnection;174;0;172;0
WireConnection;174;1;173;0
WireConnection;23;0;174;0
WireConnection;187;0;191;2
WireConnection;18;0;23;0
WireConnection;18;1;13;0
WireConnection;197;0;187;0
WireConnection;198;0;197;0
WireConnection;198;1;18;0
WireConnection;192;0;198;0
WireConnection;193;0;187;0
WireConnection;194;0;193;0
WireConnection;194;1;192;0
WireConnection;105;0;74;1
WireConnection;105;1;104;0
WireConnection;101;0;105;0
WireConnection;101;1;74;3
WireConnection;195;0;194;0
WireConnection;154;0;195;0
WireConnection;200;0;199;0
WireConnection;200;1;195;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;98;0;101;0
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;153;0;154;0
WireConnection;131;0;200;0
WireConnection;102;0;98;0
WireConnection;122;0;120;1
WireConnection;122;1;121;0
WireConnection;9;1;7;0
WireConnection;129;0;131;0
WireConnection;103;1;102;0
WireConnection;123;0;122;0
WireConnection;123;1;120;3
WireConnection;141;0;140;0
WireConnection;141;1;143;0
WireConnection;163;0;153;0
WireConnection;166;0;161;0
WireConnection;166;1;164;0
WireConnection;142;0;140;0
WireConnection;142;1;143;0
WireConnection;157;0;163;0
WireConnection;157;1;155;0
WireConnection;124;0;123;0
WireConnection;110;0;103;0
WireConnection;139;0;129;0
WireConnection;139;1;142;0
WireConnection;139;2;141;0
WireConnection;10;0;9;0
WireConnection;158;0;163;0
WireConnection;158;1;155;0
WireConnection;162;0;166;0
WireConnection;144;1;139;0
WireConnection;159;0;162;0
WireConnection;159;1;157;0
WireConnection;159;2;158;0
WireConnection;113;0;110;0
WireConnection;113;1;114;0
WireConnection;11;0;3;0
WireConnection;11;1;10;0
WireConnection;118;0;124;0
WireConnection;128;1;117;0
WireConnection;167;1;159;0
WireConnection;127;0;118;0
WireConnection;127;3;128;0
WireConnection;111;0;113;0
WireConnection;111;1;11;0
WireConnection;145;0;144;0
WireConnection;168;0;145;0
WireConnection;168;1;167;0
WireConnection;126;0;111;0
WireConnection;126;1;127;0
WireConnection;169;0;168;0
WireConnection;112;0;126;0
WireConnection;202;0;112;0
WireConnection;202;1;169;0
WireConnection;150;0;148;0
WireConnection;150;1;149;0
WireConnection;148;0;151;0
WireConnection;152;0;150;0
WireConnection;203;0;202;0
WireConnection;0;0;147;0
WireConnection;0;2;147;0
WireConnection;0;9;203;0
ASEEND*/
//CHKSM=CB09CDA5A5ED0B08A4A8C68800B4325C4D26DFC7