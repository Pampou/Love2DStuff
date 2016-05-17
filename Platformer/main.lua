require 'player'

platformImage = love.graphics.newImage("img/platform.png")
player = nil
SPEED = 5

function CreatePlatform(x, y)
	platform = {}
	
	platform.x = x
	platform.y = y
	
	platform.image = platformImage
	
	return platform
end

-- https://openclassrooms.com/courses/theorie-des-collisions/formes-simples
function checkCollision(a, b)
	if b.x >= a.x + a.image:getWidth() or b.x + b.image:getWidth() <= a.x or b.y >= a.y + a.image:getHeight() or b.y + b.image:getHeight() <= a.y then
		return false
	else
		return true
	end
end

-- Check collisions between player and any platform
function collide(xVel, yVel, platforms)
	for key, value in pairs(platforms) do -- For any platform
		if checkCollision(player, value) then -- Check if there is a collision between player and this platform 
			if xVel > 0 then player.x = value.x - 32 end
			if xVel < 0 then player.x = value.x + 32 end
			if yVel > 0 then 
				player.y = value.y - 32
				player.onGround = true
				player.yVel = 0
			end
			if yVel < 0 then
				player.y = value.y + 32
				player.yVel = 0
			end
		end
	end
end

function love.load()
	--love.graphics.setBackgroundColor(104, 136, 248)
	love.window.setTitle("Platformer Demo - Click on the screen to add platforms")
	love.window.setMode(640, 480)
	
	player = CreatePlayer(world)
	platforms = {}
	
	for x = 0, 20 do
		table.insert(platforms, CreatePlatform(x*32, 448))
	end
end

function love.update(dt)
	if love.mouse.isDown(1) then
		mouseX = (love.mouse.getX() - love.mouse.getX()%32)
		mouseY = (love.mouse.getY() - love.mouse.getY()%32)
		table.insert(platforms, CreatePlatform(mouseX, mouseY))
	end
	
	-- Quit Game
	if love.keyboard.isDown("escape") then love.event.quit() end
	
	-- ResetPosition (Respawn)
	if love.keyboard.isDown("r") then ResetPosition() end
	
	-- Get keyboard keys
	up = love.keyboard.isDown("up")
	left = love.keyboard.isDown("left")
	right = love.keyboard.isDown("right")

	
	
	-- Jump
	if up then
		if player.onGround then player.yVel = -10 end
	end
	
	
	-- Direction
	player.xVel = 0
	
	if left then
		player.xVel = -SPEED
	end
	
	if right then
		player.xVel = SPEED
	end
	
	-- Falling
	if not player.onGround then
		player.yVel = player.yVel + 0.5
	end
	
	-- Check horizontal collisions
	player.x = player.x + player.xVel
	collide(player.xVel, 0, platforms)
	
	-- Check vertical collisions
	player.y = player.y + player.yVel
	player.onGround = false
	collide(0, player.yVel, platforms)
	
end

function love.draw()
	-- Draw Levels
	for index = 1, table.getn(platforms) do
		love.graphics.draw(platforms[index].image, platforms[index].x, platforms[index].y)
	end
	-- Draw player
	love.graphics.draw(player.image, player.x, player.y)
	
	-- Debug
	love.graphics.print("X = " .. player.x .. " Y = " .. player.y, 0, 0)
end