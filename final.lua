local player = game:GetService("Player")
local Localplayer = player.LocalPlayer

local lobby_ID = 99521272836282
local battle_ID = 79787558257549

local currentplace = game.PlaceID
if currentplace ~= battle_ID then
  print("位置錯誤")
  return
end
