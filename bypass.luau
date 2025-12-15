local RS = game:GetService("ReplicatedStorage")
local gc = getgc(true)

local function findTargetConstant()
    local candidates = {}
    
    for _, obj in pairs(gc) do
        pcall(function()
            if type(obj) == "function" and islclosure(obj) and not isexecutorclosure(obj) then
                local protos = getprotos(obj)
                if protos and #protos == 1 then
                    local consts = getconstants(protos[1])
                    for _, const in pairs(consts) do
                        if type(const) == "number" and const > 1000000 and const < 10000000 then
                            table.insert(candidates, {value = const, func = obj})
                        end
                    end
                end
            end
        end)
    end
    
    return candidates
end

for _, obj in pairs(gc) do
    pcall(function()
        if type(obj) == "table" and rawlen(obj) == 19 then
            local last = rawget(obj, 19)
            if type(last) == "userdata" then
                for i = 2, 18 do
                    rawset(obj, i, math.random(1e6, 1e8))
                end
            end
        end
    end)
end

local detectedConstants = findTargetConstant()

if #detectedConstants > 0 then
    for _, candidate in ipairs(detectedConstants) do
        pcall(function()
            hookfunction(candidate.func, newcclosure(function() end))
        end)
    end
end

local remote = RS.Remotes.CharacterSoundEvent
local oldFire = remote.FireServer

hookfunction(remote.FireServer, newcclosure(function(self, ...)
    local args = {...}
    
    if type(args[1]) == "string" and #args[1] > 20 then
        if args[2] == "b51b07a5c14d" or args[2] == "error" then
            return
        end
    end
    
    return oldFire(self, ...)
end))

_G.b51b07a5c14d = false

local fakeLS = Instance.new("LocalScript")
fakeLS.Disabled = true
fakeLS.Parent = game:GetService("ReplicatedFirst")

for _, tbl in pairs(gc) do
    pcall(function()
        if type(tbl) == "table" then
            local mt = getrawmetatable(tbl)
            if mt and mt.__call then
                local oldCall = mt.__call
                rawset(mt, "__call", newcclosure(function(self, a, b, c, d, e, f)
                    if a and b and c and d and e and f then
                        if a > 1000 and b > 1000 then
                            return { 20.02 }
                        end
                    end
                    return oldCall(self, a, b, c, d, e, f)
                end))
                rawset(mt, "__tostring", nil)
            end
        end
    end)
end
