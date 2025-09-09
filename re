-- ===============================
-- RECORD & PLAYBACK MOVEMENT
-- ===============================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Data rekaman
local recording = false
local playback = false
local recordData = {}

-- Mulai rekam
local function startRecord()
	recording = true
	recordData = {}
	print("[Recorder] Start recording...")
	
	local startTime = tick()
	
	-- Loop rekam
	while recording do
		local t = tick() - startTime
		table.insert(recordData, {
			time = t,
			cf = hrp.CFrame,
			vel = hrp.Velocity,
			jump = humanoid.Jump
		})
		RunService.Heartbeat:Wait()
	end
	print("[Recorder] Recording stopped. Frames:", #recordData)
end

-- Stop rekam
local function stopRecord()
	recording = false
end

-- Playback
local function playRecord()
	if #recordData == 0 then
		warn("[Recorder] No data recorded!")
		return
	end
	playback = true
	print("[Recorder] Start playback...")
	
	local startTime = tick()
	for i, frame in ipairs(recordData) do
		if not playback then break end
		
		-- Tunggu sesuai timing
		local now = tick() - startTime
		local delay = frame.time - now
		if delay > 0 then
			task.wait(delay)
		end
		
		-- Set posisi
		hrp.CFrame = frame.cf
		hrp.Velocity = frame.vel
		
		-- Trigger jump
		if frame.jump then
			humanoid.Jump = true
		end
	end
	print("[Recorder] Playback finished.")
	playback = false
end

local function stopPlayback()
	playback = false
end

-- ===============================
-- SIMPLE KEYBIND (R = Record, T = Stop, Y = Play)
-- ===============================
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.R then
		if not recording then
			task.spawn(startRecord)
		end
	elseif input.KeyCode == Enum.KeyCode.T then
		if recording then
			stopRecord()
		else
			stopPlayback()
		end
	elseif input.KeyCode == Enum.KeyCode.Y then
		if not playback then
			task.spawn(playRecord)
		end
	end
end)

print(">> Press R to Record, T to Stop, Y to Playback <<")
