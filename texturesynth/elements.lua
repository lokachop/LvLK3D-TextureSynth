TextureSynth = TextureSynth or {}
print("elements")

TextureSynth.Elements = TextureSynth.Elements or {}
TextureSynth.ElementsSortedList = TextureSynth.ElementsSortedList or {}

function TextureSynth.DeclareNewElement(name, data)
    -- generate paramLookups
    data.paramLookups = {}
    data.paramTypes = {}
    for k, v in ipairs(data.params) do
        data.paramLookups[k] = v[1]
        data.params[k] = v[2]

        if v[3] then
            data.paramTypes[k] = v[3]
        end
    end

    TextureSynth.Elements[name] = data

    TextureSynth.ElementsSortedList[#TextureSynth.ElementsSortedList + 1] = name
end


TextureSynth.DeclareNewElement("newTex", {
    ["inputs"] = {},
    ["params"] = {
        {"w", 256},
        {"h", 256},
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = LvLK3D.ProcTexNewTemp(params.w, params.h)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "local " .. tex .. " = LvLK3D.ProcTexNewTemp(" .. params.w .. ", " .. params.h .. ")"
    end
})


TextureSynth.DeclareNewElement("setRGB", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"rgb", {255, 255, 255}, "colour"},
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexApplyColour(tex, params.rgb[1] / 255, params.rgb[2] / 255, params.rgb[3] / 255)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexApplyColour(" .. tex .. ", " .. params.rgb[1] .. " / 255, " .. params.rgb[2] .. " / 255, " .. params.rgb[3] .. " / 255)"
    end,
})

TextureSynth.DeclareNewElement("mulRGB", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"rgb", {255, 255, 255}, "colour"},
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexApplyColourMul(tex, params.rgb[1] / 255, params.rgb[2] / 255, params.rgb[3] / 255)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexApplyColourMul(" .. tex .. ", " .. params.rgb[1] .. " / 255, " .. params.rgb[2] .. " / 255, " .. params.rgb[3] .. " / 255)"
    end,
})

TextureSynth.DeclareNewElement("addRGB", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"rgb", {255, 255, 255}, "colour"},
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexApplyColourAdd(tex, params.rgb[1] / 255, params.rgb[2] / 255, params.rgb[3] / 255)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexApplyColourAdd(" .. tex .. ", " .. params.rgb[1] .. " / 255, " .. params.rgb[2] .. " / 255, " .. params.rgb[3] .. " / 255)"
    end,
})

TextureSynth.DeclareNewElement("worleyMul", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"minDist", 1},
        {"scaleX", 3},
        {"scaleY", 3},
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexWorleyMultiply(tex, params.scaleX, params.scaleY, params.minDist)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexWorleyMultiply(" .. tex .. ", " .. params.scaleX .. ", " .. params.scaleY .. ", " .. params.minDist .. ")"
    end,
})

TextureSynth.DeclareNewElement("worleyNormal", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"minDist", 1},
        {"scaleX", 3},
        {"scaleY", 3},
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexWorleyNormal(tex, params.scaleX, params.scaleY, params.minDist)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexWorleyNormal(" .. tex .. ", " .. params.scaleX .. ", " .. params.scaleY .. ", " .. params.minDist .. ")"
    end,
})

TextureSynth.DeclareNewElement("simplexMul", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"scaleX", 3},
        {"scaleY", 3},
        {"originX", 0},
        {"originY", 0}
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexSimplexMultiply(tex, params.scaleX, params.scaleY, params.originX, params.originY)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexSimplexMultiply(" .. tex .. ", " .. params.scaleX .. ", " .. params.scaleY .. ", " .. params.originX .. ", " .. params.originY .. ")"
    end,
})

TextureSynth.DeclareNewElement("simplexAdd", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"scaleX", 3},
        {"scaleY", 3},
        {"originX", 0},
        {"originY", 0}
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexSimplexAdd(tex, params.scaleX, params.scaleY, params.originX, params.originY)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexSimplexAdd(" .. tex .. ", " .. params.scaleX .. ", " .. params.scaleY .. ", " .. params.originX .. ", " .. params.originY .. ")"
    end,
})

TextureSynth.DeclareNewElement("invert", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexInvert(tex)
        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexInvert(" .. tex .. ")"
    end,
})

TextureSynth.DeclareNewElement("blur", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"size", 8},
        {"quality", 3},
        {"dirs", 16}
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexBlur(tex, params.size, params.quality, params.dirs)
        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexBlur(" .. tex .. ", " .. params.size .. ", " .. params.quality .. ", " .. params.dirs .. ")"
    end,
})

TextureSynth.DeclareNewElement("treshold", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"target", 0.5},
        {"maxDist", 0.2},
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexTreshold(tex, params.target, params.maxDist)
        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexTreshold(" .. tex .. ", " .. params.target .. ", " .. params.maxDist .. ")"
    end,
})

TextureSynth.DeclareNewElement("normalMap", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexNormalify(tex)
        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexNormalify(" .. tex .. ")"
    end,
})

TextureSynth.DeclareNewElement("clamp", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"min", 0},
        {"max", 1}
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexClamp(tex, params.min, params.max)
        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexClamp(" .. tex .. ", " .. params.min .. ", " .. params.max .. ")"
    end,
})

TextureSynth.DeclareNewElement("mask", {
    ["inputs"] = {
        "tex",
        "texBlend",
        "texMask",
    },
    ["params"] = {},
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexMask(tex, inputs.texMask, inputs.texBlend)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        local texMask = inputs["texMask"]
        local texBlend = inputs["texBlend"]
        return "LvLK3D.ProcTexMask(" .. tex .. ", " .. texMask .. ", " .. texBlend .. ")"
    end,
})

TextureSynth.DeclareNewElement("mergeAdd", {
    ["inputs"] = {
        "tex",
        "texAdd",
    },
    ["params"] = {},
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexMergeAdd(tex, inputs.texAdd)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        local texAdd = inputs["texAdd"]
        return "LvLK3D.ProcTexMergeAdd(" .. tex .. ", " .. texAdd .. ")"
    end,
})

TextureSynth.DeclareNewElement("multiply", {
    ["inputs"] = {
        "tex",
        "texMul",
    },
    ["params"] = {},
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexMultiply(tex, inputs.texMul)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        local texMul = inputs["texMul"]
        return "LvLK3D.ProcTexMultiply(" .. tex .. ", " .. texMul .. ")"
    end,
})

TextureSynth.DeclareNewElement("lightDot", {
    ["inputs"] = {
        "tex",
        "texNorm",
    },
    ["params"] = {
        {"sunDirX", 0.25},
        {"sunDirY", 0.5},
        {"sunDirZ", -0.25},
        {"specMul", 1},
        {"specConst", 4},
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexLightDot(tex, inputs.texNorm, {params.sunDirX, params.sunDirY, params.sunDirZ}, params.specMul, params.specConst)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexLightDot(" .. tex .. ", {" .. params.sunDirX .. ", " .. params.sunDirY .. ", " .. params.sunDirZ .. "}, " .. params.specMul .. ", " .. params.specConst .. ")"
    end,
})

TextureSynth.DeclareNewElement("distort", {
    ["inputs"] = {
        "tex",
        "texDist",
    },
    ["params"] = {
        {"intensity", 0.015},
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexDistort(tex, inputs.texDist, params.intensity)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        local texDist = inputs["texDist"]
        return "LvLK3D.ProcTexDistort(" .. tex .. ", " .. texDist .. ", " .. params.intensity .. ")"
    end,
})

TextureSynth.DeclareNewElement("output", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"name", "none"},
    },
    ["outputs"] = {},
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        print("Declaring texture \"" .. params.name .. "\": " .. tostring(tex))
        LvLK3D.ProcTexDeclareTexture(params.name, tex)

        return tex
    end,
    ["onExportCode"] = function(params, inputs)
        local tex = inputs["tex"]
        return "LvLK3D.ProcTexDeclareTexture(\"" .. params.name .. "\", " .. tex .. ")"
    end,
    ["isOutput"] = true
})