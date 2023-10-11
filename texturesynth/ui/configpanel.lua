TextureSynth = TextureSynth or {}
TextureSynth.ConfigPanel = nil
function TextureSynth.SetupConfigPanel(elm)
	TextureSynth.ConfigPanel:ClearAll()
	TextureSynth.ConfigPanel.SetupToElement(TextureSynth.ConfigPanel, elm)
end

function TextureSynth.InitConfigPanel(parent)
	local w, h = love.graphics.getDimensions()

	local fractPanel = .5
	local invFract = 1 - fractPanel

	local panel_config = LvLKUI.NewElement("panel_config", "panel")
	panel_config:SetPriority(51200)
	panel_config:SetPos({0, h * invFract})
	panel_config:SetSize({196, h * fractPanel})

	local panel_config_label = LvLKUI.NewElement("panel_config_label", "label")
	panel_config_label:SetPriority(51200)
	panel_config_label:SetPos({196 * .5, 16})
	panel_config_label:SetLabel("Config")
	panel_config_label:SetAlignMode({1, 1})

	LvLKUI.PushElement(panel_config_label, panel_config)


	function panel_config:ClearAll()
		for k, v in pairs(panel_config.children) do
			if k ~= "panel_config_label" then
				v:Remove()
			end
		end
	end

	local function addStringParam(elmTarget, index, yOffset, elm, fancyName)
		local elmParams = elmTarget:GetParameters()

		local entry_param = LvLKUI.NewElement("entry_idx_" .. index, "textentry")
		entry_param:SetPos({16, yOffset})
		entry_param:SetSize({196 - 32, 24})
		entry_param:SetLabel(fancyName)
		entry_param:SetText(elmParams[index])
		entry_param:SetOnTextChange(function(_, new)
			elmParams[index] = new
		end)
		LvLKUI.PushElement(entry_param, elm)
	end

	local function addNumParam(elmTarget, index, yOffset, elm, fancyName)
		local elmParams = elmTarget:GetParameters()

		local entry_param = LvLKUI.NewElement("entry_idx_" .. index, "textentry")
		entry_param:SetPos({16, yOffset})
		entry_param:SetSize({196 - 32, 24})
		entry_param:SetLabel(fancyName)
		entry_param:SetNumericalOnly(true)
		entry_param:SetAllowDecimals(true)
		entry_param:SetText(tonumber(elmParams[index]))
		entry_param:SetOnTextChange(function(_, new)
			elmParams[index] = tonumber(new) or 0
		end)
		LvLKUI.PushElement(entry_param, elm)
	end

	local function addColourParam(elmTarget, index, yOffset, elm, fancyName)
		local elmParams = elmTarget:GetParameters()

		local entry_param_rgb = LvLKUI.NewElement("entry_idx_" .. index, "rgbentry")
		entry_param_rgb:SetPos({16, yOffset})
		entry_param_rgb:SetSize({196 - 32, 24})
		entry_param_rgb:SetOnChange(function(_, new, idx)
			elmParams[index][idx] = new[idx]
		end)
		LvLKUI.PushElement(entry_param_rgb, elm)
		entry_param_rgb:SetRGB(elmParams[index][1], elmParams[index][2], elmParams[index][3])
	end


	local function addTableParam(elmTarget, index, yOffset, elm, fancyName)
		local _, _, paramTypes = elmTarget:GetParameters()

		local paramType = paramTypes[index]
		-- check the param type...

		if paramType == "colour" then
			addColourParam(elmTarget, index, yOffset, elm, fancyName)
		end
	end

	local function addLabel(elmTarget, index, yOffset, elm, fancyName)
		local label_idx = LvLKUI.NewElement("label_idx_" .. index, "label")
		label_idx:SetPriority(10)
		label_idx:SetPos({196 * .5, yOffset})
		label_idx:SetLabel(fancyName)
		label_idx:SetAlignMode({1, 0})
		LvLKUI.PushElement(label_idx, elm)
	end

	function panel_config.SetupToElement(elm, elmTarget)
		local yOff = 32
		local paramIndex = 1

		local elmParams, paramLookups = elmTarget:GetParameters()
		for k, v in ipairs(elmParams) do
			local fancyName = paramLookups[k]
			addLabel(elmTarget, k, yOff, elm, fancyName)
			yOff = yOff + 24

			if type(v) == "number" then
				addNumParam(elmTarget, k, yOff, elm, fancyName)
				yOff = yOff + 42
			elseif type(v) == "string" then
				addStringParam(elmTarget, k, yOff, elm, fancyName)
				yOff = yOff + 42
			elseif type(v) == "table" then
				addTableParam(elmTarget, k, yOff, elm, fancyName)
				yOff = yOff + 42
			end

			paramIndex = paramIndex + 1
		end
	end

	TextureSynth.ConfigPanel = panel_config
	LvLKUI.PushElement(panel_config, parent)
end