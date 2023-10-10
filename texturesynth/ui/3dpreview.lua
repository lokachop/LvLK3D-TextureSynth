TextureSynth = TextureSynth or {}
LvLK3D = LvLK3D or {}

local UnivPreview = LvLK3D.NewUniverse("Preview_TexSynth")
local RTPreview = LvLK3D.NewRenderTarget("Preview_TexSynth_RT", 256, 256)

local function setLK3DFlagAndRefresh(flag, val)
	LvLK3D.PushUniverse(UnivPreview)
		LvLK3D.SetObjectFlag("cube_showtex", flag, val)
		LvLK3D.UpdateObjectMesh("cube_showtex")
	LvLK3D.PopUniverse()
end


local function setLK3DModelAndRefresh(mdl)
	LvLK3D.PushUniverse(UnivPreview)
	LvLK3D.SetObjectModel("cube_showtex", mdl)
		LvLK3D.UpdateObjectMesh("cube_showtex")
	LvLK3D.PopUniverse()
end

local function addFlagToggleButton(parent, name, flag, id)
	local button_flag = LvLKUI.NewElement("button_flag_" .. flag, "button")
	button_flag:SetPriority(10)
	button_flag:SetPos({8, id * (24 + 8)})
	button_flag:SetSize({96, 24})
	button_flag:SetLabel(name)

	button_flag:SetOnClick(function(elm)
		elm._flagToggle = not (elm._flagToggle or false)
		setLK3DFlagAndRefresh(flag, elm._flagToggle)
	end)

	LvLKUI.PushElement(button_flag, parent)
end

local function addModelToggleButton(parent, name, model, id)
	local button_mdl = LvLKUI.NewElement("button_model_" .. model, "button")
	button_mdl:SetPriority(10)
	button_mdl:SetPos({8, id * (24 + 8)})
	button_mdl:SetSize({96, 24})
	button_mdl:SetLabel(name)

	button_mdl:SetOnClick(function(elm)
		setLK3DModelAndRefresh(model)
	end)

	LvLKUI.PushElement(button_mdl, parent)
end

function TextureSynth.UpdatePreviewTexture3D()
	LvLK3D.PushUniverse(UnivPreview)
		LvLK3D.SetObjectMat("cube_showtex", "previewTex")
		LvLK3D.UpdateObjectMesh("cube_showtex")
	LvLK3D.PopUniverse()
end


function TextureSynth.SetupPreviewFrame()
	LvLK3D.PushUniverse(UnivPreview)
		LvLK3D.SetSunLighting(false)
		LvLK3D.SetSunCol({1, 1, 1})


		LvLK3D.AddObjectToUniv("cube_showtex", "cube")
		LvLK3D.SetObjectPos("cube_showtex", Vector(0, 0, 0))
		LvLK3D.SetObjectMat("cube_showtex", "previewTex")
		LvLK3D.UpdateObjectMesh("cube_showtex")
		--LvLK3D.SetObjectShadow("cube_showtex", true)
	LvLK3D.PopUniverse()


	LvLK3D.BuildProjectionMatrix(1, 0.01, 1000)


	local w, h = love.graphics.getDimensions()

	local frame_preview = LvLKUI.NewElement("frame_preview", "frame")
	frame_preview:SetPriority(5120)
	frame_preview:SetPos({w - 256 - 96 - 18, h - 256 - 18})
	frame_preview:SetSize({256 + 96 + 18, 256 + 18})
	frame_preview:SetLabel("3D preview")
	frame_preview:SetCloseDisabled(true)


	local panel_view = LvLKUI.NewElement("panel_view", "panel")
	panel_view:SetPriority(5120)
	panel_view:SetPos({96 + 18, 18})
	panel_view:SetSize({256, 256})

	panel_view:SetOnPaint(function(elm, w, h)
		LvLK3D.PushUniverse(UnivPreview)
		LvLK3D.PushRenderTarget(RTPreview)
			LvLK3D.SetCamPos(Vector(0, 0, -2.5))
			LvLK3D.Clear(.1, .2, .3)
			LvLK3D.RenderActiveUniverse()
		LvLK3D.PopRenderTarget()
		LvLK3D.PopUniverse()


		local rtW, rtH = RTPreview:getDimensions()

		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("fill", 0, 0, w, h)

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setBlendMode("alpha", "premultiplied")
		love.graphics.draw(RTPreview, 0, 0, 0, w / rtW, h / rtH)
		love.graphics.setBlendMode("alpha")
	end)

	panel_view:SetOnThink(function(elm, dt)
		--LvLK3D.NoclipCam(dt)
		LvLK3D.PushUniverse(UnivPreview)
			LvLK3D.SetObjectAng("cube_showtex", Angle(CurTime * 24, CurTime * 32, 0))
		LvLK3D.PopUniverse()
	end)

	LvLKUI.PushElement(panel_view, frame_preview)


	-- buttons for config
	addFlagToggleButton(frame_preview, "Shading", "SHADING", 1)
	addFlagToggleButton(frame_preview, "ShadeSmooth", "SHADING_SMOOTH", 2)
	addFlagToggleButton(frame_preview, "NormInvert", "NORM_INVERT", 3)

	-- models
	addModelToggleButton(frame_preview, "Cube", "cube", 4)
	addModelToggleButton(frame_preview, "UVSphere", "uv_sphere", 5)
	addModelToggleButton(frame_preview, "UVSphereHQ", "uv_sphere_hq", 6)
	addModelToggleButton(frame_preview, "ICOSphere", "ico_sphere", 7)

	LvLKUI.PushElement(frame_preview)
end