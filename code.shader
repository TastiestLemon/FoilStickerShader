#define _PI 3.1415926

half4 stickerColor(float2 texcoord, fixed4 col, float frequency, int cells, float shimmerSpeed, float dimness, float backdropDimness)
{
  // brightens color
  float lightMultiplier = 1.0;
  // shimmer relative to time
  float offset = _Time.w * shimmerSpeed;
  float distance = (texcoord.x + texcoord.y) + offset;
  lightMultiplier += sin(distance * _PI * frequency) / dimness;
  // get light multiplier of grid cells
  float cellLightMultiplier = 0.5;
  // get grid cell
  float cellX = (texcoord.x * cells) % 1;
  float cellY = (texcoord.y * cells) % 1;
  // brighten to the top left
  cellLightMultiplier += (2.0 - cellX) + cellY;
  // pick whichever intensity is more prominent, & dim effect on lower alpha levels
  col.rgb *= (1.0 - col.a) + (col.a * max(lightMultiplier, cellLightMultiplier / backdropDimness));
  return col;
}
