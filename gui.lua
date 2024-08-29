-- Função para modificar funções potencialmente perigosas ou restritas
local function modifyFunctions()
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer

    -- Loop para procurar e modificar funções no registro de debug
    for _, v in pairs(debug.getregistry()) do
        if type(v) == "table" and rawget(v, "indexInstance") then
            local indexInstance = rawget(v, "indexInstance")
            if type(indexInstance) == "table" and indexInstance[1] == "kick" then
                v.tvk = { "kick", function() return Player.Character or Player.CharacterAdded:Wait() end }
            end
        end
    end

    for _, v in pairs(debug.getregistry()) do
        if type(v) == "function" then
            local constants = debug.getconstants(v)
            if table.find(constants, "Detected") and table.find(constants, "crash") then
                debug.sethook(v, function()
                    return task.wait(9e9)
                end, "c")
            end
        end
    end
end

-- Tente executar a função modifyFunctions, mas ignore qualquer erro que ela possa gerar
local success, err = pcall(modifyFunctions)
if not success then
    warn("Falha ao modificar funções de debug: ", err)
end

-- Configuração da interface gráfica
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyScreenGui"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Parent = ScreenGui

local MiscFrame = Instance.new("Frame")
MiscFrame.Size = UDim2.new(1, 0, 1, 0)
MiscFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MiscFrame.Parent = MainFrame

-- Botão Rollback
local RollbackButton = Instance.new("TextButton")
RollbackButton.Size = UDim2.new(1, 0, 0.5, 0)
RollbackButton.Position = UDim2.new(0, 0, 0, 0)
RollbackButton.Text = "Enable Rollback"
RollbackButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RollbackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RollbackButton.Parent = MiscFrame

-- Função de rollback com controle de loop
RollbackButton.MouseButton1Click:Connect(function()
    local running = true
    while running do
        local ohTable1 = { ["1"] = "\255" }
        game:GetService("ReplicatedStorage").Remotes.Data.UpdateHotbar:FireServer(ohTable1)
        print("Rollback Setup")
        task.wait(0.1)  -- Adiciona uma pausa para evitar sobrecarga
    end
end)

-- Botão Rejoin
local RejoinButton = Instance.new("TextButton")
RejoinButton.Size = UDim2.new(1, 0, 0.5, 0)
RejoinButton.Position = UDim2.new(0, 0, 0.5, 0)
RejoinButton.Text = "Rejoin"
RejoinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinButton.Parent = MiscFrame

-- Função de reentrada no servidor
RejoinButton.MouseButton1Click:Connect(function()
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Player)
end)
