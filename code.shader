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

// Clearly not the full file, but just call this function to apply the effect to any color in the fragment shader
