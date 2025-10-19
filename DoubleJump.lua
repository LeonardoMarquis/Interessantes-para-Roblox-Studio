--[[ Made by coolcapidog
Channel ->> https://www.youtube.com/c/coolcapidog
You can change the settings but you shouldn't change anything except settings.
]]

----------------------------------------- Settings
local MaxJumps = 2
local JumpCooldown = 0.1
----------------------------------------- Settings

local UIS = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local NumJumps = 0
local canjump = false

Humanoid.StateChanged:Connect(function(oldstate, newstate)
	if Enum.HumanoidStateType.Landed == newstate then
		NumJumps = 0
		canjump = false
	elseif Enum.HumanoidStateType.Freefall == newstate then
		wait(JumpCooldown)
		canjump = true
	elseif Enum.HumanoidStateType.Jumping == newstate then
		canjump = false
		NumJumps += 1
	end
end)

UIS.JumpRequest:Connect(function()
	if canjump and NumJumps < MaxJumps then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)
