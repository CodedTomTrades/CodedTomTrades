local RS = game:GetService("ReplicatedStorage")
local InRound = RS.InRound
local VotingSystem = game.Workspace.Voting

RS.Voted.OnClientEvent:Connect(function(But, OtherButtons)
	-- this wi change the button that is pressed to green
	But.BrickColor = BrickColor.new("Bright green")
	-- the other buttons than haven been pressed before, will revert back to beng grey
	OtherButtons[1].BrickColor = BrickColor.new("Fossil")
	OtherButtons[2].BrickColor = BrickColor.new("Fossil")
end)

RS.VoteReset.OnClientEvent:Connect(function(Button)
	Button.BrickColor = BrickColor.new("Fossil")
end)
