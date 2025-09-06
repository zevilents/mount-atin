-- AUTO FISHING + AUTO SELL (Fish It)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- biasanya event server ada di ReplicatedStorage
-- misal RemoteEvent: "CastLine", "ReelIn", "SellFish"
-- ini contoh, kamu harus cek nama event di game Fish It

local remoteCast = ReplicatedStorage:WaitForChild("CastLine") -- ganti sesuai event asli
local remoteReel = ReplicatedStorage:WaitForChild("ReelIn")   -- ganti sesuai event asli
local remoteSell = ReplicatedStorage:WaitForChild("SellFish") -- ganti sesuai event asli

local autofish = true
local autosell = true

-- Auto fishing loop
task.spawn(function()
    while autofish do
        pcall(function()
            remoteCast:FireServer() -- lempar pancing
            task.wait(5) -- tunggu ikan (atur sesuai timing di game)
            remoteReel:FireServer() -- tarik ikan
        end)
        task.wait(1)
    end
end)

-- Auto sell loop
task.spawn(function()
    while autosell do
        pcall(function()
            remoteSell:FireServer() -- jual ikan
        end)
        task.wait(10) -- tiap 10 detik jual
    end
end)
