 -- https://lovr.org/docs/Environment/Triplanar_Mapping

 return lovr.graphics.newShader('unlit', [[
    uniform texture2D textureX;
    uniform texture2D textureY;
    uniform texture2D textureZ;
    uniform float textureScale;

    vec4 lovrmain() {
      vec2 xscale = vec2(-sign(Normal.x), -1.);
      vec2 yscale = vec2( sign(Normal.y), +1.);
      vec2 zscale = vec2( sign(Normal.z), -1.);

      vec3 colorX = getPixel(textureX, PositionWorld.zy * textureScale * xscale).rgb;
      vec3 colorY = getPixel(textureY, PositionWorld.xz * textureScale * yscale).rgb;
      vec3 colorZ = getPixel(textureZ, PositionWorld.xy * textureScale * zscale).rgb;

      vec3 normal = abs(normalize(Normal));
      vec3 weight = normal / (normal.x + normal.y + normal.z);
      vec3 color = colorX * weight.x + colorY * weight.y + colorZ * weight.z;
      
      return Color * vec4(color, 1.);
    }
  ]])