TextureSynth = TextureSynth or {}
TextureSynth.TexElmCount = TextureSynth.TexElmCount or 0
function TextureSynth.SetupElementAddPanel()
	print("add")
	local w, h = love.graphics.getDimensions()

	local elm_list_add = LvLKUI.NewElement("elm_list_add", "frame")
	elm_list_add:SetPriority(512000)
	elm_list_add:SetPos({196 + 16, 16})
	elm_list_add:SetSize({256 + 256 + 16, 256 + 128})
	elm_list_add:SetLabel("Element List")
	--elm_list_add:SetCloseDisabled(true)


	-- setup all the shit
	local indElm = 0
	for k, v in pairs(TextureSynth.Elements) do
		local yCalc = ((indElm % 11) * (24 + 8)) + 24
		local xCalc = (math.floor(indElm / 11) * (96 + 8)) + 8


		-- make a button for it
		local button_elm = LvLKUI.NewElement("button_elm_list" .. k, "button")
		button_elm:SetPriority(10)
		button_elm:SetPos({xCalc, yCalc})
		button_elm:SetSize({96, 24})
		button_elm:SetLabel(k)

		button_elm:SetOnClick(function(elm)
			TextureSynth.TexElmCount = TextureSynth.TexElmCount + 1
			-- spawn a tex element
			local tex_elm = LvLKUI.NewElement("texElm_" .. TextureSynth.TexElmCount, "texelement")
			tex_elm:SetPriority(1)
			tex_elm:SetPos({w * .5, h * .5})
			tex_elm:SetSize({128, 96})
			tex_elm:SetElementType(k)
			tex_elm:SetElementParameteri(v)
			tex_elm:SetLabel(k)

			LvLKUI.PushElement(tex_elm)
		end)


		LvLKUI.PushElement(button_elm, elm_list_add)

		indElm = indElm + 1
	end

	LvLKUI.PushElement(elm_list_add)
end

function TextureSynth.SetupSidePanel()
	local w, h = love.graphics.getDimensions()

	local panel_side = LvLKUI.NewElement("panel_side", "panel")
	panel_side:SetPriority(51200)
	panel_side:SetPos({0, 0})
	panel_side:SetSize({196, h})

	local button_add = LvLKUI.NewElement("button_add_panel", "button")
	button_add:SetPriority(200)
	button_add:SetPos({32, 32})
	button_add:SetSize({128, 48})
	button_add:SetLabel("Add element")

	button_add:SetOnClick(function()
		if LvLKUI.ActiveElements["elm_list_add"] then
			return
		end

		TextureSynth.SetupElementAddPanel()
	end)

	LvLKUI.PushElement(button_add, panel_side)

	TextureSynth.InitConfigPanel(panel_side)


	LvLKUI.PushElement(panel_side)
end


LvLK3D.NewTextureFunc("previewTex", 256, 256, function(w, h)
	love.graphics.setColor(0.6, 0.8, 0.6)
	love.graphics.rectangle("fill", 0, 0, w * .5, h * .5)
	love.graphics.rectangle("fill", w * .5, h * .5, w * .5, h * .5)

	love.graphics.setColor(0.3, 0.5, 0.3)
	love.graphics.rectangle("fill", w * .5, 0, w * .5, h * .5)
	love.graphics.rectangle("fill", 0, h * .5, w * .5, h * .5)

	local fontLarge = love.graphics.newFont(24)
	local textLarge = love.graphics.newText(fontLarge, "/!\\ No Texture /!\\")
	local tw, th = textLarge:getDimensions()


	love.graphics.setColor(0, 0, 0, 1)
	for i = 1, 3 do
		love.graphics.draw(textLarge, ((w * .5) - (tw * .5)) + i, ((h * .5) - (th * .5)) + i)
	end

	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.draw(textLarge, (w * .5) - (tw * .5), (h * .5) - (th * .5))
end)


function TextureSynth.SetupUI()
	TextureSynth.SetupSidePanel()
	TextureSynth.SetupPreviewFrame()
	TextureSynth.SetupPreviewFrame2D()
end

function TextureSynth.UpdatePreviewTexture()
	TextureSynth.UpdatePreviewTexture2D()
	TextureSynth.UpdatePreviewTexture3D()
end