TextureSynth = TextureSynth or {}
print("elements")

TextureSynth.Elements = TextureSynth.Elements or {}

function TextureSynth.DeclareNewElement(name, data)
    -- generate paramLookups
    data.paramLookups = {}
    for k, v in ipairs(data.params) do
        data.paramLookups[k] = v[1]
        data.params[k] = v[2]
    end

    TextureSynth.Elements[name] = data
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
    end
})


TextureSynth.DeclareNewElement("setRGB", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"cR", 255},
        {"cG", 255},
        {"cB", 255},
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexApplyColour(tex, params.cR / 255, params.cG / 255, params.cB / 255)

        return tex
    end
})

TextureSynth.DeclareNewElement("mulRGB", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"cR", 255},
        {"cG", 255},
        {"cB", 255},
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexApplyColourMul(tex, params.cR / 255, params.cG / 255, params.cB / 255)

        return tex
    end
})

TextureSynth.DeclareNewElement("addRGB", {
    ["inputs"] = {
        "tex"
    },
    ["params"] = {
        {"cR", 255},
        {"cG", 255},
        {"cB", 255},
    },
    ["outputs"] = {
        "tex"
    },
    ["onCompute"] = function(params, inputs)
        local tex = inputs["tex"]
        LvLK3D.ProcTexApplyColourAdd(tex, params.cR / 255, params.cG / 255, params.cB / 255)

        return tex
    end
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
    end
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
    end
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
    end
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
    end
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
    end
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
    end
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
    end
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
    end
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
    end
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
    end
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
    end
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
    end
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
    end
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
    end
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
})