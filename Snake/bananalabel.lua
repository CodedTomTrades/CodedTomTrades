local Value = workspace.Value

game["Run Service"].Heartbeat:Connect(function(DeltaTime)
	if Value.Value == true then
		script.Parent.Visible = true
	end
	if Value.Value == false  then
		script.Parent.Visible = false
	end
end)
