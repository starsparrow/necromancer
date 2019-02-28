debug = true

Player = {
	x = love.graphics.getWidth() / 2,
	y = love.graphics.getHeight() / 2,
	w = 14,
	h = 20,

	dx = 0,
	dy = 0,
	acc = 4,
	dec = 3,
	speed = 400,
	
	maxMana = 200,
	manaRechargeRate = 20,
	mana = 0
}

function love.load(arg)
	Player.mana = Player.maxMana
end

function love.update(dt)
	
	-- Begin Keyboard Movement
	------ Accelerate
	if love.keyboard.isDown("w") and Player.dy > -1 then 
		Player.dy = Player.dy - (Player.acc * dt)
	end
	if love.keyboard.isDown("a") and Player.dx > -1 then
		Player.dx = Player.dx - (Player.acc * dt)
	end
	if love.keyboard.isDown("s") and Player.dy < 1 then
		Player.dy = Player.dy + (Player.acc * dt)
		end
	if love.keyboard.isDown("d") and Player.dx < 1 then
		Player.dx = Player.dx + (Player.acc * dt)
	end
	------ End Accelerate
	
	------ Begin Move
	if Player.dx ~= 0 or Player.dy ~= 0 then
		targetx = Player.x + Player.dx * Player.speed * dt
		if targetx > love.graphics.getWidth() - Player.w then
			targetx = love.graphics.getWidth() - Player.w
		elseif targetx < 0 then
			targetx = 0
		end
		Player.x = targetx
		
		targety = Player.y + Player.dy * Player.speed * dt
		if targety > love.graphics.getHeight() - Player.h then
			targety = love.graphics.getHeight() - Player.h
		elseif targety < 0 then
			targety = 0
		end
		Player.y = targety
	end
	------ End Move
	
	------ Begin Decelerate
	if not love.keyboard.isDown("a") and Player.dx < 0 then
		if (Player.dx + (Player.dec * dt)) > 0 then
			Player.dx = 0
		else
			Player.dx = Player.dx + (Player.dec * dt)
		end
	end
	if not love.keyboard.isDown("d") and Player.dx > 0 then
		if (Player.dx - (Player.dec * dt)) < 0 then
			Player.dx = 0
		else	
			Player.dx = Player.dx - (Player.dec * dt)
		end
	end
	if not love.keyboard.isDown("s") and Player.dy > 0 then
		if (Player.dy - (Player.dec * dt) < 0) then
			Player.dy = 0
		else
			Player.dy = Player.dy - (Player.dec * dt)
		end
	end
	if not love.keyboard.isDown("w") and Player.dy < 0 then
		if (Player.dy + (Player.dec  * dt)) > 0 then
			Player.dy = 0
		else
			Player.dy = Player.dy + (Player.dec  * dt)
		end
	end
	------ End Decelerate
	-- End Keyboard Movement
	
	-- Begin Recharge Mana
	if Player.mana < Player.maxMana then
		if Player.mana + (Player.manaRechargeRate * dt) > Player.maxMana then
			Player.mana = Player.maxMana
		else
			Player.mana = Player.mana + (Player.manaRechargeRate * dt)
		end
	end
	-- End Recharge Mana
	
end

function love.mousepressed(x, y)
	
	-- Begin Blink
	if Player.mana >= 120 then
		Player.dx, Player.dy = 0, 0
		Player.x, Player.y = x, y
		Player.y = y
		Player.mana = Player.mana - 120
	end
	-- End Blink
	
end

function love.draw(dt)

	love.graphics.rectangle("fill", Player.x, Player.y, Player.w, Player.h)
	
	-- Begin Info Display
	love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
	love.graphics.print("Mana: " .. Player.mana, 10, 30)
	love.graphics.print("x: " .. Player.x .. ", y: " .. Player.y , 10, 50)
	love.graphics.print("dx: " .. Player.dx .. ", dy: " .. Player.dy , 10, 70)
	-- End Info Display
	
end
