local Media = LibStub("LibSharedMedia-3.0")
local config = {}
local path = "Interface\\Addons\\TidyPlates_ThreatPlates\\Artwork\\"
local f = CreateFrame("Frame")
local function CreateStyle(self,event,...)
	local arg1 = ...
	if arg1 == "TidyPlates_ThreatPlates" then
	local db = TidyPlatesThreat.db.profile.settings
config.hitbox = {
	width = 128,
	height = 24,
}
config.frame = {
	emptyTexture =					path.."Empty",
	width = 124,
	height = 30,
	x = 0,
	y = 0,
	anchor = "CENTER",
}
config.threatborder = {
	texture =						path.."Empty",
	elitetexture =					path.."Empty",
	width = 256,
	height = 64,
	x = 0,
	y = 0,
	anchor = "CENTER",
}
config.healthborder = {
	texture = 						path.."Empty",
	glowtexture = 					path.."Empty",
	elitetexture = 					path.."Empty",
	width = 256,
	height = 64,
	x = 0,
	y = 0,
	anchor = "CENTER",
}
config.castborder = {
	texture = 						path.."Empty",
	width = 256,
	height = 64,
	x = 0,
	y = -15,
	anchor = "CENTER",
}

config.castnostop = {
	texture =						path.."Empty",
	width = 256,
	height = 64,
	x = 0,
	y = -15,
	anchor = "CENTER",
}
--[[Bar Textures]]--
config.healthbar = {
	texture = 						path.."Empty",
	width = 120,
	height = 10,
	x = 0,
	y = 0,
	anchor = "CENTER",
	orientation = "HORIZONTAL",
}
config.castbar = {
	texture =						path.."Empty",
	width = 120,
	height = 10,
	x = 0,
	y = -15,
	anchor = "CENTER",
	orientation = "HORIZONTAL",
}
--[[TEXT]]--

config.name = {
	typeface =						Media:Fetch('font', db.name.typeface),
	size = db.name.size,
	width = db.name.width,
	height = db.name.height,
	x = db.name.x,
	y = db.name.y,
	align = db.name.align,
	anchor = "CENTER",
	vertical = db.name.vertical,
	shadow = db.name.shadow,
	flags = db.name.flags,
}
config.level = {
	typeface =						Media:Fetch('font', db.level.typeface),
	size = db.level.size,
	width = db.level.width,
	height = db.level.height,
	x = db.level.x,
	y = db.level.y,
	align = db.level.align,
	anchor = "CENTER",
	vertical = db.level.vertical,
	shadow = db.level.shadow,
	flags = db.level.flags,
}
config.specialText = {
	typeface =						Media:Fetch('font', db.specialText.typeface),
	size = db.specialText.size,
	width = db.specialText.width,
	height = db.specialText.height,
	x = db.specialText.x,
	y = db.specialText.y,
	align = db.specialText.align,
	anchor = "CENTER",
	vertical = db.specialText.vertical,
	shadow = db.specialText.shadow,
	flags = db.specialText.flags,
}
config.specialText2 = {
	typeface =						Media:Fetch('font', db.specialText2.typeface),
	size = db.specialText2.size,
	width = db.specialText2.width,
	height = db.specialText2.height,
	x = db.specialText2.x,
	y = db.specialText2.y,
	align = db.specialText2.align,
	anchor = "CENTER",
	vertical = db.specialText2.vertical,
	shadow = db.specialText2.shadow,
	flags = db.specialText2.flags,
}
--[[ICONS]]--
config.dangerskull = {
	width = (db.dangerskull.scale),
	height = (db.dangerskull.scale),
	x = (db.dangerskull.x),
	y = (db.dangerskull.y),
	anchor = (db.dangerskull.anchor),
}
config.specialArt = {
	width = (db.specialArt.scale),
	height = (db.specialArt.scale),
	x = (db.specialArt.x),
	y = (db.specialArt.y),
	anchor = (db.specialArt.anchor),
}
config.spellicon = {
	width = (db.spellicon.scale),
	height = (db.spellicon.scale),
	x = (db.spellicon.x),
	y = (db.spellicon.y),
	anchor = (db.spellicon.anchor),
}
config.raidicon = {
	width = (db.raidicon.scale),
	height = (db.raidicon.scale),
	x = (db.raidicon.x),
	y = (db.raidicon.y),
	anchor = (db.raidicon.anchor),
}
--[[OPTIONS]]--
local threat = db.totem.threatcolor
config.threatcolor = {
	LOW = { 
		r = threat.LOW.r, 
		g = threat.LOW.g, 
		b = threat.LOW.b, 
		a = threat.LOW.a 
	},
	MEDIUM = { 
		r = threat.MEDIUM.r, 
		g = threat.MEDIUM.g, 
		b = threat.MEDIUM.b, 
		a = threat.MEDIUM.a
	},
	HIGH = { 
		r = threat.HIGH.r,
		g = threat.HIGH.g, 
		b = threat.HIGH.b, 
		a = threat.HIGH.a
	},
}
config.options = {
	showLevel = false,
	showName = false,
	showSpecialArt = false,
	showSpecialText = false,
	showSpecialText2 = false,
	showDangerSkull = false,
	showSpellIcon = false,
	showNostopSpell = false,
	useOnUpdate = true,
	useCustomHealthbarColor = true,
}
TidyPlatesThemeList["Threat Plates"]["etotem"] = {}
TidyPlatesThemeList["Threat Plates"]["etotem"] = config
	end
end
f:SetScript("OnEvent", function(self,event,...) 
	CreateStyle(self,event,...)
end)
f:RegisterEvent("ADDON_LOADED")