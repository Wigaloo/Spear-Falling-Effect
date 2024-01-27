local TweenService = game:GetService("TweenService")

local Vfx = {}


function Vfx.DisableAllBeams(model)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("Beam") then
			descendant.Width0 = 0
			descendant.Width1 = 0
		end
	end
end

function Vfx.FlickerBeam(model,delayTime)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("Beam") then
			descendant.Enabled = true
			task.delay(delayTime,function()
				descendant.Enabled = false
			end)
		end
	end
end

function Vfx.DisableAllTrails(model)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("Trail") then
			descendant.Enabled = false
		end
	end
end

function Vfx.EnableAllTrails(model)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("Trail") then
			descendant.Enabled = true
		end
	end
end

function Vfx.TweenToNorm(model)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("Beam") then
			local RandTime = (math.random(50,70)/100)
			local Tween = TweenService:Create(descendant, TweenInfo.new(RandTime,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Width0 = descendant:GetAttribute("Width0") , Width1 = descendant:GetAttribute("Width1")})

			task.delay(0.1,function()
				Tween:Play()
			end)
		end
	end
end

function Vfx.TweenToZero(model)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("Beam") then
			local Tween = TweenService:Create(descendant, TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Width0 = 0 , Width1 =0})
			Tween:Play()
		end
	end
end

function Vfx.ParticleToggler(model,status)
	for _, descendant in ipairs(model:GetDescendants()) do
		if descendant:IsA("ParticleEmitter") then
			descendant.Enabled = status
		end
	end
end


function Vfx.ParticleEmitter(model)
	for _, v in ipairs(model:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			local EmitCount = v:GetAttribute("EmitCount")
			local EmitDelay = v:GetAttribute("EmitDelay")
			local EmitDuration = v:GetAttribute("EmitDuration")
			
			
			local delayDuration = v:GetAttribute("EmitDelay")
			if delayDuration and delayDuration > 0 then
				task.delay(delayDuration, function()
					v:Emit(v:GetAttribute("EmitCount"))
				end)
			else
				v:Emit(v:GetAttribute("EmitCount"))
			end	
				
			if EmitDuration ~= nil then
				if EmitDuration > 0 then
				v.Enabled = true
					task.delay(EmitDuration,function()
						v.Enabled = false
					end)
				end
			end
		end
	end
end


return Vfx
