-- Certifique-se de que o jogo está completamente carregado
repeat
    wait()
until game:IsLoaded()

-- Correções no código de manipulação do GC (Adicione verificações e mensagens apropriadas)
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

-- Certifique-se de que o Roact está presente em ReplicatedStorage
local Roact = require(game.ReplicatedStorage:WaitForChild("Roact"))

-- Componente de Botão
local Button = Roact.Component:extend("Button")

function Button:init()
    self:setState({
        isPressed = false
    })
end

function Button:render()
    return Roact.createElement("TextButton", {
        Text = self.props.Text,
        Size = UDim2.new(0, 200, 0, 50),
        Position = self.props.Position,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSans,
        TextSize = 24,
        [Roact.Event.Activated] = function()
            if self.props.OnClick then
                self.props.OnClick()
            end
        end
    })
end

-- Componente Principal da GUI
local MainGui = Roact.Component:extend("MainGui")

function MainGui:render()
    return Roact.createElement("ScreenGui", {}, {
        RollbackButton = Roact.createElement(Button, {
            Text = "Enable Rollback",
            Position = UDim2.new(0.5, -100, 0.3, -25),
            OnClick = function()
                while true do
                    local ohTable1 = {
                        ["1"] = "\255"
                    }
                    game:GetService("ReplicatedStorage").Remotes.Data.UpdateHotbar:FireServer(ohTable1)
                    print("Rollback Setup")
                    task.wait(5) -- Adicione um delay apropriado para evitar problemas de desempenho
                end
            end
        }),
        
        RejoinButton = Roact.createElement(Button, {
            Text = "Rejoin",
            Position = UDim2.new(0.5, -100, 0.4, -25),
            OnClick = function()
                local ts = game:GetService("TeleportService")
                local p = game.Players.LocalPlayer
                ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
            end
        })
    })
end

-- Montar a GUI
Roact.mount(Roact.createElement(MainGui), game.Players.LocalPlayer:WaitForChild("PlayerGui"))
