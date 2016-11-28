AddCSLuaFile()
DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

GM.Name = "Warbox: Hidden"
GM.Author = "Nitai Sasson"
GM.Email = "N/A"
GM.Website = "N/A"

function GM:Initialize(...)
	BaseClass.Initialize(self, ...)
end
