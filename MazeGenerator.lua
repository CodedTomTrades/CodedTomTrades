local maze = {}
local pathWd = 10
local wallHt = 12
local wallHtPos = wallHt/2
local wallThick = 2
local wallLen = pathWd + 2*wallThick
local wallOffset = pathWd/2+wallThick/2
local floorHt = 1
local floorHtPos = floorHt/2
local floorTileDist = pathWd + wallThick
local stack = {}
table.insert(stack, { zVal=0, xVal=0 })
local cols = 12
local rows = 12
local rnd = Random.new()
local function createEnd()
	for i, v in ipairs(workspace:GetChildren()) do
		if v:IsA("Part") and v.Position == Vector3.new(132, 6, 138) then
			v:Destroy()
			continue
		end
	end
end
local function createPart(x, y, z, px, py, pz)
	local part = Instance.new("Part", workspace)
	part.Anchored = true
	part.Size = Vector3.new(x, y, z)
	part.Position = Vector3.new(px, py, pz)
	part.TopSurface = Enum.SurfaceType.Smooth
	return part
end
local function createFloor()
	for z=0, rows-1, 1 do
		maze[z] = {}
		for x=0, cols-1, 1 do
			local posX = x*floorTileDist
			local posZ = z*floorTileDist
			local part = createPart(pathWd, floorHt, pathWd, posX, floorHtPos, posZ)
			maze[z][x] = { tile=part }
		end
	end
end
local function createWalls()
	for z=0, rows-1, 1 do
		for x=0, cols-1, 1 do
			local posX = x*floorTileDist+wallOffset
			local posZ = z*floorTileDist
			local part = createPart(wallThick, wallHt, wallLen, posX, wallHtPos, posZ)
			maze[z][x].eastWall = part
			if maze[z][x+1] then
				maze[z][x+1].westWall = part
			end
			local posX = x*floorTileDist
			local posZ = z*floorTileDist+wallOffset
			local part = createPart(wallLen, wallHt, wallThick, posX, wallHtPos, posZ)
			maze[z][x].southWall = part
			if maze[z+1] then
				maze[z+1][x].northWall = part
			end
			if x==0 then
				local posX = -wallOffset
				local posZ = z*floorTileDist
				createPart(wallThick, wallHt, wallLen, posX, wallHtPos, posZ)	
			end
			if z==0 and x~=0 then
				local posX = x*floorTileDist
				local posZ = -wallOffset
				createPart(wallLen, wallHt, wallThick, posX, wallHtPos, posZ)				
			end
		end
	end
end
local function removeWall(wall)
	local s = wall.Size
	local p = wall.Position
	wall.Size = Vector3.new(s.X, floorHt, s.Z)
	wall.Position = Vector3.new(p.X, floorHtPos, p.Z)
	wall.BrickColor = BrickColor.White()
end
local function redrawMaze()
	for z=0, rows-1, 1 do
		for x=0, cols-1, 1 do
			local cell = maze[z][x]
			if cell.visited then
				cell.tile.BrickColor = BrickColor.White()
				if cell.northPath then
					removeWall(cell.northWall)
				end
				if cell.eastPath then
					removeWall(cell.eastWall)
				end
				if cell.southPath then
					removeWall(cell.southWall)
				end
				if cell.westPath then
					removeWall(cell.westWall)
				end
			end
		end	
	end
end
local function getUnVisitedNeighbor(z, x)
	local neighbors = {} 
	if maze[z-1] and not maze[z-1][x].visited then
		table.insert(neighbors, 0)
	end
	if maze[z][x+1] and not maze[z][x+1].visited then
		table.insert(neighbors, 1)
	end
	if maze[z+1] and not maze[z+1][x].visited then
		table.insert(neighbors, 2)
	end
	if maze[z][x-1] and not maze[z][x-1].visited then
		table.insert(neighbors, 3)
	end
	return neighbors
end
local function searchPath()
	if stack==nil or #stack==0 then
		return false
	end
	local stackCell = stack[#stack]
	local x = stackCell.xVal
	local z = stackCell.zVal
	maze[z][x].tile.BrickColor = BrickColor.Green()
	task.wait()
	local neighbors = getUnVisitedNeighbor(z, x)
	if #neighbors > 0 then
		local idx = rnd:NextInteger(1, #neighbors)
		local nextCellDir = neighbors[idx]
		if nextCellDir == 0 then --north
			maze[z][x].northPath = true
			maze[z-1][x].southPath = true
			maze[z-1][x].visited = true
			table.insert(stack, { zVal=z-1, xVal=x })
		elseif nextCellDir == 1 then --east
			maze[z][x].eastPath = true
			maze[z][x+1].westPath = true
			maze[z][x+1].visited = true
			table.insert(stack, { zVal=z, xVal=x+1 })
		elseif nextCellDir == 2 then --south
			maze[z][x].southPath = true
			maze[z+1][x].northPath = true
			maze[z+1][x].visited = true
			table.insert(stack, { zVal=z+1, xVal=x })
		elseif nextCellDir == 3 then --west
			maze[z][x].westPath = true
			maze[z][x-1].eastPath = true
			maze[z][x-1].visited = true
			table.insert(stack, { zVal=z, xVal=x-1 })
		end
	else
		table.remove(stack, #stack)
	end
	return true
end
createFloor()
createWalls()
maze[0][0].visited = true
for i=10, 1, -1 do
	print("starting in ", i)
	task.wait(1)
end
while searchPath() do
	redrawMaze()
	task.wait()
	createEnd()
end
print("Finished!")
