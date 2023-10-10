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
            print("Fname", fancyName)
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

function TextureSynth.ComputeAtElement(elm)
    _COMPUTE_ITR = 0
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