local RP = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local plrGUI = plr.PlayerGui
local PartyGUI = plrGUI:WaitForChild("PartyGUI")

PartyGUI.PartyBTN.Activated:Connect(function()
    PartyGUI.SearchPlayer.Visible = not PartyGUI.SearchPlayer.Visible
    PartyGUI.Background.Visible = not PartyGUI.Background.Visible
    PartyGUI.CreatePartyBTN.Visible = not PartyGUI.CreatePartyBTN.Visible
end)

PartyGUI.SearchPlayer.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local inputText = PartyGUI.SearchPlayer.text:lower()
        if inputText == "" then return end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then
                local playerName = player.Name:lower()
                if playerName:sub(1, #inputText) == inputText then
                    PartyGUI.SearchPlayer.Text = player.Name
                    RP.Remotes.PartyRemote:FireServer({msg = player.Name, msg2 = "Send"})
                    break
                end
            end
        end
    end
end)

PartyGUI.InviteBG.Accept.Activated:Connect(function()
    RP.Remotes.PartyRemote:FireServer({msg = "", msg2 = "Accepted"})
end)

PartyGUI.InviteBG.Accept.Activated:Connect(function()
    RP.Remotes.PartyRemote:FireServer({msg = "", msg2 = "Declined"})
end)

PartyGUI.CreatePartyBTN.Activated:Connect(function()
    if not plr:GetAttribute("PARTIED") then
        RP.Remotes.PartyRemote:FireServer({msg = "", msg2 = "CreateParty"})
    end
end)

PartyGUI.LeaveBTN.Activated:Connect(function()
    RP.Remotes.PartyRemote:FireServer({msg = "", msg2 = "Declined"})
end)