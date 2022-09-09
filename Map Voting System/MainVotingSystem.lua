--Variables
local RS = game:GetService("ReplicatedStorage")
local VotingSystem = game.Workspace.Voting
local Status = RS.Status

local Choices = VotingSystem:GetChildren()
local Maps = RS.Maps:GetChildren()

local Intermission = 10

local IsAnOption
local RandomMap

local ChosenMap
local MapClone

local function PickRandomMap()

	local RandomNumber = math.random(1, #Maps)

	RandomMap = Maps[RandomNumber]
	
	return RandomMap.CanBeVoted
end


for i, choice in pairs(Choices) do

	local Name = choice.label.SurfaceGui.TextLabel
	local Picture = choice.Image.SurfaceGui.ImageLabel

	IsAnOption = PickRandomMap()
	
	if IsAnOption.Value == true then
		repeat 
			IsAnOption = PickRandomMap()
		until
		IsAnOption.Value == false
		Name.Text = RandomMap.Name
		Picture.Image = RandomMap.Image.Value
		RandomMap.CanBeVoted.Value = true
		
	else
		Name.Text = RandomMap.Name
		Picture.Image = RandomMap.Image.Value
		RandomMap.CanBeVoted.Value = true		
	end					
end	


RS.InRound.Changed:Connect(function()
	
	if RS.InRound.Value == false then
		
		MapClone:Destroy()
		
		for i, map in pairs(Maps) do
			map.CanBeVoted.Value = false
		end
		
		for i, choice in pairs(Choices) do

			local name = choice.label.SurfaceGui.TextLabel
			local picture = choice.Image.SurfaceGui.ImageLabel
			
			IsAnOption = PickRandomMap()

			if IsAnOption.Value == true then
				repeat 
					IsAnOption = PickRandomMap()
				until
				IsAnOption.Value == false
				name.Text = RandomMap.Name
				picture.Image = RandomMap.Image.Value
				RandomMap.CanBeVoted.Value = true

			else
				name.Text = RandomMap.Name
				picture.Image = RandomMap.Image.Value
				RandomMap.CanBeVoted.Value = true		
			end					
		end	
		
		
	else
		
		-- after the intermission has ended, the round will soon begin
    
		--- when the map with most votes will be spawned

		local Choice1Votes = #VotingSystem.Choice1.button.Votes:GetChildren()
		local Choice2Votes = #VotingSystem.Choice2.button.Votes:GetChildren()
		local Choice3Votes = #VotingSystem.Choice3.button.Votes:GetChildren()

		if Choice1Votes >= Choice2Votes and Choice1Votes >= Choice3Votes then

			ChosenMap = VotingSystem.Choice1.label.SurfaceGui.TextLabel.Text

		elseif Choice2Votes >= Choice1Votes and Choice2Votes >= Choice3Votes then

			ChosenMap = VotingSystem.Choice2.label.SurfaceGui.TextLabel.Text

		else

			ChosenMap = VotingSystem.Choice3.label.SurfaceGui.TextLabel.Text

		end
		
		
		Status.Value = "The Chosen map is: ".. ChosenMap
		
		--- getting the map from the replicated storgae to the workspace
		
		for i, map in pairs(Maps) do
			if ChosenMap == map.Name then
				MapClone = map:Clone()
				MapClone.Parent = game.Workspace
			end
		end	
		
		task.wait(3)
		
		-- clears all the votes for next round

		for i, choice in pairs(Choices) do
			choice.label.SurfaceGui.TextLabel.Text = " "
			choice.Image.SurfaceGui.ImageLabel.Image = " "
			choice.button.Votes:ClearAllChildren()
			RS.VoteReset:FireAllClients(choice.button)
		end
		
		local Spawns = MapClone.Spawns:GetChildren()
		
		for i, plr in pairs(game.Players:GetChildren()) do

			local char = plr.Character or plr.CharacterAdded:Wait()
			local hum = char:WaitForChild("Humanoid")
			local humanRoot = char:WaitForChild("HumanoidRootPart")
			
			plr.Team = game.Teams.Playing
			humanRoot.CFrame = Spawns[math.random(1, #Spawns)].CFrame
			
			hum.Died:Connect(function()
				plr.Team = game.Teams.Lobby
			end)
			
		end
		
	end	
end)
