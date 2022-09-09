game:GetService("Players").PlayerAdded:Connect(function(Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Parent = Player
	leaderstats.Name = "hi"
	
	local Length = Instance.new("NumberValue")
	Length.Parent = leaderstats
	Length.Name = "Length"
	
	local Cash =Instance.new("NumberValue")
	Cash.Parent = leaderstats
	Cash.Name = "Cash"
end)
