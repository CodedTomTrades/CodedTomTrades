local text = script.Parent

text.Text = game.ReplicatedStorage.Status.Value

game.ReplicatedStorage.Status.Changed:Connect(function()
	text.Text = game.ReplicatedStorage.Status.Value
end)
