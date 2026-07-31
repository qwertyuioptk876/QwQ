local player = game:GetService("Players")
local LocalPlayer = player.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local lobby_ID = 99521272836282
local battle_ID = 79787558257549

local currentplace = game.PlaceId
if currentplace ~= battle_ID then
  print("位置錯誤")
  return
end

local StatsList = game.Players.LocalPlayer.PlayerGui.Frames.PauseFrame.LeftFrame.StatList
local Frames = PlayerGui:WaitForChild("Frames")
local PauseFrame = Frames:WaitForChild("PauseFrame")
local Holder = Frames:WaitForChild("Upgrades"):WaitForChild("Holder")


local Mystats = {}
local Myselections = { 
  [1] = {botton = Holder.Selection1, name =  Holder.Selection1.ItemTitle},
  [2] = {botton = Holder.Selection2, name =  Holder.Selection2.ItemTitle},
  [3] = {botton = Holder.Selection3, name =  Holder.Selection3.ItemTitle}
}

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

while true do
  task.wait(2)
  for i = 1, 3, 1 do
    if Myselections[i].name.Text == "luck" and Mystats.luck.Text < 600  then
      Myselections[i].botton.Activate()
    end
    if i == 3 then
      Myselections[i].botton.Activate()
    end
  end
end


