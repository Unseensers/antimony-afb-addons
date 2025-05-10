getgenv().afb = true -- automatically turn on bond autofarm
game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default -- unlock mouse
task.spawn(function()
    while true do
        getgenv().afb = true -- automatically turn on bond autofarm
        game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default -- unlock mouse
        task.wait()
    end
end)

task.wait(1.5) -- wait for game to load a bit

local Player = game.Players.LocalPlayer

-- gets a random server with only a few people using roblox's API
local function GetRandomServer()
    local status, id = pcall(function()
        local httpservice = cloneref(game:GetService("HttpService"))
        local link = "https://games.roblox.com/v1/games/116495829188952/servers/0?sortOrder=1&excludeFullGames=false&limit=100"
        local startdata = game:HttpGet(link)
        local data = httpservice:JSONDecode(startdata)

        return data["data"][math.random(1, 100)]["id"]
    end)

    if not status and task.wait(20) then
        return GetRandomServer()
    end

    return id
end

-- hook the kick function and make it teleport to lobby.
hookfunction(Player.Kick, function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(116495829188952, GetRandomServer())
end)

local oldnamecall; oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
    if self == Player and getnamecallmethod() == "Kick" then
        game:GetService("TeleportService"):TeleportToPlaceInstance(116495829188952, GetRandomServer())
        return
    end

    return oldnamecall(self, ...)
end)

-- bunch of performance fastflags. render distance and uncapped fps renders more bonds
setfflag("DFIntDebugFRMQualityLevelOverride", "1")x
setfflag("FIntRenderShadowIntensity", "0")
setfflag("DFIntDebugRestrictGCDistance", "0")
setfflag("FFlagRenderNoLowFrmBloom", "False")
setfflag("FFlagDebugCheckRenderThreading", "True")
setfflag("FFlagRenderDebugCheckThreading2", "True")
setfflag("FIntRuntimeMaxNumOfThreads", "4")
setfflag("FIntRenderShadowIntensity", "0")
setfflag("DFIntPerformanceControlTextureQualityBestUtility", "-1")
setfflag("FFlagTaskSchedulerLimitTargetFpsTo2402", "False")
setfflag("DFIntTaskSchedulerTargetFps", "9999")

-- rejoin if you get kicked by server or somsething 
game.CoreGui.DescendantAdded:Connect(function(desc)
    if desc.Name == "ErrorFrame" then
        game:GetService("TeleportService"):TeleportToPlaceInstance(116495829188952, GetRandomServer())
    end
end)
