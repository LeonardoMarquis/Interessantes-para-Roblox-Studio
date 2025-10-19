-- Coloque esse script dentro do Dummy original no Workspace

local originalDummy = script.Parent
local respawnDelay = 5
local maxHealth = 100

-- Salva o CFrame inicial (posição)
local initialCFrame = originalDummy:GetPrimaryPartCFrame()


-- Salva o modelo original como referência para clonar
local dummyTemplate = originalDummy:Clone()
dummyTemplate.Name = originalDummy.Name -- opcional: manter o mesmo nome

-- Desativa o original (não será usado diretamente)
originalDummy:Destroy()

-- Função para spawnar um novo dummy
local function spawnDummy()
	local newDummy = dummyTemplate:Clone()
	newDummy.Parent = workspace
	newDummy:SetPrimaryPartCFrame(initialCFrame)


	local humanoid = newDummy:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.MaxHealth = maxHealth
		humanoid.Health = maxHealth

		-- Conecta evento de morte
		humanoid.Died:Connect(function()
			-- Espera o tempo de respawn
			wait(respawnDelay)
			-- Remove dummy morto
			if newDummy then
				newDummy:Destroy()
			end
			-- Respawna outro, porque na verdade, aquele morto se perde e é destruido, entao spawnamos um clone dele
			spawnDummy()
		end)


	end


end



-- Começa o primeiro spawn
spawnDummy()
