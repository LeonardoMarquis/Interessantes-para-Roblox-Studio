

local UIS = game:GetService("UserInputService")
local plr = game.Players:GetPlayerFromCharacter(script.Parent)

local Order = script:WaitForChild("Order")
local Order = 1


local character = plr.Character
if not character or not character.Parent then
	character = plr.CharacterAdded:Wait()
end

local humanoid = character:WaitForChild("Humanoid")

--local runanimation = Instance.new("Animation")
--runanimation.AnimationId = "rbxassetid://12198336336"
--local Animator = humanoid:WaitForChild("Animator")

--local animationrun = Animator:LoadAnimation(runanimation)


--MOBILE--====================
local PowersInfo = plr.PlayerGui:WaitForChild("PowersInfo")
local mobile_btns = PowersInfo:WaitForChild("MobileBtns")

--================================================


local function run(input)
	if input.KeyCode == Enum.KeyCode.LeftControl then
		if Order == 1 then
			plr.Character.Humanoid.WalkSpeed = 34
			--animationrun:Play()
			Order = 2
			
		elseif Order == 2 then 
			plr.Character.Humanoid.WalkSpeed = 16
			--animationrun:Stop()
			
			Order = 1
		end

	end
end



local function run2()

	if Order == 1 then
		plr.Character.Humanoid.WalkSpeed = 34
		--animationrun:Play()
		Order = 2

	elseif Order == 2 then 
		plr.Character.Humanoid.WalkSpeed = 16
		--animationrun:Stop()

		Order = 1
	end

end




UIS.InputBegan:Connect(function(input)
	run(input)
end)

mobile_btns.Run.MouseButton1Click:Connect(function()
	run2()
end)