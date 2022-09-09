local Intermission = 10
local RoundLength = 15

local InRound = game.ReplicatedStorage.InRound
local Staus = game.ReplicatedStorage.Status



InRound.Changed:Connect(function()
	if InRound.Value == false then
		for i, plr in pairs(game.Players:GetChildren()) do
			local char = plr.Character or plr.CharacterAdded:Wait()
			local humanRoot = char:WaitForChild("HumanoidRootPart")
			humanRoot.CFrame = game.Workspace.lobbySpawn.CFrame
		end	
	end	
end)


local function round()
	while true do
		InRound.Value = false		
		for i = Intermission, 0, -1 do
			Staus.Value = "Game will start in "..i.." seconds"
			task.wait(1)
		end

		InRound.Value = true		
		task.wait(3)
		for i = RoundLength, 0, -1 do
			task.wait(1)
			Staus.Value = "Game will end in "..i.." seconds"
			local playing = {}
			for i, plr in pairs(game.Players:GetChildren()) do
				if plr.Team.Name == "Playing" then
					table.insert(playing, plr.Name)
					--print("inserted player")
				end	
			end

			if #playing == 0 then
				Staus.Value = "Everyone Has Died"
				task.wait(3)
				break
			end
		end
	end
end


task.spawn(round)
