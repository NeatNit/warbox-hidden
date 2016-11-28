AddCSLuaFile("cl_init.lua")
include("shared.lua")

local function PlayerCanSeeNav(nav)
	local ply = Entity(1)
	local eyes = ply:EyePos()
	local floor = nav:GetCenter()
	return not (
		util.TraceLine({start = eyes, filter = ply, endpos = floor}).Hit and
		util.TraceLine({start = eyes, filter = ply, endpos = floor + Vector(0, 0, 10)}).Hit and
		util.TraceLine({start = eyes, filter = ply, endpos = floor + Vector(0, 0, 20)}).Hit
	)
end

--hook.Add("InitPostEntity", "Spawn Zombies Randomly", function()
	timer.Create("spawn zombies", 2, 0, function()
		local thisnav = navmesh.GetNavArea(Entity(1):GetPos(), 1000)
		if not IsValid(thisnav) then return end

		local tried = {}

		while true do
			if not PlayerCanSeeNav(thisnav) then
				PrintMessage(HUD_PRINTTALK, "Picked spawn point - player can't see")
				break
			end

			tried[thisnav:GetID()] = true
			local neighbors = thisnav:GetAdjacentAreas()
			for i = #neighbors, 1, -1 do	-- go backwards so we can table.remove stuff
				local nav = neighbors[i]
				if tried[nav:GetID()] then
					table.remove(neighbors, i)
					break
				end
			end

			if #neighbors == 0 then
				PrintMessage(HUD_PRINTTALK, "Picked spawn point - no neighbors left")
				break
			end
			thisnav = neighbors[math.random(1, #neighbors)]
		end

		local zombie = ents.Create("npc_zombie")
		print(zombie)
		if not IsValid(zombie) then return end
		zombie:SetPos(thisnav:GetCenter() + Vector(0, 0, 10))
		zombie:Spawn()
	end)
--end)


util.AddNetworkString("testnav")

timer.Create("testnav",10,0,function()
	local navs = navmesh.GetAllNavAreas()

	print("navs:", #navs)

	-- local hide_vecs = {}
	local center_vecs = {}
	for _, nav in pairs(navs) do
		-- for _, vec in pairs(nav:GetHidingSpots()) do
		-- 	table.insert(hide_vecs, vec)
		-- end

		table.insert(center_vecs, nav:GetCenter())
	end

	-- local ai_vecs = {}
	-- for _, node in pairs(ents.FindByClass("ai_hint")) do
	-- 	table.insert(ai_vecs, node:GetPos())
	-- end

	-- local hlnav = navmesh.GetNavArea(Entity(1):GetPos(), 1000)
	-- local hlpos = hlnav:GetCenter() or vector_origin
	-- print(hlnav, hlpos)

	net.Start("testnav")
		-- net.WriteVector(hlpos)
		-- net.WriteInt(#hide_vecs, 32)
		-- for i = 1, #hide_vecs do
		-- 	net.WriteVector(hide_vecs[i])
		-- end

		-- net.WriteInt(#ai_vecs, 32)
		-- for i = 1, #ai_vecs do
		-- 	net.WriteVector(ai_vecs[i])
		-- end

		net.WriteInt(#center_vecs, 32)
		for i = 1, #center_vecs do
			net.WriteVector(center_vecs[i])
		end
	net.Broadcast()
end)
