-- Configuração inicial (mantenha conforme o necessário)
for _, v in pairs(getgc(true)) do
    if pcall(function() return rawget(v, "indexInstance") end) and type(rawget(v, "indexInstance")) == "table" and rawget(v, "indexInstance")[1] == "kick" then
        v.tvk = { "kick", function() return game.Workspace:WaitForChild("Player").Character end }
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

-- Configuração da interface gráfica e serviços
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerData") -- substitua "PlayerData" pelo nome desejado

-- Inicializar variáveis de controle de salvamento
local saveEnabled = true
local MAX_BACKUPS = 5 -- Número máximo de backups a serem mantidos

-- Função para salvar dados do jogador
local function savePlayerData(player)
    if saveEnabled then
        local success, errorMessage = pcall(function()
            -- Carregar o histórico de backups
            local backups = playerDataStore:GetAsync(player.UserId .. "_backups") or {}

            -- Adicionar o backup atual
            table.insert(backups, 1, player.leaderstats.Points.Value) -- Exemplo de dado a ser salvo

            -- Manter apenas os últimos N backups
            if #backups > MAX_BACKUPS then
                table.remove(backups, #backups)
            end

            -- Salvar backups atualizados
            playerDataStore:SetAsync(player.UserId .. "_backups", backups)
            -- Salvar o estado atual
            playerDataStore:SetAsync(player.UserId, player.leaderstats.Points.Value)
        end)
        
        if success then
            print("Dados do jogador " .. player.Name .. " salvos com sucesso.")
        else
            warn("Falha ao salvar dados do jogador " .. player.Name .. ": " .. errorMessage)
        end
    else
        print("Salvamento desativado.")
    end
end

-- Evento quando o jogador sai do jogo
game.Players.PlayerRemoving:Connect(savePlayerData)

-- Configuração da interface gráfica
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

-- Botão para parar o salvamento
local StopSaveButton = Instance.new("TextButton")
StopSaveButton.Size = UDim2.new(1, 0, 0.5, 0)
StopSaveButton.Position = UDim2.new(0, 0, 0, 0)
StopSaveButton.Text = "Parar Salvamento"
StopSaveButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
StopSaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopSaveButton.Parent = MiscFrame

-- Evento para parar o salvamento ao clicar no botão
StopSaveButton.MouseButton1Click:Connect(function()
    saveEnabled = false
    StopSaveButton.Text = "Salvamento Parado"
end)

-- Botão de rollback
local RollbackButton = Instance.new("TextButton")
RollbackButton.Size = UDim2.new(1, 0, 0.5, 0)
RollbackButton.Position = UDim2.new(0, 0, 0, 50)
RollbackButton.Text = "Rollback"
RollbackButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RollbackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RollbackButton.Parent = MiscFrame

-- Função de rollback ao clicar no botão
RollbackButton.MouseButton1Click:Connect(function()
    local success, errorMessage = pcall(function()
        -- Carregar backups
        local backups = playerDataStore:GetAsync(Player.UserId .. "_backups") or {}

        -- Restaurar o backup mais recente
        if #backups > 0 then
            local mostRecentBackup = backups[1]
            Player.leaderstats.Points.Value = mostRecentBackup
            print("Rollback realizado com sucesso.")
        else
            print("Nenhum backup encontrado para rollback.")
        end
    end)
    
    if not success then
        warn("Erro ao realizar rollback: " .. errorMessage)
    end
end)
