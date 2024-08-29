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

local RollbackButton = Instance.new("TextButton")
RollbackButton.Size = UDim2.new(1, 0, 0.5, 0)
RollbackButton.Position = UDim2.new(0, 0, 0, 0)
RollbackButton.Text = "Enable Rollback"
RollbackButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RollbackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RollbackButton.Parent = MiscFrame

RollbackButton.MouseButton1Click:Connect(function()
    while true do
        local ohTable1 = {
            ["1"] = "\255"
        }
        game:GetService("ReplicatedStorage").Remotes.Data.UpdateHotbar:FireServer(ohTable1)
        print("Rollback Setup")
        wait(1)
    end
end)

local RejoinButton = Instance.new("TextButton")
RejoinButton.Size = UDim2.new(1, 0, 0.5, 0)
RejoinButton.Position = UDim2.new(0, 0, 0.5, 0)
RejoinButton.Text = "Rejoin"
RejoinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinButton.Parent = MiscFrame

RejoinButton.MouseButton1Click:Connect(function()
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = 10595058975
    local JobId = game.JobId
    TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Player)
end)
