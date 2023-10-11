LvLKUI = LvLKUI or {}

LvLKUI.DeclareComponent("rgbentry", {
	["_valRGB"] = {0, 0, 0},

	-- what to do when we're initialized
	["onInit"] = function(elm)
		local elmSize = elm.size

		local wEnt = elmSize[1] / 3
		local wEntSpace = elmSize[1] / 4

		local entry_r = LvLKUI.NewElement("entry_red", "textentry")
		entry_r:SetPos({0, 0})
		entry_r:SetSize({wEntSpace, elmSize[2]})
		entry_r:SetLabel("R")
		entry_r:SetNumericalOnly(true)
		entry_r:SetText("0")
		entry_r:SetOnTextChange(function(elmNew, new)
			elm._valRGB[1] = (tonumber(new) or elm._valRGB[1])
			elm.onChange(elm, elm._valRGB, 1)
		end)
		entry_r:SetColourOverride({0.4, 0.3, 0.3}, {0.125, 0.1, 0.1}, {1, 0.8, 0.8})
		LvLKUI.PushElement(entry_r, elm)


		local entry_g = LvLKUI.NewElement("entry_green", "textentry")
		entry_g:SetPos({wEnt, 0})
		entry_g:SetSize({wEntSpace, elmSize[2]})
		entry_g:SetLabel("R")
		entry_g:SetNumericalOnly(true)
		entry_g:SetText("0")
		entry_g:SetOnTextChange(function(elmNew, new)
			elm._valRGB[2] = (tonumber(new) or elm._valRGB[2])
			elm.onChange(elm, elm._valRGB, 2)
		end)
		entry_g:SetColourOverride({0.3, 0.4, 0.3}, {0.1, 0.125, 0.1}, {0.8, 1, 0.8})
		LvLKUI.PushElement(entry_g, elm)


		local entry_b = LvLKUI.NewElement("entry_blue", "textentry")
		entry_b:SetPos({wEnt * 2, 0})
		entry_b:SetSize({wEntSpace, elmSize[2]})
		entry_b:SetLabel("R")
		entry_b:SetNumericalOnly(true)
		entry_b:SetText("0")
		entry_b:SetOnTextChange(function(elmNew, new)
			elm._valRGB[3] = (tonumber(new) or elm._valRGB[3])
			elm.onChange(elm, elm._valRGB, 3)
		end)
		entry_b:SetColourOverride({0.3, 0.3, 0.4}, {0.1, 0.1, 0.125}, {0.8, 0.8, 1})
		LvLKUI.PushElement(entry_b, elm)
	end,

	["onChange"] = function(elm, val, idx)
	end,

	["SetOnChange"] = function(elm, func)
		if not func then
			return
		end

		elm.onChange = func
	end,

	["SetRGB"] = function(elm, r, g, b)
		elm._valRGB = {
			r or 255,
			g or 255,
			b or 255,
		}

		local entry_r = elm:GetChild("entry_red")
		entry_r:SetText(r or 255)

		local entry_g = elm:GetChild("entry_green")
		entry_g:SetText(g or 255)

		local entry_b = elm:GetChild("entry_blue")
		entry_b:SetText(b or 255)
	end,

	["onSizeChange"] = function(elm)
		local elmSize = elm.size
		local wEnt = elmSize[1] / 3
		local wEntSpace = elmSize[1] / 4

		local entry_r = elm:GetChild("entry_red")
		entry_r:SetPos({0, 0})
		entry_r:SetSize({wEntSpace, elmSize[2]})

		local entry_g = elm:GetChild("entry_green")
		entry_g:SetPos({wEnt, 0})
		entry_g:SetSize({wEntSpace, elmSize[2]})

		local entry_b = elm:GetChild("entry_blue")
		entry_b:SetPos({wEnt * 2, 0})
		entry_b:SetSize({wEntSpace, elmSize[2]})
	end,

	-- what to do each tick?
	["onThink"] = function()

	end,

	-- what to do when clicked?
	["onClick"] = function(elm, mx, my, button)

	end,

	-- what to do when hovering?
	["onHover"] = function(elm, mx, my)

	end,

	-- what to draw when drawing? (children are handled automatically)
	["onPaint"] = function(elm, w, h, colPrimary, colSecondary, colHighlight, font)
		love.graphics.setColor(colSecondary[1], colSecondary[2], colSecondary[3])
		love.graphics.rectangle("fill", 0, 0, w, h)

		--love.graphics.setColor(colPrimary[1], colPrimary[2], colPrimary[3])
		--love.graphics.setLineWidth(4)
		--love.graphics.rectangle("line", 0, 0, w, h)
	end,

	-- what to do when we're removed?
	["onRemove"] = function()

	end,
})