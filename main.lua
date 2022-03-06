debug = true -- Set false for realease

--[[
    love.load is called when the game first starts. 
    We'll load our assets -- images, sounds, etc -- here
]]--
function love.load(arg)
    player.img = love.graphics.newImage('assets/plane.png')
    --we now have an asset ready to be used inside Love
end

--[[
    love.update and love.draw 
    are called on every frame.
]]--
function love.update(dt)
    -- I always start with an easy way to exit the game
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    if love.keyboard.isDown("left") then
        player.x = player.x - (player.speed*dt)
    elseif love.keyboard.isDown('right') then
        player.x = player.x + (player.speed*dt)
    end
end

player = { x = 185, y = 610, speed = 150, img = nil }

function love.draw(dt)
    love.graphics.draw(player.img, player.x, player.y)
end
