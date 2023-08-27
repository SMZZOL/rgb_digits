Shader "Custom/NumShader2"
{
	Properties
	{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_TimeTex("Time Line",2D) = "white"{}
		_TimeVal("Time", Range(1,20)) = 1  //시간 값에 대한 변수

	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			#pragma surface surf Standard fullforwardshadows

			#pragma target 3.0

			sampler2D _MainTex;
			sampler2D _TimeTex;

			struct Input
			{
				float2 uv_Time;
				float2 uv_MainTex;
			};
			int _StartStop;
			float _TimeVal;

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				fixed4 t = tex2D(_TimeTex, float2(_Time.x*_TimeVal*0.1, 0.5));
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
				float G = c.g;
				float R = c.r;
				float B = c.b;
				float tmp;
				float time = ceil(t.r * 10);
				if (time == 1) { tmp = B - (R*B); }
				else if (time == 2) { tmp = R + B - (G*B); }
				else if (time == 3) { tmp = R + B - R * B - R * B + R * G*B; }
				else if (time == 4) { tmp = G + B - R * B - R * G*B; }
				else if (time == 5) { tmp = R + G - R * B; }
				else if (time == 6)tmp = max(0, R + G - (B - R - G));
				else if (time == 7)tmp = max(0, min(1, R + G + B) - (R*B + R * G));
				else if (time == 8)tmp = R + B + G;
				else if (time == 9)tmp = min(1, R + B + G) - R * B;
				else if (time == 0)tmp = min(1, R + B + G) - R * G + R * G*B;




				o.Emission = tmp * float3 (0,1,0);
				o.Alpha = c.a;
			}
			ENDCG
		}
			FallBack "Diffuse"
}
