TextureSynth = TextureSynth or {}
TextureSynth.ConfigPanel = nil
function TextureSynth.SetupConfigPanel(elm)
	TextureSynth.ConfigPanel:ClearAll()
	TextureSynth.ConfigPanel.SetupToElement(TextureSynth.ConfigPanel, elm)
end

function TextureSynth.InitConfigPanel(parent)
	local w, h = love.graphics.getDimensions()

	local fractPanel = .6
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

	local function addStringParam(elmTarget, index, numIndex, elm, fancyName)
		local yCalc = numIndex * (18 + 24)
		local label_idx = LvLKUI.NewElement("label_idx_" .. numIndex, "label")
		label_idx:SetPriority(10)
		label_idx:SetPos({196 * .5, yCalc})
		label_idx:SetLabel(fancyName)
		label_idx:SetAlignMode({1, 0})
		LvLKUI.PushElement(label_idx, elm)


		local elmParams = elmTarget:GetParameters()

		local entry_param = LvLKUI.NewElement("entry_idx_" .. numIndex, "textentry")
		entry_param:SetPos({16, yCalc + 16})
		entry_param:SetSize({196 - 32, 24})
		entry_param:SetLabel(fancyName)
		entry_param:SetText(elmParams[index])
		entry_param:SetOnTextChange(function(_, new)
			elmParams[index] = new
		end)
		LvLKUI.PushElement(entry_param, elm)
	end

	local function addNumParam(elmTarget, index, numIndex, elm, fancyName)
		local yCalc = numIndex * (18 + 24)
		local label_idx = LvLKUI.NewElement("label_idx_" .. numIndex, "label")
		label_idx:SetPriority(10)
		label_idx:SetPos({196 * .5, yCalc})
		label_idx:SetLabel(fancyName)
		label_idx:SetAlignMode({1, 0})
		LvLKUI.PushElement(label_idx, elm)


		local elmParams = elmTarget:GetParameters()

		local entry_param = LvLKUI.NewElement("entry_idx_" .. numIndex, "textentry")
		entry_param:SetPos({16, yCalc + 16})
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

	function panel_config.SetupToElement(elm, elmTarget)
		local paramIndex = 1

		local elmParams, paramLookups = elmTarget:GetParameters()
		for k, v in ipairs(elmParams) do
			local fancyName = paramLookups[k]

			if type(v) == "number" then
				addNumParam(elmTarget, k, paramIndex, elm, fancyName)
			elseif type(v) == "string" then
				addStringParam(elmTarget, k, paramIndex, elm, fancyName)
			end

			paramIndex = paramIndex + 1
		end
	end

	TextureSynth.ConfigPanel = panel_config
	LvLKUI.PushElement(panel_config, parent)
end