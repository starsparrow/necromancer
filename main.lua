debug = false

spritesheet = love.graphics.newImage("graphics/fantasy-tileset.png")
floortile = love.graphics.newImage("graphics/floor-tile.png")
floortile:setWrap("repeat", "repeat")
font = love.graphics.newFont("fonts/ALGER.TTF", 24, "light")

mx, my = nil, nil

Player = {
	img = nil,

	x = love.graphics.getWidth() / 2,
	y = love.graphics.getHeight() / 2,
	w = 32,
	h = 32,

	dx = 0,
	dy = 0,
	acc = 4,
	dec = 4,
	speed = 300,
	canMove = true,
	
	maxHp = 100,
	currentHp = 0,
	
	maxMana = 200,
	manaRechargeRate = 20,
	currentMana = 0,
	
	-- Spell: Blink
	blinkManaCost = 150,
	blinkQueued = false,
	blinkSound = love.audio.newSource("audio/spell-blink.wav", "static"),
	playBlinkAudio = true,
	blinkTimer = 0,
	blinkTargetY = nil,
	blinkTargetX = nil
}


function love.load(arg)	
	Player.sprite = love.graphics.newQuad(225, 576, 32, 32, spritesheet:getDimensions())
	floorSprite = love.graphics.newQuad(
		0, 0, love.graphics.getWidth(), love.graphics.getHeight(), floortile:getDimensions()
	)
	
	hpDisplayString = nil
	hpDisplay = love.graphics.newText(font, hpDisplayString)
	manaDisplayString = nil
	manaDisplay = love.graphics.newText(font, manaDisplayString)

	Player.currentMana = Player.maxMana
	Player.currentHp = Player.maxHp
	
	love.mouse.setVisible(false)
	
	love.audio.play(love.audio.newSource("audio/bgm.wav", "stream"))
end


function love.update(dt)

	mx, my = love.mouse.getPosition()

	-- Begin Casting Blink
	if Player.blinkQueued then
		if Player.playBlinkAudio == true then
			love.audio.play(Player.blinkSound)
			Player.playBlinkAudio = false
		end
		Player.blinkTimer = Player.blinkTimer + (1 * dt)
		Player.canMove = false
		if Player.blinkTimer > 0.4 then
			Player.dx, Player.dy = 0, 0
			Player.x = Player.blinkTargetX - (Player.w / 2)
			Player.y = Player.blinkTargetY - (Player.h / 2)
			Player.currentMana = Player.currentMana - Player.blinkManaCost
			Player.blinkQueued = false
			Player.blinkTimer = 0
			Player.playBlinkAudio = true
			Player.canMove = true
		end
	end
	-- End Casting Blink

	-- Begin Keyboard Movement
	------ Accelerate
	if Player.canMove then
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
	if (not love.keyboard.isDown("a") or not Player.canMove) and Player.dx < 0 then
		if (Player.dx + (Player.dec * dt)) > 0 then
			Player.dx = 0
		else
			Player.dx = Player.dx + (Player.dec * dt)
		end
	end
	if (not love.keyboard.isDown("d") or not Player.canMove) and Player.dx > 0 then
		if (Player.dx - (Player.dec * dt)) < 0 then
			Player.dx = 0
		else	
			Player.dx = Player.dx - (Player.dec * dt)
		end
	end
	if (not love.keyboard.isDown("s") or not Player.canMove) and Player.dy > 0 then
		if (Player.dy - (Player.dec * dt) < 0) then
			Player.dy = 0
		else
			Player.dy = Player.dy - (Player.dec * dt)
		end
	end
	if (not love.keyboard.isDown("w") or not Player.canMove) and Player.dy < 0 then
		if (Player.dy + (Player.dec  * dt)) > 0 then
			Player.dy = 0
		else
			Player.dy = Player.dy + (Player.dec  * dt)
		end
	end
	------ End Decelerate
	-- End Keyboard Movement
	
	-- Begin Recharge Mana
	if Player.currentMana < Player.maxMana then
		if Player.currentMana + (Player.manaRechargeRate * dt) > Player.maxMana then
			Player.currentMana = Player.maxMana
		else
			Player.currentMana = Player.currentMana + (Player.manaRechargeRate * dt)
		end
	end
	-- End Recharge Mana
	
	hpDisplay:set("HP: " .. math.floor(Player.currentHp))
	manaDisplay:set("Mana: " .. math.floor(Player.currentMana))
	
	
end


function love.mousepressed(x, y)
	if Player.currentMana >= Player.blinkManaCost then
		Player.blinkTargetX, Player.blinkTargetY, Player.blinkQueued = x, y, true
	end
end


function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	
	if key == "`" then
		debug = not debug
	end
end


function love.draw(dt)

	love.graphics.draw(floortile, floorSprite, 0, 0)
	
	love.graphics.draw(spritesheet, Player.sprite, Player.x, Player.y)
	
	love.graphics.setLineWidth(0.5)
	love.graphics.setLineStyle("smooth")
	love.graphics.setColor(255, 255, 255, 0.2)
	love.graphics.line(0, my, love.graphics.getWidth(), my)
	love.graphics.line(mx, 0, mx, love.graphics.getHeight())
	love.graphics.setColor(255, 255, 255, 1)

	-- Begin Info Display
	if debug then
		love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
		love.graphics.print("x: " .. math.floor(Player.x) .. 
							",y: " .. math.floor(Player.y) , 10, 30)
		love.graphics.print("dx: " .. Player.dx .. ", dy: " .. Player.dy , 10, 50)
	end
	
	love.graphics.setColor(0, 255, 0, 0.8)
	love.graphics.draw(hpDisplay, love.graphics.getWidth() - 140, 10)
	love.graphics.draw(manaDisplay, love.graphics.getWidth() - 140, 40)
	love.graphics.setColor(255, 255, 255, 1)
	-- End Info Display
	
	

	
	
	
	
	
	
	
	
end
