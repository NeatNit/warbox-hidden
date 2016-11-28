include("shared.lua")

local highlight = Vector(0,0,0)
local hide_vecs = {}
local ai_vecs = {}
local center_vecs = {}
net.Receive("testnav", function()
	highlight = net.ReadVector()

	hide_vecs = {}
	local count = net.ReadInt(32)
	for i = 1, count do
		table.insert(hide_vecs, net.ReadVector())
	end

	ai_vecs = {}
	count = net.ReadInt(32)
	for i = 1, count do
		table.insert(ai_vecs, net.ReadVector())
	end

	center_vecs = {}
	count = net.ReadInt(32)
	for i = 1, count do
		table.insert(center_vecs, net.ReadVector())
	end
end)

hook.Add("PostDrawTranslucentRenderables", "testnav", function()
	render.SetColorMaterialIgnoreZ()
	for i = 1, #ai_vecs do
		render.DrawSphere(ai_vecs[i], 10, 4, 3, Color(255, 0, 0))
	end

	render.DrawSphere(highlight, 9, 4, 3, Color(0, 0, 255))

	for i = 1, #hide_vecs do
		render.DrawSphere(hide_vecs[i], 8, 4, 3, Color(255, 255, 0))
	end

	for i = 1, #center_vecs do
		render.DrawSphere(center_vecs[i], 6, 4, 3, Color(0, 255, 0))
	end
end)
