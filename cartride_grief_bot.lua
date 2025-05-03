--loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Steve-Bloks/other/refs/heads/main/cartride_grief_bot.lua'))()
local isChatLegacy = (game.TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService)
local chatRemote = game.ReplicatedStorage:FindFirstChild("SayMessageRequest", true)
local function sendchat(str) if isChatLegacy then chatRemote:FireServer(str, "All") else chatChannel:SendAsync(str) end end

local clicking = {}

for i, v in pairs(workspace:GetDescendants()) do
    if v.Parent.Name == "Down" and v.ClassName == "ClickDetector" then
        table.insert(clicking, v)
    end
end

workspace.DescendantAdded:Connect(function(v)
    if v and v.Parent and v.Parent.Name == "Down" and v.ClassName == "ClickDetector" then
        table.insert(clicking, v)
    end
end)

do
    local function setCanCollideOfModelDescendants(model, bval)
        if not model then
            return
        end
        for i, v in pairs(model:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = bval
            end
        end
    end

    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            game:GetService("RunService").Stepped:Connect(function()
                setCanCollideOfModelDescendants(v.Character, false)
            end)
        end
    end

    game.Players.PlayerAdded:Connect(function(plr)
        game:GetService("RunService").Stepped:Connect(function()
            setCanCollideOfModelDescendants(plr.Character, false)
        end)
    end)
end

do
    local function spin()
        local Spin = Instance.new("BodyAngularVelocity")
        Spin.Name = "Spinning"
        Spin.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.AngularVelocity = Vector3.new(0,4,0)
    end

    game.Players.LocalPlayer.CharacterAdded:Connect(spin)
    spin()
end

sendchat("Hello people!")
task.wait(0.5)
sendchat("Going forward in your carts is no longer allowed! Please only go backwards.")
task.wait(2)

game:GetService("RunService").Heartbeat:Connect(function()
    for _, clicker in pairs(clicking) do
        if clicker and clicker.Parent and clicker.Parent:IsA("BasePart") then
            if clicker.Parent.BrickColor ~= BrickColor.new("Dark green") then
                fireclickdetector(clicker)
            end
        end
    end
end)
task.wait(3)
sendchat("[This is a bot, if there are any issues during its presence please say '-report <issue>', the developer will review chat logs after the test]")
task.wait()
sendchat("{debug} WAIT 240")
task.wait(241)
if httprequest then
    local servers = {}
    local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", PlaceId)})
        local body = HttpService:JSONDecode(req.Body)

    if body and body.data then
        for i, v in next, body.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
                table.insert(servers, 1, v.id)
            end
        end
    end

    if #servers > 0 then
        sendchat("{debug} teleporting to new instance...")
        queue_on_teleport("loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Steve-Bloks/other/refs/heads/main/cartride_grief_bot.lua'))()"); task.wait(4)
        TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
    else
        sendchat("{debug} failed to find new instance, exitting...")
        error("Serverhop: Couldn't find a server.")
    end
end
