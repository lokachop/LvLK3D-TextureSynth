TextureSynth = TextureSynth or {}

-- handles computing the texture



local _COMPUTE_MAX_ITR = 512
local _COMPUTE_ITR = 0
local function computeTree(elm)
    _COMPUTE_ITR = _COMPUTE_ITR + 1
    if _COMPUTE_ITR > _COMPUTE_MAX_ITR then
        return false, "Too many iterations! (infinite loop?)"
    end

    if not elm then
        return false, "Element is invalid!"
    end

    local elementType = elm:GetElementType()
    local elementDeclaration = TextureSynth.Elements[elementType]
    if not elementDeclaration then
        return false, "No element declaration?!?! Contact Lokachop... [\"" .. elementType .. "\"]"
    end

    -- we have to get those first
    local inputsComputeTbl = {}
    if #elm.inputs > 0 then
        -- compute them first
        for k, v in ipairs(elm.inputs) do
            if not v.isWired then
                return false, "Not wired!"
            end

            local fine, ret = computeTree(v.connection._parent)
            if not fine then
                return false, ret
            end

            local fancyName = elm.inputIndices[k]
            inputsComputeTbl[fancyName] = ret
        end
    end
    local elmParams, paramLookups = elm:GetParameters()
    local paramFancy = {}

    for k, v in ipairs(elmParams) do
        local fancyName = paramLookups[k]
        paramFancy[fancyName] = v
    end

    return true, elementDeclaration.onCompute(paramFancy, inputsComputeTbl)
end

local _EXPORT_BUFFER = {}
local _EXPORT_STRINGID = 0
local function exportTree(elm) -- more hacks :(
    _COMPUTE_ITR = _COMPUTE_ITR + 1
    if _COMPUTE_ITR > _COMPUTE_MAX_ITR then
        return false, "Too many iterations! (infinite loop?)"
    end

    if not elm then
        return false, "Element is invalid!"
    end

    local elementType = elm:GetElementType()
    local elementDeclaration = TextureSynth.Elements[elementType]
    if not elementDeclaration then
        return false, "No element declaration?!?! Contact Lokachop... [\"" .. elementType .. "\"]"
    end

    -- we have to get those first
    local inputsComputeTbl = {}
    if #elm.inputs > 0 then
        -- compute them first
        for k, v in ipairs(elm.inputs) do
            if not v.isWired then
                return false, "Not wired!"
            end

            local fine, ret, texName = exportTree(v.connection._parent)
            if not fine then
                return false, ret
            end

            local fancyName = elm.inputIndices[k]
            inputsComputeTbl[fancyName] = texName
        end
    else
        inputsComputeTbl["tex"] = "textureID_" .. _EXPORT_STRINGID
        _EXPORT_STRINGID = _EXPORT_STRINGID + 1
    end
    local elmParams, paramLookups = elm:GetParameters()
    local paramFancy = {}

    for k, v in ipairs(elmParams) do
        local fancyName = paramLookups[k]
        paramFancy[fancyName] = v
    end


    local calc = elementDeclaration.onExportCode(paramFancy, inputsComputeTbl)
    _EXPORT_BUFFER[#_EXPORT_BUFFER + 1] = calc

    return true, calc, inputsComputeTbl["tex"]
end


function TextureSynth.ComputeAtElement(elm)
    _COMPUTE_ITR = 0
    _EXPORT_STRINGID = 0
    _EXPORT_BUFFER = {}
    print("Computing for element \"" .. elm.name .. "\"!")
    -- we have to generate a fucking tree of inputs up to this point
    local fine, ret = computeTree(elm)
    if not fine then
        print("ComputeTree Error! \"" .. ret .. "\"")
        return
    end

    print("Compute success!", fine, ret)

    LvLK3D.ProcTexDeclareTexture("previewTex", ret)
    TextureSynth.UpdatePreviewTexture()
end


function TextureSynth.ExportAtElement(elm, fileName)
    if not elm then
        return
    end

    print("Exporting...")
    fine, ret = exportTree(elm)
    if not fine then
        print("ExportTree Error! \"" .. ret .. "\"")
        return
    end

    love.filesystem.write(fileName .. ".lua", table.concat(_EXPORT_BUFFER, "\n"))
    love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
    print("Saved file as \"" .. fileName .. ".lua\"!")
end


local binser = require("binser") -- guess who couldnt be asked to make a binary format

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

-- custom format exporting
function TextureSynth.ExportLPN(fileName)
    local texElementList = {}
    print("LPN export")
    for k, v in pairs(LvLKUI.ActiveElements) do
        if v._isTexElement then
            local idx = #texElementList + 1
            v._saveID = idx
            texElementList[idx] = v
        end
    end

    print(tostring(#texElementList) .. " tex elements...")
    if #texElementList <= 0 then
        print("Can't save 0 elements!")
    end

    local serTable = {}

    for k, v in ipairs(texElementList) do
        serTable[k] = {
            ["type"] = v._elementType,
            ["inputIndices"] = copyTable(v.inputIndices),
            ["inputs"] = {},
            ["outputIndices"] = copyTable(v.outputIndices),
            ["outputs"] = {},
            ["parameteri"] = copyTable(v._elementParameteri),
            ["pos"] = copyTable(v.pos),
        }


    end
end