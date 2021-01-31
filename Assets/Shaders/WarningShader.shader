// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WarningShader"
{
	Properties
	{
		_DotsRadius("Dots Radius", Float) = 10
		_InnerBandRadius("Inner Band Radius", Float) = 5
		_OuterBandRadius("Outer Band Radius", Float) = 6
		_BandOpacity("Band Opacity", Range( 0 , 1)) = 1
		_Color("Color", Color) = (0,0,0,0)
		_DotsTransparency("Dots Transparency", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
		};

		uniform float4 _Color;
		uniform float _DotsRadius;
		uniform float _DotsTransparency;
		uniform float _InnerBandRadius;
		uniform float _OuterBandRadius;
		uniform float _BandOpacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_output_40_0 = _Color;
			o.Albedo = temp_output_40_0.rgb;
			o.Emission = temp_output_40_0.rgb;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult8 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 break16_g1 = ( appendResult8 * float2( 0.5,0.5 ) );
			float2 appendResult7_g1 = (float2(( break16_g1.x + ( 1.0 * step( 1.0 , ( break16_g1.y % 2.0 ) ) ) ) , ( break16_g1.y + ( 1.0 * step( 1.0 , ( break16_g1.x % 2.0 ) ) ) )));
			float temp_output_2_0_g1 = 0.46;
			float2 appendResult11_g2 = (float2(temp_output_2_0_g1 , temp_output_2_0_g1));
			float temp_output_17_0_g2 = length( ( (frac( appendResult7_g1 )*2.0 + -1.0) / appendResult11_g2 ) );
			float4 transform11 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float clampResult14 = clamp( (1.0 + (distance( float4( ase_worldPos , 0.0 ) , transform11 ) - 0.0) * (0.0 - 1.0) / (_DotsRadius - 0.0)) , 0.0 , 1.0 );
			float4 transform17 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float smoothstepResult16 = smoothstep( ( _InnerBandRadius - 0.05 ) , ( _InnerBandRadius + 0.05 ) , distance( float4( ase_worldPos , 0.0 ) , transform17 ));
			float4 transform27 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float smoothstepResult32 = smoothstep( ( _OuterBandRadius - 0.05 ) , ( _OuterBandRadius + 0.05 ) , distance( float4( ase_worldPos , 0.0 ) , transform27 ));
			float clampResult35 = clamp( ( ( smoothstepResult16 - smoothstepResult32 ) * _BandOpacity ) , 0.0 , 1.0 );
			float clampResult37 = clamp( ( ( ( saturate( ( ( 1.0 - temp_output_17_0_g2 ) / fwidth( temp_output_17_0_g2 ) ) ) * clampResult14 ) * _DotsTransparency ) + clampResult35 ) , 0.0 , 1.0 );
			o.Alpha = clampResult37;
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
-1920;0;1920;1019;1550.565;369.215;1.512328;True;True
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;27;-912.0707,1426.542;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-858.0706,1627.642;Inherit;False;Property;_OuterBandRadius;Outer Band Radius;2;0;Create;True;0;0;0;False;0;False;6;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-721.5351,1141.841;Inherit;False;Constant;_Sharpness;Sharpness;1;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;17;-776.4289,789.385;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;18;-763.329,620.885;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;20;-722.4286,990.4853;Inherit;False;Property;_InnerBandRadius;Inner Band Radius;1;0;Create;True;0;0;0;False;0;False;5;19.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-825.571,1805.742;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;26;-898.9709,1258.042;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;7;-1233.86,-322.0726;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;10;-702,66.5;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;11;-693,267.5;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1025.86,-307.0726;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-592.8719,1571.742;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-594.1719,1712.143;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-458.5294,1074.986;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-457.2293,934.5852;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;29;-501.8724,1413.142;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;9;-445,139.5;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-891.4999,522.6998;Inherit;False;Property;_DotsRadius;Dots Radius;0;0;Create;True;0;0;0;False;0;False;10;28.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;24;-366.2296,775.9851;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;12;-368,237.5;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-812.5658,-124.6122;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;32;-9.996874,1090.447;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;-197.2294,740.8844;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;4;-488,-154.5;Inherit;False;Dots Pattern;-1;;1;7d8d5e315fd9002418fb41741d3a59cb;1,22,1;5;21;FLOAT2;0,0;False;3;FLOAT2;8,8;False;2;FLOAT;0.46;False;4;FLOAT;1;False;5;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;14;-97,230.5;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;104.7295,874.4995;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;103.9053,1281.853;Inherit;False;Property;_BandOpacity;Band Opacity;3;0;Create;True;0;0;0;False;0;False;1;0.372;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;291.434,991.4863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-125,-14.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-89.65587,483.7383;Inherit;False;Property;_DotsTransparency;Dots Transparency;5;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;35;449.7344,967.222;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;215.8345,382.412;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;504.6725,631.5521;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;37;699.7626,699.6069;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;40;652.8809,141.5577;Inherit;False;Property;_Color;Color;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,1,0.8197026,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1030.825,174.2329;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;WarningShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;7;1
WireConnection;8;1;7;3
WireConnection;31;0;33;0
WireConnection;31;1;28;0
WireConnection;30;0;33;0
WireConnection;30;1;28;0
WireConnection;21;0;20;0
WireConnection;21;1;25;0
WireConnection;23;0;20;0
WireConnection;23;1;25;0
WireConnection;29;0;26;0
WireConnection;29;1;27;0
WireConnection;9;0;10;0
WireConnection;9;1;11;0
WireConnection;24;0;18;0
WireConnection;24;1;17;0
WireConnection;12;0;9;0
WireConnection;12;2;15;0
WireConnection;41;0;8;0
WireConnection;32;0;29;0
WireConnection;32;1;31;0
WireConnection;32;2;30;0
WireConnection;16;0;24;0
WireConnection;16;1;23;0
WireConnection;16;2;21;0
WireConnection;4;21;41;0
WireConnection;14;0;12;0
WireConnection;34;0;16;0
WireConnection;34;1;32;0
WireConnection;39;0;34;0
WireConnection;39;1;38;0
WireConnection;13;0;4;0
WireConnection;13;1;14;0
WireConnection;35;0;39;0
WireConnection;43;0;13;0
WireConnection;43;1;42;0
WireConnection;36;0;43;0
WireConnection;36;1;35;0
WireConnection;37;0;36;0
WireConnection;0;0;40;0
WireConnection;0;2;40;0
WireConnection;0;9;37;0
ASEEND*/
//CHKSM=B4E22F6D3FC78563EBA7A78E656888D0615D5169