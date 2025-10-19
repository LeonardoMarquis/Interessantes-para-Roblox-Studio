local user_input_service = game:GetService("UserInputService")
local player = game.Players:GetPlayerFromCharacter(script.Parent)

	

--Settings

local key = Enum.KeyCode.Q
local velocity = 18000
local debounce = false --o cooldown ativator
local cooldown = 2 --cooldown time
local duration = 0.1 -- dash duration




local function Dash()
	local dash_animation = script:WaitForChild("Animation")	
	local character = player.Character
	
	if character and not debounce then 
		debounce = true
		
		--dash script here
		
		local humanoid = character.Humanoid
		local HRP = character.HumanoidRootPart
		
		local loaded_animation = humanoid.Animator:LoadAnimation(dash_animation)
		
		loaded_animation:AdjustSpeed(1000)
		
		
		local dash_direction = nil
		local move_direction = humanoid.MoveDirection
		local lookvector = HRP.CFrame.LookVector
		local minus_velocity = -velocity
		
		
		local is_on_ground = humanoid.FloorMaterial ~= Enum.Material.Water 
		
		----- TEM QUE AJEITAR A FORÇA DO DASH NO AR, TA MUITO ALTA, ESSA LINHA AI ENTREGA A MESMA FORÇA DE DASH NO AR E CHÃO
		
		if is_on_ground then
			
			if move_direction == Vector3.new(0,0,0) then --if player is not currentaly moving
				dash_direction = HRP.Position + Vector3.new(lookvector.X,0,lookvector.Z)
			else -- if player are currerntaly moving, walking
				dash_direction = HRP.Position + Vector3.new(move_direction.X,0,move_direction.Z)
			end
			
			
			-- uping bodygyro para girar entre deireções com suavidade
			local bodyGyro = Instance.new("BodyGyro")
			bodyGyro.Parent = HRP
			bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			bodyGyro.D = 0 --D is the dampening
			bodyGyro.P = 500000 --P is aggressiveness -- 500000
			bodyGyro.CFrame = CFrame.lookAt(HRP.Position, dash_direction) --make o player olhar para a direção do dash
			
			local attachment = Instance.new("Attachment")
			attachment.Parent = HRP
			
			--usar a Vectorforce para mover o player
			local vectorforce = Instance.new("VectorForce")
			vectorforce.Parent = HRP
			-- vectorforce precisa do attachment para dizer onde vai
			vectorforce.Attachment0 = attachment
			
			vectorforce.Force = Vector3.new(0,0,minus_velocity)
			
			loaded_animation:Play()
			humanoid.AutoRotate = false
			
			wait(duration)
			
			humanoid.AutoRotate = true
			vectorforce:Destroy()
			bodyGyro:Destroy()
			attachment:Destroy()
			
			wait(duration)
			loaded_animation:Stop()
			
			
		end
		
		
		wait(cooldown)
		debounce = false
	end
end


--MOBILE--====================
local PowersInfo = player.PlayerGui:WaitForChild("PowersInfo")
local mobile_btns = PowersInfo:WaitForChild("MobileBtns")

--================================================


user_input_service.InputBegan:Connect(function(input)
	if input.KeyCode == key then
		Dash()
	end
	
	
	mobile_btns.Dash.MouseButton1Click:Connect(function()
		
		Dash()
	end)
	
	
	
end)


