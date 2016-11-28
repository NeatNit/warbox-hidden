AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("testnav")

timer.Create("testnav",2,0,function()
	local navs = navmesh.GetAllNavAreas()

	print("navs:", #navs)

	local hide_vecs = {}
	local center_vecs = {}
	for _, nav in pairs(navs) do
		for _, vec in pairs(nav:GetHidingSpots()) do
			table.insert(hide_vecs, vec)
		end

		table.insert(center_vecs, nav:GetCenter())
	end

	local ai_vecs = {}
	for _, node in pairs(ents.FindByClass("ai_hint")) do
		table.insert(ai_vecs, node:GetPos())
	end

	local hlnav = navmesh.GetNavArea(Entity(1):GetPos(), 1000)
	local hlpos = hlnav:GetCenter() or vector_origin
	print(hlnav, hlpos)

	net.Start("testnav")
	net.WriteVector(hlpos)
	net.WriteInt(#hide_vecs, 32)
		for i = 1, #hide_vecs do
			net.WriteVector(hide_vecs[i])
		end

		net.WriteInt(#ai_vecs, 32)
		for i = 1, #ai_vecs do
			net.WriteVector(ai_vecs[i])
		end

		net.WriteInt(#center_vecs, 32)
		for i = 1, #center_vecs do
			net.WriteVector(center_vecs[i])
		end
	net.Broadcast()
end)
