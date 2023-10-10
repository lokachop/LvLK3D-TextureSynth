function love.load()
	love.filesystem.load("/lvlk3d/lvlk3d.lua")()
	love.filesystem.load("/lvlkui/lvlkui.lua")()
	love.filesystem.load("/texturesynth.lua")()
	love.keyboard.setKeyRepeat(true)
	CurTime = 0

	TextureSynth.SetupUI()
end

function love.update(dt)
	CurTime = CurTime + dt

	LvLKUI.TriggerThink(dt)
end

function love.textinput(t)
	LvLKUI.TriggerKeypress(t, false)
end

function love.keypressed(key)
	LvLKUI.TriggerKeypress(key, true)
end

function love.mousepressed(x, y, button)
	LvLKUI.TriggerClick(x, y, button)
end

function love.mousemoved(x, y)
	LvLKUI.TriggerHover(x, y)
end


function love.draw()
	love.graphics.clear()
	LvLKUI.DrawAll()
end