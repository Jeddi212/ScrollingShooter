debug = true -- Set false for realease

--[[
    love.load is called when the game first starts. 
    We'll load our assets -- images, sounds, etc -- here
]]--
function love.load(arg)
    playerImg = love.graphics.newImage('assets/plane.png')
    --we now have an asset ready to be used inside Love
end

--[[
    love.update and love.draw 
    are called on every frame.
]]--

playerImg = nil -- This just for storage
function love.update(dt)
    
end

function love.draw(dt)
    love.graphics.draw(playerImg, 100, 100)
end
