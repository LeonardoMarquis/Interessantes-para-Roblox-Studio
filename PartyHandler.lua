local RP = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local PARTY_LIMIT = 5

local function getPartySize(partyLeader)
    local count = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player:GetAttribute("PARTIED") == partyLeader then
            count += 1
        end
    end
    return count
end

local function updatePartyUI(partyLeader)
    local partyMembers = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player:GetAttribute("PARTIED") == partyLeader then
            table.insert(partyMembers, player)
        end
    end


    for _, member in ipairs(partyMembers) do
        local playergui = member:FindFirstChild("PlayerGui")
        if playerGui then
            local partyGUI = playerGui:FindFirstChild("PartyGUI")
            if partGUI then

                for _, frame in ipairs(partyGUI.Background:GetChildren()) do
                    if frame:IsA("Frame") then
                        frame:Destroy()
                    end
                end
                for _, partyMember in ipairs(partyMembers) do
                    local newBar = RP.Assets.GUI.Template:Clone()
                    newBar.Parent = partyGUI.Background
                    newBar.PlayerName.Text = partyMember.Name
                end

                partyGUI.leaveBTN.Visible = true
            end
        end
    end
end

local function clearPlayerUI(plr)
    local PlayerGui = plr:FindFirstChild("PlayerGui")
    if playerGui then
        local partyGUI = playerGui:FindFirstChild("PartyGUI")
        if partyGUI then
            for _, frame in ipairs(partyGUI.Background:GetChildren()) do
                if frame:IsA("Frame") then
                    frame:Destroy()
                end
            end
            partyGUI.leaveBTN.Visible = false
        end
    end
end

local function handlePlayerLeave(plr)
    local partyLeader == plr:GetAttribute("PARTIED")

    if partyLeader then
        if partyLeader == plr.Name then
            for _, member in ipairs(Players:GetPlayers()) do
                if member:GetAttribute("PARTIED") == plr.Name then
                    member.SetAttribute("PARTIED", nil)
                    clearPlayerUI(member)
                end
            end
        else
            plr:SetAttribute("PARTIED", nil)
            clearPlayerUI(plr)
            updatePartyUI(partyLeader)
        end
    end
end

RP.Remotes.PartyRemote.OnServerEvent:Connect(function(plr, params)
    if params.msg2 == "Send" then

        if plr:GetAttribute("PARTIED") and plr:GetAttribute("PARTIED") ~=plr.Name then
            return
        end

        local partyLeader = plr:GetAttribute("PARTIED") or plr.Name
        if getPartySize(partyLeader) >= PARTY_LIMIT then
            plr:FindFirstChild("PlayerGui").PartyGUI.InvitedBG.TextLabel.Text = "Party is full !"
            return
        end

        for _, v in ipairs(Players:GetPlayers()) do
            if v.Name == params.msg then
                if v.GetAttribute("InvitedBy") or v:GetAttribute("PARTIED") then return end

                local egui = v:FindFirstChild("PlayerGui")
                if not egui then return end

                v.SetAttribute("InvitedBy", plr.Name)

                task.delay(10, function()
                    v:SetAttribute("InvitedBy", nil)
                    local partGUI = egui:FindFirstChild("PartyGUI")
                    if partyGUI then
                        partGUI.InvitedBG.Visible = false
                    end
                end)

                local partyGUI = egui:FindFirstChild("PartyGUI")
                if partGUI then
                    partyGUI.InvitedBG.Visible = true
                    partyGUI.InvitedBG.TextLabel.Text = plr.Name .. "  invited you to their party."
                end
            end
        end

    elseif params.msg2 == "Accepted" then
        local egui = plr:FindFirstChild("PlayerGui")
        if not egui then return end

        local partyLeader = plr:GetAttribute("InvitedBy")
        if not partyLeader then return end

        if getPartySize(partyLeader) >= PARTY_LIMIT then
            plr:SetAttribute("InvitedBy", nil)
            egui.PartyGUI.InvitedBG.TextLabel.Text = "Party is full !"
            egui.PartyGUI.InvitedBG.TextLabel.Visible = true
            return
        end

        plr:SetAttribute("PARTIED", partyLeader)

        local partyGUI = egui:FindFirstChild("PartyGUI")
        if partyGUI then
            partyGUI.InvitedBG.Visible = false
            partyGUI.leaveBTN.Visible = true
        end

        updatePartyUI(partyLeader)

    elseif params.msg2 == "Declined" then
        print("DECLINED")
    elseif params.msg2 == "CreateParty" then
        plr:SetAttribute("PARTIED", plr.Name)


        local egui = plr:FindFirstChild("PartyGUI")
        if egui then
            local partyGUI = egui:FindFirstChild("PartyGUI")
            if partyGUI then
                partyGUI.leaveBTN.Visible = true
            end
        end

        updatePartyUI(plr.Name)

    elseif params.msg2 == "LeaveParty" then
        local partyLeader = plr:GetAttribute("PARTIED")
        if not partyLeader then return end

        plr:SetAttribute("PARTIED", nil)
        clearPlayerUI(plr)

        if partyLeader == plr.Name then
            for _, member in ipairs(Players:GetPlayers()) do
                if member:GetAttribute("PARTIED") == partyLeader then
                    member:SetAttribute("PARTIED", nil)
                    clearPlayerUI(member)
                end
            end
        else
            updatePartyUI(partyLeader)
        end
    end
end)

Players.PlayerRemoving:Connect(handlePlayerLeave)
