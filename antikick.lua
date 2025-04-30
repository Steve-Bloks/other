local old;
old = hookmetamethod(game, "__namecall", newcclosure(function(...) 
    local self, message = ...
    local ncm = getnamecallmethod()

    if not checkcaller() and self == game.Players.LocalPlayer and ncm == "Kick" then
        print("[LDToolkit]: Blocked kick: "..message)
        return newcclosure(function() end)
    end
    return old(...)
end))
print("[LDToolkit]: anti-kick enabled")
