TextureSynth = TextureSynth or {}

local function loadFileThing(path)
	require("texturesynth." .. path)
end

loadFileThing("components.wirebutton")
loadFileThing("components.texelement")

loadFileThing("elements")
loadFileThing("compute")

loadFileThing("ui.2dpreview")
loadFileThing("ui.3dpreview")
loadFileThing("ui.configpanel")
loadFileThing("ui")