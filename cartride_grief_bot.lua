--loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Steve-Bloks/other/refs/heads/main/cartride_grief_bot.lua'))()

task.wait(8)
print("18")

local isChatLegacy = (game.TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService)
httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local chatRemote = game.ReplicatedStorage:FindFirstChild("SayMessageRequest", true)
local function sendchat(str)
    if isChatLegacy then
        chatRemote:FireServer(str, "All")
    else
        chatChannel:SendAsync(str)
    end
end
sendchat("[Powered by LuaDev's ro-bot framework]")

local HttpService = game:GetService("HttpService")
local chatLogs = {}
local logIndexFile = "chatlog_index.txt"
local logIndex = 1

if isfile(logIndexFile) then
    local data = readfile(logIndexFile)
    logIndex = tonumber(data) or 1
end

for _, player in ipairs(game.Players:GetPlayers()) do
    player.Chatted:Connect(function(msg)
        table.insert(chatLogs, {
            player = player.Name,
            message = msg
        })
    end)
end

game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(msg)
        table.insert(chatLogs, {
            player = player.Name,
            message = msg
        })
    end)
end)

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
        if not model then return end
        for _, v in pairs(model:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = bval
            end
        end
    end

    task.spawn(function()
        while true do
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Character then
                    setCanCollideOfModelDescendants(plr.Character, false)
                end
            end
            task.wait(0.5)
        end
    end)
end

do
    local function spin()
        local Spin = Instance.new("BodyAngularVelocity")
        Spin.Name = "Spinning"
        Spin.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.AngularVelocity = Vector3.new(0, 4, 0)
    end

    game.Players.LocalPlayer.CharacterAdded:Connect(spin)
    spin()
end

do
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(310.417419, 855.799927, 322.503387)
    task.wait(1.5)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(44.64011, 3.09999967, -75.1940765)
end

task.wait(0.5)
sendchat("Hello people!")
task.wait(0.5)
sendchat("Going forward in your carts is no longer allowed! Please only go backwards.")
task.wait(1)
sendchat("[This is a bot, if there are any issues during its presence please say '-report <issue>', the developer will review the chat logs after the test]")
task.wait(7)

task.spawn(function()
    while true do
        for _, clicker in ipairs(clicking) do
            if clicker and clicker.Parent and clicker.Parent:IsA("BasePart") then
                if clicker.Parent.BrickColor ~= BrickColor.new("Dark green") then
                    fireclickdetector(clicker)
                end
            end
        end
        task.wait(0.1)
    end
end)

task.wait(1)
sendchat("{debug} WAIT 180")
task.wait(181)
print("finding new server...")

local function writeLogs()
    local logText = ""
    for _, entry in ipairs(chatLogs) do
        logText = logText .. "Player: " .. entry.player .. "\nMessage: " .. entry.message .. "\n\n"
    end

    local filename = "chatlog_" .. logIndex .. ".txt"
    writefile(filename, logText)
    writefile(logIndexFile, tostring(logIndex + 1))
end

local servers = {}
local req = httprequest({
    Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)
})
local body = game:GetService("HttpService"):JSONDecode(req.Body)

if body and body.data then
    for i, v in next, body.data do
        if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
            table.insert(servers, 1, v.id)
        end
    end
end

if #servers > 0 then
    writeLogs()
    sendchat("{debug} teleporting to new instance")
    queue_on_teleport("loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Steve-Bloks/other/refs/heads/main/cartride_grief_bot.lua'))()")
    task.wait(4)
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
else
    sendchat("{debug} failed to find new instance, exitting...")
    error("Serverhop: Couldn't find a server.")
end
