E2Lib.RegisterExtension("tardis2", true)

local function getTardis(ent)
	if not IsValid(ent) then return end
	local class = ent:GetClass()
	if class == "gmod_tardis" or class == "sent_tardis" then
		return ent
	elseif class == "sent_tardis_interior" and IsValid(ent.tardis) then
		return ent.tardis
	elseif (class == "gmod_tardis_interior" or ent.Base == "gmod_tardis_part") and IsValid(ent.exterior) then
		return ent.exterior
	elseif ent:IsPlayer() and IsValid(ent.tardis) then
		return ent.tardis.exterior or ent.tardis
	else
		return NULL
	end
end

local function HandleE2(ent, name, ...)
	if IsValid(getTardis(ent)) then
		return ent:HandleE2(name, ...)
	else
		error("Can't call TARDIS functions on something other than a TARDIS.")
	end
end

e2function entity entity:tardisGet()
	return getTardis(this)
end

e2function string  entity:tardisGetData(string id)
	return tostring(this:GetData(id,false))
end

e2function number entity:tardisDemat(vector pos, angle rot)
	return HandleE2(this, "Demat",self, pos, rot)
end

e2function number entity:tardisDemat(vector pos)
	return HandleE2(this, "Demat",self, pos)
end

e2function number entity:tardisMaterialise()
	return HandleE2(this, "Mat", self)
end

e2function number entity:tardisSetDestination(vector pos, angle ang)
	return HandleE2(this, "SetDestination", self, pos, ang)
end

e2function number entity:tardisSetDestination(vector pos)
	return HandleE2(this, "SetDestination", self, pos)
end

e2function number entity:t2SetFlight(normal on)
	return this:SetFlight(tobool(on))
end

e2function number entity:t2ToggleFlight()
	return this:ToggleFlight()
end