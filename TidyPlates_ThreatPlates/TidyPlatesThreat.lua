TidyPlatesThreat = LibStub("AceAddon-3.0"):NewAddon("TidyPlatesThreat", "AceConsole-3.0", "AceEvent-3.0")
local Media = LibStub("LibSharedMedia-3.0")
local path = "Interface\\Addons\\TidyPlates_ThreatPlates\\Artwork\\"
local _, PlayerClass = UnitClass("player")
local Active = function() return GetActiveTalentGroup() end
local HEX_CLASS_COLOR = { 
	SHAMAN 		= "2459FF", 
	MAGE 		= "69CCF0",
	WARLOCK 	= "9482C9",
	HUNTER		= "ABD473",
	ROGUE		= "FFF569",
	PRIEST		= "FFFFFF",
	DRUID 		= "FF7D0A",
	DEATHKNIGHT = "C41F3B",
	WARRIOR 	= "C79C6E",
	PALADIN 	= "F58CBA",
}
local tankRole = "|cff00ff00tanking|r"
local dpsRole = "|cffff0000dpsing / healing|r"

--[[Set MultiStyle]]--
if not TidyPlatesThemeList then TidyPlatesThemeList = {} end
TidyPlatesThemeList["Threat Plates"] = {}

-- Callback Functions
function TidyPlatesThreat:UpdateTheme()
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

-- Dual Spec Functions
currentSpec = {}
function currentRoleBool(number)
	currentSpec[1] = TidyPlatesThreat.db.char.spec.primary
	currentSpec[2] = TidyPlatesThreat.db.char.spec.secondary
	currentSpec[3] = TidyPlatesThreat.db.char.spec.secondary2
	if currentSpec[number] then return currentSpec[number] end
end
function setSpecTank(number)
	local specIs = {}
	specIs[1] = "primary"
	specIs[2] = "secondary"
	specIs[3] = "secondary2"
	TidyPlatesThreat.db.char.spec[specIs[number]] = true
end
function setSpecDPS(number)
	local specIs = {}
	specIs[1] = "primary"
	specIs[2] = "secondary"
	specIs[3] = "secondary2"
	TidyPlatesThreat.db.char.spec[specIs[number]] = false
end

function dualSpec() --Staggered till after called
	currentSpec[3] = ""
	if Active() == 1 then
		currentSpec[3] = "primary"
	elseif Active() == 2 then
		currentSpec[3] = "secondary"
	else 
		currentSpec[3] = "unknown"
	end
	return currentSpec[3]
end

function roleText() --Staggered till after called
	if Active() == 1 then
		if TidyPlatesThreat.db.char.spec.primary then
			return tankRole
		else
			return dpsRole
		end
	elseif Active() == 2 then
		if TidyPlatesThreat.db.char.spec.secondary then
			return tankRole
		else
			return dpsRole
		end
	elseif Active() == 3 then
		if TidyPlatesThreat.db.char.spec.secondary2 then
			return tankRole
		else
			return dpsRole
		end
	end
end

function specName()
	local Spec = TidyPlatesThreat.db.char.specName
	local t = TidyPlatesThreat.db.char.specInfo[Active()]
	local spentTotal = t[1] + t[2] + t[3]
	if t[1] > t[2] and t[1] > t[3] then
		return Spec[1]
	elseif t[2] > t[1] and t[2] > t[3] then
		return Spec[2]
	elseif t[3] > t[1] and t[3] > t[2] then
		return Spec[3]
	else
		if spentTotal < 1 then
			return "Undetermined"
		end
		return ""
	end
end

--[[Options and Default Settings]]--
function TidyPlatesThreat:OnInitialize()
	local defaults 	= {
		char = {
			welcome = false,
			specInfo = {
				[1] = {
					[1] = 0,
					[2] = 0,
					[3] = 0
				},
				[2] = {
					[1] = 0,
					[2] = 0,
					[3] = 0
				},
				[3] = {
					[1] = 0,
					[2] = 0,
					[3] = 0
				},
			},
			threat = {
				tanking = true,
			},
			spec = {
				primary = true,
				secondary = false,
				secondary2 = false
			},
			specName = {
				[1] = nil,
				[2] = nil,
				[3] = nil
			},
		},
		profile = {
			cache = {},
			theme = "default",
			classTheme = "default",
			OldSetting = true,
			verbose = true,
			blizzFade = {
				toggle  = true,
				amount = 0
			},
			healthColorChange = {
				toggle = false,
			},
			customColor = {
				toggle = false,
			},
			allowClass = {
				toggle = false,
			},
			friendlyClass = {
				toggle = true,
			},
			cacheClass = {
				toggle = false,
			},
			castbarSettings = {
				toggle = true,
			},
			castbarColor = {
				toggle = true,
				r = 1,
				g = 0.56, 
				b = 0.06,
				a = 1
			},
			aHPbarColor = {
				r = 0,
				g = 1,
				b = 0
			},
			bHPbarColor = {
				r = 1,
				g = 0,
				b = 0
			},
			fHPbarColor = {
				r = 1,
				g = 1, 
				b = 1
			},
			nHPbarColor = {
				r = 1,
				g = 1, 
				b = 1
			},
			HPbarColor = {
				r = 1,
				g = 1, 
				b = 1
			},
			totemSettings = {
				hideHealthbar = false,
			--	["Reference"] = {allow totem nameplate, allow hp color, r, g, b, show icon, style}
				-- Air Totems
				["A1"] = {true,true,0.67,1,1,true,"normal"},
				["A2"] = {true,true,0.67,1,1,true,"normal"},
				["A3"] = {true,true,0.67,1,1,true,"normal"},
				["A4"] = {true,true,0.67,1,1,true,"normal"},
				["A5"] = {true,true,0.67,1,1,true,"normal"},
				-- Earth Totems
				["E1"] = {true,true,1,0.7,0.12,true,"normal"},
				["E2"] = {true,true,1,0.7,0.12,true,"normal"},
				["E3"] = {true,true,1,0.7,0.12,true,"normal"},
				["E4"] = {true,true,1,0.7,0.12,true,"normal"},
				["E5"] = {true,true,1,0.7,0.12,true,"normal"},
				["E6"] = {true,true,1,0.7,0.12,true,"normal"},
				-- Fire Totems
				["F1"] = {true,true,1,0.4,0.4,true,"normal"},
				["F2"] = {true,true,1,0.4,0.4,true,"normal"},
				["F3"] = {true,true,1,0.4,0.4,true,"normal"},
				["F4"] = {true,true,1,0.4,0.4,true,"normal"},
				["F5"] = {true,true,1,0.4,0.4,true,"normal"},
				["F6"] = {true,true,1,0.4,0.4,true,"normal"},
				-- Water Totems
				["W1"] = {true,true,0.58,0.72,1,true,"normal"},
				["W2"] = {true,true,0.58,0.72,1,true,"normal"},
				["W3"] = {true,true,0.58,0.72,1,true,"normal"},
				["W4"] = {true,true,0.58,0.72,1,true,"normal"},
				["W5"] = {true,true,0.58,0.72,1,true,"normal"}
			},
			uniqueSettings = {
				--[[	
					["Reference"] = {
					[1] = allow mob nameplate,
					[2] = allow hp color,
					[3] = r,
					[4] = g,
					[5] = b,
					[6] = show icon,
					[7] = scale,
					[8] = alpha,
					[9] = use unique style,
					[10] = override scale,
					[11] = override alpha,
					[12] = allow raid mark coloring
					}
				]]--
				["U1"] = {true,true,1,0.39,0.96,true,0.75,1,true,false,false}, 	-- Web Wrap
				["U2"] = {true,true,0.33,0.33,0.33,true,1,1,true,false,false}, 	-- Immortal Guardian
				["U3"] = {true,true,0.75,0,0.02,true,1,1,true,false,false}, 	-- Marked Immortal Guardian
				["U4"] = {true,true,0.29,0.11,1,true,1,1,true,false,false}, 	-- Empowered Adherent
				["U5"] = {true,true,0.55,0.7,0.29,true,1,1,true,false,false}, 	-- Deformed Fanatic
				["U6"] = {true,true,1,0.88,0.61,true,1,1,true,false,false}, 	-- Reanimated
				["U7"] = {true,true,1,1,1,true,1,1,true,false,false}, 		-- Bone Spike
				["U8"] = {true,true,0.33,0.28,0.71,true,1,1,true,false,false}, 	-- Onyxian Whelp
				["U9"] = {true,true,0.69,0.26,0.25,true,1,1,true,false,false}, 	-- Shambling Horror
				-- Player Pets
				["U10"] = {true,true,0.61,0.40,0.86,true,0.45,1,true,false,false}, 	-- Shadow Fiend
				["U11"] = {true,true,0.32,0.7,0.89,true,0.45,1,true,false,false}, 	-- Spirit Wolf
				["U12"] = {true,true,1,0.1,0.47,true,0.45,1,true,false,false}, 	-- Ebon Gargoyle
				["U13"] = {true,true,0.33,0.72,0.44,true,0.45,1,true,false,false}, 	-- Water Elemental
				["U14"] = {true,true,1,0.71,0,true,0.45,1,true,false,false}, 	-- Treant
				["U15"] = {true,true,0.39,1,0.11,true,0.45,1,true,false,false}, 	-- Viper / Venomous Snake
				["U16"] = {true,true,0.87,0.78,0.88,true,0.45,1,true,false,false}, 	-- Army Ghouls
				-- Added
				["U17"] = {true,true,0.96,0.56,0.07,true,1,1,true,false,false}, 	-- Gas Cloud
				["U18"] = {true,true,0.36,0.95,0.33,true,1,1,true,false,false}, 	-- Volatile Ooze
				["U19"] = {true,true,0.78,0.61,0.43,true,1,1,true,false,false}, 	-- Darnavan
				["U20"] = {true,true,0.47,0.89,1,true,1,1,true,false,false}, 	-- Val'kyr Shadowguard
				["U21"] = {true,true,0.91,0.71,0.1,true,1,1,true,false,false}, 	-- Kenetic Bomb
				["U22"] = {true,true,0.77,0.12,0.23,true,1,1,true,false,false},  	-- Lich King
				["U23"] = {true,true,0.77,0.27,0,true,1,1,true,false,false},  	-- Raging Spirit
				["U24"] = {true,true,0.43,0.43,0.43,false,0.85,1,true,false,false}, 	-- Drudge Ghoul
				["U25"] = {true,true,0.36,0.77,0.51,true,0.85,1,false,false,false},  	-- Unbound Seer
				["U26"] = {true,true,0,1,0,true,1,1,true,false,false}, 	-- Living Inferno
				["U27"] = {true,true,0.25,0.25,0.25,false,0.60,0.75,true,false,false},  	-- Living Ember
				["U28"] = {false,true,1,1,1,false,0,0,true,false,false}  	-- Fanged Pit Viper
			},
			text = {
				amount = true,
				deficit = false,
				full = false,
				max = false,
				percent = true,
				truncate = true		
			},
			totemWidget = {
				ON = true,
				scale = 35,
				x = 0,
				y = 35,
				level = 1,
				anchor = "CENTER"
			},
			debuffWidget = {
				ON = true,
				x = 0,
				y = 32,
				mode = "whitelist",
				filter = {}
			},
			uniqueWidget = {
				ON = true,
				scale = 35,
				x = 0,
				y = 35,
				level = 1,
				anchor = "CENTER"
			},
			classWidget = {
				ON = true,
				scale = 22,
				x = -74,
				y = -7,
				theme = "default",
				anchor = "CENTER"
			},
			targetWidget = {
				ON = true,
				theme = "default",
				level = 21,
				r = 1,
				g = 1,
				b = 1
			},
			threatWidget = {
				ON = false,
				x = 0,
				y = 26,
				style = 1
			},
			tankedWidget = {
				ON = false,
				x = 0,
				y = 26
			},
			comboWidget = {
				ON = false,
				x = 0,
				y = -8
			},
			eliteWidget = {
				ON = true,
				theme = "default",
				scale = 15,
				x = 64,
				y = 9,
				level = 22,
				anchor = "CENTER"
			},
			settings = {
				offsetx = 0,
				offsety = 0,
				options = {
					showLevel = true,
					showName = true,
					showSpecialText = true,
					showSpecialText2 = true,
					showSpecialArt = true,
					showDangerSkull = true,
				},
				healthbar = {
					texture = "ThreatPlatesBar"
				},
				castbar = {
					texture = "ThreatPlatesBar"
				},
				name = {
					typeface = "Accidental Presidency",
					width = 116,
					height = 14,
					size = 14,
					x = 0,
					y = 13,
					align = "CENTER",
					vertical = "CENTER",
					shadow = true,
					flags = "NONE",
					color = {
						r = 1,
						g = 1,
						b = 1
					},
				},
				level = {
					typeface = "Accidental Presidency",
					size = 12,
					width = 20,
					height = 14,
					x = 50,
					y = 0,
					align = "RIGHT",
					vertical = "TOP",
					shadow = true,
					flags = "NONE",
				},
				specialText = {
					typeface = "Accidental Presidency",
					size = 12,
					width = 110,
					height = 14,
					x = 0,
					y = 1,
					align = "CENTER",
					vertical = "CENTER",
					shadow = true,
					flags = "NONE",
				},
				specialText2 = {
					typeface = "Accidental Presidency",
					size = 12,
					width = 110,
					height = 14,
					x = 0,
					y = -13,
					align = "CENTER",
					vertical = "CENTER",
					shadow = true,
					flags = "NONE",
				},
				raidicon = {
					scale = 20,
					x = 0,
					y = 27,
					anchor = "CENTER",
					hpColor = true,
					hpMarked = {
						["STAR"] = {
							r = 0.85,
							g = 0.81,
							b = 0.27
						},
						["MOON"] = {
							r = 0.60,
							g = 0.75,
							b = 0.85
						},
						["CIRCLE"] = {
							r = 0.93,
							g = 0.51,
							b = 0.06
						},
						["SQUARE"] = {
							r = 0,
							g = 0.64,
							b = 1
						},
						["DIAMOND"] = {
							r = 0.7,
							g = 0.06,
							b = 0.84
						},
						["CROSS"] = {
							r = 0.82,
							g = 0.18,
							b = 0.18
						},
						["TRIANGLE"] = {
							r = 0.14,
							g = 0.66,
							b = 0.14
						},
						["SKULL"] = {
							r = 0.89,
							g = 0.83,
							b = 0.74
						},
					},
				},
				spellicon = {
					scale = 20,
					x = 75,
					y = -7,
					anchor = "CENTER",
				},
				specialArt = {
					scale = 22,
					x = -74,
					y = -7,
					anchor = "CENTER"
				},
				dangerskull = {
					scale = 16,
					x = 55,
					y = 0,
					anchor = "CENTER"
				},
				unique = {
					threatcolor = {
						LOW = {
							r = 0,
							g = 0,
							b = 0,
							a = 0
						},
						MEDIUM = { 
							r = 0, 
							g = 0, 
							b = 0, 
							a = 0
						},
						HIGH = { 
							r = 0,
							g = 0, 
							b = 0, 
							a = 0
						},
					},
				},
				totem = {
					threatcolor = {
						LOW = {
							r = 0,
							g = 0,
							b = 0,
							a = 0
						},
						MEDIUM = { 
							r = 0, 
							g = 0, 
							b = 0, 
							a = 0
						},
						HIGH = { 
							r = 0,
							g = 0, 
							b = 0, 
							a = 0
						},
					},
				},
				normal = {
					threatcolor = {
						LOW = {
							r = 1,
							g = 1,
							b = 1,
							a = 1
						},
						MEDIUM = { 
							r = 1, 
							g = 1, 
							b = 0, 
							a = 1
						},
						HIGH = { 
							r = 1,
							g = 0, 
							b = 0, 
							a = 1
						},
					},
				},
				dps = {
					threatcolor = {
						LOW = {
							r = 0,
							g = 1,
							b = 0,
							a = 1
						},
						MEDIUM = { 
							r = 1, 
							g = 1, 
							b = 0, 
							a = 1
						},
						HIGH = { 
							r = 1,
							g = 0, 
							b = 0, 
							a = 1
						},
					},
				},
				tank = {
					threatcolor = {
						LOW = {
							r = 1,
							g = 0,
							b = 0,
							a = 1
						},
						MEDIUM = { 
							r = 1, 
							g = 1, 
							b = 0, 
							a = 1
						},
						HIGH = { 
							r = 0,
							g = 1, 
							b = 0, 
							a = 1
						},
					},
				},
			},
			threat = {
				ON = true,
				nonCombat = true,
				hideNonCombat = false,
				useType = true,
				useScale = true,
				useAlpha = true,
				useHPColor = true,
				scaleType = {
					["Normal"] = -0.2,
					["Elite"] = 0,
					["Boss"] = 0.2
				},
				toggle = {
					["Boss"]	= true,
					["Elite"]	= true,
					["Normal"]	= true,
					["Neutral"]	= true
				},
				dps = {
					scale = {
						LOW = 0.8,
						MEDIUM = 0.9,
						HIGH = 1.25
					},
					alpha = {
						LOW = 1,
						MEDIUM = 1,
						HIGH = 1
					},
				},
				tank = {
					scale = {
						LOW = 1.25,
						MEDIUM = 0.9,
						HIGH = 0.8
					},
					alpha = {
						LOW = 1,
						MEDIUM = 0.85,
						HIGH = 0.75
					},
				},
				marked = {
					alpha = false,
					art = false,
					scale = false
				},
			},
			nameplate = {
				toggle = {
					["Boss"]	= true,
					["Elite"]	= true,
					["Normal"]	= true,
					["Neutral"]	= true
				},
				scale = {
					["Totem"]	= 0.75,
					["Boss"]	= 1.1,
					["Elite"]	= 1.04,
					["Normal"]	= 1,
					["Neutral"]	= 0.9,
					["Marked"] 	= 1
				},
				alpha = {
					["Totem"]	= 1,
					["Boss"]	= 1,
					["Elite"]	= 1,
					["Normal"]	= 1,
					["Neutral"]	= 1,
					["Marked"] 	= 1
				},
			},
		}
	}
	local db = LibStub('AceDB-3.0'):New('ThreatPlates3BetaDB', defaults, 'Default')
	self.db = db
	local RegisterCallback = db.RegisterCallback
	RegisterCallback(self, 'OnProfileChanged', 'UpdateTheme')
	RegisterCallback(self, 'OnProfileCopied', 'UpdateTheme')
	RegisterCallback(self, 'OnProfileReset', 'UpdateTheme')
	
	self:RegisterOptions()
end
--[[TPTP Tank Toggle Command]]--
function toggleDPS()
	setSpecDPS(Active())
	TidyPlatesThreat.db.char.threat.tanking = false
	TidyPlatesThreat.db.profile.threat.ON = true
	if TidyPlatesThreat.db.profile.verbose then
	print("-->>|cffff0000Модуль ДПС включен|r<<--")
	print("|cff89F559Threat Plates|r: Обнаружена ветка дд, вы сейчас в |cff89F559"..dualSpec().."|r Спек переключен на |cffff0000дпс/хил|r ")
	end
	TidyPlates:ForceUpdate()
end
function toggleTANK()
	setSpecTank(Active())	
	TidyPlatesThreat.db.char.threat.tanking = true
	TidyPlatesThreat.db.profile.threat.ON = true
	if TidyPlatesThreat.db.profile.verbose then
	print("-->>|cff00ff00Модуль танка включен|r<<--")
	print("|cff89F559Threat Plates|r: Обнаружена ветка танка, вы сейчас в |cff89F559"..dualSpec().."|r Спек переключен на |cff00ff00танка|r ")
	end
	TidyPlates:ForceUpdate()
end
local function TPTPDPS()
	toggleDPS()
end
SLASH_TPTPDPS1 = "/tptpdps"
SlashCmdList["TPTPDPS"] = TPTPDPS
local function TPTPTANK()
	toggleTANK()
end
SLASH_TPTPTANK1 = "/tptptank"
SlashCmdList["TPTPTANK"] = TPTPTANK
local function TPTPTOGGLE()
	TidyPlatesThreat.db.char.threat.tanking = not TidyPlatesThreat.db.char.threat.tanking
	if TidyPlatesThreat.db.char.threat.tanking then 
		toggleTANK()
	else
		toggleDPS()
	end
end
SLASH_TPTPTOGGLE1 = "/tptptoggle"
SlashCmdList["TPTPTOGGLE"] = TPTPTOGGLE
local function TPTPOVERLAP()
	SetCVar("nameplateAllowOverlap",abs(GetCVar("nameplateAllowOverlap")-1))
	if GetCVar("nameplateAllowOverlap") == "1" and TidyPlatesThreat.db.profile.verbose then
		print("-->>Наложение плашек |cff00ff00Включено!|r<<--")
	else
		print("-->>Наложение плашек |cffff0000Выключено!|r<<--")
	end
end
SLASH_TPTPOVERLAP1 = "/tptpol"
SlashCmdList["TPTPOVERLAP"] = TPTPOVERLAP
local function TPTPVERBOSE()
	TidyPlatesThreat.db.profile.verbose = not TidyPlatesThreat.db.profile.verbose
	if TidyPlatesThreat.db.profile.verbose then
		print("-->>Threat Plates |cff00ff00Включен!|r<<--")
	else
		print("-->>Threat Plates |cffff0000Выключен!|r<<-- shhh!!")
	end
end
SLASH_TPTPVERBOSE1 = "/tptpverbose"
SlashCmdList["TPTPVERBOSE"] = TPTPVERBOSE
-- Unit Classification
function UnitType(unit)
	local unitRank
	local totem = TPtotemList[unit.name]
	local unique = TPuniqueList[unit.name]
	local uS = TidyPlatesThreat.db.profile.uniqueSettings[TPuniqueList[unit.name]]
	if totem then
		unitRank = "Totem"
	elseif unique and uS[9] then
		unitRank = "Unique"
	elseif (unit.isDangerous and (unit.reaction == "FRIENDLY" or unit.reaction == "HOSTILE")) then
		unitRank = "Boss"
	elseif (unit.isElite and not unit.isDangerous and (unit.reaction == "FRIENDLY" or unit.reaction == "HOSTILE")) then
		unitRank = "Elite"
	elseif (not unit.isElite and not unit.isDangerous and (unit.reaction == "FRIENDLY" or unit.reaction == "HOSTILE"))then
		unitRank = "Normal"
	elseif unit.reaction == "NEUTRAL" then
		unitRank = "Neutral"
	end
	--print(unitRank)
	return unitRank
end

function SetStyleThreatPlates(unit)
	local db = TidyPlatesThreat.db.profile
	local tS = db.totemSettings[TPtotemList[unit.name]]
	local uS = db.uniqueSettings[TPuniqueList[unit.name]]
	local T = UnitType(unit)
	if T == "Totem" then
		if tS[1] then
			if db.totemSettings.hideHealthbar then 
				return "etotem"
			else
				return "totem"
			end
		else
			return "empty"
		end
	elseif T == "Unique" then
		if uS[1] then
			return "unique"
		else
			return "empty"
		end
	else
		if unit.reaction == "HOSTILE" or unit.reaction == "NEUTRAL" then
			if db.nameplate.toggle[T] then
				if db.threat.toggle[T] and db.threat.ON and unit.class == "UNKNOWN" and InCombatLockdown() then
					if db.threat.nonCombat then 
						if unit.isInCombat or (unit.health < unit.healthmax) then
							if TidyPlatesThreat.db.char.threat.tanking then
								return "tank"
							else
								return "dps"
							end
						else
							if not db.threat.hideNonCombat then
								return "normal"
							else
								return "empty"
							end
						end
					else
						if TidyPlatesThreat.db.char.threat.tanking then
							return "tank"
						else
							return "dps"
						end
					end
				else 
					return "normal"
				end
			else
				return "empty"
			end
		elseif unit.reaction == "FRIENDLY" then
			if db.nameplate.toggle[T] then
				return "normal"
			else
				return "empty"
			end
		else 
			return "empty"
		end
	end
end
------------
-- EVENTS --
------------
function specInfo()
	for i=1, GetNumTalentGroups() do
		for z=1, GetNumTalentTabs() do
			name, iconTexture, pointsSpent, background, previewPointsSpent = GetTalentTabInfo(z, false, false, i)
			TidyPlatesThreat.db.char.specInfo[i][z] = pointsSpent
			TidyPlatesThreat.db.char.specName[z] = name
		end
	end
end
local function SetToThreatPlates()
	TidyPlatesOptions.primary = "Threat Plates"
	TidyPlatesOptions.secondary = "Threat Plates"
	TidyPlatesOptions.secondary2 = "Threat Plates"
	ReloadUI()
end
function TidyPlatesThreat:StartUp()
	specInfo()
	local t = self.db.char.specInfo[Active()]
	-- Welcome
	local Welcome = "Добро пожаловать, вы: |r|cff"..HEX_CLASS_COLOR[PlayerClass]..specName().." "..UnitClass("player")..": "..t[1].."/"..t[2].."/"..t[3].."|r|cff89F559.|r\n"
	-- Body
	local NotTank = Welcome.."|cff89f559Your dual spec's have been set to |r"..dpsRole.."|cff89f559.|r"
	local CurrentlyDPS = Welcome.."|cff89f559You are currently in your "..dpsRole.."|cff89f559 role.|r"
	local CurrentlyTank = Welcome.."|cff89f559You are currently in your "..tankRole.."|cff89f559 role.|r"
	local Undetermined = Welcome.."|cff89f559Your role can not be determined.\nPlease set your dual spec preferences in the |rThreat Plates|cff89f559 options.|r"
	-- End
	local Conclusion = "|cff89f559Additional options can be found by typing |r'/tptp'|cff89F559.|r"
	-- Welcome Setup / Display
	if not self.db.char.welcome then
		self.db.char.welcome = true
		if ((TidyPlatesOptions.primary ~= "Threat Plates") and (TidyPlatesOptions.secondary ~= "Threat Plates")) then
			local spec = dualSpec()
			StaticPopupDialogs["SetToThreatPlates"] = {
				text = GetAddOnMetadata("TidyPlates_ThreatPlates", "title")..":\nНажмите '|cff00ff00Да|r' для установки Threat Plates и перезагрузки UI, \n или '|cffff0000Нет|r' для настройки.", 
				button1 = "Да", 
				button2 = "Отмена",
				button3 = "Нет",
				timeout = 0,
				whileDead = 1, 
				hideOnEscape = 1, 
				OnAccept = function() SetToThreatPlates() end,
				OnAlt = function() 
					InterfaceOptionsFrame_OpenToCategory("Tidy Plates")
				end,
				OnCancel = function() 
					if TidyPlatesThreat.db.profile.verbose then print("-->>|cffff0000Ручная настройка!|r<<--") end
				end,
			}
			StaticPopup_Show("SetToThreatPlates")
		end
		if PlayerClass == "SHAMAN" 
			or PlayerClass == "MAGE" 
			or PlayerClass == "HUNTER" 
			or PlayerClass == "ROGUE" 
			or PlayerClass == "PRIEST" 
			or PlayerClass == "WARLOCK" then
			if TidyPlatesThreat.db.profile.verbose then	print(NotTank) end
			for i=1, GetNumTalentGroups() do
				setSpecDPS(i)
			end
		elseif PlayerClass == "WARRIOR" then
			if t[3] > t[2] and t[3] > t[1] then -- Detects protection spec
				if TidyPlatesThreat.db.profile.verbose then	print(CurrentlyTank) end
			else
				if TidyPlatesThreat.db.profile.verbose then	print(CurrentlyDPS)	end
			end
			for i=1, GetNumTalentGroups() do
				z = self.db.char.specInfo[i] 
				if z[3] > z[2] and z[3] > z[1] then -- Detects protection spec
					setSpecTank(i)
				else
					setSpecDPS(i)
				end
			end
		elseif PlayerClass == "PALADIN" then
			if t[2] > t[1] and t[2] > t[3] then -- Detects protection spec
				if TidyPlatesThreat.db.profile.verbose then	print(CurrentlyTank) end
			else
				if TidyPlatesThreat.db.profile.verbose then	print(CurrentlyDPS)	end
			end
			for i=1, GetNumTalentGroups() do
				z = self.db.char.specInfo[i] 
				if z[2] > z[1] and z[2] > z[3] then -- Detects protection spec
					setSpecTank(i)
				else
					setSpecDPS(i)
				end
			end
		elseif PlayerClass == "DRUID" then
			if (t[2] > t[1]) and (t[2] > t[3]) then
				if TidyPlatesThreat.db.profile.verbose then	print(Undetermined)	end
			else
				if TidyPlatesThreat.db.profile.verbose then	print(CurrentlyDPS)	end
			end
			for i=1, GetNumTalentGroups() do
				z = self.db.char.specInfo[i] 
				if z[2] > z[1] and z[2] > z[3] then -- Detects feral spec
					setSpecTank(i)
				else
					setSpecDPS(i)
				end
			end
		elseif PlayerClass == "DEATHKNIGHT"	then
			if TidyPlatesThreat.db.profile.verbose then	print(Undetermined)	end
		else
			if TidyPlatesThreat.db.profile.verbose then	print(Welcome) end
		end
		if TidyPlatesThreat.db.profile.verbose then	print(Conclusion) end
		self.db.char.threat.tanking = currentRoleBool(Active()) -- Сравнивает ветку танка с текущей, после установки.
		if GetCVar("ShowVKeyCastbar") == 1 then
			TidyPlatesThreat.db.profile.castbarSettings.toggle = true
		else
			TidyPlatesThreat.db.profile.castbarSettings.toggle = false
		end
	end
end
--[[Events]]--
local events = {}
local f = CreateFrame("Frame")
function f:Events(self,event,...)
	local arg1, arg2 = ...
	if event == "ADDON_LOADED" then
		if arg1 == "TidyPlates_ThreatPlates" then
			local setup = {
				SetStyle = SetStyleThreatPlates,
				SetScale = TidyPlatesThreat.SetScale,
				SetAlpha = TidyPlatesThreat.SetAlpha,
				SetSpecialText = TidyPlatesThreat.SetSpecialText,
				SetSpecialText2 = TidyPlatesThreat.SetSpecialText2,
				SetThreatColor = TidyPlatesThreat.SetThreatColor,
				SetCastbarColor = TidyPlatesThreat.SetCastbarColor,
				SetHealthbarColor = TidyPlatesThreat.SetHealthbarColor,
			}
			TidyPlatesThemeList["Threat Plates"] = setup
		end
	elseif event == "PLAYER_ALIVE" then
		TidyPlatesThreat:StartUp()
	elseif event == "PLAYER_LOGIN" then
		TidyPlatesThreat.db.char.threat.tanking = currentRoleBool(Active()) -- Сравнивает ветку танка с текущей, после входа в систему.
		if GetCVar("nameplateShowEnemyTotems") == "1" then
			TidyPlatesThreat.db.profile.nameplate.toggle["Totem"] = true
		else
			TidyPlatesThreat.db.profile.nameplate.toggle["Totem"] = false
		end
		SetCVar("ShowClassColorInNameplate", 1)
		if TidyPlatesThreat.db.char.welcome and ((TidyPlatesOptions.primary == "Threat Plates") or (TidyPlatesOptions.secondary == "Threat Plates")) and TidyPlatesThreat.db.profile.verbose then
			print("|cff89f559Threat Plates:|r Добро пожаловать |cff"..HEX_CLASS_COLOR[PlayerClass]..UnitName("player").."|r!")
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		local inInstance, iType = IsInInstance()
		if iType == "arena" or iType == "pvp" then
			TidyPlatesThreat.db.profile.threat.ON = false
		elseif iType == "party" or iType == "raid" or iType == "none" then
			TidyPlatesThreat.db.profile.threat.ON = TidyPlatesThreat.db.profile.OldSetting	
		end
		TidyPlatesThreat.db.profile.cache = {}
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	elseif event == "PLAYER_LEAVING_WORLD" then
		self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		local t = TidyPlatesThreat.db.char.specInfo[Active()]
		TidyPlatesThreat.db.char.threat.tanking = currentRoleBool(Active())
		if ((TidyPlatesOptions.primary == "Threat Plates") or (TidyPlatesOptions.secondary == "Threat Plates")) and TidyPlatesThreat.db.profile.verbose then
			print("|cff89F559Ветка талантов определена|r: |cff"..HEX_CLASS_COLOR[PlayerClass]..specName()..": ("..t[1].."/"..t[2].."/"..t[3]..")|r, вы |cff89F559"..dualSpec().."|r "..roleText()..".")
		end
		TidyPlates:ForceUpdate()
	elseif event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" then
		if TidyPlatesThreat.db.profile.threat.ON and (GetCVar("threatWarning") ~= 3) then
			SetCVar("threatWarning", 3)
		elseif not TidyPlatesThreat.db.profile.threat.ON and (GetCVar("threatWarning") ~= 0) then
			SetCVar("threatWarning", 0)
		end
	elseif event == "PLAYER_LOGOUT" then
		TidyPlatesThreat.db.profile.cache = {}
	end
end
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ALIVE")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LEAVING_WORLD")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_LOGOUT")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:SetScript("OnEvent", function(self,event,...)
	f:Events(self,event,...)
end)



