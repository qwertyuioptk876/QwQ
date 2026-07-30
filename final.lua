local player = game:GetService("Player")
local LocalPlayer = player.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local lobby_ID = 99521272836282
local battle_ID = 79787558257549

local currentplace = game.PlaceID
if currentplace ~= battle_ID then
  print("位置錯誤")
  return
end

local StatsList = game.Players.LocalPlayer.playerGui.Frames.PauseFrame.LeftFrame.StatList
local Mystats = {}
local Wish = {
  "Luck",
  "Damage",
  "Attack Speed"
}

for _, item in ipairs(StatsList:GetDescendants()) do
  if item.Name == "StatAmount" then
    local StatName = item.Parent.Name 
    Mystats[StatName] = item
  end
end

