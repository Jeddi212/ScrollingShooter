-- Timers
-- We declare these here so we don't have to edit them multiple places
local canShoot = true
local canShootTimerMax = 0.2 
local canShootTimer = canShootTimerMax

-- Image Storage
local bulletImg = nil

-- Entity Storage
local bullets = {} -- array of current bullets being drawn and updated

--More timers
local createEnemyTimerMax = 0.4
local createEnemyTimer = createEnemyTimerMax
  
-- More images
local enemyImg = nil -- Like other images we'll pull this in during out love.load function
  
-- More storage
local enemies = {} -- array of current enemies on screen

-- Audio Storage
local gunSound = nil

debug = false -- Set false for realease

-- Collision detection taken function from http://love2d.org/wiki/BoundingBox.lua
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end

local isAlive = true
local score = 0

--[[
    love.load is called when the game first starts. 
    We'll load our assets -- images, sounds, etc -- here
]]--
function love.load(arg)
    Player.img = love.graphics.newImage('assets/plane.png')
    bulletImg = love.graphics.newImage('assets/bullet.png')
    enemyImg = love.graphics.newImage('assets/enemy.png')
    gunSound = love.audio.newSource("assets/gun-sound.wav", "static")
    gunSound:setVolume(0.1)
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

    -- Player Movement
    if love.keyboard.isDown('left', 'a') then
        if Player.x > 0 then -- binds us to the map
            Player.x = Player.x - (Player.speed*dt)
        end
    elseif love.keyboard.isDown('right', 'd') then
        -- [ : ] is syntactic sugar for object oriented for 'self' keyword
        if Player.x < (love.graphics.getWidth() - Player.img:getWidth()) then
            Player.x = Player.x + (Player.speed*dt)
        end
    end

    if love.keyboard.isDown('up', 'w') then
        if Player.y > 0 then -- membatasi map di atas
            Player.y = Player.y - (Player.speed*dt)
        end
    elseif love.keyboard.isDown('down', 's') then
        if Player.y < (love.graphics.getHeight() - Player.img:getHeight()) then
            Player.y = Player.y + (Player.speed*dt)
        end
    end

    -- Time out how far apart our shots can be.
    canShootTimer = canShootTimer - (1 * dt)
    if canShootTimer < 0 then
        canShoot = true
    end

    if love.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot then
        -- Create some bullets
        newBullet = { x = Player.x + (Player.img:getWidth()/2), y = Player.y, img = bulletImg }
        table.insert(bullets, newBullet)

        --NEW LINE
        gunSound:play()
        --END NEW

        canShoot = false
        canShootTimer = canShootTimerMax
    end

    -- update the positions of bullets
    for i, bullet in ipairs(bullets) do
        bullet.y = bullet.y - (250 * dt)

        if bullet.y < 0 then -- remove bullets when they pass off the screen
            table.remove(bullets, i)
        end
    end

    -- Time out enemy creation
    createEnemyTimer = createEnemyTimer - (1 * dt)
    if createEnemyTimer < 0 then
        createEnemyTimer = createEnemyTimerMax

        -- Create an enemy
        randomNumber = math.random(10, love.graphics.getWidth() - 10)
        local newEnemy = { x = randomNumber, y = -10, img = enemyImg }
        table.insert(enemies, newEnemy)
    end

    -- update the positions of enemies
    for i, enemy in ipairs(enemies) do
        enemy.y = enemy.y + (200 * dt)

        if enemy.y > 850 then -- remove enemies when they pass off the screen
            table.remove(enemies, i)
        end
    end

    -- run our collision detection
    -- Since there will be fewer enemies on screen than bullets we'll loop them first
    -- Also, we need to see if the enemies hit our Player
    for i, enemy in ipairs(enemies) do
        for j, bullet in ipairs(bullets) do
            if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
                table.remove(bullets, j)
                table.remove(enemies, i)
                score = score + 1
            end
        end

        if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), Player.x, Player.y, Player.img:getWidth(), Player.img:getHeight()) 
        and isAlive then
            table.remove(enemies, i)
            isAlive = false
        end
    end

    if not isAlive and love.keyboard.isDown('r') then
        -- remove all our bullets and enemies from screen
        bullets = {}
        enemies = {}

        -- reset timers
        canShootTimer = canShootTimerMax
        createEnemyTimer = createEnemyTimerMax

        -- move Player back to default position
        Player.x = 185
        Player.y = 610

        -- reset our game state
        score = 0
        isAlive = true
    end
end

Player = { x = 185, y = 610, speed = 150, img = nil }

function love.draw(dt)
    -- Score
    love.graphics.print("Score : ".. score, 5, 5)

    -- Player
    if isAlive then
        love.graphics.draw(Player.img, Player.x, Player.y)
    else
        love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
    end

    -- Bullet
    for i, bullet in ipairs(bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end

    -- Enemies
    for i, enemy in ipairs(enemies) do
        love.graphics.draw(enemy.img, enemy.x, enemy.y)
    end
end
