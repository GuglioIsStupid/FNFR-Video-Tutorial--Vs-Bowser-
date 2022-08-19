local song, difficulty

local stageBack, stageFront, curtains

return {
	enter = function(self, from, songNum, songAppend)
		weeks:enter()

		song = songNum
		difficulty = songAppend
        cam.sizeX, cam.sizeY = 0.75, 0.75
        camScale.x, camScale.y = 0.75, 0.75

		enemy = love.filesystem.load("sprites/characters/bowser.lua")()
        love.graphics.setBackgroundColor(1,1,1)

		enemy.x, enemy.y = 0, 0

		enemyIcon:animate("bowser", false)

		self:load()
	end,

	load = function(self)
		weeks:load()

		inst = love.audio.newSource("music/blackjack/Inst.ogg", "stream")
		voices = love.audio.newSource("music/blackjack/Voices.ogg", "stream")

		self:initUI()

		weeks:setupCountdown()
	end,

	initUI = function(self)
		weeks:initUI()

		weeks:generateNotes(love.filesystem.load("charts/blackjack/blackjack.lua")())
	end,

	update = function(self, dt)
		weeks:update(dt)

		if health >= 80 then
			if enemyIcon:getAnimName() == "bowser" then
				enemyIcon:animate("bowser losing", false)
			end
		else
			if enemyIcon:getAnimName() == "bowser losing" then
				enemyIcon:animate("bowser", false)
			end
		end

		if not (countingDown or graphics.isFading()) and not (inst:isPlaying() and voices:isPlaying()) then
			status.setLoading(true)

			graphics.fadeOut(
				0.5,
				function()
					Gamestate.switch(menu)

					status.setLoading(false)
				end
			)
		end

		weeks:updateUI(dt)
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(cam.sizeX, cam.sizeY)

			love.graphics.push()
			    enemy:draw()
			love.graphics.pop()
			weeks:drawRating(0.9)
		love.graphics.pop()

		weeks:drawUI()
	end,

	leave = function(self)
		weeks:leave()
        love.graphics.setColor(0,0,0)
	end
}
