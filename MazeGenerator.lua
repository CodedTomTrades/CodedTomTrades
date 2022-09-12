local maze = {}
local pathWidth = 10

local wallHeight = 12
local wallHeightPosition = wallHeight/2
local wallThick = 2
local wallLength = pathWidth + 2*wallThick
local wallOffset = pathWidth/2+wallThick/2

local floorHeight = 1
local floorHeightPosition = floorHeight/2
local floorTileDistance = pathWidth + wallThick

local stack = {}
table.insert(stack, { zValue=0, xValue=0 })
local columns = 12
local rows = 12
local random = Random.new()

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
	for z = 0, rows - 1, 1 do
		maze[z] = {}
		for x=0, columns-1, 1 do
			local positionX = x*floorTileDistance
			local positionZ = z*floorTileDistance
			local part = createPart(pathWidth, floorHeight, pathWidth, positionX, floorHeightPosition, positionZ)
			maze[z][x] = { tile=part }
		end
	end
end

local function createWalls()
	for z = 0, rows - 1, 1 do
		for x = 0, columns - 1, 1 do
			-- east walls
			local positionX = x*floorTileDistance+wallOffset
			local positionZ = z*floorTileDistance
			local part = createPart(wallThick, wallHeight, wallLength, positionX, wallHeightPosition, positionZ)
			maze[z][x].eastWall = part
			if maze[z][x+1] then
				maze[z][x+1].westWall = part
			end
			-- south walls
			local positionX = x*floorTileDistance
			local positionZ = z*floorTileDistance+wallOffset
			local part = createPart(wallLength, wallHeight, wallThick, positionX, wallHeightPosition, positionZ)
			maze[z][x].southWall = part
			if maze[z+1] then
				maze[z+1][x].northWall = part
			end
			-- edge along west
			if x == 0 then
				local positionX = -wallOffset
				local positionZ = z*floorTileDistance
				createPart(wallThick, wallHeight, wallLength, positionX, wallHeightPosition, positionZ)	
			end
			-- edge along north
			if z == 0 and x ~= 0 then
				local positionX = x*floorTileDistance
				local positionZ = -wallOffset
				createPart(wallLength, wallHeight, wallThick, positionX, wallHeightPosition, positionZ)				
			end
		end
	end
end
--Function to remove walls for the maze
local function removeWall(wall)
	local size = wall.Size
	local position = wall.Position
	wall.Size = Vector3.new(size.X, floorHeight, size.Z)
	wall.Position = Vector3.new(position.X, floorHeightPosition, position.Z)
	wall.BrickColor = BrickColor.White()
end
--Function to redraw the maze if its impossible
local function redrawMaze()
	for z = 0, rows - 1, 1 do
		for x = 0, columns - 1, 1 do
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
--get a cell neighbour thats unvisted so we can create the rest of the maze
local function getUnVisitedNeighbor(z, x)
	local neighbors = {} -- north:0, east:1, south:2, west:3
	-- north
	if maze[z - 1] and not maze[z - 1][x].visited then
		table.insert(neighbors, 0)
	end
	-- east
	if maze[ z ][x + 1] and not maze[z][x + 1].visited then
		table.insert(neighbors, 1)
	end
	-- south
	if maze[z + 1] and not maze[z + 1][x].visited then
		table.insert(neighbors, 2)
	end
	-- west
	if maze[z][x - 1] and not maze[z][x - 1].visited then
		table.insert(neighbors, 3)
	end
	return neighbors
end

local function searchPath()
	if stack == nil or #stack == 0 then
		return false
	end
	local stackCell = stack[#stack]
	local x = stackCell.xValue
	local z = stackCell.zValue

	maze[z][x].tile.BrickColor = BrickColor.Green()
	task.wait()
	local neighbors = getUnVisitedNeighbor(z, x)
	if #neighbors > 0 then
		local index = random:NextInteger(1, #neighbors)
		local nextCellDirection = neighbors[index]
		if nextCellDirection == 0 then --north
			maze[z][x].northPath = true
			maze[z - 1][x].southPath = true
			maze[z - 1][x].visited = true
			table.insert(stack, { zValue = z - 1, xValue = x })
		elseif nextCellDirection == 1 then --east
			maze[z][x].eastPath = true
			maze[z][x + 1].westPath = true
			maze[z][x + 1].visited = true
			table.insert(stack, { zValue = z, xValue = x + 1 })
		elseif nextCellDirection == 2 then --south
			maze[z][x].southPath = true
			maze[z + 1][x].northPath = true
			maze[z + 1][x].visited = true
			table.insert(stack, { zValue = z + 1, xValue = x })
		elseif nextCellDirection == 3 then --west
			maze[z][x].westPath = true
			maze[z][x - 1].eastPath = true
			maze[z][x - 1].visited = true
			table.insert(stack, { zValue = z, xValue = x - 1 })
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
