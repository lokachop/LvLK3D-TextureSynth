TextureSynth = TextureSynth or {}
LvLK3D = LvLK3D or {}

local UnivPreview2D = LvLK3D.NewUniverse("Preview_TexSynth2D")
local RTPreview2D = LvLK3D.NewRenderTarget("Preview_TexSynth_RT2D", 256, 256)


function TextureSynth.UpdatePreviewTexture2D()
	LvLK3D.PushUniverse(UnivPreview2D)
		LvLK3D.SetObjectMat("plane_showtex", "previewTex")
		LvLK3D.UpdateObjectMesh("plane_showtex")
	LvLK3D.PopUniverse()
end

function TextureSynth.SetupPreviewFrame2D()
	LvLK3D.PushUniverse(UnivPreview2D)
		LvLK3D.SetSunLighting(false)
		LvLK3D.SetSunCol({1, 1, 1})

		LvLK3D.AddObjectToUniv("plane_showtex", "plane")
		LvLK3D.SetObjectPos("plane_showtex", Vector(0, 0, 0))
		LvLK3D.SetObjectAng("plane_showtex", Angle(-90, 180, 0))
		LvLK3D.SetObjectMat("plane_showtex", "previewTex")
		LvLK3D.UpdateObjectMesh("plane_showtex")
	LvLK3D.PopUniverse()

	local w, h = love.graphics.getDimensions()

	local frame_preview = LvLKUI.NewElement("frame_preview2d", "frame")
	frame_preview:SetPriority(5120)
	frame_preview:SetPos({w - 256, h - (256 + 18) * 2})
	frame_preview:SetSize({256 + 1, 256 + 18})
	frame_preview:SetLabel("2D preview")
	frame_preview:SetCloseDisabled(true)

	local panel_view = LvLKUI.NewElement("panel_view2d", "panel")
	panel_view:SetPriority(5120)
	panel_view:SetPos({0, 18})
	panel_view:SetSize({256, 256})
	panel_view:SetOnPaint(function(elm, w, h)
		LvLK3D.PushUniverse(UnivPreview2D)
		LvLK3D.PushRenderTarget(RTPreview2D)
			LvLK3D.SetCamPos(Vector(0, 0, -1))
			LvLK3D.Clear(.1, .2, .3)
			LvLK3D.RenderActiveUniverse()
		LvLK3D.PopRenderTarget()
		LvLK3D.PopUniverse()

		local rtW, rtH = RTPreview2D:getDimensions()

		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("fill", 0, 0, w, h)

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setBlendMode("alpha", "premultiplied")
		love.graphics.draw(RTPreview2D, 0, 0, 0, w / rtW, h / rtH)
		love.graphics.setBlendMode("alpha")
	end)

	LvLKUI.PushElement(panel_view, frame_preview)

	LvLKUI.PushElement(frame_preview)
end
