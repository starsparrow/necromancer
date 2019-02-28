debug = true

Player = {
	x = love.graphics.getWidth() / 2,
	y = love.graphics.getHeight() / 2,
	w = 15,
	h = 15,
	speed = 500
}

function love.load(arg)
	
end

function love.update(dt)
	print(Player.x, Player.y)

	local dx, dy = 0, 0
	if love.keyboard.isDown("w") then dy = -1 end
	if love.keyboard.isDown("a") then dx = -1 end
	if love.keyboard.isDown("s") then dy = 1 end
	if love.keyboard.isDown("d") then dx = 1 end
	if dx ~= 0 or dy ~= 0 then
		if dx ~= 0 and dy ~= 0 then
			dx = dx * 0.7071
			dy = dy * 0.7071
		end
		
		targetx = Player.x + dx * Player.speed * dt
		if targetx > love.graphics.getWidth() - Player.w then
			targetx = love.graphics.getWidth() - Player.w
		elseif targetx < 0 then
			targetx = 0
		end
		Player.x = targetx
		
		
		targety = Player.y + dy * Player.speed * dt
		if targety > love.graphics.getHeight() - Player.h then
			targety = love.graphics.getHeight() - Player.h
		elseif targety < 0 then
			targety = 0
		end
		Player.y = targety
		
	end
end

function love.draw(dt)
	love.graphics.rectangle("fill", Player.x, Player.y, Player.w, Player.h)
end
