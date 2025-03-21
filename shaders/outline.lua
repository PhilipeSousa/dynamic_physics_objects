return lovr.graphics.newShader([[
    vec4 lovrmain() {
        vec4 pos = Transform * VertexPosition;
        pos.xyz += normalize((NormalMatrix * VertexNormal)) * 0.1;
        return Projection * View * pos;
    }
]], [[
    vec4 lovrmain() {
        // black color
        return vec4(0.0, 0.0, 0.0, 1.0);
    }
]])