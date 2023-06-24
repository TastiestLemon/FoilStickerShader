Shader "Unlit/UnlitStickerSample"
{
  Properties
  {
      _MainTex("Texture", 2D) = "white" {}
      _Color("Color", Color) = (1,1,1,1)
      _Frequency("Frequency",float) = 3.0
      _Cells("Cells",int) = 5
      _ShimmerSpeed("ShimmerSpeed",float) = 0.2
      _Dimness("Dimness", float) = 5.0
      _CellDimness("CellDimness",float) = 3.0
  }

  SubShader
  {
    Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
    LOD 100
    ZWrite Off
    Blend SrcAlpha OneMinusSrcAlpha

    Pass
    {
              CGPROGRAM
              #pragma vertex vert
              #pragma fragment frag
              #pragma target 2.0

              #include "UnityCG.cginc"

              struct appdata_t
              {
                  float4 vertex : POSITION;
                  float2 texcoord : TEXCOORD0;
                  UNITY_VERTEX_INPUT_INSTANCE_ID
              };

              struct v2f
              {
                  float4 vertex : SV_POSITION;
                  float2 texcoord : TEXCOORD0;
                  UNITY_VERTEX_OUTPUT_STEREO
              };

              sampler2D _MainTex;
              float4 _MainTex_ST;
              fixed4 _Color;
              float _Frequency;
              int _Cells;
              float _ShimmerSpeed;
              float _Dimness;
              float _CellDimness;

              v2f vert(appdata_t v)
              {
                  v2f o;
                  UNITY_SETUP_INSTANCE_ID(v);
                  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                  o.vertex = UnityObjectToClipPos(v.vertex);
                  o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                  return o;
              }

              #define _PI 3.1415926

              half4 stickerColor(float2 texcoord, fixed4 col, float frequency, int cells, float shimmerSpeed, float dimness, float cellDimness)
              {
                // brightens color
                float lightMultiplier = 1.0;
                // shimmer relative to time
                float offset = _Time.w * shimmerSpeed;
                float distance = (texcoord.x + texcoord.y) + offset;
                lightMultiplier += sin(distance * _PI * frequency) / dimness;
                // get grid cell
                float cellX = (texcoord.x * cells) % 1;
                float cellY = (texcoord.y * cells) % 1;
                // brighten to the top left
                float cellLightMultiplier = (2.5 - cellX + cellY) / cellDimness;
                // pick whichever intensity is more prominent, & dim effect on lower alpha levels
                col.rgb *= (1.0 - col.a) + (col.a * max(lightMultiplier, cellLightMultiplier));
                return col;
              }

              fixed4 frag(v2f i) : SV_Target
              {
                  fixed4 col = tex2D(_MainTex, i.texcoord) * _Color;
                  return stickerColor(i.texcoord, col, _Frequency, _Cells, _ShimmerSpeed, _Dimness, _CellDimness);
              }
          ENDCG
      }
      }
      }
