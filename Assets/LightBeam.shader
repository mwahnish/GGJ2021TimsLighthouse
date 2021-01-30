// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LightBeam"
{
	Properties
	{
		_Transparency("Transparency", Float) = 0
		_Color("Color", Color) = (0,0,0,0)
		_FalloffStrength("Falloff Strength", Float) = 1
		_Sparklies("Sparklies", Range( 0 , 1)) = 1
		_Dust("Dust", Range( 0 , 1)) = 1
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 transform25 = mul(unity_ObjectToWorld,float4( float3(0,0,0) , 0.0 ));
			float4 temp_output_17_0 = ( float4( ase_worldPos , 0.0 ) - transform25 );
			float4 normalizeResult23 = normalize( temp_output_17_0 );
			float dotResult18 = dot( normalizeResult23 , float4( float3(1,0,0) , 0.0 ) );
			float temp_output_65_0 = ( dotResult18 + ( _Time.y * 0.01 ) );
			float temp_output_50_0 = ( 40.0 - length( temp_output_17_0 ) );
			float clampResult51 = clamp( ( ( ( sin( ( ( temp_output_65_0 * 10.0 ) + ( _Time.y * 0.1 ) ) ) * 20.0 ) + temp_output_50_0 ) + ( ( sin( ( temp_output_65_0 * 20.0 ) ) * 30.0 ) + temp_output_50_0 ) ) , 0.0 , 1.0 );
			clip( ( ( ( ( sin( ( temp_output_65_0 * 200.0 ) ) + 1.0 ) / 2.0 ) * ( ( sin( ( temp_output_65_0 * 73.0 ) ) + 1.0 ) / 2.0 ) ) + clampResult51 ) - 0.005);
			float4 temp_output_43_0 = _Color;
			o.Albedo = temp_output_43_0.rgb;
			o.Emission = temp_output_43_0.rgb;
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
			float clampResult112 = clamp( ( ( ( clampResult110 * _Sparklies ) + 0.0 + ( _Transparency * clampResult10 ) ) * (( 1.0 - _Dust ) + (clampResult118 - 0.0) * (1.0 - ( 1.0 - _Dust )) / (1.0 - 0.0)) ) , 0.0 , 1.0 );
			o.Alpha = clampResult112;
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
-1920;0;1920;1019;849.646;507.4441;1.3;True;True
Node;AmplifyShaderEditor.Vector3Node;24;-2462.458,-1047.561;Inherit;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;25;-2248.724,-1001.243;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;15;-2316.663,-1231.283;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;-1915.238,-1010.688;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;23;-1327.862,-1252.135;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;66;-1219.61,-813.746;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;13;-1571.4,-1030.122;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;1,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;18;-1230,-1101.321;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;104;-24.21267,-219.6444;Inherit;False;1;0;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;74;-62.38415,-133.6492;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1013.61,-822.746;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;156.4865,-197.5444;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;69;-410.1627,-775.9224;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-418.9507,-1137.024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-216.6649,-704.8041;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-236.0877,-904.8321;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;5;237.5798,1059.744;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;4;203.5798,878.744;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;101;217.7935,-82.75223;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;98;376.7859,-39.93684;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;121;-78.78919,157.7209;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;6;465.5797,959.744;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-50.75305,-774.842;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;120;-116.9606,243.7162;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-415.2215,-605.4174;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;439.5797,1145.744;Inherit;False;Property;_FalloffStrength;Falloff Strength;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-26.98986,-1196.292;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;73;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-604.0783,-547.8799;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;40;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;54;-269.8329,-511.8507;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-302.3668,-1456.075;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;200;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;52;-1287.481,-668.6528;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;59;101.288,-843.5814;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;102;574.925,-44.04717;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;7;677.5798,971.744;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;122;113.61,168.1209;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;236.4668,-842.0079;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;103;780.9581,-87.31184;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;123;163.2169,294.6131;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-127.3229,-534.8818;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;30;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;30;-11.74816,-1329.555;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;50;-467.2985,-386.975;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;33;-74.62607,-1009.415;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;815.5793,894.744;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;55.37394,-978.4153;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;124;322.2094,337.4285;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;71.32701,-385.1746;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;638.6072,615.626;Inherit;False;Property;_Dust;Dust;4;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;364.5797,755.7441;Inherit;False;Property;_Transparency;Transparency;0;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;112.668,-559.5737;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;10;973.5804,934.744;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;552.7839,182.3607;Inherit;False;Property;_Sparklies;Sparklies;3;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;118.2518,-1298.555;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;110;907.3881,28.05626;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;128;766.2543,515.6562;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;35;264.374,-1069.415;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;32;272.2519,-1313.555;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;118;852.8115,405.4216;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;927.7841,183.3607;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;1128.58,845.744;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;231.7783,-491.7757;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;51;347.2473,-375.329;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;499.8833,-1093.726;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;127;1043.154,418.1559;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;1165.346,227.1365;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;567.5005,-630.0799;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;680.4734,-776.7391;Inherit;False;Property;_Color;Color;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;1349.954,353.1559;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;116;726.3817,290.0535;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;43;883.3283,-548.1987;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.005;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;100;1544.096,681.9799;Inherit;False;Constant;_Skip;Skip;3;0;Create;True;0;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;112;1579.746,207.3365;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1825.256,-192.0111;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;LightBeam;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;24;0
WireConnection;17;0;15;0
WireConnection;17;1;25;0
WireConnection;23;0;17;0
WireConnection;18;0;23;0
WireConnection;18;1;13;0
WireConnection;67;0;66;0
WireConnection;105;0;74;1
WireConnection;105;1;104;0
WireConnection;65;0;18;0
WireConnection;65;1;67;0
WireConnection;71;0;69;0
WireConnection;58;0;65;0
WireConnection;101;0;105;0
WireConnection;101;1;74;3
WireConnection;98;0;101;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;70;0;58;0
WireConnection;70;1;71;0
WireConnection;55;0;65;0
WireConnection;36;0;65;0
WireConnection;54;0;55;0
WireConnection;29;0;65;0
WireConnection;52;0;17;0
WireConnection;59;0;70;0
WireConnection;102;0;98;0
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;122;0;120;1
WireConnection;122;1;121;0
WireConnection;60;0;59;0
WireConnection;103;1;102;0
WireConnection;123;0;122;0
WireConnection;123;1;120;3
WireConnection;57;0;54;0
WireConnection;30;0;29;0
WireConnection;50;0;53;0
WireConnection;50;1;52;0
WireConnection;33;0;36;0
WireConnection;9;1;7;0
WireConnection;34;0;33;0
WireConnection;124;0;123;0
WireConnection;56;0;57;0
WireConnection;56;1;50;0
WireConnection;61;0;60;0
WireConnection;61;1;50;0
WireConnection;10;0;9;0
WireConnection;31;0;30;0
WireConnection;110;0;103;0
WireConnection;128;1;117;0
WireConnection;35;0;34;0
WireConnection;32;0;31;0
WireConnection;118;0;124;0
WireConnection;113;0;110;0
WireConnection;113;1;114;0
WireConnection;11;0;3;0
WireConnection;11;1;10;0
WireConnection;63;0;61;0
WireConnection;63;1;56;0
WireConnection;51;0;63;0
WireConnection;37;0;32;0
WireConnection;37;1;35;0
WireConnection;127;0;118;0
WireConnection;127;3;128;0
WireConnection;111;0;113;0
WireConnection;111;2;11;0
WireConnection;64;0;37;0
WireConnection;64;1;51;0
WireConnection;126;0;111;0
WireConnection;126;1;127;0
WireConnection;43;0;1;0
WireConnection;43;1;64;0
WireConnection;112;0;126;0
WireConnection;0;0;43;0
WireConnection;0;2;43;0
WireConnection;0;9;112;0
ASEEND*/
//CHKSM=145ABDEB81673BE337AC6C895B9E35CFCDEE9516