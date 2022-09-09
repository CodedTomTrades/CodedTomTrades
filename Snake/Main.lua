local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local SellPart = workspace.SellArea

local CharacterData = {}

local Folder = nil
local Counter = 0

local Color1Default = Color3.fromRGB(0,16, 176)
local Color2Default = Color3.fromRGB(255, 0, 0)

local Grape = ServerStorage.Grape
local Apple = ServerStorage.Apple
local Pineapple = ServerStorage.Pineapple
local Banana = ServerStorage.Banana

function CreateFoods()
	local NewGrape = Grape:Clone()
	NewGrape.Parent = workspace:WaitForChild("Food")
	NewGrape.Position = Vector3.new(math.random(-50, 50), 2, math.random(-50, 50))
	local NewApple = Apple:Clone()
	NewApple.Parent = workspace:WaitForChild("Food")
	NewApple.Position = Vector3.new(math.random(-50, 50), 2, math.random(-50, 50))
	local NewPinapple = Pineapple:Clone()
	NewPinapple.Parent = workspace:WaitForChild("Food")
	NewPinapple.Position = Vector3.new(math.random(-50, 50), 2, math.random(-50, 50))
	local NewBanana = Banana:Clone()
	NewBanana.Parent = workspace:WaitForChild("Food")
	NewBanana.Position = Vector3.new(math.random(-50, 50), 2, math.random(-50, 50))
end

function CreatePart(Character, PlayerColor1 : Color3, PlayerColor2 : Color3)
	local Data = CharacterData[Character]

	local Part = Instance.new("Part")
	Part.Shape = Enum.PartType.Ball
	Part.Anchored = true
	Part.Size = Vector3.new(1.5, 1.5, 1.5)
	Part.Material = Enum.Material.SmoothPlastic
	Part.Parent = Character
	Part.CanCollide = false
	Part.Name = "SnakePart"

	Counter += 0.005 -- increment the color
	Part.Color = PlayerColor1:Lerp(PlayerColor2, Counter % 1) -- set the new parts color

	table.insert(Data.Parts, Part)
end

function OnHeartbeat(DeltaTime)

	for Character, Data in pairs(CharacterData) do
		if (Character.PrimaryPart.Position - Data.Position).Magnitude < 1 then continue end
		local Part = table.remove(Data.Parts, 1)
		if Part == nil then continue end
		table.insert(Data.Parts, Part)
		Part.Position = Data.Position

		Counter += 0.005-- increment the color

		Data.Position = Character.PrimaryPart.Position
		
		local Color1 = Character:WaitForChild("Color1")
		local Color2 = Character:WaitForChild("Color2")
		
		Data.PlayerColor1 = Color1.Value
		Data.PlayerColor2 = Color2.Value
		
		Part.Color = Data.PlayerColor1:Lerp(Data.PlayerColor2, Counter % 1) -- update the parts color
		
		
	end
end

function CharacterAdded(Character)
	local Data = {}
	Data.Position = Character.PrimaryPart.Position
	Data.Parts = {}
	Data.Number = 0
	CharacterData[Character] = Data
	local Name = Character.Name
	local Color1 = Instance.new("Color3Value", Character)
	Color1.Name = "Color1"
	Color1.Value = Color3.fromRGB(0,16, 176)
	local Color2 = Instance.new("Color3Value", Character)
	Color2.Name = "Color2"
	Color2.Value = Color3.fromRGB(255, 0, 0)
	
	
	local OnTouched = function(Hit)
		if Hit.Parent ~= Folder then 
			return
		end
		if Hit.Name == "Apple" or Hit.Name == "Pineapple" or Hit.Name == "Banana" or Hit.Name == "Grape" then
			Players:FindFirstChild(Name).hi.Length.Value += 1
		end
		if Hit.Name == "SellPart" then
			print("touched sell")
			for _, v in ipairs(Character:GetChildren()) do
				print("looping")
				if v.Name == "SnakePart" then
					print("found ")
					Data.Number += 1
					print("added")
					v:Destroy()
					print("destroyed")
				end 
			end
			Players:FindFirstChild(Name).hi.Cash.Value += Data.Number
			Data.Number = 0 
		end
		Hit.Position = Vector3.new(math.random(-50, 50), 2, math.random(-50, 50))
		
		Data.PlayerColor1 = Character:WaitForChild("Color1")
		Data.PlayerColor2 = Character:WaitForChild("Color2")
		
		
		--[[
		Color1.Changed:Connect(function(NewValue)
			Color1.Value = NewValue
			Color1Value = NewValue
			print("Changed")
		end)
		
		Color2.Changed:Connect(function(NewValue)
			Color2.Value = NewValue
			Color2Value = NewValue
			print("Changed")
		end)
		
			]]
		CreatePart(Character, Data.PlayerColor1.Value, Data.PlayerColor2.Value)
	end
	Character.PrimaryPart.Touched:Connect(OnTouched)
end
function CharacterRemoving(Character)
	local Data = CharacterData[Character]

	for i, Part in ipairs(Data.Parts) do
		Part:Destroy()
	end

	CharacterData[Character] = nil
end

function PlayerAdded(Player)
	Player.CharacterAdded:Connect(CharacterAdded)
	Player.CharacterRemoving:Connect(CharacterRemoving)
end


--[[
local SellPartTouched = function(Hit)
	local Character = Hit.Parent
	print("script still running")
	local Humanoid = Character:FindFirstChild("Humanoid")
	local Player = Players:FindFirstChild(Character.Name)
	local hiFolder = Player:WaitForChild("hi", 0.01)
	print(hiFolder.Name)
	local LengthValue = Players:FindFirstChild(Character.Name):WaitForChild("hi"):WaitForChild("Length")
	
	if Player and LengthValue and Character and Humanoid then
		local Data = {}
		Data.Number = 0
		CharacterData[Character] = Data
		for _, v in ipairs(Character:GetChildren()) do
			if v.Name == "SnakePart" then
				Data.Number += 1
				v:Destroy()
				continue
			end
		end
	end
end
]]
Folder = Instance.new("Folder")
Folder.Parent = workspace
Folder.Name = "Food"

for i = 1, 7, 1 do
	CreateFoods() 
end

Players.PlayerAdded:Connect(function(Player)
	PlayerAdded(Player)
end)
RunService.Heartbeat:Connect(OnHeartbeat)
