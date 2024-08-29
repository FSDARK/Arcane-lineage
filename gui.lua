repeat
    wait()
until game:IsLoaded()
wait()

-- Not my adonis bypasses - Everything else made by me (OneFool)
for _, v in pairs(getgc(true)) do
    if pcall(function() return rawget(v, "indexInstance") end) and type(rawget(v, "indexInstance")) == "table" and (rawget(v, "indexInstance"))[1] == "kick" then
        v.tvk = { "kick", function() return game.Workspace:WaitForChild("") end }
    end
end

for _, v in next, getgc() do
    if typeof(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
        local Constants = debug.getconstants(v)
        if table.find(Constants, "Detected") and table.find(Constants, "crash") then
            setthreadidentity(2)
            hookfunction(v, function()
                return task.wait(9e9)
            end)
            setthreadidentity(7)
        end
    end
end
-- End Adonis Bypasses

------------------------Anti_AFK----------------------------------
if getconnections then
    for _, v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
        v:Disable()
    end
end

if not getconnections then
    game:GetService("Players").LocalPlayer.Idled:connect(
        function()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end
    )
end
------------------------End_Anti_AFK------------------------------

local NPCList = {}
local QuestNPCList = {}
local Moves = {}
local lp = game:GetService("Players").LocalPlayer
local BlacklistedNPC = { "Quest", "Filler", "Aretim", "PurgNPC", "ExampleNPC", "Pup 1", "Pup 2", "Pup 3", "SlimeStatue3" }
local aux = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mikro55/Arcane_Lineage/main/Hacker%20Hub"))()

function checkforfight()
    if game:GetService("Workspace").Living[lp.Name]:FindFirstChild("FightInProgress") then
        return true
    else
        return false
    end
end

function getproximity()
    for _, Cauldrons in next, game:GetService("Workspace").Cauldrons:GetDescendants() do
        if Cauldrons:IsA("ProximityPrompt") then
            fireproximityprompt(Cauldrons)
        end
    end
end

function getclicker()
    for _, CauldronsClick in next, game:GetService("Workspace").Cauldrons:GetDescendants() do
        if CauldronsClick:IsA("ClickDetector") then
            fireclickdetector(CauldronsClick)
        end
    end
end

for _, Movess in next, lp.PlayerGui.StatMenu.SkillMenu.Actives:GetChildren() do
    if Movess:IsA("TextButton") then
        table.insert(Moves, Movess.Name)
    end
end

for _, NPC in next, game:GetService("Workspace").NPCs:GetChildren() do
    if NPC:IsA("Model") and not table.find(BlacklistedNPC, NPC.Name) then
        table.insert(NPCList, NPC.Name)
    end
end

for _, QuestNPC in next, game:GetService("Workspace").NPCs.Quest:GetChildren() do
    if QuestNPC:IsA("Model") then
        table.insert(QuestNPCList, QuestNPC.Name)
    end
end

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Mikro55/Arcane_Lineage/main/Hacker%20Hub')))()
local Window = OrionLib:MakeWindow({
    Name = "Hacker Hub | Arcane Lineage",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FoolArcLin"
})

local Misc = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://12614663538",
    PremiumOnly = false
})

Misc:AddButton({
	Name = "Enable Rollback",
	Callback = function()
		while task.wait() do
			local ohTable1 = {
				["1"] = "\255"
			}
			game:GetService("ReplicatedStorage").Remotes.Data.UpdateHotbar:FireServer(ohTable1)
			print("Rollback Setup")
		end
	end
})

Misc:AddButton({
    Name = "Rejoin",
    Callback = function()
        local ts = game:GetService("TeleportService")
        local p = lp
        ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
    end
})

local AntiAFK = Misc:AddSection({
    Name = "Anti-AFK Built In"
})

OrionLib:Init()
