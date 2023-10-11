TextureSynth = TextureSynth or {}
TextureSynth.TexElmCount = TextureSynth.TexElmCount or 0
TextureSynth.HasExporter = false
TextureSynth.ExporterPtr = nil
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
	for k, v in ipairs(TextureSynth.ElementsSortedList) do
		local elmThing = TextureSynth.Elements[v] -- hack :(...

		local yCalc = ((indElm % 11) * (24 + 8)) + 24
		local xCalc = (math.floor(indElm / 11) * (96 + 8)) + 8


		-- make a button for it
		local button_elm = LvLKUI.NewElement("button_elm_list" .. k, "button")
		button_elm:SetPriority(10)
		button_elm:SetPos({xCalc, yCalc})
		button_elm:SetSize({96, 24})
		button_elm:SetLabel(v)

		button_elm:SetOnClick(function(elm)
			local isExp = false
			if elmThing["isOutput"] then
				if TextureSynth.HasExporter == true then
					print("There's already an output!")
					return
				end

				TextureSynth.HasExporter = true
				isExp = true
			end

			TextureSynth.TexElmCount = TextureSynth.TexElmCount + 1
			-- spawn a tex element
			local tex_elm = LvLKUI.NewElement("texElm_" .. TextureSynth.TexElmCount, "texelement")
			tex_elm:SetPriority(1)
			tex_elm:SetPos({w * .5, h * .5})
			tex_elm:SetSize({128, 96})
			tex_elm:SetElementType(v)
			tex_elm:SetElementParameteri(elmThing)
			tex_elm:SetLabel(v)

			if isExp then
				tex_elm._isExp = isExp
				TextureSynth.ExporterPtr = tex_elm
			end

			LvLKUI.PushElement(tex_elm)
		end)


		LvLKUI.PushElement(button_elm, elm_list_add)

		indElm = indElm + 1
	end

	LvLKUI.PushElement(elm_list_add)
end

LvLKUI.EXPORT_NAME = ""

function TextureSynth.SetupSidePanel()
	local w, h = love.graphics.getDimensions()

	local panel_side = LvLKUI.NewElement("panel_side", "panel")
	panel_side:SetPriority(51200)
	panel_side:SetPos({0, 0})
	panel_side:SetSize({196, h})

	local button_add = LvLKUI.NewElement("button_add_panel", "button")
	button_add:SetPriority(200)
	button_add:SetPos({18, 32})
	button_add:SetSize({160, 48})
	button_add:SetLabel("Add element")

	button_add:SetOnClick(function()
		if LvLKUI.ActiveElements["elm_list_add"] then
			return
		end

		TextureSynth.SetupElementAddPanel()
	end)

	LvLKUI.PushElement(button_add, panel_side)

	local entry_name = LvLKUI.NewElement("entry_filename", "textentry")
	entry_name:SetPriority(200)
	entry_name:SetPos({18, 128})
	entry_name:SetSize({160, 24})
	entry_name:SetLabel("Export name")
	entry_name:SetMaxLength(40) -- 40 should be plenty
	entry_name:SetOnTextChange(function(_, new)
		LvLKUI.EXPORT_NAME = new
	end)
	LvLKUI.PushElement(entry_name, panel_side)

	local button_export = LvLKUI.NewElement("button_export", "button")
	button_export:SetPriority(200)
	button_export:SetPos({18, 160})
	button_export:SetSize({160, 48})
	button_export:SetLabel("Export to lua code")
	button_export:SetOnClick(function()
		if not TextureSynth.HasExporter then
			print("No output node!")
			return
		end

		if LvLKUI.EXPORT_NAME == "" then
			print("No export name given!")
			return
		end

		TextureSynth.ExportAtElement(TextureSynth.ExporterPtr, LvLKUI.EXPORT_NAME)
	end)
	LvLKUI.PushElement(button_export, panel_side)

	local button_export_lpn = LvLKUI.NewElement("button_export_lpn", "button")
	button_export_lpn:SetPriority(200)
	button_export_lpn:SetPos({18, 224})
	button_export_lpn:SetSize({160, 48})
	button_export_lpn:SetLabel("Export to LPN")
	button_export_lpn:SetOnClick(function()
		if LvLKUI.EXPORT_NAME == "" then
			print("No export name given!")
			return
		end

		TextureSynth.ExportLPN(LvLKUI.EXPORT_NAME)
	end)
	LvLKUI.PushElement(button_export_lpn, panel_side)




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