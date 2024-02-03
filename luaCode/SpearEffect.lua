
--Credit: Jolly Sev (For some aspects of this code)
--Services--
local rp = game:GetService("ReplicatedStorage")
local plr = game:GetService("Players")
local uis = game:GetService("UserInputService")
local debris = game:GetService("Debris")
local runService = game:GetService("RunService")
local ts = game:GetService("TweenService")

local vfxMod = require(script.VfxModule)
local Generaluse = require(rp.Modules.Shared.GeneralUse)
local BaseEffects = require(rp.Modules.Shared.BaseEffects)

local LocalPlayer = plr.LocalPlayer
local Camera = workspace.CurrentCamera
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hum,hroot = char:FindFirstChild("Humanoid"),char:FindFirstChild("HumanoidRootPart")
local Mouse = LocalPlayer:GetMouse()
local assetFolder = rp.Assets.Particles.Spells.Ice.SpearCast

--Constants--
local numOfSpears = 3
local SpearSpawnHeight = 25

--Functions--
function findFloorPosition(startingPosition)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {workspace.Debris}

	local raycastResult = workspace:Raycast(startingPosition + Vector3.new(0,1000,0), Vector3.new(0, -100000000000000000, 0),raycastParams)

	if raycastResult then
		return raycastResult.Position
	else
		return nil -- Return nil if no intersection with the floor is found
	end
end

local function Explosion(explodePos, bool)
	if bool == true then
		local Explode = assetFolder.IceSpearImpact:Clone()
		Explode.Position = explodePos
		Explode.Parent = workspace.Debris
		vfxMod.ParticleEmitter(Explode.Attachment, 1)
		debris:AddItem(Explode,4)
	end
end


local function getSurfaceCF(baseCF:CFrame)
	baseCF = baseCF * CFrame.new(0,2,0)
	local function getRaycastPosition(cfChange:CFrame)
		local startCF = baseCF*cfChange

		local raycastDirecton = baseCF.UpVector*-10
		local result = Generaluse.GetFirstCollidable(startCF.Position,raycastDirecton)
		local endPos = (result and result.Position) or (startCF*CFrame.new(0,-2,0)).Position

        --[[ local dist = (startCF.Position-endPos).Magnitude
        generateDebugPart(CFrame.new(startCF.Position,endPos)*CFrame.new(0,0,-dist/2),Vector3.new(.2*.1,.2*.1,dist))
        generateDebugPart(startCF,Vector3.new(.3,.3,.3)*.1)
        generateDebugPart(CFrame.new(endPos),Vector3.new(.5,.5,.5)*.1)--]]
		return endPos,result
	end

	local rightPos,leftPos = getRaycastPosition(CFrame.new(.1,0,0)),getRaycastPosition(CFrame.new(-.1,0,0))
	local upPos,downPos = getRaycastPosition(CFrame.new(0,0,-.1)),getRaycastPosition(CFrame.new(0,0,.1))
	local centerPos,centerResult = getRaycastPosition(CFrame.new(0,0,0))
	local rightVector = CFrame.new(leftPos,rightPos).LookVector
	local upVector = CFrame.new(downPos,upPos).LookVector

	local surfaceCF = CFrame.fromMatrix(centerPos,rightVector,upVector)
	return surfaceCF*CFrame.Angles(math.pi/2,0,0),centerResult
end



local function SpawnSpear(startPos, LandPos, bool)
	
	if bool == true then
		local Spear = assetFolder.IceSpear:Clone()
		local endPos = findFloorPosition(LandPos)
		Spear.Position = LandPos 
		Spear.Parent = workspace.Debris		
		
		ts:Create(Spear,TweenInfo.new(0.75,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Transparency = 0}):Play()
		
		task.wait(0.3)
		
		ts:Create(Spear,TweenInfo.new(.45,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Position = endPos}):Play()
		
		task.wait(.45)
		local aftermath = assetFolder.Aftermath:Clone()
		aftermath.Parent = workspace.Debris
		aftermath.Position = endPos
		vfxMod.TweenToZero(Spear)
		ts:Create(Spear,TweenInfo.new(.65,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Transparency = 1}):Play()
		Explosion(endPos,bool)
		
		vfxMod.ParticleToggler(Spear)
		
		local rockCframe = CFrame.new(endPos)
		BaseEffects.GroundExpandV2(rockCframe,3,7)
		debris:AddItem(Spear,2)
		
		task.wait(0.5)
		ts:Create(aftermath,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = Vector3.new(0,0,0)}):Play()
		debris:AddItem(aftermath,3)
	end
end



function makeExplosion(landPos, spawnPos, bool)
	SpawnSpear(landPos, spawnPos, bool)
end

local function main()
	local hitMouse = Mouse.Hit
	if findFloorPosition(hitMouse.Position) == nil then print("No Target") return end
	local spearPos = hitMouse.Position + Vector3.new(0,SpearSpawnHeight,0)	
	SpawnSpear(hitMouse.Position,spearPos, true)
	
end


--Input--
uis.InputBegan:Connect(function(input, gpe)
	if not gpe  then
		if input.KeyCode == Enum.KeyCode.E then
			main()
		end
	end
end)
