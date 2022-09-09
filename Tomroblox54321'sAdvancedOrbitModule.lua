--Code Made By Tomroblox54321 and IlyasTawawe
--Eccentricty Code made tweaked by Creeperman16487
--All gave permission to use code in the module
--Hope you Enjoy!




local OrbitModule = {}

--Getting RunService
local RunService = game:GetService("RunService")

--Getting Our Math Variables
local CosineMath = math.cos
local SineMath = math.sin
local Atan2Math = math.atan2
local Tan = math.tan

local PIMath = math.pi
local TAU = 2*PIMath

--Getting HeartbeatWait
local HeartbeatWait = RunService.Heartbeat:Wait()


--Creating the Circular Orbit Function
function OrbitModule:CircularOrbit(PlanetOrbiting : PVInstance, PlanetGettingOrbited : PVInstance, TimeToOrbit : number)
	assert(PlanetOrbiting ~= PlanetGettingOrbited, "Cannot orbit itself, PlanetOrbiting and PlanetGettingOrbited should be different")
	task.wait(HeartbeatWait)

	--Getting Our Difference, Radius and Angle
	local DifferenceVector = PlanetOrbiting:GetPivot().Position-PlanetGettingOrbited:GetPivot().Position --Differnce
	local Radius = DifferenceVector.Magnitude
	local Angle = Atan2Math(DifferenceVector.Y, DifferenceVector.X)--Angle
	
	--Creating the HeartbeatCobnection
	local HeartbeatConnection
	HeartbeatConnection = RunService.Heartbeat:Connect(function(DeltaTime)
		-- Disconnect the event if one of the planets got destroyed
		if not (PlanetOrbiting or PlanetGettingOrbited) then
			HeartbeatConnection:Disconnect()
			HeartbeatConnection = nil
			assert("Orbit Disconnected")
		end
		
		task.wait(HeartbeatWait/10)
		-- Polar coordinates 2D
		local x = Radius*CosineMath(Angle)
		local y = Radius*SineMath(Angle)
		local z =  0
		
		--Putting it all together
		PlanetOrbiting:PivotTo(PlanetGettingOrbited.CFrame*CFrame.new(x, y, z))
		Angle += DeltaTime*TAU/TimeToOrbit
	end)
	-- Return the heartbeat connection, so we can disconnect it if we no longer wants the part to orbit
	return HeartbeatConnection
end


function OrbitModule:EccentricOrbit(PlanetOrbiting : PVInstance, PlanetGettingOrbited : PVInstance, TimeToOrbit : number, Eccentricity : number)
	assert(PlanetOrbiting ~= PlanetGettingOrbited, "Cannot orbit itself, PlanetOrbiting and PlanetGettingOrbited should be different")
	
	--Getting Our Difference, Radius and Angle
	local DifferenceVector = PlanetOrbiting:GetPivot().Position-PlanetGettingOrbited:GetPivot().Position --Differnce
	local Radius = DifferenceVector.Magnitude
	local Angle = Atan2Math(DifferenceVector.Y, DifferenceVector.X)--Angle
	
	
	--Creating HeartbeatConnection
	local HeartbeatConnection
	HeartbeatConnection = RunService.Heartbeat:Connect(function(DeltaTime)
		-- Disconnect the event if one of the planets got destroyed
		if not (PlanetOrbiting or PlanetGettingOrbited) then
			HeartbeatConnection:Disconnect()
			HeartbeatConnection = nil
			assert("Orbit Disconnected")
		end

		-- Polar coordinates 2D
		local x = (Radius+Eccentricity/2)*CosineMath(Angle)
		local y = Radius*SineMath(Angle)
		local z = 0
		local Offset = CFrame.new(Eccentricity,0,0)
		PlanetOrbiting:PivotTo((PlanetGettingOrbited.CFrame*Offset)*CFrame.new(x, y, z))
		Angle += DeltaTime*TAU/TimeToOrbit
	end)

	-- Return the heartbeat connection, so we can disconnect it if we no longer wants the part to orbit
	return HeartbeatConnection

end

function OrbitModule:EllipticalOrbit(PlanetOrbiting : PVInstance, PlanetGettingOrbited : PVInstance, TimeToOrbit : number, Ellipse : number)
	assert(PlanetOrbiting ~= PlanetGettingOrbited, "Cannot orbit itself, PlanetOrbiting and PlanetGettingOrbited should be different")

	local DifferenceVector = PlanetOrbiting:GetPivot().Position-PlanetGettingOrbited:GetPivot().Position --Differnce
	local Radius = DifferenceVector.Magnitude

	local Angle = Atan2Math(DifferenceVector.Y, DifferenceVector.X)--Angle

	local HeartbeatConnection
	HeartbeatConnection = RunService.Heartbeat:Connect(function(DeltaTime)
		-- Disconnect the event if one of the planets got destroyed
		if not (PlanetOrbiting or PlanetGettingOrbited) then
			HeartbeatConnection:Disconnect()
			HeartbeatConnection = nil
		end
		
		local EllipseNumber = (Ellipse/10)

		-- Polar coordinates 2D
		local x = (Radius*EllipseNumber)*CosineMath(Angle)
		local y = (Radius/EllipseNumber)*SineMath(Angle)
		local z = 0
		--Putting it all together
		PlanetOrbiting:PivotTo(PlanetGettingOrbited.CFrame*CFrame.new(x, y, z))
		Angle += DeltaTime*TAU/TimeToOrbit
	end)

	-- Return the heartbeat connection, so we can disconnect it if we no longer wants the part to orbit
	return HeartbeatConnection
end

--Returning the whole module
return OrbitModule
