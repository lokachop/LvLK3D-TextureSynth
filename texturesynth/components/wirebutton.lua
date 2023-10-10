LvLKUI = LvLKUI or {}
LvLKUI.GLOBAL_WIRING = LvLKUI.GLOBAL_WIRING or false
LvLKUI.GLOBAL_WIRING_MODE = LvLKUI.GLOBAL_WIRING_MODE or 1
LvLKUI.GLOBAL_WIRING_SRC = LvLKUI.GLOBAL_WIRING_SRC or nil

local cursorClick = love.mouse.getSystemCursor("hand")

LvLKUI.DeclareComponent("wirebutton", {
	["label"] = "Wire Button",
	["_isHovered"] = false,
	["MOUSE_HOVER_EXTERNAL"] = true,
	["MOUSE_CLICK_EXTERNAL"] = false,
	["_textLabelObj"] = nil,
	["isDisabled"] = false,

	["wireType"] = 0,
	["connection"] = nil,

	["_wiringRender"] = false,
	["_wiredRender"] = false,

	["isWired"] = false,

	["SetWireType"] = function(elm, wType)
		elm.wireType = wType
	end,

	["GetConnection"] = function(elm, wType)
		elm.wireType = wType
	end,

	-- what to do when we're initialized
	["onInit"] = function(elm)
		local theme = LvLKUI.Themes[elm.theme]

		elm._textLabelObj = love.graphics.newText(theme._fontObj, elm.label)
	end,

	-- what to do each tick?
	["onThink"] = function(elm)
		if elm.isWired and (elm.connection == nil) then
			elm.isWired = false
			elm._wiredRender = false
		end
	end,

	["DeAttach"] = function(elm)
		if elm.connection == nil then
			return
		end

		local connected = elm.connection
		connected.connection = nil
		connected.isWired = false
		connected._wiredRender = false

		elm.connection = nil
		elm.isWired = false
		elm._wiredRender = false
	end,

	-- what to do when clicked?
	["onClick"] = function(elm, mx, my, button, hit)
		if button == 2 and (elm.connection ~= nil) then
			elm:DeAttach()
			return
		end

		if button ~= 1 then
			return
		end

		if elm.connection ~= nil then
			return
		end


		if not LvLKUI.GLOBAL_WIRING then
			LvLKUI.GLOBAL_WIRING_MODE = elm.wireType
			LvLKUI.GLOBAL_WIRING_SRC = elm
			LvLKUI.GLOBAL_WIRING = true

			elm._wiringRender = true
			return
		end

		local other = LvLKUI.GLOBAL_WIRING_SRC
		if other == elm then
			print("Can't wire to self...")
			return
		end

		if other._parent == elm._parent then
			print("Can't wire to same parent...")
			return
		end

		local mode = LvLKUI.GLOBAL_WIRING_MODE
		if mode == elm.wireType then
			print("Can't wire same type..")
			return
		end

		elm.connection = other
		other.connection = elm

		elm.isWired = true
		other.isWired = true

		other._wiredRender = true
		other._wiringRender = false

		LvLKUI.GLOBAL_WIRING = false
	end,

	-- what to do when hovering?
	["onHover"] = function(elm, mx, my, hit)
		elm._isHovered = hit

		if hit then
			love.mouse.setCursor(cursorClick)
		else
			love.mouse.setCursor()
		end
	end,

	-- what to do when the label changes
	["onLabelChange"] = function(elm)
		elm._textLabelObj:set(elm.label)

		local theme = LvLKUI.Themes[elm.theme]
		elm._textLabelObj:setFont(theme._fontObj)
	end,


	-- what to draw when drawing? (children are handled automatically)
	["onPaint"] = function(elm, w, h, colPrimary, colSecondary, colHighlight, font)
		local _addHover = elm._isHovered and 0.1 or 0.0
		local _addMouse = (elm._isHovered and love.mouse.isDown(1)) and 0.2 or 0

		local _add = _addHover + _addMouse

		love.graphics.setColor(colSecondary[1] + _add, colSecondary[2] + _add, colSecondary[3] + _add)
		love.graphics.rectangle("fill", 0, 0, w, h)

		love.graphics.setColor(colPrimary[1] + _add, colPrimary[2] + _add, colPrimary[3] + _add)
		love.graphics.setLineWidth(2)
		love.graphics.rectangle("line", 0, 0, w, h)

		-- align to center
		local textWide, textTall = elm._textLabelObj:getDimensions()

		love.graphics.setColor(colHighlight[1], colHighlight[2], colHighlight[3])
		love.graphics.draw(elm._textLabelObj, (w * .5) - (textWide * .5), (h * .5) - (textTall * .5))


		if elm._wiringRender then
			local selfPos = elm.pos
			local parentPos = elm._parent.pos

			local globalPos = {selfPos[1] + parentPos[1], selfPos[2] + parentPos[2]}

			local xc = elm.wireType == 1 and 0 or w
			local yc = h * .5

			local mx, my = love.mouse.getPosition()
			love.graphics.setColor(1, 0, 0, 1)
			love.graphics.setLineWidth(3)
			love.graphics.line(mx - globalPos[1], my - globalPos[2], xc, yc)
		end


		if elm._wiredRender then
			local selfPos = elm.pos
			local parentPos = elm._parent.pos
			local globalPosSelf = {selfPos[1] + parentPos[1], selfPos[2] + parentPos[2]}


			local other = elm.connection
			if not other then
				return
			end

			local otherPos = other.pos
			local otherparentPos = other._parent.pos
			local globalPosOther = {otherPos[1] + otherparentPos[1], otherPos[2] + otherparentPos[2]}

			love.graphics.setColor(0.5, 0, 0, 1)
			love.graphics.setLineWidth(1.5)

			local xc = elm.wireType == 1 and 0 or w
			local yc = h * .5

			local xcOther = elm.wireType == 1 and w or 0
			local ycOther = h * .5

			love.graphics.line((globalPosOther[1] + xcOther) - globalPosSelf[1], (globalPosOther[2] + ycOther) - globalPosSelf[2], xc, yc)
		end
	end,

	-- what to do when we're removed?
	["onRemove"] = function()
	end,
})