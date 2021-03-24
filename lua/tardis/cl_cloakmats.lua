TARDIS.CloakMaterials = TARDIS.CloakMaterials or {}

function TARDIS:CreateCloakMaterial(metadataid, refresh)
	if not TARDIS:GetInteriors()[metadataid] or (not refresh and self.CloakMaterials[metadataid]) then return end
	local metadata = TARDIS:GetInterior(metadataid)

	local ent = ClientsideModel(metadata.Exterior.Model, RENDERGROUP_OTHER)
	local basemat = Material(ent:GetMaterials()[1])
	ent:Remove()
	ent = nil

	local normalmap = basemat:GetString("$normalmap")
	local bumpmap = basemat:GetString("$bumpmap")

	local mat = CreateMaterial("tardiscloak-"..metadataid, "Refract", {
		["$model"] = 1,
		["$refractamount"] = ".1",
		["$bluramount"] = 0,
		["$normalmap"] = normalmap or bumpmap,
		["$bumpframe"] = 0,
		Proxies = {
			AnimatedTexture ={
				animatedtexturevar = "$normalmap",
				animatedtextureframenumvar = "$bumpframe",
				animatedtextureframerate = 100.00
			}
		}
	})

	self.CloakMaterials[metadataid] = mat
end

function TARDIS:CreateCloakMaterials()
	local interiors = self:GetInteriors()

	for k,v in pairs(interiors) do
		if v.Exterior.PhaseMaterial then return end
		self:CreateCloakMaterial(k)
	end
end

function TARDIS:GetCloakMaterial(id)
	if TARDIS:GetInterior(id).Exterior.PhaseMaterial then
		return Material(TARDIS:GetInterior(id).Exterior.PhaseMaterial)
	end
	return self.CloakMaterials[id] or self.CloakMaterials["default"]
end

TARDIS:CreateCloakMaterial("default")