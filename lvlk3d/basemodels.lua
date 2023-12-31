LvLK3D = LvLK3D or {}

-- path is relative to root
local function readFile(path)
    return love.filesystem.read(path)
end

local function loadModelFromOBJ(name, path)
    local objData = readFile(path)
    if not objData then
        error("Could not read model \"" .. path .. "\"")
        return
    end

    LvLK3D.DeclareModelOBJ(name, objData)
end

loadModelFromOBJ("cube", "models/cubenuv.obj")
loadModelFromOBJ("plane", "models/plane.obj")
loadModelFromOBJ("lokachop_sqr", "models/lokachopsqr.obj")

loadModelFromOBJ("traintrack_hq", "models/traintrack.obj")
loadModelFromOBJ("traintrack", "models/traintrack_lod.obj")

loadModelFromOBJ("train", "models/train/train.obj")
loadModelFromOBJ("train_lod1", "models/train/train_lod1.obj")
loadModelFromOBJ("train_lod2", "models/train/train_lod2.obj")


loadModelFromOBJ("uv_sphere", "models/uvsphere.obj")
loadModelFromOBJ("uv_sphere_hq", "models/uvsphere_hq.obj")
loadModelFromOBJ("ico_sphere", "models/icosphere.obj")