LvLKUI = LvLKUI or {}
LvLKUI.GLOBAL_DRAGGING = LvLKUI.GLOBAL_DRAGGING or false
LvLKUI.GLOBAL_WIRING = LvLKUI.GLOBAL_WIRING or false
LvLKUI.GLOBAL_WIRING_MODE = LvLKUI.GLOBAL_WIRING_MODE or 1
LvLKUI.GLOBAL_WIRING_SRC = LvLKUI.GLOBAL_WIRING_SRC or nil
LvLKUI.GLOBAL_WIRING_SRC_ID = LvLKUI.GLOBAL_WIRING_SRC_ID or 0

local function copyTable(tbl)
	local new = {}

	for k, v in pairs(tbl) do
		if type(v) == "table" then
			new[k] = copyTable(v)
		else
			new[k] = v
		end
	end

	return new
end


local function copy(obj)
	if type(obj) == "table" then
		return copyTable(obj)
	else
		return obj
	end
end


LvLKUI.DeclareComponent("texelement", {
	["MOUSE_HOVER_EXTERNAL"] = true,
	["_isDragging"] = false,
	["_elementType"] = "none",
	["_elementParameteri"] = {},

	["label"] = "TexElement",
	["_textLabelObj"] = nil,

	["inputIndices"] = {},
	["inputs"] = {},

	["outputIndices"] = {},
	["outputs"] = {},

	["_inCount"] = 0,
	["_outCount"] = 0,
	["_isTexElement"] = true, -- hacks and hacks and hacks

	["SetElementType"] = function(elm, etype)
		elm._elementType = etype or "none"
	end,

	["GetElementType"] = function(elm)
		return elm._elementType
	end,

	["SetElementParameteri"] = function(elm, params)
		elm._elementParameteri = copy(params)

		elm.setupParameteriOptions(elm)
	end,

	["GetParameters"] = function(elm)
		local parameteri = elm._elementParameteri
		return parameteri.params, parameteri.paramLookups, parameteri.paramTypes
	end,

	-- this is called last, its like a late init
	["setupParameteriOptions"] = function(elm)
		print("::parameter setup for \"" .. elm._elementType .. "\"")

		if elm._elementParameteri.inputs then
			elm.setupInputs(elm)
		end
		if elm._elementParameteri.outputs then
			elm.setupOutputs(elm)
		end
	end,

	["setupInputs"] = function(elm)
		local inputs = elm._elementParameteri.inputs
		local inCount = #inputs
		print("::" .. inCount .. " inputs")

		local elmSize = elm.size
		local center = elmSize[2] * .5
		local bTall = 24

		for k, v in ipairs(inputs) do
			local yc = center - (bTall * (inCount / 2)) + (bTall * (k - .5))
			local bIn = LvLKUI.NewElement("bIn_TexElement_" .. k, "wirebutton")
			bIn:SetPriority(30)
			bIn:SetPos({0, yc})
			bIn:SetSize({32, 16})
			bIn:SetLabel(v .. ">")
			bIn:SetWireType(1)
			LvLKUI.PushElement(bIn, elm)

			elm.inputIndices[k] = v
			elm.inputs[k] = bIn
		end

		print("::input indices::")
		LvLKUI.PrintTable(elm.inputIndices)
		elm._inCount = inCount
	end,

	["setupOutputs"] = function(elm)
		local outputs = #elm._elementParameteri.outputs
		local outCount = outputs
		print("::" .. outCount .. " outputs")

		local elmSize = elm.size
		local center = elmSize[2] * .5
		local bTall = 24

		for k, v in pairs(elm._elementParameteri.outputs) do
			local yc = center - (bTall * (outCount / 2)) + (bTall * (k - .5))
			local bOut = LvLKUI.NewElement("bOut_TexElement_" .. k, "wirebutton")
			bOut:SetPriority(30)
			bOut:SetPos({elmSize[1] - 32, yc})
			bOut:SetSize({32, 16})
			bOut:SetLabel(v .. ">")
			bOut:SetWireType(2)
			LvLKUI.PushElement(bOut, elm)

			elm.outputIndices[k] = v
			elm.outputs[k] = bOut
		end

		print("::output indices::")
		LvLKUI.PrintTable(elm.outputIndices)
		elm._outCount = outCount
	end,

	-- what to do when we're initialized
	["onInit"] = function(elm)
		local theme = LvLKUI.Themes[elm.theme]
		elm._textLabelObj = love.graphics.newText(theme._fontObj, elm.label)

		local elmSize = elm.size
		local bCompute = LvLKUI.NewElement("bCompute", "button")
		bCompute:SetPriority(30)
		bCompute:SetPos({elmSize[1] - 16, elmSize[2] - 16})
		bCompute:SetSize({16, 16})
		bCompute:SetLabel("C")
		bCompute:SetOnClick(function()
			TextureSynth.ComputeAtElement(elm)
		end)

		LvLKUI.PushElement(bCompute, elm)

		local bClose = LvLKUI.NewElement("bClose", "button")
		bClose:SetPriority(30)
		bClose:SetPos({elmSize[1] - 16, 0})
		bClose:SetSize({16, 16})
		bClose:SetLabel("X")
		bClose:SetOnClick(function()
			if LvLKUI.GLOBAL_WIRING then
				local other = LvLKUI.GLOBAL_WIRING_SRC
				other._wiringRender = false
				LvLKUI.GLOBAL_WIRING = false
			end


			for k, v in ipairs(elm.inputs) do
				print("deattach Ink:" .. k)
				v:DeAttach()
			end

			for k, v in ipairs(elm.outputs) do
				print("deattach Outk:" .. k)
				v:DeAttach()
			end

			elm:Remove()
		end)
		bClose:SetColourOverride(elm.colOverridePrimary, elm.colOverrideSecondary, {1, 0.25, 0.25})

		LvLKUI.PushElement(bClose, elm)
	end,

	-- what to do when the label changes
	["onLabelChange"] = function(elm)
		elm._textLabelObj:set(elm.label)

		local theme = LvLKUI.Themes[elm.theme]
		elm._textLabelObj:setFont(theme._fontObj)
	end,

	["onSizeChange"] = function(elm)
		local elmSize = elm.size

		local bCompute = elm:GetChild("bCompute")
		bCompute:SetPos({elmSize[1] - 16, elmSize[2] - 16})

		local bClose = elm:GetChild("bClose")
		bClose:SetPos({elmSize[1] - 16, 0})
	end,

	-- what to do each tick?
	["onThink"] = function()

	end,

	-- what to do when clicked?
	["onClick"] = function(elm, mx, my, button)
		TextureSynth.SelectedElement = elm
		TextureSynth.SetupConfigPanel(elm)
	end,

	-- what to do when hovering?
	["onHover"] = function(elm, mx, my, hit, rx, ry)
		-- wow more terrible hacks
		if LvLKUI.GLOBAL_DRAGGING and LvLKUI.GLOBAL_DRAGGING ~= elm then
			return
		end

		if not elm._isDragging then
			if not hit then
				return
			end

			if not love.mouse.isDown(1) then
				return
			end

			local elmSize = elm.size

			if not LvLKUI.Inrange2D({mx, my}, {0, 0}, {elmSize[1], elmSize[2]}) then
				return
			end

			elm._isDragging = true
			elm._relativePickup = {mx, my}

			LvLKUI.GLOBAL_DRAGGING = elm
		else
			if not love.mouse.isDown(1) then
				elm._isDragging = false
				LvLKUI.GLOBAL_DRAGGING = nil
				return
			end


			local rmx, rmy = love.mouse.getPosition()
			local rela = elm._relativePickup
			elm:SetPos({-rela[1] + rmx, -rela[2] + rmy})
		end
	end,

	-- what to draw when drawing? (children are handled automatically)
	["onPaint"] = function(elm, w, h, colPrimary, colSecondary, colHighlight, font)
		love.graphics.setColor(colSecondary[1], colSecondary[2], colSecondary[3])
		love.graphics.rectangle("fill", 0, 0, w, h)

		local _addSel = TextureSynth.SelectedElement == elm and .5 or 0

		love.graphics.setColor(colPrimary[1] + _addSel, colPrimary[2] + _addSel, colPrimary[3] + _addSel)
		love.graphics.setLineWidth(4)
		love.graphics.rectangle("line", 0, 0, w, h)


		-- align to center
		local textWide, textTall = elm._textLabelObj:getDimensions()

		love.graphics.setColor(colHighlight[1], colHighlight[2], colHighlight[3])
		love.graphics.draw(elm._textLabelObj, (w * .5) - (textWide * .5), 18)
	end,

	-- what to do when we're removed?
	["onRemove"] = function(elm)
		if elm._isExp then
			print("removal of global is output")
			TextureSynth.HasExporter = false
		end
	end,
})