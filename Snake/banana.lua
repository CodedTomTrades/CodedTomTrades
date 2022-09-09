local Banana = game:GetService("ServerStorage").BIGBANANA
local Value = workspace.Value

while true do
	task.wait(10)
	local NewBannana = Banana:Clone()
	NewBannana.Parent = workspace
	Value.Value = true
	task.wait(45)
end
