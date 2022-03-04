// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterShader"
{
	Properties
	{
		_SpeedReflection("SpeedReflection", Range( 0 , 1)) = 0.5
		_ReflectionThickness("Reflection Thickness", Range( 0.5 , 4)) = 1.511452
		_ReflectionScale("Reflection Scale", Range( 1 , 200)) = 100
		_Basecolor("Base color", Color) = (0,0.7775211,1,1)
		_EdgeDistance("Edge Distance", Float) = 1
		_EdgePower("Edge Power", Float) = 1
		_BorderColor("Border Color", Color) = (0.2196078,0,1,0)
		_ReflectionIntesity("Reflection Intesity", Range( 0 , 10)) = 4
		_ReflectionColor("Reflection Color", Color) = (0.7311321,1,1,1)
		_WaterOppacity("WaterOppacity", Range( 0 , 1)) = 1
		_DepthFadeDistance("Depth Fade Distance", Range( 0 , 1000)) = 0
		_OppacityFadeDistance("Oppacity Fade Distance", Range( 0 , 1000)) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_DepthFadeIntensity("Depth Fade Intensity", Range( 0 , 1)) = 1
		_SpeedWave("Speed Wave", Range( 0 , 1)) = 0.1138735
		_waveSize("wave Size", Range( 1 , 10)) = 3.198547
		_PowerHeightWave("Power Height Wave", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform float _SpeedWave;
		uniform float _waveSize;
		uniform float _PowerHeightWave;
		uniform float4 _BorderColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _EdgeDistance;
		uniform float _EdgePower;
		uniform float _ReflectionIntesity;
		uniform float _ReflectionScale;
		uniform float _SpeedReflection;
		uniform float _ReflectionThickness;
		uniform float4 _ReflectionColor;
		uniform float4 _Basecolor;
		uniform float _DepthFadeIntensity;
		uniform sampler2D _Texture0;
		uniform float _DepthFadeDistance;
		uniform float _WaterOppacity;
		uniform float _OppacityFadeDistance;


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


		struct Gradient
		{
			int type;
			int colorsLength;
			int alphasLength;
			float4 colors[8];
			float2 alphas[8];
		};


		Gradient NewGradient(int type, int colorsLength, int alphasLength, 
		float4 colors0, float4 colors1, float4 colors2, float4 colors3, float4 colors4, float4 colors5, float4 colors6, float4 colors7,
		float2 alphas0, float2 alphas1, float2 alphas2, float2 alphas3, float2 alphas4, float2 alphas5, float2 alphas6, float2 alphas7)
		{
			Gradient g;
			g.type = type;
			g.colorsLength = colorsLength;
			g.alphasLength = alphasLength;
			g.colors[ 0 ] = colors0;
			g.colors[ 1 ] = colors1;
			g.colors[ 2 ] = colors2;
			g.colors[ 3 ] = colors3;
			g.colors[ 4 ] = colors4;
			g.colors[ 5 ] = colors5;
			g.colors[ 6 ] = colors6;
			g.colors[ 7 ] = colors7;
			g.alphas[ 0 ] = alphas0;
			g.alphas[ 1 ] = alphas1;
			g.alphas[ 2 ] = alphas2;
			g.alphas[ 3 ] = alphas3;
			g.alphas[ 4 ] = alphas4;
			g.alphas[ 5 ] = alphas5;
			g.alphas[ 6 ] = alphas6;
			g.alphas[ 7 ] = alphas7;
			return g;
		}


		float4 SampleGradient( Gradient gradient, float time )
		{
			float3 color = gradient.colors[0].rgb;
			UNITY_UNROLL
			for (int c = 1; c < 8; c++)
			{
			float colorPos = saturate((time - gradient.colors[c-1].w) / (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, (float)gradient.colorsLength-1);
			color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
			}
			#ifndef UNITY_COLORSPACE_GAMMA
			color = half3(GammaToLinearSpaceExact(color.r), GammaToLinearSpaceExact(color.g), GammaToLinearSpaceExact(color.b));
			#endif
			float alpha = gradient.alphas[0].x;
			UNITY_UNROLL
			for (int a = 1; a < 8; a++)
			{
			float alphaPos = saturate((time - gradient.alphas[a-1].y) / (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, (float)gradient.alphasLength-1);
			alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
			}
			return float4(color, alpha);
		}


		float2 voronoihash15( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi15( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash15( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 panner96 = ( ( _Time.y * _SpeedWave ) * float2( -1,-1 ) + v.texcoord.xy);
			float simplePerlin2D103 = snoise( panner96*_waveSize );
			simplePerlin2D103 = simplePerlin2D103*0.5 + 0.5;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_105_0 = ( simplePerlin2D103 * ( ase_vertexNormal * _PowerHeightWave ) );
			float3 HeightOffest110 = temp_output_105_0;
			v.vertex.xyz += HeightOffest110;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			Gradient gradient112 = NewGradient( 0, 8, 2, float4( 0, 0, 0, 0 ), float4( 1, 1, 1, 0.09411765 ), float4( 0, 0, 0, 0.1441215 ), float4( 1, 1, 1, 0.3000076 ), float4( 0, 0, 0, 0.402945 ), float4( 0, 0, 0, 0.5411765 ), float4( 1, 1, 1, 0.6147097 ), float4( 1, 1, 1, 1 ), float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth54 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth54 = abs( ( screenDepth54 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _EdgeDistance ) );
			float clampResult116 = clamp( ( SampleGradient( gradient112, ( 1.0 - distanceDepth54 ) ).r * _EdgePower ) , 0.0 , 0.5 );
			float4 Edge61 = ( _BorderColor * clampResult116 );
			float mulTime12 = _Time.y * 2.0;
			float time15 = ( mulTime12 * _SpeedReflection );
			float2 coords15 = i.uv_texcoord * _ReflectionScale;
			float2 id15 = 0;
			float2 uv15 = 0;
			float voroi15 = voronoi15( coords15, time15, id15, uv15, 0 );
			float4 ReflectionColor23 = _ReflectionColor;
			float4 WaterReflection26 = ( _ReflectionIntesity * ( pow( voroi15 , _ReflectionThickness ) * ReflectionColor23 ) );
			o.Albedo = ( Edge61 + ( WaterReflection26 + _Basecolor ) ).rgb;
			float screenDepth69 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth69 = saturate( abs( ( screenDepth69 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) ) );
			float2 appendResult70 = (float2(distanceDepth69 , distanceDepth69));
			float4 ToEmissive73 = ( _DepthFadeIntensity * tex2D( _Texture0, appendResult70 ) );
			o.Emission = ToEmissive73.rgb;
			float screenDepth85 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth85 = saturate( abs( ( screenDepth85 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _OppacityFadeDistance ) ) );
			float2 appendResult84 = (float2(distanceDepth85 , distanceDepth85));
			o.Alpha = ( _WaterOppacity * appendResult84 ).x;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
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
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.screenPos = IN.screenPos;
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
Version=18500
602;73;1040;655;4636.85;144.9193;3.518925;True;False
Node;AmplifyShaderEditor.CommentaryNode;27;-2852.164,-222.0576;Inherit;False;2314.231;630.2817;;13;26;44;46;24;25;18;17;40;15;14;16;12;13;WaterReflection;0,0.4612292,0.9811321,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;63;-3315.23,680.9875;Inherit;False;2500.777;475.2092;;11;115;56;57;55;54;61;60;66;116;53;112;Edge;0.7783019,0.995613,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-2704.351,-172.0576;Inherit;True;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2802.164,91.61291;Inherit;False;Property;_SpeedReflection;SpeedReflection;0;0;Create;True;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;62;-2669.836,1326.191;Inherit;False;555.6113;262;;2;21;23;Color Reflection;0,1,0.9233861,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-3258.709,738.5836;Inherit;False;Property;_EdgeDistance;Edge Distance;4;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2428.283,85.09551;Inherit;False;Property;_ReflectionScale;Reflection Scale;2;0;Create;True;0;0;False;0;False;100;3;1;200;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-2325.533,-56.17935;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;52;-2376.744,-340.0171;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;21;-2619.836,1376.191;Inherit;False;Property;_ReflectionColor;Reflection Color;8;0;Create;True;0;0;False;0;False;0.7311321,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;54;-2956.15,726.8697;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;55;-2603.68,735.2839;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;111;-2780.022,2616.397;Inherit;False;2428.866;808.5242;;13;101;100;102;99;97;96;104;103;105;110;107;106;108;Moving Water;0,0.488204,1,1;0;0
Node;AmplifyShaderEditor.GradientNode;112;-2618.499,900.9998;Inherit;False;0;8;2;0,0,0,0;1,1,1,0.09411765;0,0,0,0.1441215;1,1,1,0.3000076;0,0,0,0.402945;0,0,0,0.5411765;1,1,1,0.6147097;1,1,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-2342.225,1395.582;Inherit;False;ReflectionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2108.858,299.8384;Inherit;False;Property;_ReflectionThickness;Reflection Thickness;1;0;Create;True;0;0;False;0;False;1.511452;2.5;0.5;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;15;-2063.198,-57.70412;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;3;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.CommentaryNode;95;-2768.756,1770.58;Inherit;False;2190.367;556.5364;;9;68;69;70;72;75;71;76;67;73;Deep Effect;0.05339978,0.05948927,0.4528302,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-2143.643,968.2961;Inherit;False;Property;_EdgePower;Edge Power;5;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;115;-2329.465,772.0887;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;101;-2717.574,3261.553;Inherit;False;Property;_SpeedWave;Speed Wave;15;0;Create;True;0;0;False;0;False;0.1138735;0.1807823;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-2718.756,2211.117;Inherit;False;Property;_DepthFadeDistance;Depth Fade Distance;11;0;Create;True;0;0;False;0;False;0;0;0;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-1560.655,196.1885;Inherit;False;23;ReflectionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;17;-1759.81,-25.07235;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;100;-2730.022,3030.501;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;69;-2381.418,2071.931;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-2373.524,3150.966;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;97;-2709.447,2666.397;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;99;-2722.561,2863.818;Inherit;False;Constant;_Vector0;Vector 0;15;0;Create;True;0;0;False;0;False;-1,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1895.816,794.0732;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1299.546,43.05057;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1369.677,-78.80283;Inherit;False;Property;_ReflectionIntesity;Reflection Intesity;7;0;Create;True;0;0;False;0;False;4;3.670369;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;66;-1612.145,693.136;Inherit;False;Property;_BorderColor;Border Color;6;0;Create;True;0;0;False;0;False;0.2196078,0,1,0;0.2196078,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;116;-1620.152,884.5556;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-1952.239,3031.538;Inherit;False;Property;_waveSize;wave Size;16;0;Create;True;0;0;False;0;False;3.198547;3.6;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;106;-1336.263,3095.487;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;107;-1353.21,3308.921;Inherit;False;Property;_PowerHeightWave;Power Height Wave;17;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-986.143,-169.1164;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;70;-2022.689,2066.579;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;72;-2043.802,1820.58;Inherit;True;Property;_Texture0;Texture 0;13;0;Create;True;0;0;False;0;False;f167cb3e24207af42ae7c5642abb023f;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;96;-2094.636,2693.878;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;71;-1705.516,1930.807;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-750.3458,54.33855;Inherit;False;WaterReflection;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-1075.909,3116.084;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-1451.764,1867.113;Inherit;False;Property;_DepthFadeIntensity;Depth Fade Intensity;14;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-477.3504,477.1402;Inherit;False;Property;_OppacityFadeDistance;Oppacity Fade Distance;12;0;Create;True;0;0;False;0;False;0;0;0;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;103;-1451.534,2774.704;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1324.813,814.0453;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-101.2035,-350.0972;Inherit;False;Property;_Basecolor;Base color;3;0;Create;True;0;0;False;0;False;0,0.7775211,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;85;-70.61358,357.7589;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1119.482,1884.953;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-97.78989,-456.5686;Inherit;False;26;WaterReflection;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-1038.454,835.5175;Inherit;False;Edge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-799.7283,2818.626;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;11;-2869.648,-1135.06;Inherit;False;830.2462;314.8007;;3;8;9;10;World Space UV;0.7774972,0.1084906,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;113.3813,-574.6639;Inherit;False;61;Edge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2;28.90948,165.3785;Inherit;False;Property;_WaterOppacity;WaterOppacity;9;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;142.5269,-405.2938;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-575.1561,2850.38;Inherit;False;HeightOffest;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;193.2112,350.4324;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-802.3885,2039.044;Inherit;False;ToEmissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;303.6098,-92.41151;Inherit;False;73;ToEmissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;497.8348,221.2719;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;472.6501,55.90027;Inherit;False;110;HeightOffest;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-2555.025,-1074.259;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-2344.658,192.8;Inherit;False;10;WorldSpaceUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;8;-2857.362,-1095.835;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-2263.403,-1045.457;Inherit;False;WorldSpaceUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PosVertexDataNode;67;-2633.686,2014.071;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;109.6117,18.95957;Inherit;False;Property;_Refraction;Refraction;10;0;Create;True;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;356.9262,-494.9424;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;718.2471,-266.025;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;WaterShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;0;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;54;0;53;0
WireConnection;55;0;54;0
WireConnection;23;0;21;0
WireConnection;15;0;52;0
WireConnection;15;1;14;0
WireConnection;15;2;40;0
WireConnection;115;0;112;0
WireConnection;115;1;55;0
WireConnection;17;0;15;0
WireConnection;17;1;18;0
WireConnection;69;0;68;0
WireConnection;102;0;100;0
WireConnection;102;1;101;0
WireConnection;57;0;115;1
WireConnection;57;1;56;0
WireConnection;24;0;17;0
WireConnection;24;1;25;0
WireConnection;116;0;57;0
WireConnection;46;0;44;0
WireConnection;46;1;24;0
WireConnection;70;0;69;0
WireConnection;70;1;69;0
WireConnection;96;0;97;0
WireConnection;96;2;99;0
WireConnection;96;1;102;0
WireConnection;71;0;72;0
WireConnection;71;1;70;0
WireConnection;26;0;46;0
WireConnection;108;0;106;0
WireConnection;108;1;107;0
WireConnection;103;0;96;0
WireConnection;103;1;104;0
WireConnection;60;0;66;0
WireConnection;60;1;116;0
WireConnection;85;0;83;0
WireConnection;76;0;75;0
WireConnection;76;1;71;0
WireConnection;61;0;60;0
WireConnection;105;0;103;0
WireConnection;105;1;108;0
WireConnection;30;0;28;0
WireConnection;30;1;1;0
WireConnection;110;0;105;0
WireConnection;84;0;85;0
WireConnection;84;1;85;0
WireConnection;73;0;76;0
WireConnection;86;0;2;0
WireConnection;86;1;84;0
WireConnection;9;0;8;1
WireConnection;9;1;8;2
WireConnection;9;2;8;3
WireConnection;10;0;9;0
WireConnection;65;0;64;0
WireConnection;65;1;30;0
WireConnection;0;0;65;0
WireConnection;0;2;74;0
WireConnection;0;9;86;0
WireConnection;0;11;109;0
ASEEND*/
//CHKSM=1C42AE5BF4F64EEEB42CC2F5670ABD9B4DBAF12F