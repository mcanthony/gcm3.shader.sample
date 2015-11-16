﻿Shader "Custom/RimLighting" {
	Properties {
		_Color ("Color", Color) = (0.296875,0.296875,0.296875,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RimColor ("Rim Color", Color) = (1,0.140625,0,1)
      	_RimPower ("Rim Power", Range(0.01,8.0)) = 3
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert fullforwardshadows

		sampler2D _MainTex;

		struct Input {
			fixed2 uv_MainTex;
			fixed3 viewDir;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		fixed4 _RimColor;
		fixed _RimPower;

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			
			// Rim
			fixed3 view = normalize(IN.viewDir);
			fixed3 nml = o.Normal;
			fixed VdN = dot(view, nml);
			fixed rim = 1.0 - saturate(VdN);
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);

			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
