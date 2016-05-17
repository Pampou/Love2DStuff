function CreatePlayer(physicWorld)
	player = {}
	player.x = 0
	player.y = 0
	
	player.xVel = 0
	player.yVel = 0
	
	player.image = love.graphics.newImage("img/player.png")
	player.onGround = false
	
	return player
end

-- Function : Reset Position
function ResetPosition()
	player.x, player.y = 0, 0
end