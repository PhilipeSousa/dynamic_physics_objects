function lovr.load()

    local textures = require('textures/load_textures')
    watermelon_v = textures.watermelon_v
    watermelon_h = textures.watermelon_h
    inner = textures.inner
    triplanar = require('shaders.triplanar')
    outline_shader = require('shaders.outline')

    lovr.graphics.setBackgroundColor(0.1, 0.1, .1)
    free_cam = false
  
    world = lovr.physics.newWorld(0, -9.81, 0)
    boxes_spawn_size = 50

    local width = 4
    local height = 3
    local depth = 3
    dynamic_collider = world:newBoxCollider(0, -2, -10, width, height, depth)
    dynamic_collider:setKinematic(true) 

    box_colliders = {}
    spawn_timer = 0  

    -- 100 per second
    spawn_interval = 0.01 
    
end

function lovr.update(dt)
    world:update(dt)

    spawn_timer = spawn_timer + dt

    while spawn_timer >= spawn_interval do
        spawn_timer = spawn_timer - spawn_interval 

        local collider = world:newBoxCollider(
          lovr.math.randomNormal(boxes_spawn_size / 10, 0),
          lovr.math.randomNormal(1, 20),
          lovr.math.randomNormal(boxes_spawn_size / 10, -10),
          1)
        table.insert(box_colliders, collider)
    end

    -- destroy boxes 70 units far away
    for i = #box_colliders, 1, -1 do
        local collider = box_colliders[i]
        local x, y, z = collider:getPosition()

        if y < -70 then
            collider:destroy() 
            table.remove(box_colliders, i) 
        end
    end
  
    local width = 2 + 1 * math.cos(lovr.timer.getTime())
    local height = 2 + 1 * math.sin(lovr.timer.getTime())
    local depth = 3

    -- Destroy the dynamic collider e create another one
    dynamic_collider:destroy()
    dynamic_collider = world:newBoxCollider(0, -2, -10, width * 10, height, depth * 5)
    dynamic_collider:setKinematic(true)
end

function lovr.keypressed(key)
    if key == "f" then
        free_cam = not free_cam
    end
end

function lovr.draw(pass)

    pass:text('Press f for free camera', -5, -1.5, -5, 0.35)

    if not free_cam then
        pass:setViewPose(1, -15.27, 8.97, 9.05, 0.71, -0.35, -0.93, -0.12)
    end

    pass:setShader(triplanar)
    pass:send('textureScale', 1.0)
    pass:send('textureX', watermelon_h)
    pass:send('textureY', watermelon_v)
    pass:send('textureZ', inner)
  
    local x, y, z = dynamic_collider:getPosition()
    local width, height, depth = dynamic_collider:getShapes()[1]:getDimensions()
  
    -- watermelon visual
    pass:box(x, y, z, width, height, depth)

    --x, y, z, angle, ax, ay, az = pass:getViewPose(1)
    --print(string.format("%.2f, %.2f, %.2f, %.2f, %.2f, %.2f, %.2f", x, y, z, angle, ax, ay, az))

    -- outline shader can be removed
    pass:setShader(outline_shader)
    pass:setCullMode('front') 
    for _, collider in ipairs(box_colliders) do
        pass:box(mat4(collider:getPose()))
      end
    pass:setCullMode('back')
    
    -- yellow boxes 
    pass:setShader()
    pass:setColor(0.925, 0.745, 0.137)
    for _, collider in ipairs(box_colliders) do
      pass:box(mat4(collider:getPose()))
    end
end