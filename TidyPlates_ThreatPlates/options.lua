local TidyPlatesThreat = TidyPlatesThreat
local LibStub = LibStub

-- Shared Media Configs
local Media = LibStub("LibSharedMedia-3.0")
Media:Register("statusbar", "ThreatPlatesBar", [[Interface\Addons\TidyPlates_ThreatPlates\Artwork\TP_BarTexture.tga]])
Media:Register("font", "Accidental Presidency",[[Interface\Addons\TidyPlates_ThreatPlates\Fonts\Accidental Presidency.ttf]])

-- Threat Texture Themes:

ClassList = {default = "По умолчанию", transparent = "Прозрачная"}
ThreatStyleList = { [1] = "Threat Line", [2] = "Threat Wheel"}
local FullAlign = {
	TOPLEFT = "Сверху слева",
	TOP = "Сверху",
	TOPRIGHT = "Сверху справа",
	LEFT = "Слева",
	CENTER = "По центру",
	RIGHT = "Справа",
	BOTTOMLEFT = "Снизу слева",
	BOTTOM = "Снизу",
	BOTTOMRIGHT = "Снизу справа"
}
local AlignH = {LEFT = "Слева", CENTER = "По центру", RIGHT = "Справа"}
local AlignV = {BOTTOM = "Снизу", CENTER = "По центру", TOP = "Сверху"}
FontStyle = {
	NONE = "Нет", 
	OUTLINE = "Контур", 
	THICKOUTLINE = "Толстый контур", 
	["NONE, MONOCHROME"] = "Монохромный", 
	["OUTLINE, MONOCHROME"] = "Контур, Монохромный", 
	["THICKOUTLINE, MONOCHROME"] = "Толстый Контур, Монохромный"
}
local DebuffMode = {
	["whitelist"] = "Белый список",
	["blacklist"] = "Черный список",
	["all"] = "Все дебафы"
}

-- Добавьте свои собственные текстуры угрозы с папкой в папке произведения искусства с собственными низкими средними и высокими текстурами.
-- Например:
-- Создайте папку в папке произведения искусства под названием «Custom».
-- Поместите три текстура вашего предпочтения, затем отредактируйте таблицу темы выше:
-- ThemeList = {default = "Default", bar = "Bar Style", Custom = "Custom"} 
-- Первое значение - это имя папки, вторая - это имя планировки текстуры.
-- Так что вы также можете иметь это таким образом:
-- ThemeList = {default = "Default", bar = "Bar Style", Custom = "TOTALLY RAD TEXTURES BY ME"} 
-- Это также установит ваши текстуры доступны.

local function SplitToTable( ... )
	local t = {}
	local index, line
	for index = 1, select("#", ...) do
		line = select(index, ...)
		if line ~= "" then t[line] = true end
	end
	return t
end

local function TableToString(t)
	local list = ""
	for i=1,#t do
		if list then
			if (t[(i+1)] ~= "") then
				list = list..(tostring(t[i])).."\n"
			else 
				list = list..(tostring(t[i]))
			end
		else 
			list = (tostring(t[i])).."\n"
		end
	end
	return list
end

-- Totem Option Functions

local function GetTotemValue(info)
	local location, mod = info.arg[1],info.arg[2]
	return TidyPlatesThreat.db.profile.totemSettings[location][mod]
end

local function SetTotemValue(info, val)
	local location, mod = info.arg[1],info.arg[2]
	TidyPlatesThreat.db.profile.totemSettings[location][mod] = val
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

local function GetTotemColor(info)
	local location = info.arg[1]
	local t = TidyPlatesThreat.db.profile.totemSettings[location]
	return t[3], t[4], t[5]
end

local function SetTotemColor(info, r, g, b)
	local location = info.arg[1]
	local t = TidyPlatesThreat.db.profile.totemSettings[location]
	t[3], t[4], t[5] = r, g, b
end

-- Unique Nameplate Functions
local function GetUniqueValue(info)
	local location, mod = info.arg[1],info.arg[2]
	return TidyPlatesThreat.db.profile.uniqueSettings[location][mod]
end

local function SetUniqueValue(info, val)
	local location, mod = info.arg[1],info.arg[2]
	TidyPlatesThreat.db.profile.uniqueSettings[location][mod] = val
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

local function GetUniqueColor(info)
	local location = info.arg[1]
	local t = TidyPlatesThreat.db.profile.uniqueSettings[location]
	return t[3], t[4], t[5]
end

local function SetUniqueColor(info, r, g, b)
	local location = info.arg[1]
	local t = TidyPlatesThreat.db.profile.uniqueSettings[location]	
	t[3], t[4], t[5] = r, g, b
end

-- Widget Option Functions

local function GetWidgetValue(info)
	local location, mod = info.arg[1], info.arg[2]
	return TidyPlatesThreat.db.profile[location][mod]
end

local function SetWidgetValue(info, val)
	local location, mod = info.arg[1], info.arg[2]
	TidyPlatesThreat.db.profile[location][mod] = val
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

local function GetThemeInfo(info)
	local location, mod = info.arg[1], info.arg[2]
	return TidyPlatesThreat.db.profile.settings[location][mod]
end

local function SetThemeValue(info, val)
	local location, mod = info.arg[1], info.arg[2]
	local themeList = {'normal', 'tank', 'dps', 'empty'}
	local modList = {"width", "height"}
	TidyPlatesThreat.db.profile.settings[location][mod] = val
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
	if location == "specialArt" and mod == "scale" then -- Сохраняет текстуры угроз из класса значок изменения.
		for z=1, 2 do
			TidyPlatesThemeList['Threat Plates']["normal"][location][modList[z]] = TidyPlatesThreat.db.profile.settings[location][mod]
		end
	elseif mod == "showSpecialArt" then
		TidyPlatesThemeList['Threat Plates']["normal"][location][mod] = TidyPlatesThreat.db.profile.settings[location][mod]
	else
		if mod == "scale" then -- Позволяет установить ширину и высоту для «масштабирования» настроек.Не применяет тему изменения в Eliteicon.
			for z=1, 2 do
				for i=1,4 do
					TidyPlatesThemeList['Threat Plates'][themeList[i]][location][modList[z]] = TidyPlatesThreat.db.profile.settings[location][mod]
				end
			end
		elseif location ~= "targetWidget" then
			for i=1,4 do
				TidyPlatesThemeList['Threat Plates'][themeList[i]][location][mod] = TidyPlatesThreat.db.profile.settings[location][mod]
			end
		end
	end
end

-- Text Colors

local function GetTextColor(info)
	local location, mod = info.arg[1], info.arg[2]
	local p = TidyPlatesThreat.db.profile.settings[location][mod]
	return p.r, p.g, p.b
end

local function SetTextColor(info, r, g, b)
	local location, mod = info.arg[1], info.arg[2]
	local p = TidyPlatesThreat.db.profile.settings[location][mod]
	p.r, p.g, p.b = r, g, b
end
-- Threat Colors

local function GetThreatColor(info)
	local location, mod, style = info.arg[1], info.arg[2], info.arg[3]
	local p = TidyPlatesThreat.db.profile.settings[style][location][mod]
	return p.r, p.g, p.b, p.a
end

local function SetThreatColor(info, r,g,b,a)
	local location, mod, style = info.arg[1], info.arg[2], info.arg[3]
	local p = TidyPlatesThreat.db.profile.settings[style][location][mod]
	p.r, p.g, p.b, p.a = r,g,b,a
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end
-- Raid Mark Colors
local function GetColor(info)
	local location, extention, mod = info.arg[1], info.arg[2], info.arg[3]
	local m = TidyPlatesThreat.db.profile.settings[location][extention][mod]
	return m.r, m.g, m.b
end
local function SetColor(info,r,g,b)
	local location, extention, mod = info.arg[1], info.arg[2], info.arg[3]
	local m = TidyPlatesThreat.db.profile.settings[location][extention][mod]
	m.r, m.g, m.b = r, g, b
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

-- Target Texture

local function GetArtColor(info)
	local location = info.arg
	local a = TidyPlatesThreat.db.profile[location]
	return a.r, a.g, a.b
end
local function SetArtColor(info,r,g,b)
	local location = info.arg
	local a = TidyPlatesThreat.db.profile[location]
	a.r, a.g, a.b = r, g, b
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

-- SharedMedia 

local function SetTexture(info, val)
	local location, mod = info.arg[1], info.arg[2]
	local themeList = {'normal', 'tank', 'dps'}
	TidyPlatesThreat.db.profile.settings[location][mod] = val
	for i=1,3 do
		TidyPlatesThemeList['Threat Plates'][themeList[i]][location][mod] = Media:Fetch('statusbar', TidyPlatesThreat.db.profile.settings[location][mod])
	end
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

local function SetFont(info, val)
	local location, mod = info.arg[1], info.arg[2]
	local themeList = {'normal', 'tank', 'dps', 'empty'}
	TidyPlatesThreat.db.profile.settings[location][mod] = val
	for i=1,4 do
		TidyPlatesThemeList['Threat Plates'][themeList[i]][location][mod] = Media:Fetch('font', TidyPlatesThreat.db.profile.settings[location][mod])
	end
	TidyPlates:ReloadTheme()
end

-- Nameplate Toggle Functions

local function GetToggleNameplate(info)
	return TidyPlatesThreat.db.profile.nameplate.toggle[info.arg]
end

local function SetToggleNameplate(info)
	TidyPlatesThreat.db.profile.nameplate.toggle[info.arg] = not TidyPlatesThreat.db.profile.nameplate.toggle[info.arg]
	if TidyPlatesThreat.db.profile.nameplate.toggle[info.arg] and TidyPlatesThreat.db.profile.verbose then 
		return print("-->>"..info.arg.." nameplates are now |cff00ff00ON!|r<<--") 
	elseif TidyPlatesThreat.db.profile.verbose then 
		return print("-->>"..info.arg.." nameplates are now |cffff0000OFF!|r<<--") 
	end
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

local function SetToggleText(info)
	local location, mod, TextInfo = info.arg[1], info.arg[2], info.arg[3]
	local themeList = {'normal', 'tank', 'dps'}
	TidyPlates:ForceUpdate()
	TidyPlatesThreat.db.profile.settings[location][mod] = not TidyPlatesThreat.db.profile.settings[location][mod]
	for i=1,3 do
		TidyPlatesThemeList['Threat Plates'][themeList[i]][location][mod] = TidyPlatesThreat.db.profile.settings[location][mod]
	end
	if TidyPlatesThreat.db.profile.settings[location][mod] and TidyPlatesThreat.db.profile.verbose then
		return print("-->>"..info.arg[3].." text is now |cff00ff00ON!|r<<--")
	elseif TidyPlatesThreat.db.profile.verbose then
		return print("-->>"..info.arg[3].." text is now |cffff0000OFF!|r<<--")
	end
	
	TidyPlates:ReloadTheme()
end

local function GetToggle(info)
	local location, mod, TextInfo = info.arg[1], info.arg[2], info.arg[3]
	return TidyPlatesThreat.db.profile[location][mod]
end

local function SetToggle(info)
	local location, mod, TextInfo = info.arg[1], info.arg[2], info.arg[3]
	TidyPlatesThreat.db.profile[location][mod] = not TidyPlatesThreat.db.profile[location][mod]
	if TidyPlatesThreat.db.profile[location][mod] and TidyPlatesThreat.db.profile.verbose then
		return print("-->>"..info.arg[3].." now |cff00ff00ON!|r<<--")
	elseif TidyPlatesThreat.db.profile.verbose then
		return print("-->>"..info.arg[3].." now |cffff0000OFF!|r<<--")
	end
	TidyPlates:ReloadTheme()	
	TidyPlates:ForceUpdate()
end

local function GetNameplateScale(info)
	return TidyPlatesThreat.db.profile.nameplate.scale[info.arg]
end

local function SetNameplateScale(info, v)
	TidyPlatesThreat.db.profile.nameplate.scale[info.arg] = v
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

local function GetNameplateAlpha(info)
	return TidyPlatesThreat.db.profile.nameplate.alpha[info.arg]
end

local function SetNameplateAlpha(info, v)
	TidyPlatesThreat.db.profile.nameplate.alpha[info.arg] = v
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

-- Nameplate Auto Hide

local function CombatAutoHide()
	if TidyPlatesThreat.db.profile.nameplate.autohide then
		--TidyPlates:UseAutoHide(true)
		TidyPlatesThreat.db.profile.nameplate.autohide = false
		if TidyPlatesThreat.db.profile.verbose then print("-->>Auto hiding of nameplates upon leaving combat is now |cffff0000OFF!|r<<--") end
	elseif not TidyPlatesThreat.db.profile.nameplate.autohide then
		--TidyPlates:UseAutoHide(false)
		TidyPlatesThreat.db.profile.nameplate.autohide = true
		if TidyPlatesThreat.db.profile.verbose then print("-->>Auto hiding of nameplates upon leaving combat is now |cff00ff00ON!|r<<--") end
	end
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

-- Threat Toggle Functions
local function GetThreatToggle(info)
	return TidyPlatesThreat.db.profile.threat.toggle[info.arg]
end

local function SetThreatToggle(info)
	TidyPlatesThreat.db.profile.threat.toggle[info.arg] = not TidyPlatesThreat.db.profile.threat.toggle[info.arg]
	if TidyPlatesThreat.db.profile.threat.toggle[info.arg] and TidyPlatesThreat.db.profile.verbose then 
		return print("-->>|cff00ff00"..info.arg.." Threat System is now ON!|r<<--") 
	elseif TidyPlatesThreat.db.profile.verbose then 
		return print("-->>|cffff0000"..info.arg.." Threat System is now OFF!|r<<--") 
	end
	TidyPlates:ReloadTheme()
end

function SetThreatOldSetting()
	self = TidyPlatesThreat.db.profile
	local inInstance, iType = IsInInstance()
	if iType == "party" or iType == "raid" or iType == "none" then
		self.OldSetting = self.threat.ON
	end
end
-- Get Set Threat Alpha & Scale per role
local function GetThreatValue(info)	
	local role, mod, location = info.arg[1], info.arg[2], info.arg[3]
	return TidyPlatesThreat.db.profile.threat[role][mod][location]
end

local function SetThreatValue(info, v)	
	local role, mod, location = info.arg[1], info.arg[2], info.arg[3]
	TidyPlatesThreat.db.profile.threat[role][mod][location] = v
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

-- Get Set Threat Scale per type

local function GetThreatType(info)
	local location, mod = info.arg[1], info.arg[2]
	return TidyPlatesThreat.db.profile.threat[location][mod]
end

local function SetThreatType(info, v)
	local location, mod = info.arg[1], info.arg[2]
	TidyPlatesThreat.db.profile.threat[location][mod] = v
	TidyPlates:ReloadTheme()
	TidyPlates:ForceUpdate()
end

local options = { 
		type = "group", 
		args = {
			OptionsHeader = {
				order = 2,
				type = "header",
				name = GetAddOnMetadata("TidyPlates_ThreatPlates", "title").." v"..GetAddOnMetadata("TidyPlates_ThreatPlates", "version"),
			},
			NameplateOptFrame = {
				order = 3,
				type  = "group",
				name  = "Внешний вид",
				args = {
					Header = {
						type = "header",
						order = 1,
						name = "Отображение"
					},
					description = {
						type = "description",
						order = 2,
						name = "Показать определённые типы существ",
					},
					ShowNeutral = {
						type = "toggle",
						width = "full",
						order = 3,
						name = "Нейтральные",
						get = GetToggleNameplate,
						set = SetToggleNameplate,
						arg = "Neutral",
					},
					ShowNormal = {
						type = "toggle",
						width = "full",
						order = 4,
						name = "Обычные",
						get = GetToggleNameplate,
						set = SetToggleNameplate,
						arg = "Normal",
					},
					ShowElite = {
						type = "toggle",
						width = "full",
						order = 5,
						name = "Элитные",
						get = GetToggleNameplate,
						set = SetToggleNameplate,
						arg = "Elite",
					},
					ShowBoss = {
						type = "toggle",
						width = "full",
						order = 6,
						name = "Боссы",
						get = GetToggleNameplate,
						set = SetToggleNameplate,
						arg = "Boss",
					},
					Header2 = {
						type = "header",
						order = 7,
						name = "Текстуры"
					},
					showTarget = {
						type = "toggle",
						width = "full",
						order = 8,
						name = "Подсветка цели",
						get = GetToggle,
						set = SetToggle,
						arg = {"targetWidget","ON","Target Highlight textures are"},
					},
					targetArt = {
						type = "select",
						width = "full",
						order = 8.02,
						name = "Текстура",
						values = TargetList,
						get = GetWidgetValue,
						set = SetWidgetValue,
						arg = {"targetWidget","theme"},
					},
					targetArtColor = {
						type = "color",
						order = 8.03,
						name = "Цвет",
						get = GetArtColor,
						set = SetArtColor,
						arg = "targetWidget",
					},
					Level = {
						type = "range",
						width = "full",
						order = 8.05,
						name = "Уровень кадра",
						get = GetWidgetValue,
						set = SetWidgetValue,
						arg = {"targetWidget","level"},
						min = 0,
						max = 40,
						step = 1,
					},
					HealthBarTexture = {
						type = "select",
						width = "full",
						dialogControl = "LSM30_Statusbar",
						order = 8.1,
						name = 'Полоса здоровья',
						values = AceGUIWidgetLSMlists.statusbar,
						set = SetTexture,
						get = GetThemeInfo,
						arg = {"healthbar", "texture"},
					},
					Header3 = {
						type = "header",
						order = 9,
						name = "Чтение заклинания",
					},
					CastBarTexture = {
						type = "select",
						width = "full",
						dialogControl = "LSM30_Statusbar",
						order = 9.2,
						name = 'Текстура',
						values = AceGUIWidgetLSMlists.statusbar,
						set = SetTexture,
						get = GetThemeInfo,
						arg = {"castbar", "texture"},
					},
					castbarToggle = {
						type = "toggle",
						width = "full",
						order = 9.1,
						name = "Включить",
						get = function() return TidyPlatesThreat.db.profile.castbarSettings.toggle end, -- if  == "1" then return true else return false end,
						set = function(info, val)
							TidyPlatesThreat.db.profile.castbarSettings.toggle = not TidyPlatesThreat.db.profile.castbarSettings.toggle
							SetCVar("ShowVKeyCastbar", abs((GetCVar("ShowVKeyCastbar") - 1)))
						end,
					},
					castbarColorToggle = {
						type = "toggle",
						width = "full",
						order = 9.3,
						name = "Свой цвет",
						get = GetToggle,
						set = SetToggle,
						arg = {"castbarColor", "toggle", "Custom Castbar Color"},
					},
					castbarColor = {
						type = "color",
						order = 9.4,
						name = "Цвет",
						get = function(info) 
							local c = TidyPlatesThreat.db.profile.castbarColor
							return c.r, c.g, c.b, c.a
						end,
						set = function(info, r, g, b) 
							local p = TidyPlatesThreat.db.profile.castbarColor
							p.r, p.g, p.b = r,g,b
							TidyPlates:ReloadTheme()
							TidyPlates:ForceUpdate()
						end,
						hasAlpha = false,
					},
					Header4 = {
						type = "header",
						order = 10,
						name = "Цвет уровня угрозы"
					},
					LowThreat = {
						type = 'color',
						order = 11,
						name = "Низкий",
						get = GetThreatColor,
						set = SetThreatColor,
						arg = {"threatcolor", "LOW", "normal"},
						hasAlpha = true,
					},
					MediumThreat = {
						type = 'color',
						order = 12,
						name = "Средний",
						get = GetThreatColor,
						set = SetThreatColor,
						arg = {"threatcolor", "MEDIUM", "normal"},
						hasAlpha = true,
					},
					HighThreat = {
						type = 'color',
						order = 13,
						name = "Высокий",
						get = GetThreatColor,
						set = SetThreatColor,
						arg = {"threatcolor", "HIGH", "normal"},
						hasAlpha = true,
					},
					Header5 = {
						type = "header",
						order = 14,
						name = "Цвет полос здоровья"
					},
					GradualHPColor = {
						type = "toggle",
						width = "full",
						order = 14.1,
						name = "Адаптивный",
						desc = "Цвет здоровья меняется от зеленого к красному, в зависимости от его количества.",
						get = GetToggle,
						set = SetToggle,
						arg = {"healthColorChange", "toggle", "Gradual HP Bar Color"},
					},
					friendlyClass = {
						type = "toggle",
						width = "full",
						order = 14.2,
						name = "Цвет союзников по классу",
						desc = "Окрасить цвет полос в зависимости от класса.",
						get = GetToggle,
						set = SetToggle,
						arg = {"friendlyClass", "toggle", "Friendly Class Color"},
					},
					cacheClass = {
						type = "toggle",
						width = "full",
						order = 14.3,
						name = "Кеширование",
						desc = "Сохраняет класс союзников. **более высокое использование памяти**",
						get = GetToggle,
						set = SetToggle,
						arg = {"cacheClass", "toggle", "Friendly Class Colors"},
					},
					div = {
						type = "header",
						name = "Свои цвета полос здоровья",
						order = 14.4,
					},
					EnableCustomHPColor = {
						type = "toggle",
						width = "full",
						order = 15,
						name = "Включить",
						get = GetToggle,
						set = SetToggle,
						arg = {"customColor", "toggle", "Custom HP Bar Color"},
					},
					EnableClassOverrideColor = {
						type = "toggle",
						width = "full",
						order = 15.5,
						name = "Скрыть цвет класса",
						desc = "Для работы, требуется включить опцию выше.",
						get = GetToggle,
						set = SetToggle,
						arg = {"allowClass", "toggle", "Hiding of Class Настройка цвета"},
					},
					FriendlyCustomHPColor = {
						type = 'color',
						order = 16.25,
						name = "Дружелюбные",
						get = function(info) 
							local c = TidyPlatesThreat.db.profile.fHPbarColor
							return c.r, c.g, c.b
						end,
						set = function(info, r, g, b) 
							local p = TidyPlatesThreat.db.profile.fHPbarColor
							p.r, p.g, p.b = r,g,b
							TidyPlates:ReloadTheme()
							TidyPlates:ForceUpdate()
						end,
						hasAlpha = false,
					},
					NeutralCustomHPColor = {
						type = 'color',
						order = 16.75,
						name = "Нейтральные",
						get = function(info) 
							local c = TidyPlatesThreat.db.profile.nHPbarColor
							return c.r, c.g, c.b
						end,
						set = function(info, r, g, b) 
							local p = TidyPlatesThreat.db.profile.nHPbarColor
							p.r, p.g, p.b = r,g,b
							TidyPlates:ReloadTheme()
							TidyPlates:ForceUpdate()
						end,
						hasAlpha = false,
					},
					HostileCustomHPColor = {
						type = 'color',
						order = 16,
						name = "Враждебные",
						get = function(info) 
							local c = TidyPlatesThreat.db.profile.HPbarColor
							return c.r, c.g, c.b
						end,
						set = function(info, r, g, b) 
							local p = TidyPlatesThreat.db.profile.HPbarColor
							p.r, p.g, p.b = r,g,b
							TidyPlates:ReloadTheme()
							TidyPlates:ForceUpdate()
						end,
						hasAlpha = false,
					},
					--[[
					xOff = {
						type = "range",
						width = "full",
						order = 15,
						name = "X Offset",
						min = -120,
						max = 120,
						step = 1,
						get = function() return TidyPlatesThreat.db.profile.settings.offsetx end,
						set = function(info, val)
							TidyPlatesThreat.db.profile.settings.offsetx = val
							TidyPlates:ReloadTheme()
							end,
					},
					yOff = {
						type = "range",
						width = "full",
						order = 15,
						name = "Y Offset",
						min = -120,
						max = 120,
						step = 1,
						get = function() return TidyPlatesThreat.db.profile.settings.offsety end,
						set = function(info, val)
							TidyPlatesThreat.db.profile.settings.offsety = val
							TidyPlates:ReloadTheme()
							end,
					},
					Header = {
						type = 'header',
						order = 6.1,
						name = "Auto Hide Nameplates",
					},
					Description = {
						type = 'description',
						order = 6.2,
						name = "Toggle the auto hiding of nameplates after leaving combat."
					},
					UseAutoHide = {
						type = "toggle",
						width = "full",
						order = 6.3,
						name = "Enable Autohide",
						get = function() return TidyPlatesThreat.db.profile.nameplate.autohide end,
						set = CombatAutoHide,
					},]]--
					comboWidget = {
						name = "Комбо поинты",
						type = 'group',
						desc = "Настройка параметров для комбо поинтов.",
						order = 0.5,
						args = {
							widgetHeader = {
								type = "header",
								order = 1,
								name = "Настройка",
							},
							enable = {
								type = "toggle",
								width = "full",
								name = "Включить",
								order = 2,
								get = GetToggle,
								set = SetToggle,
								arg = {"comboWidget","ON", "Combo Widget"},
							},
							widgetX = {
								type = "range",
								width = "full",
								name = "Смещение по оси X",
								order = 3,
								get = function() return TidyPlatesThreat.db.profile.comboWidget.x end,
								set = function(info, val)
									TidyPlatesThreat.db.profile.comboWidget.x = val
									TidyPlates:ForceUpdate()
									TidyPlates:ReloadTheme()
									end,
								min = -120,
								max = 120,
								step = 1,
								isPercent = false,
							},
							widgetY = {
								type = "range",
								width = "full",
								name = "Смещение по оси Y",
								order = 3,
								get = function() return TidyPlatesThreat.db.profile.comboWidget.y end,
								set = function(info, val)
									TidyPlatesThreat.db.profile.comboWidget.y = val
									TidyPlates:ForceUpdate()
									TidyPlates:ReloadTheme()
									end,
								min = -120,
								max = 120,
								step = 1,
								isPercent = false,
							},
						},
					},
					RaidIcon = {
						type = "group",
						order = 1,
						name = "Метка цели",
						args = {
							header = {
								type = 'header',
								order = 1,
								name = "Настройка",
							},
						--[[
							Enable = {
								type = "toggle",
								width = "full",
								order = 1.5,
								name = "Raid Icon y",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"options","showDangerSkull"},
							},
						]]--
							Size = {
								type = "range",
								width = "full",
								order = 2,
								name = "Размер",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"raidicon","scale"},
								min = 6,
								max = 64,
								step = 1,
							},
							X = {
								type = "range",
								width = "full",
								order = 3,
								name = "Смещение по оси X",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"raidicon","x"},
								min = -120,
								max = 120,
								step = 1,
							},
							Y = {
								type = "range",
								width = "full",
								order = 4,
								name = "Смещение по оси Y",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"raidicon","y"},
								min = -120,
								max = 120,
								step = 1,
							},
							Anchor = {
								type = "select",
								width = "full",
								order = 5,
								name = "Крепление",
								values = FullAlign,
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"raidicon","anchor"},
							},
							CustomHPcolor = {
								type = "header",
								order = 6,
								name = "Свой цвет",
							},
							hpColorEnable = {
								type = "toggle",
								width = "full",
								order = 7,
								name = "Включить",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"raidicon","hpColor"},
							},
							STAR = {
								type = "color",
								order = 8,
								name = "Звезда",
								get = GetColor,
								set = SetColor,
								arg = {"raidicon","hpMarked","STAR"},
								hasAlpha = false,
							},
							MOON = {
								type = "color",
								order = 9,
								name = "Луна",
								get = GetColor,
								set = SetColor,
								arg = {"raidicon","hpMarked","MOON"},
								hasAlpha = false,
							},
							CIRCLE = {
								type = "color",
								order = 9,
								name = "Круг",
								get = GetColor,
								set = SetColor,
								arg = {"raidicon","hpMarked","CIRCLE"},
								hasAlpha = false,
							},
							SQUARE = {
								type = "color",
								order = 10,
								name = "Квадрат",
								get = GetColor,
								set = SetColor,
								arg = {"raidicon","hpMarked","SQUARE"},
								hasAlpha = false,
							},
							DIAMOND = {
								type = "color",
								order = 11,
								name = "Ромб",
								get = GetColor,
								set = SetColor,
								arg = {"raidicon","hpMarked","DIAMOND"},
								hasAlpha = false,
							},
							CROSS = {
								type = "color",
								order = 11,
								name = "Крест",
								get = GetColor,
								set = SetColor,
								arg = {"raidicon","hpMarked","CROSS"},
								hasAlpha = false,
							},
							TRIANGLE = {
								type = "color",
								order = 11,
								name = "Треугольник",
								get = GetColor,
								set = SetColor,
								arg = {"raidicon","hpMarked","TRIANGLE"},
								hasAlpha = false,
							},
							SKULL = {
								type = "color",
								order = 11,
								name = "Череп",
								get = GetColor,
								set = SetColor,
								arg = {"raidicon","hpMarked","SKULL"},
								hasAlpha = false,
							},
						},
					},
					ClassIcon = {
						type = "group",
						order = 2,
						name = "Икока класса",
						args = {
							header = {
								type = 'header',
								order = 1,
								name = "Настройка",
							},
							Enable = {
								type = "toggle",
								width = "full",
								order = 1.5,
								name = "Включить",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"classWidget","ON"},
							},
							textures = {
								type = "select",
								width = "full",
								order = 4,
								name = 'Текстура',
								desc = 'Выберите текстуру',
								style = dropdown,
								values = ClassList,
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"classWidget","theme"},
							},
							Size = {
								type = "range",
								width = "full",
								order = 2,
								name = "Размер",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"classWidget","scale"},
								min = 6,
								max = 64,
								step = 1,
							},
							X = {
								type = "range",
								width = "full",
								order = 3,
								name = "Смещение по оси X",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"classWidget","x"},
								min = -120,
								max = 120,
								step = 1,
							},
							Y = {
								type = "range",
								width = "full",
								order = 4,
								name = "Смещение по оси Y",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"classWidget","y"},
								min = -120,
								max = 120,
								step = 1,
							},
							Anchor = {
								type = "select",
								width = "full",
								order = 5,
								name = "Крепление",
								values = FullAlign,
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"classWidget","anchor"},
							},
						},
					},
					SkullIcon = {
						type = "group",
						order = 3,
						name = "Настройка значка череп",
						args = {
							header = {
								type = 'header',
								order = 1,
								name = "Настрока",
							},
							Enable = {
								type = "toggle",
								width = "full",
								order = 1.5,
								name = "Включить",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"options","showDangerSkull"},
							},
						
							Size = {
								type = "range",
								width = "full",
								order = 2,
								name = "Размер",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"dangerskull","scale"},
								min = 6,
								max = 64,
								step = 1,
							},
							X = {
								type = "range",
								width = "full",
								order = 3,
								name = "Смещение по оси X",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"dangerskull","x"},
								min = -120,
								max = 120,
								step = 1,
							},
							Y = {
								type = "range",
								width = "full",
								order = 4,
								name = "Смещение по оси Y",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"dangerskull","y"},
								min = -120,
								max = 120,
								step = 1,
							},
							Anchor = {
								type = "select",
								width = "full",
								order = 5,
								name = "Крепление",
								values = FullAlign,
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"dangerskull","anchor"},
							},
						},
					},
					EliteIcon = {
						type = "group",
						order = 3.5,
						name = "Иконка элитных нпс",
						args = {
							header = {
								type = 'header',
								order = 1,
								name = "Настройка",
							},
							Enable = {
								type = "toggle",
								width = "full",
								order = 1.5,
								name = "Включить",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"eliteWidget","ON"},
							},
							Size = {
								type = "range",
								width = "full",
								order = 2,
								name = "Размер",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"eliteWidget","scale"},
								min = 6,
								max = 64,
								step = 1,
							},
							X = {
								type = "range",
								width = "full",
								order = 3,
								name = "Смещение по оси X",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"eliteWidget","x"},
								min = -120,
								max = 120,
								step = 1,
							},
							Y = {
								type = "range",
								width = "full",
								order = 4,
								name = "Смещение по оси Y",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"eliteWidget","y"},
								min = -120,
								max = 120,
								step = 1,
							},
							Level = {
								type = "range",
								width = "full",
								order = 4.5,
								name = "Уровень кадра",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"eliteWidget","level"},
								min = 0,
								max = 40,
								step = 1,
							},
							textures = {
								type = "select",
								width = "full",
								order = 5,
								name = 'Текстура',
								desc = 'Выберите тему',
								style = dropdown,
								values = EliteList,
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"eliteWidget","theme"}
							},
							Anchor = {
								type = "select",
								width = "full",
								order = 6,
								name = "Крепление",
								values = FullAlign,
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"eliteWidget","anchor"},
							},
						},
					},
					debuffWidget = {
						name = "Дебаффы",
						type = 'group',
						desc = "Настройка параметров для виджета дебаффов.",
						order = 3.7,
						args = {
							widgetHeader = {
								type = "header",
								order = 1,
								name = "Настройка",
							},
							enable = {
								type = "toggle",
								width = "full",
								name = "Включить",
								order = 2,
								get = GetToggle,
								set = SetToggle,
								arg = {"debuffWidget","ON", "Debuff Widget"},
							},
							widgetX = {
								type = "range",
								width = "full",
								name = "Смещение по оси X",
								order = 3,
								get = function() return TidyPlatesThreat.db.profile.debuffWidget.x end,
								set = function(info, val)
									TidyPlatesThreat.db.profile.debuffWidget.x = val
									TidyPlates:ForceUpdate()
									TidyPlates:ReloadTheme()
									end,
								min = -120,
								max = 120,
								step = 1,
								isPercent = false,
							},
							widgetY = {
								type = "range",
								width = "full",
								name = "Смещение по оси Y",
								order = 4,
								get = function() return TidyPlatesThreat.db.profile.debuffWidget.y end,
								set = function(info, val)
									TidyPlatesThreat.db.profile.debuffWidget.y = val
									TidyPlates:ForceUpdate()
									TidyPlates:ReloadTheme()
									end,
								min = -120,
								max = 120,
								step = 1,
								isPercent = false,
							},
							filter = {
								type = "header",
								order = 5,
								name = "Фильтр",
							},
							Mode = {
								type = "select",
								order = 6,
								name = "Режим",
								width = "full",
								values = DebuffMode,
								get = function() return TidyPlatesThreat.db.profile.debuffWidget.mode end,
								set = function(info,v) TidyPlatesThreat.db.profile.debuffWidget.mode = v end,
							},
							addDebuff = {
								type = "input",
								order = 7,
								name = "Добавить дебафф",
								dialogControl = "MultiLineEditBox",
								width = "full",
								get = function(info) local list = TidyPlatesThreat.db.profile.debuffWidget.filter; return TableToString(list) end, --TableToString(list) end, --for i=1,#TidyPlatesThreat.db.profile.debuffWidget.filter do return index end
								set = function(info, v) 
									local table = {strsplit("\n", v)};
									TidyPlatesThreat.db.profile.debuffWidget.filter = table end, --SplitToTable(v) end,
							},
						},
					},
					Scale = {
						type = "group",
						order = 6,
						name = "Размеры полос",
						desc = "Выберите размер для каждого типа",
						args = {
							levels = {
								type = "header",
								order = 3,
								name = "Настройка",
							},
							Neutral_scale = {
								type = "range",
								width = "full",
								order = 4,
								name = "Нейтральные",
								arg = "Neutral",
								get = GetNameplateScale,
								set	= SetNameplateScale,
								step = 0.05,
								min = 0.3,
								max = 2,
								isPercent = true,
							},
							Normal_scale = {
								type = "range",
								width = "full",
								order = 5,
								name = "Обычные",
								arg = "Normal",
								get = GetNameplateScale,
								set	= SetNameplateScale,
								step = 0.05,
								min = 0.3,
								max = 2,
								isPercent = true,
							},
							Elite_scale = {
								type = "range",
								width = "full",
								order = 6,
								name = "Элитные",
								arg = "Elite",
								get = GetNameplateScale,
								set	= SetNameplateScale,
								step = 0.05,
								min = 0.3,
								max = 2,
								isPercent = true,
							},
							Boss_scale = {
								type = "range",
								width = "full",
								order = 7,
								name = "Боссы",
								arg = "Boss",
								get = GetNameplateScale,
								set	= SetNameplateScale,
								step = 0.05,
								min = 0.3,
								max = 2,
								isPercent = true,
							},
						},
					},
					Alpha = {
						type = "group",
						order = 7,
						name = "Прозрачность",
						desc = "Настройки прозрачности",
						args = {
							levels = {
								type = "header",
								order = 3,
								name = "Настройка",
							},
							blizzFade = {
								type = "toggle",
								width = "full",
								order = 3.1,
								name = "Отключить для скрытых целей",
								get = GetToggle,
								set = SetToggle,
								arg = {"blizzFade","toggle","Diabling of targetting alpha change"},
							},
							blizzFadeAmount = {
								type = "range",
								width = "full",
								order = 3.2,
								name = "Нет цели",
								get = function() return TidyPlatesThreat.db.profile.blizzFade.amount end,
								set = function(info, val)
									TidyPlatesThreat.db.profile.blizzFade.amount = val
									TidyPlates:ForceUpdate()
									TidyPlates:ReloadTheme()
									end,
								min = -1,
								max = 0,
								step = 0.01,
								isPercent = true,
							},
							divider = {
								type = "header",
								order = 3.3,
								name = "",
							},
							Neutral_alpha = {
								type = "range",
								width = "full",
								order = 4,
								name = "Нейтральные",
								arg = "Neutral",
								get = GetNameplateAlpha,
								set	= SetNameplateAlpha,
								step = 0.05,
								min = 0,
								max = 1,
								isPercent = true,
							},
							Normal_alpha = {
								type = "range",
								width = "full",
								order = 5,
								name = "Обычные",
								arg = "Normal",
								get = GetNameplateAlpha,
								set	= SetNameplateAlpha,
								step = 0.05,
								min = 0,
								max = 1,
								isPercent = true,
							},
							Elite_alpha = {
								type = "range",
								width = "full",
								order = 6,
								name = "Элитные",
								arg = "Elite",
								get = GetNameplateAlpha,
								set	= SetNameplateAlpha,
								step = 0.05,
								min = 0,
								max = 1,
								isPercent = true,
							},
							Boss_alpha = {
								type = "range",
								width = "full",
								order = 7,
								name = "Боссы",
								arg = "Boss",
								get = GetNameplateAlpha,
								set	= SetNameplateAlpha,
								step = 0.05,
								min = 0,
								max = 1,
								isPercent = true,
							},
						},
					},
				},
			},
			TextOptFrame = {
				order = 4,
				type  = "group",
				name  = "Текст",
				args = {
					TextOptHeader = {
						order = 1,
						type = "header",
						name = "Настройка",
					},
					formatheader = {
						order = 6,
						type = "header",
						name = "Формат"
					},
					fullhp = {
						order = 7,
						type = "toggle",
						width = "full",
						name = "Показать при фулл ХП",
						desc = "Отображать значения, когда у юнита 100% ХП",
						get = GetToggle,
						set = SetToggle,
						arg = {"text","full","Full HP text is"},
					},
					hpamount = {
						order = 8,
						type = "toggle",
						width = "full",
						name = "Числа",
						desc = "Показать цифровые значения.",
						get = GetToggle,
						set = SetToggle,
						arg = {"text","amount","HP Text Amount is"},
					},
					hptruncate = {
						order = 9,
						type = "toggle",
						width = "full",
						name = "Сокращённо",
						desc = "Сократить значения миллионов и тысяч.",
						get = GetToggle,
						set = SetToggle,
						arg = {"text","truncate","HP Text Amount truncation is"},
					},
					hpdeficit = {
						order = 10,
						type = "toggle",
						width = "full",
						name = "Нехватка",
						desc = "Показать, сколько не хватает здоровья.",
						get = GetToggle,
						set = SetToggle,
						arg = {"text","deficit","Deficit HP Text Amount is"},
					},
					extrasheader = {
						order = 11,
						type = "header",
						name = "Дополнительно"
					},
					hp_percent = {
						order = 12,
						type = "toggle",
								width = "full",
						name = "Проценты",
						desc = "Показать проценты.",
						get = GetToggle,
						set = SetToggle,
						arg = {"text","percent","HP Percentage Text is"},
					},
					hpmax = {
						order = 13,
						type = "toggle",
						width = "full",
						name = "Максимальный запас",
						desc = "Показать значение максимального запаса здоровья.",
						get = GetToggle,
						set = SetToggle,
						arg = {"text","max","HP Maximum Text is"},
					},
					NameSettings = {
						type = "group",
						name = "Имена",
						order = 1,
						args = {
							NameHeader = {
								type = 'header',
								order = 1,
								name = 'Настройка',
							},
							NameToggle = {
								order = 1.05,
								type = "toggle",
								width = "full",
								name = "Включить",
								desc = "Переключает показ и скрытие имени",
								arg = {"options","showName", "Name"},
								get = GetThemeInfo,
								set = SetToggleText,
							},
							Divider = {
								type = 'header',
								order = 1.1,
								name = "",
							},
							NameFont = {
								type = "select",
								width = "full",
								order = 1.2,
								name = 'Шрифт:',
								dialogControl = 'LSM30_Font',
								values = AceGUIWidgetLSMlists.font,
								set = SetFont,
								get = GetThemeInfo,
								arg = {"name", "typeface"},
							},
							NameFontStyle = {
								type = "select",
								width = "full",
								order = 1.25,
								name = 'Стиль шрифта',
								desc = 'Выберите стиль шрифта.',
								style = dropdown,
								arg = {"name", "flags"},
								values = FontStyle,
								get = GetThemeInfo,
								set = SetThemeValue,
							},
							NameTextColor = {
								type = "color",
								order = 1.12,
								name = "Цвет",
								get = GetTextColor,
								set = SetTextColor,
								arg = {"name", "color"},
								hasAlpha = false,
							},
							NameShadow = {
								order = 1.3,
								type = "toggle",
								width = "full",
								name = "Тень",
								arg = {"name", "shadow", "Name Shadow"},
								get = GetThemeInfo,
								set = SetToggleText,
							},
							NameSize = {
								type = "range",
								width = "full",
								order = 2,
								name = "Размер шрифта",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"name", "size"},
								max = 36,
								min = 6,
								step = 1,
								isPercent = false,
							},
							NameWidth = {
								type = "range",
								width = "full",
								order = 3,
								name = "Ширина текста",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"name", "width"},
								max = 250,
								min = 20,
								step = 1,
								isPercent = false,
							},
							NameHeight = {
								type = "range",
								width = "full",
								order = 4,
								name = "Высота текста",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"name", "height"},
								max = 40,
								min = 8,
								step = 1,
								isPercent = false,
							},
							NamePosX = {
								type = "range",
								width = "full",
								order = 5,
								name = "Смещение по оси Х",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"name", "x"},
								max = 120,
								min = -120,
								step = 1,
								isPercent = false,
							},
							NamePosY = {
								type = "range",
								width = "full",
								order = 6,
								name = "Смещение по оси Y",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"name", "y"},
								max = 120,
								min = -120,
								step = 1,
								isPercent = false,
							},
							NameAlignH = {
								type = "select",
								width = "full",
								order = 7,
								name = "Горизонтальное выравнивание",
								values = AlignH,
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"name", "align"},
							},
							NameAlignV = {
								type = "select",
								width = "full",
								order = 8,
								name = "Вертикальное выравнивание",
								values = AlignV,
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"name", "vertical"},
							},
						},
					},
					LevelSettings = {
						type = "group",
						name = "Уровень",
						order = 2,
						args = {
							LevelHeader = {
								type = 'header',
								order = 1,
								name = 'Настройка',
							},
							LevelToggle = {
								order = 1.05,
								type = "toggle",
								width = "full",
								name = "Включить",
								desc = "Переключает показ и скрытие уровня",
								arg = {"options","showLevel", "Level"},
								get = GetThemeInfo,
								set = SetToggleText,
							},
							Divider = {
								type = 'header',
								order = 1.1,
								name = "",
							},
							LevelFont = {
								type = "select",
								width = "full",
								order = 1.2,
								name = 'Шрифт:',
								dialogControl = 'LSM30_Font',
								values = AceGUIWidgetLSMlists.font,
								set = SetFont,
								get = GetThemeInfo,
								arg = {"level", "typeface"},
							},
							LevelFontStyle = {
								type = "select",
								width = "full",
								order = 1.25,
								name = 'Стиль шрифта',
								desc = 'Выберите стиль шрифта.',
								style = dropdown,
								arg = {"level", "flags"},
								values = FontStyle,
								get = GetThemeInfo,
								set = SetThemeValue,
							},
							LevelShadow = {
								order = 1.3,
								type = "toggle",
								width = "full",
								name = "Тень",
								arg = {"level", "shadow", "Level Shadow"},
								get = GetThemeInfo,
								set = SetToggleText,
							},
							LevelSize = {
								type = "range",
								width = "full",
								order = 2,
								name = "Размер шрифта",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"level", "size"},
								max = 36,
								min = 6,
								step = 1,
								isPercent = false,
							},
							LevelWidth = {
								type = "range",
								width = "full",
								order = 3,
								name = "Ширина текста",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"level", "width"},
								max = 250,
								min = 20,
								step = 1,
								isPercent = false,
							},
							LevelHeight = {
								type = "range",
								width = "full",
								order = 4,
								name = "Высота текста",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"level", "height"},
								max = 40,
								min = 8,
								step = 1,
								isPercent = false,
							},
							LevelPosX = {
								type = "range",
								width = "full",
								order = 5,
								name = "Смещение по оси Х",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"level", "x"},
								max = 120,
								min = -120,
								step = 1,
								isPercent = false,
							},
							LevelPosY = {
								type = "range",
								width = "full",
								order = 6,
								name = "Смещение по оси Y",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"level", "y"},
								max = 120,
								min = -120,
								step = 1,
								isPercent = false,
							},
							LevelAlignH = {
								type = "select",
								width = "full",
								order = 7,
								name = "Горизонтальное выравнивание",
								values = AlignH,
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"level", "align"},
							},
							LevelAlignV = {
								type = "select",
								width = "full",
								order = 8,
								name = "Вертикальное выравнивание",
								values = AlignV,
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"level", "vertical"},
							},
						},
					},
					HealthSettings = {
						type = "group",
						name = "Здоровье",
						order = 3,
						args = {
							HealthHeader = {
								type = 'header',
								order = 1,
								name = 'Настройка',
							},
							HealthToggle = {
								order = 1.05,
								type = "toggle",
								width = "full",
								name = "Включить",
								desc = "Переключает показ и скрытие значений запаса здоровья.",
								arg = {"options","showSpecialText", "Health"},
								get = GetThemeInfo,
								set = SetToggleText,
							},
							Divider = {
								type = 'header',
								order = 1.1,
								name = "",
							},
							HealthFont = {
								type = "select",
								width = "full",
								order = 1.2,
								name = 'Шрифт:',
								dialogControl = 'LSM30_Font',
								values = AceGUIWidgetLSMlists.font,
								set = SetFont,
								get = GetThemeInfo,
								arg = {"specialText", "typeface"},
							},
							HealthFontStyle = {
								type = "select",
								width = "full",
								order = 1.25,
								name = 'Стиль шрифта',
								desc = 'Выберите стиль шрифта.',
								style = dropdown,
								arg = {"specialText", "flags"},
								values = FontStyle,
								get = GetThemeInfo,
								set = SetThemeValue,
							},
							HealthShadow = {
								order = 1.3,
								type = "toggle",
								width = "full",
								name = "Тень",
								arg = {"specialText", "shadow", "Health Shadow"},
								get = GetThemeInfo,
								set = SetToggleText,
							},
							HealthSize = {
								type = "range",
								width = "full",
								order = 2,
								name = "Размер шрифта",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText", "size"},
								max = 36,
								min = 6,
								step = 1,
								isPercent = false,
							},
							HealthWidth = {
								type = "range",
								width = "full",
								order = 3,
								name = "Ширина текста",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText", "width"},
								max = 250,
								min = 20,
								step = 1,
								isPercent = false,
							},
							HealthHeight = {
								type = "range",
								width = "full",
								order = 4,
								name = "Высота текста",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText", "height"},
								max = 40,
								min = 8,
								step = 1,
								isPercent = false,
							},
							HealthPosX = {
								type = "range",
								width = "full",
								order = 5,
								name = "Смещение по оси Х",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText", "x"},
								max = 120,
								min = -120,
								step = 1,
								isPercent = false,
							},
							HealthPosY = {
								type = "range",
								width = "full",
								order = 6,
								name = "Смещение по оси Y",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText", "y"},
								max = 120,
								min = -120,
								step = 1,
								isPercent = false,
							},
							HealthAlignH = {
								type = "select",
								width = "full",
								order = 7,
								name = "Горизонтальное выравнивание",
								values = AlignH,
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText", "align"},
							},
							HealthAlignV = {
								type = "select",
								width = "full",
								order = 8,
								name = "Вертикальное выравнивание",
								values = AlignV,
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText", "vertical"},
							},
						},
					},
					CastbarSettings = {
						type = "group",
						name = "Чтение заклинания",
						order = 4,
						args = {
							CastHeader = {
								type = 'header',
								order = 1,
								name = 'Настройка',
							},
							CastToggle = {
								order = 1.05,
								type = "toggle",
								width = "full",
								name = "Включить",
								desc = "Переключает показ и скрытие названия заклинания.",
								arg = {"options","showSpecialText2", "Cast"},
								get = GetThemeInfo,
								set = SetToggleText,
							},
							Divider = {
								type = 'header',
								order = 1.1,
								name = "",
							},
							CastbarFont = {
								type = "select",
								width = "full",
								order = 1.2,
								name = 'Шрифт:',
								dialogControl = 'LSM30_Font',
								values = AceGUIWidgetLSMlists.font,
								set = SetFont,
								get = GetThemeInfo,
								arg = {"specialText2", "typeface"},
							},
							CastFontStyle = {
								type = "select",
								width = "full",
								order = 1.25,
								name = 'Стиль шрифта',
								desc = 'Выберите стиль шрифта.',
								style = dropdown,
								arg = {"specialText2", "flags"},
								values = FontStyle,
								get = GetThemeInfo,
								set = SetThemeValue,
							},
							CastShadow = {
								order = 1.3,
								type = "toggle",
								width = "full",
								name = "Тень",
								arg = {"specialText2", "shadow", "Cast Shadow"},
								get = GetThemeInfo,
								set = SetToggleText,
							},
							CastbarSize = {
								type = "range",
								width = "full",
								order = 2,
								name = "Размер шрифта",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText2", "size"},
								max = 36,
								min = 6,
								step = 1,
								isPercent = false,
							},
							CastbarWidth = {
								type = "range",
								width = "full",
								order = 3,
								name = "Ширина текста",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText2", "width"},
								max = 250,
								min = 20,
								step = 1,
								isPercent = false,
							},
							CastbarHeight = {
								type = "range",
								width = "full",
								order = 4,
								name = "Высота текста",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText2", "height"},
								max = 40,
								min = 8,
								step = 1,
								isPercent = false,
							},
							CastbarPosX = {
								type = "range",
								width = "full",
								order = 5,
								name = "Смещение по оси Х",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText2", "x"},
								max = 120,
								min = -120,
								step = 1,
								isPercent = false,
							},
							CastbarPosY = {
								type = "range",
								width = "full",
								order = 6,
								name = "Смещение по оси Y",
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText2", "y"},
								max = 120,
								min = -120,
								step = 1,
								isPercent = false,
							},
							CastbarAlignH = {
								type = "select",
								width = "full",
								order = 7,
								name = "Горизонтальное выравнивание",
								values = AlignH,
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText2", "align"},
							},
							CastbarAlignV = {
								type = "select",
								width = "full",
								order = 8,
								name = "Вертикальное выравнивание",
								values = AlignV,
								get = GetThemeInfo,
								set = SetThemeValue,
								arg = {"specialText2", "vertical"},
							},
						},
					},
				},
			},
			TotemOptFrame = {
				order = 4,
				type = "group",
				name = "Тотемы",
				args = {
					header = {
						type = "header",
						order = 1,
						name = "Настойка",
					},
					HideNameplate = {
						type = "toggle",
						width = "full",
						order = 1.5,
						name = "Скрыть полосы здоровья",
						get = GetToggle,
						set = SetToggle,
						arg = {"totemSettings", "hideHealthbar", "Totem Healthbars"}
					},
					Scale = {
						type = "range",
						width = "full",
						order = 2,
						name = "Размер",
						arg = "Totem",
						get = GetNameplateScale,
						set = SetNameplateScale,
						min = 0.3,
						max = 2,
						isPercent = true,
					},
					Alpha = {
						type = "range",
						width = "full",
						order = 3,
						name = "Прозрачность",
						arg = "Totem",
						get = GetNameplateAlpha,
						set = SetNameplateAlpha,
						min = 0,
						max = 1,
						isPercent = true,
					},
					TotemIcons = {
						type = "group",
						order = 4,
						name = "Иконки",
						args = {
							header = {
								type = 'header',
								order = 1,
								name = "Настройка",
							},
							Enable = {
								type = "toggle",
								width = "full",
								order = 1.5,
								name = "Включить",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"totemWidget","ON"},
							},--[[
							textures = {
								type = "select",
								width = "full",
								order = 4,
								name = 'Texture',
								desc = 'Set the Totem Icon theme',
								style = dropdown,
								values = ClassList,
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"totemWidget","theme"},
							},]]--
							Size = {
								type = "range",
								width = "full",
								order = 2,
								name = "Размер",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"totemWidget","scale"},
								min = 6,
								max = 64,
								step = 1,
							},
							X = {
								type = "range",
								width = "full",
								order = 3,
								name = "Смещение по оси X",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"totemWidget","x"},
								min = -120,
								max = 120,
								step = 1,
							},
							Y = {
								type = "range",
								width = "full",
								order = 4,
								name = "Смещение по оси Y",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"totemWidget","y"},
								min = -120,
								max = 120,
								step = 1,
							},
							Anchor = {
								type = "select",
								width = "full",
								order = 5,
								name = "Крепление",
								values = FullAlign,
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"totemWidget","anchor"},
							},
						},
					},
					FireTotems = {
						order = 5,
						type = "group",
						name = "|cffff8f8fТотемы огня|r",
						args = {
							[tL(2894)] = {
								name = tL(2894),
								type = "group",
								order = 2,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F1", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F1", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F1", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F1", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"F1"}
									},
								},
							},
							[tL(8227)] = {
								name = tL(8227),
								type = "group",
								order = 2,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F2", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F2", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F2", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F2", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"F2"}
									},
								},
							},
							[tL(8181)] = {
								name = tL(8181),
								type = "group",
								order = 3,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F3", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F3", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F3", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F3", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"F3"}
									},
								},
							},
							[tL(8190)] = {
								name = tL(8190),
								type = "group",
								order = 4,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F4", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F4", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F4", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F4", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"F4"}
									},
								},
							},
							[tL(3599)] = {
								name = tL(3599),
								type = "group",
								order = 5,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F5", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F5", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F5", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F5", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"F5"}
									},
								},
							},
							[tL(30706)] = {
								name = tL(30706),
								type = "group",
								order = 6,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F6", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F6", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F6", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"F6", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"F6"}
									},
								},
							},
						},
					},
					EarthTotems = {
						order = 6,
						type = "group",
						name = "|cffffb31fТотемы земли|r",
						args = {
							[tL(2062)] = {
								name = tL(2062),
								type = "group",
								order = 2,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E1", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E1", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E1", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E1", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"E1"}
									},
								},
							},
							[tL(2484)] = {
								name = tL(2484),
								type = "group",
								order = 2,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E2", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E2", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E2", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E2", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"E2"}
									},
								},
							},
							[tL(5730)] = {
								name = tL(5730),
								type = "group",
								order = 3,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E3", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E3", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E3", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E3", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"E3"}
									},
								},
							},
							[tL(8071)] = {
								name = tL(8071),
								type = "group",
								order = 4,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E4", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E4", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E4", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E4", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"E4"}
									},
								},
							},
							[tL(8075)] = {
								name = tL(8075),
								type = "group",
								order = 5,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E5", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E5", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E5", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E5", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"E5"}
									},
								},
							},
							[tL(8143)] = {
								name = tL(8143),
								type = "group",
								order = 6,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E6", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E6", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E6", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"E6", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"E6"}
									},
								},
							},
						},
					},
					WaterTotems = {
						order = 7,
						type = "group",
						name = "|cff2b76ffТотемы воды|r",
						args = {
							[tL(8170)] = {
								name = tL(8170),
								type = "group",
								order = 2,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W1", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W1", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W1", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W1", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"W1"}
									},
								},
							},
							[tL(8184)] = {
								name = tL(8184),
								type = "group",
								order = 2,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W2", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W2", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W2", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W2", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"W2"}
									},
								},
							},
							[tL(5394)] = {
								name = tL(5394),
								type = "group",
								order = 3,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W3", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W3", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W3", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W3", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"W3"}
									},
								},
							},
							[tL(5675)] = {
								name = tL(5675),
								type = "group",
								order = 4,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W4", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W4", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W4", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W4", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"W4"}
									},
								},
							},
							[tL(16190)] = {
								name = tL(16190),
								type = "group",
								order = 5,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W5", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W5", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W5", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"W5", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"W5"}
									},
								},
							},
						},
					},
					AirTotems = {
						order = 8,
						type = "group",
						name = "|cffb8d1ffТотемы воздуха|r",
						args = {
							[tL(8177)] = {
								name = tL(8177),
								type = "group",
								order = 2,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A1", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A1", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A1", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A1", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"A1"}
									},
								},
							},
							[tL(10595)] = {
								name = tL(10595),
								type = "group",
								order = 2,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A2", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A2", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A2", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A2", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"A2"}
									},
								},
							},
							[tL(6495)] = {
								name = tL(6495),
								type = "group",
								order = 3,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A3", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A3", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A3", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A3", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"A3"}
									},
								},
							},
							[tL(8512)] = {
								name = tL(8512),
								type = "group",
								order = 4,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A4", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A4", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A4", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A4", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"A4"}
									},
								},
							},
							[tL(3738)] = {
								name = tL(3738),
								type = "group",
								order = 5,
								args = {
									ToggleOn = {
										name = "Показать ХП и иконку",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A5", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A5", 6},
									},
									IconStyle = {
										name = "Стиль",
										order = 3.5,
										type = "select",
										width = "full",
										values = TotemStyles,
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A5", 7},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									AllowColor = {
										name = "Включить",
										order = 5,
										type = "toggle",
										width = "full",
										get = GetTotemValue,
										set = SetTotemValue,
										arg = {"A5", 2},
									},
									SetColor = {
										name = "Цвет",
										order = 6,
										type = "color",
										get = GetTotemColor,
										set = SetTotemColor,
										arg = {"A5"}
									},
								},
							},
						},
					},
				},
			},
			SpecialNameplates = {
				order = 4.5,
				type  = "group",
				name  = "Дополнительно",
				args = {
					IconOptions = {
						type = "group",
						order = 1,
						name = "Иконки",
						args = {
							header = {
								type = 'header',
								order = 1,
								name = "Настройка иконки",
							},
							Enable = {
								type = "toggle",
								width = "full",
								order = 1.5,
								name = "Включить",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"uniqueWidget","ON"},
							},
							Size = {
								type = "range",
								width = "full",
								order = 2,
								name = "Размер",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"uniqueWidget","scale"},
								min = 6,
								max = 64,
								step = 1,
							},
							X = {
								type = "range",
								width = "full",
								order = 3,
								name = "Смещение по оси X",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"uniqueWidget","x"},
								min = -120,
								max = 120,
								step = 1,
							},
							Y = {
								type = "range",
								width = "full",
								order = 4,
								name = "Смещение по оси Y",
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"uniqueWidget","y"},
								min = -120,
								max = 120,
								step = 1,
							},
							Anchor = {
								type = "select",
								width = "full",
								order = 5,
								name = "Крепление",
								values = FullAlign,
								get = GetWidgetValue,
								set = SetWidgetValue,
								arg = {"uniqueWidget","anchor"},
							},
						},
					},
					Pets = {
						type = "group",
						name = "Питомцы",
						order = 2,
						args = {
							[uL(34433)] = { -- Shadow Fiend
								name = uL(34433),
								type = "group",
								order = 1,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U10", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U10", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U10", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U10"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U10", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U10", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U10", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U10", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U10", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U10", 11},
									},
								},
							},
							SpiritWolf = {
								name = "Призрачный волк",
								type = "group",
								order = 2,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U11", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U11", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U11", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U11"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U11", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U11", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U11", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U11", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U11", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U11", 11},
									},
								},
							},
							EbonGargoyle = {
								name = "Гаргулья",
								type = "group",
								order = 3,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U12", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U12", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U12", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U12"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U12", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U12", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U12", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U12", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U12", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U12", 11},
									},
								},
							},
							WaterElemental = {
								name = "Водный элементаль",
								type = "group",
								order = 4,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U13", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U13", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U13", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U13"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U13", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U13", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U13", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U13", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U13", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U13", 11},
									},
								},
							},
							Treant = {
								name = "Treant",
								type = "group",
								order = 5,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U14", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U14", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U14", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U14"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U14", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U14", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U14", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U14", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U14", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U14", 11},
									},
								},
							},
							SnakeTrap = {
								name = "Змеиная ловушка",
								type = "group",
								order = 6,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U15", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U15", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U15", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U15"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U15", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U15", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U15", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U15", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U15", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U15", 11},
									},
								},
							},
							ArmyGhouls = {
								name = "Армия мертвецов",
								type = "group",
								order = 7,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U16", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U16", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U16", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U16"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U16", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U16", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U16", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U16", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U16", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U16", 11},
									},
								},
							},
						},
					},
					BossEncounters = {
						type = "group",
						name = "Битва с боссом",
						order = 3,
						args = {
							BoneSpike = {
								name = "Bone Spike",
								type = "group",
								order = 1,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U7", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U7", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U7", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U7"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U7", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U7", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U7", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U7", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U7", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U7", 11},
									},
								},
							},
							EmpoweredAdherent = {
								name = "Empowered Adherent",
								type = "group",
								order = 2,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U4", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U4", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U4", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U4"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U4", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U4", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U4", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U4", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U4", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U4", 11},
									},
								},
							},
							DeformedFanatic = {
								name = "Deformed Fanatic",
								type = "group",
								order = 3,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U5", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U5", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U5", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U5"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U5", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U5", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U5", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U5", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U5", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U5", 11},
									},
								},
							},
							Reanimated = {
								name = "Reanimated Adherent/Fanatic",
								type = "group",
								order = 4,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U6", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U6", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U6", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U6"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U6", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U6", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U6", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U6", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U6", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U6", 11},
									},
								},
							},
							Darnavan = {
								name = "Darnavan",
								type = "group",
								order = 5,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U19", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U19", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U19", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U19"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U19", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U19", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U19", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U19", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U19", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U19", 11},
									},
								},
							},
							GasCloud = {
								name = "Gas Cloud",
								type = "group",
								order = 6,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U17", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U17", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U17", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U17"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U17", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U17", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U17", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U17", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U17", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U17", 11},
									},
								},
							},
							VolatileOoze = {
								name = "Volatile Ooze",
								type = "group",
								order = 7,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U18", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U18", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U18", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U18"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U18", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U18", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U18", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U18", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U18", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U18", 11},
									},
								},
							},
							KeneticBomb = {
								name = "Kenetic Bomb",
								type = "group",
								order = 8,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U21", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U21", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U21", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U21"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U21", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U21", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U21", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U21", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U21", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U21", 11},
									},
								},
							},
							ShamblingHorror = {
								name = "Shambling Horror",
								type = "group",
								order = 9,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U9", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U9", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U9", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U9"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U9", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U9", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U9", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U9", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U9", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U9", 11},
									},
								},
							},
							DrudgeGhoul = {
								name = "Drudge Ghoul",
								type = "group",
								order = 10,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U24", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U24", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U24", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U24"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U24", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U24", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U24", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U24", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U24", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U24", 11},
									},
								},
							},
							RagingSpirit = {
								name = "Raging Spirit",
								type = "group",
								order = 10,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U23", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U23", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U23", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U23"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U23", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U23", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U23", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U23", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U23", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U23", 11},
									},
								},
							},
							ValkyrShadowguard = {
								name = "Val'kyr Shadowguard",
								type = "group",
								order = 11,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U20", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U20", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U20", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U20"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U20", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U20", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U20", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U20", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U20", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U20", 11},
									},
								},
							},
							LichKing = {
								name = "Lich King",
								type = "group",
								order = 12,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U22", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U22", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U22", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U22"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U22", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U22", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U22", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U22", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U22", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U22", 11},
									},
								},
							},
							UnboundSeer = {
								name = "Unbound Seer",
								type = "group",
								order = 12,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U25", 9},
									},
									TitleHeader = {
										name = "Unbound Seer",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U25", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U25", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U25"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U25", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U25", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U25", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U25", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U25", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U25", 11},
									},
								},
							},
							LivingInferno = {
								name = "Living Inferno",
								type = "group",
								order = 12.2,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U26", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U26", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U26", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U26"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U26", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U26", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U26", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U26", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U26", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U26", 11},
									},
								},
							},
							LivingEmber = {
								name = "Living Ember",
								type = "group",
								order = 12.5,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U27", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U27", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U27", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U27"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U27", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U27", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U27", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U27", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U27", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U27", 11},
									},
								},
							},
							ImmortalGuardian = {
								name = "Immortal Guardian",
								type = "group",
								order = 13,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U2", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U2", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U2", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U2"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U2", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U2", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U2", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U2", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U2", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U2", 11},
									},
								},
							},
							MarkedImmortalGuardian = {
								name = "Marked Immortal Guardian",
								type = "group",
								order = 14,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U3", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U3", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U3", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U3"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U3", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U3", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U3", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U3", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U3", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U3", 11},
									},
								},
							},
							OnyxianWhelp = {
								name = "Onyxian Whelp",
								type = "group",
								order = 15,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U8", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U8", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U8", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U8"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U8", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U8", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U8", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U8", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U8", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U25", 11},
									},
								},
							},
						},
					},
					Misc = {
						type = "group",
						name = "Misc Nameplates",
						order = 4,
						args = {
							[uL(28673)] = { -- Web Wrap
								name = uL(28673),
								type = "group",
								order = 1,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U1", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U1", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U1", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U1"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U1", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U1", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U1", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U1", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U1", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U1", 11},
									},
								},
							},
							FangedPitViper = {
								name = "Fanged Pit Viper",
								type = "group",
								order = 2,
								args = {
									AllowStyle = {
										name = "Включить стиль",
										order = 0.25,
										type = "toggle",
										width = "full",
										desc = "Использовать уникальный стиль, иначе используется стандартная настройка для дд/танк.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U28", 9},
									},
									TitleHeader = {
										name = "Полоса здоровья",
										type = "header",
										order = 0.5,
									},
									ToggleOn = {
										name = "Показать",
										order = 1,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U28", 1},
									},
									div1 = {
										name = "Настройка иконки",
										order = 2,
										type = "header",
									},
									ShowIcons = {
										name = "Показать иконку",
										order = 3,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U28", 6},
									},
									div2 = {
										name = "Настройка цвета",
										order = 4,
										type = "header",
									},
									SetColor = {
										name = "Цвет",
										order = 5,
										type = "color",
										get = GetUniqueColor,
										set = SetUniqueColor,
										arg = {"U28"}
									},
									AllowColor = {
										name = "Свой цвет",
										order = 6,
										type = "toggle",
										width = "full",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U28", 2},
									},
									AllowRaidMark = {
										name = "Показать цветную метку цели",
										order = 6.5,
										type = "toggle",
										width = "full",
										desc = "Должна быть включена соответствующая опция в разделе <Внешний вид>",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U28", 12},
									},
									div3 = {
										type = "header",
										order = 7,
										name = "Размер и прозрачность",
									},
									SetScale = {
										name = "Размер",
										type = "range",
										width = "full",
										order = 8,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0.01,
										max = 1.3,
										step = 0.01,
										isPercent = true,
										arg = {"U28", 7},
									},
									OverrideScale = {
										name = "Игнорировать масштаб",
										order = 8.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки масштаба.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U28", 10},
									},
									SetAlpha = {
										name = "Прозрачность",
										type = "range",
										width = "full",
										order = 9,
										get = GetUniqueValue,
										set = SetUniqueValue,
										min = 0,
										max = 1,
										step = 0.01,
										isPercent = true,
										arg = {"U28", 8},
									},
									OverrideAlpha = {
										name = "Игнорировать прозрачность",
										order = 9.25,
										type = "toggle",
										width = "full",
										desc = "Игнорировать уникальные настройки прозрачности.",
										get = GetUniqueValue,
										set = SetUniqueValue,
										arg = {"U28", 11},
									},
								},
							},
						},
					},
				},
			},
			ThreatOptFrame = {
				order = 5,
				type  = "group",
				name  = "Угроза",
				args = {
					ThreatDescription = {
						type = "description",
						order = 1,
						name = "Система определения угрозы",
					},
					threat = {
						order = 2,
						type = "toggle",
						width = "full",
						name = "Включить",
						desc = "Система определения угрозы позволяет изменять цвета и внешний вид полос здоровья в зависимости от текущего уровня угрозы.",
						get = function() return TidyPlatesThreat.db.profile.threat.ON end,
						set = function(info,val) 
							TidyPlatesThreat.db.profile.threat.ON = not TidyPlatesThreat.db.profile.threat.ON
							SetThreatOldSetting()
							if TidyPlatesThreat.db.profile.threat.ON and TidyPlatesThreat.db.profile.verbose then return print("-->>|cff00ff00Threat System is now ON!|r<<--") elseif TidyPlatesThreat.db.profile.verbose then return print("-->>|cffff0000Threat System is now OFF!|r<<--") end
							TidyPlates:ReloadTheme()
						end
					},
					RoleDescription = {
						type = "description",
						order = 3,
						name = "Выберите свою роль",
					},
					DPSRole = {
						order = 4,
						type = "toggle",
						width = "full",
						name = "ДПС",
						desc = "Включить или отключить систему угроз для дд или исцеления.",
						get = function() return not TidyPlatesThreat.db.char.threat.tanking end,
						set = function(info,val)
							if TidyPlatesThreat.db.profile.verbose then print("-->>|cff00ff00DPS Role threat system is now active!!|r<<--") end
							if GetActiveTalentGroup() == 1 then	
								TidyPlatesThreat.db.char.spec.primary = not TidyPlatesThreat.db.char.spec.primary
								if TidyPlatesThreat.db.profile.verbose then print("Your |cff89F559primary|r spec has been set to "..roleText()..".") end
							elseif GetActiveTalentGroup() == 2 then	
								TidyPlatesThreat.db.char.spec.secondary = not TidyPlatesThreat.db.char.spec.secondary
								if TidyPlatesThreat.db.profile.verbose then print("Your |cff89F559secondary|r spec has been set to "..roleText()..".") end
							end
							TidyPlatesThreat.db.char.threat.tanking = false
							TidyPlatesThreat.db.profile.threat.ON = true
							SetThreatOldSetting()
							TidyPlates:ReloadTheme()
						end
					},
					TankRole = {
						order = 5,
						type = "toggle",
						width = "full",
						name = "Танк",
						desc = "Включить или отключить систему угроз для танка.",
						get = function() return TidyPlatesThreat.db.char.threat.tanking end,
						set = function(info,val) 
							if TidyPlatesThreat.db.profile.verbose then print("-->>|cff00ff00Tank Role threat system is now active!!|r<<--") end
							if GetActiveTalentGroup() == 1 then	
								TidyPlatesThreat.db.char.spec.primary = not TidyPlatesThreat.db.char.spec.primary
								if TidyPlatesThreat.db.profile.verbose then print("Your |cff89F559primary|r spec has been set to "..roleText()..".") end
							elseif GetActiveTalentGroup() == 2 then	
								TidyPlatesThreat.db.char.spec.secondary = not TidyPlatesThreat.db.char.spec.secondary
								if TidyPlatesThreat.db.profile.verbose then print("Your |cff89F559secondary|r spec has been set to "..roleText()..".") end
							end
							TidyPlatesThreat.db.char.threat.tanking = true
							TidyPlatesThreat.db.profile.threat.ON = true
							SetThreatOldSetting()
							TidyPlates:ReloadTheme()
						end
					},
					header2 = {
						type = "header",
						name = "Масштаб и прозрачность",
						order = 6,
					},
					scaleOn = {
						type = "toggle",
						width = "full",
						order = 6.1,
						name = "Включить масштабирование",
						get = GetToggle,
						set = SetToggle,
						arg = {"threat","useScale","Nameplate scaling by threat"},
					},
					alphaOn = {
						type = "toggle",
						width = "full",
						order = 6.2,
						name = "Включить прозрачность",
						get = GetToggle,
						set = SetToggle,
						arg = {"threat","useAlpha","Nameplate alpha by threat"},
					},
					textures = {
						type = "select",
						width = "full",
						order = 6.3,
						name = 'Текстура',
						desc = 'Выберите текстуру',
						style = dropdown,
						values = ThemeList,
						get = function() return TidyPlatesThreat.db.profile.theme end,
						set = function(info,val)  
							TidyPlatesThreat.db.profile.theme = val
							TidyPlates:ReloadTheme()
							end,
					},
					AdditionalToggles = {
						order = 7,
						type = "header",
						name = "Дополнительно",
					},
					ColorHealth = {
						order = 7.05,
						type = "toggle",
						width = "full",
						name = "Цвет здоровья по угрозе",
						get = function() return TidyPlatesThreat.db.profile.threat.useHPColor end,
						set = function(info)
							TidyPlatesThreat.db.profile.threat.useHPColor = not TidyPlatesThreat.db.profile.threat.useHPColor
							if TidyPlatesThreat.db.profile.threat.useHPColor and TidyPlatesThreat.db.profile.verbose then 
								return print("-->>Coloring of health by threat is |cff00ff00ON!!|r<<--") 
							elseif TidyPlatesThreat.db.profile.verbose then 
								return print ("-->>Coloring of health by threat is |cffff0000OFF!!|r<<--") 
							end
						end
					},
					NonCombat = {
						order = 7.1,
						type = "toggle",
						width = "full",
						name = 'Игнорировать угрозу существ вне боя',
						get = function() return TidyPlatesThreat.db.profile.threat.nonCombat end,
						set = function(info)
							TidyPlatesThreat.db.profile.threat.nonCombat = not TidyPlatesThreat.db.profile.threat.nonCombat
							if TidyPlatesThreat.db.profile.threat.nonCombat and TidyPlatesThreat.db.profile.verbose then 
								return print("-->>Hiding of Non-Combat mob threat is |cff00ff00ON!!|r<<--") 
							elseif TidyPlatesThreat.db.profile.verbose then 
								return print ("-->>Hiding of Non-Combat mob threat is |cffff0000OFF!!|r<<--") 
							end
						end,
					},
					Neutral_Threat = {
						order = 8,
						type = "toggle",
						width = "full",
						name = "Показать угрозу у нейтральных",
						desc = "Включить или отключить систему угроз для нейтральных существ.",
						arg = "Neutral",
						get = GetThreatToggle,
						set = SetThreatToggle,
					},
					Normal_Threat = {
						order = 9,
						type = "toggle",
						width = "full",
						name = "Показать угрозу у обычных",
						desc = "Включить или отключить систему угроз для обычных существ.",
						arg = "Normal",
						get = GetThreatToggle,
						set = SetThreatToggle,
					},
					Elite_Threat = {
						order = 10,
						type = "toggle",
						width = "full",
						name = "Показать угрозу у элитных",
						desc = "Включить или отключить систему угроз для элитных существ.",
						arg = "Elite",
						get = GetThreatToggle,
						set = SetThreatToggle,
					},
					Boss_Threat = {
						order = 11,
						type = "toggle",
						width = "full",
						name = "Показать угрозу у боссов",
						desc = "Включить или отключить систему угроз для боссов.",
						arg = "Boss",
						get = GetThreatToggle,
						set = SetThreatToggle,
					},
					hideNonCombat = {
						order = 11.1,
						type = "toggle",
						width = "full",
						name = 'Скрывать существ вне боя',
						desc = "Когда вы в бою, эта опция скроет все полосы здоровья у существ вне боя. Требуется включенная опция <Игнорировать угрозу существ вне боя>",
						get = function() return TidyPlatesThreat.db.profile.threat.hideNonCombat end,
						set = function(info)
							TidyPlatesThreat.db.profile.threat.hideNonCombat = not TidyPlatesThreat.db.profile.threat.hideNonCombat
							if TidyPlatesThreat.db.profile.threat.hideNonCombat and TidyPlatesThreat.db.profile.verbose then 
								return print("-->>Hiding of Non-Combat mob nameplates is |cff00ff00ON!!|r<<--") 
							elseif TidyPlatesThreat.db.profile.verbose then 
								return print ("-->>Hiding of Non-Combat mob nameplates is |cffff0000OFF!!|r<<--") 
							end
						end,
					},
					UnitTypeScales = {
						order = 12,
						type = "header",
						name = " Настройка масштаба по типу существ",
					},
					useType = {
						order = 13,
						type = "toggle",
						width = "full",
						name = "Включить",
						get = function() return TidyPlatesThreat.db.profile.threat.useType end,
						set = function(info)
							TidyPlatesThreat.db.profile.threat.useType = not TidyPlatesThreat.db.profile.threat.useType
							if TidyPlatesThreat.db.profile.threat.useType then
								return print()
							else
								return print()
							end
							TidyPlates:ReloadTheme()
							TidyPlates:ForceUpdate()
						end,
					},
					NormalNeutral = {
						order = 14,
						type = "range",
						width = "full",
						name = 'Обычные и нейтральные',
						arg = {"scaleType", "Normal"},
						get = GetThreatType,
						set = SetThreatType,
						min = -0.5,
						max = 0.5,
						step = 0.01,
						isPercent = true,
					},
					Elite = {
						order = 15,
						type = "range",
						width = "full",
						name = 'Элитные',
						arg = {"scaleType", "Elite"},
						get = GetThreatType,
						set = SetThreatType,
						min = -0.5,
						max = 0.5,
						step = 0.01,
						isPercent = true,
					},
					Boss = {
						order = 16,
						type = "range",
						width = "full",
						name = 'Боссы',
						arg = {"scaleType", "Boss"},
						get = GetThreatType,
						set = SetThreatType,
						min = -0.5,
						max = 0.5,
						step = 0.01,
						isPercent = true,
					},
					TankedWidget = {
						name = "Виджет танка",
						type = 'group',
						desc = "Настроить параметры для танковского виджета.",
						order = 0.5,
						args = {
							widgetHeader = {
								type = "header",
								order = 1,
								name = "Настройка",
							},
							enable = {
								type = "toggle",
								width = "full",
								name = "Включить",
								order = 2,
								get = GetToggle,
								set = SetToggle,
								arg = {"tankedWidget","ON", "Tanked Widget"},
							},--[[
							style = {
								type = "select",
								width = "full",
								name = "Tanked Widget Style",
								order = 2.5,
								values = ThreatStyleList,
								get = function() return TidyPlatesThreat.db.profile.tankedWidget.style end,
								set = function(info, val)
									TidyPlatesThreat.db.profile.tankedWidget.style = val
									TidyPlates:ReloadTheme()
									TidyPlates:ForceUpdate()
								end
							},]]--
							widgetX = {
								type = "range",
								width = "full",
								name = "Смещение по оси X",
								order = 3,
								get = function() return TidyPlatesThreat.db.profile.tankedWidget.x end,
								set = function(info, val)
									TidyPlatesThreat.db.profile.tankedWidget.x = val
									TidyPlates:ForceUpdate()
									TidyPlates:ReloadTheme()
									end,
								min = -120,
								max = 120,
								step = 1,
								isPercent = false,
							},
							widgetY = {
								type = "range",
								width = "full",
								name = "Смещение по оси Y",
								order = 3,
								get = function() return TidyPlatesThreat.db.profile.tankedWidget.y end,
								set = function(info, val)
									TidyPlatesThreat.db.profile.tankedWidget.y = val
									TidyPlates:ForceUpdate()
									TidyPlates:ReloadTheme()
									end,
								min = -120,
								max = 120,
								step = 1,
								isPercent = false,
							},
						},
					},
					threatWidget = {
						name = "Виджет угрозы",
						type = 'group',
						desc = "Настроить параметры виджета угрозы для указателя мыши.",
						order = 0.6,
						args = {
							widgetHeader = {
								type = "header",
								order = 1,
								name = "Настройка",
							},
							enable = {
								type = "toggle",
								width = "full",
								name = "Включить",
								order = 2,
								get = GetToggle,
								set = SetToggle,
								arg = {"threatWidget","ON", "Threat Widget"},
							},--[[
							style = {
								type = "select",
								width = "full",
								name = "Threat Widget Style",
								order = 2.5,
								values = ThreatStyleList,
								get = function() return TidyPlatesThreat.db.profile.threatWidget.style end,
								set = function(info, val)
									TidyPlatesThreat.db.profile.threatWidget.style = val
									TidyPlates:ReloadTheme()
									TidyPlates:ForceUpdate()
								end
							},]]--
							widgetX = {
								type = "range",
								width = "full",
								name = "Смещение по оси X",
								order = 3,
								get = function() return TidyPlatesThreat.db.profile.threatWidget.x end,
								set = function(info, val)
									TidyPlatesThreat.db.profile.threatWidget.x = val
									TidyPlates:ForceUpdate()
									TidyPlates:ReloadTheme()
									end,
								min = -120,
								max = 120,
								step = 1,
								isPercent = false,
							},
							widgetY = {
								type = "range",
								width = "full",
								name = "Смещение по оси Y",
								order = 3,
								get = function() return TidyPlatesThreat.db.profile.threatWidget.y end,
								set = function(info, val)
									TidyPlatesThreat.db.profile.threatWidget.y = val
									TidyPlates:ForceUpdate()
									TidyPlates:ReloadTheme()
									end,
								min = -120,
								max = 120,
								step = 1,
								isPercent = false,
							},
						},
					},
					DPS = {
						name = "|cffffffffЦвет полос для дд|r",
						type = "group",
						desc = "Установите ползунки угроз и прозрачности для дд",
						order = 1,
						args = {
							scaleheader = {
								type = "header",
								order = 1,
								name = "Масштаб",
							},
							lowthreat = {
								type = "range",
								width = "full",
								order = 2,
								name = "|cff00ff00Низкая угроза|r",
								arg = {"dps", "scale", "LOW"},
								get = GetThreatValue,
								set = SetThreatValue,
								step = 0.05,
								min = 0.3,
								max = 2,
								isPercent = true,
							},
							medthreat = {
								type = "range",
								width = "full",
								order = 3,
								name = "|cffffff00Средняя угроза|r",
								arg = {"dps", "scale", "MEDIUM"},
								get = GetThreatValue,
								set = SetThreatValue,
								step = 0.05,
								min = 0.3,
								max = 2,
								isPercent = true,
							},
							highthreat = {
								type = "range",
								width = "full",
								order = 4,
								name = "|cffff0000Высокая угроза|r",
								arg = {"dps", "scale", "HIGH"},
								get = GetThreatValue,
								set = SetThreatValue,
								step = 0.05,
								min = 0.3,
								max = 2,
								isPercent = true,
							},
							alphaheader = {
								type = "header",
								order = 5,
								name = "Прозрачность",
							},
							alphalow = {
								type = "range",
								width = "full",
								order = 7,
								name = "|cff00ff00Низкая угроза|r",
								arg = {"dps", "alpha", "LOW"},
								get = GetThreatValue,
								set = SetThreatValue,
								step = 0.05,
								min = 0,
								max = 1,
								isPercent = true,
							},
							alphaMed = {
								type = "range",
								width = "full",
								order = 8,
								name = "|cffffff00Средняя угроза|r",
								arg = {"dps", "alpha", "MEDIUM"},
								get = GetThreatValue,
								set = SetThreatValue,
								step = 0.05,
								min = 0,
								max = 1,
								isPercent = true,
							},
							alphahigh = {
								type = "range",
								width = "full",
								order = 9,
								name = "|cffff0000Высокая угроза|r",
								arg = {"dps", "alpha", "HIGH"},
								get = GetThreatValue,
								set = SetThreatValue,
								step = 0.05,
								min = 0,
								max = 1,
								isPercent = true,
							},
							colorheader = {
								type = 'header',
								order = 10,
								name = 'Свой цвет'
							},
							LowThreat = {
								type = 'color',
								order = 11,
								name = "Низкая угроза",
								get = GetThreatColor,
								set = SetThreatColor,
								arg = {"threatcolor", "LOW", "dps"},
								hasAlpha = true,
							},
							MediumThreat = {
								type = 'color',
								order = 12,
								name = "Средняя угроза",
								get = GetThreatColor,
								set = SetThreatColor,
								arg = {"threatcolor", "MEDIUM", "dps"},
								hasAlpha = true,
							},
							HighThreat = {
								type = 'color',
								order = 13,
								name = "Высокая угроза",
								get = GetThreatColor,
								set = SetThreatColor,
								arg = {"threatcolor", "HIGH", "dps"},
								hasAlpha = true,
							},
						},
					},
					Tank = {
						name = "|cffffffffЦвет полос для танка|r",
						type = "group",
						desc = "Установите ползунки угроз и прозрачности для танка",
						order = 2,
						args = {
							tankdesc = {
								type = "header",
								order = 1,
								name = "Масштаб",
							},
							lowthreat = {
								type = "range",
								width = "full",
								order = 2,
								name = "|cffff0000Низкая угроза|r",
								arg = {"tank", "scale", "LOW"},
								get = GetThreatValue,
								set = SetThreatValue,
								step = 0.05,
								min = 0.3,
								max = 2,
								isPercent = true,
							},
							medthreat = {
								type = "range",
								width = "full",
								order = 3,
								name = "|cffffff00Средняя угроза|r",
								arg = {"tank", "scale", "MEDIUM"},
								get = GetThreatValue,
								set = SetThreatValue,
								step = 0.05,
								min = 0.3,
								max = 2,
								isPercent = true,
							},
							highthreat = {
								type = "range",
								width = "full",
								order = 4,
								name = "|cff00ff00Высокая угроза|r",
								arg = {"tank", "scale", "HIGH"},
								get = GetThreatValue,
								set = SetThreatValue,
								step = 0.05,
								min = 0.3,
								max = 2,
								isPercent = true,
							},
							alphaheader = {
								type = "header",
								order = 5,
								name = "Прозрачность",
							},
							alphalow = {
								type = "range",
								width = "full",
								order = 7,
								name = "|cffff0000Низкая угроза|r",
								arg = {"tank", "alpha", "LOW"},
								get = GetThreatValue,
								set = SetThreatValue,
								step = 0.05,
								min = 0,
								max = 1,
								isPercent = true,
							},
							alphaMed = {
								type = "range",
								width = "full",
								order = 8,
								name = "|cffffff00Средняя угроза|r",
								arg = {"tank", "alpha", "MEDIUM"},
								get = GetThreatValue,
								set = SetThreatValue,
								step = 0.05,
								min = 0,
								max = 1,
								isPercent = true,
							},
							alphahigh = {
								type = "range",
								width = "full",
								order = 9,
								name = "|cff00ff00Высокая угроза|r",
								arg = {"tank", "alpha", "HIGH"},
								get = GetThreatValue,
								set = SetThreatValue,
								step = 0.05,
								min = 0,
								max = 1,
								isPercent = true,
							},
							colorheader = {
								type = 'header',
								order = 10,
								name = 'Свой цвет'
							},
							LowThreat = {
								type = 'color',
								order = 11,
								name = "Низкая угроза",
								get = GetThreatColor,
								set = SetThreatColor,
								arg = {"threatcolor", "LOW", "tank"},
								hasAlpha = true,
							},
							MediumThreat = {
								type = 'color',
								order = 12,
								name = "Средняя угроза",
								get = GetThreatColor,
								set = SetThreatColor,
								arg = {"threatcolor", "MEDIUM", "tank"},
								hasAlpha = true,
							},
							HighThreat = {
								type = 'color',
								order = 13,
								name = "Высокая угроза",
								get = GetThreatColor,
								set = SetThreatColor,
								arg = {"threatcolor", "HIGH", "tank"},
								hasAlpha = true,
							},
						},
					},
					Marked = {
						name = "|cffffffffОтмеченные существа|r",
						type = "group",
						desc = "Переопределить настройки угроз для текстур, масштаба и прозрачности отмеченных существ (рейд метки).",
						order = 3,
						args = {
							header1 = {
								order = 1,
								type = "header",
								name = "Настройка"
							},
							descript1 = {
								order = 2,
								type = "description",
								name = "Игнорирование отмеченных существ."
							},
							art = {
								order = 3,
								name = "Отключить текстуры",
								type = "toggle",
								width = "full",
								desc = "Отключает настройки для текстур.",
								get = function() return TidyPlatesThreat.db.profile.threat.marked.art end,
								set = function(info,val) 
									TidyPlatesThreat.db.profile.threat.marked.art = not TidyPlatesThreat.db.profile.threat.marked.art
									if TidyPlatesThreat.db.profile.threat.marked.art and TidyPlatesThreat.db.profile.verbose then 
										return print("-->>Ignoring of marked unit threat textures is now |cff00ff00ON!|r<<--") 
									elseif TidyPlatesThreat.db.profile.verbose then 
										return print("-->>Ignoring of marked unit threat textures is now |cffff0000OFF!|r<<--") 
									end
									TidyPlates:ReloadTheme()
								end
							},
							alpha = {
								order = 4,
								name = "Переопределить прозрачность",
								type = "toggle",
								width = "full",
								desc = "Отключает настройки для прозрачности.",
								get = function() return TidyPlatesThreat.db.profile.threat.marked.alpha end,
								set = function(info,val) 
									TidyPlatesThreat.db.profile.threat.marked.alpha = not TidyPlatesThreat.db.profile.threat.marked.alpha
									if TidyPlatesThreat.db.profile.threat.marked.alpha and TidyPlatesThreat.db.profile.verbose then 
										return print("-->>Ignoring of marked unit threat alpha is now |cff00ff00ON!|r<<--") 
									elseif TidyPlatesThreat.db.profile.verbose then 
										return print("-->>Ignoring of marked unit threat alpha is now |cffff0000OFF!|r<<--") 
									end
									TidyPlates:ReloadTheme()
								end
							},
							scale = {
								order = 4,
								name = "Переопределить масштаб",
								type = "toggle",
								width = "full",
								desc = "Отключает настройки для масштаба.",
								get = function() return TidyPlatesThreat.db.profile.threat.marked.scale end,
								set = function(info,val) 
									TidyPlatesThreat.db.profile.threat.marked.scale = not TidyPlatesThreat.db.profile.threat.marked.scale
									if TidyPlatesThreat.db.profile.threat.marked.scale and TidyPlatesThreat.db.profile.verbose then 
										return print("-->>Ignoring of marked unit threat scale is now |cff00ff00ON!|r<<--") 
									elseif TidyPlatesThreat.db.profile.verbose then 
										return print("-->>Ignoring of marked unit threat scale is now |cffff0000OFF!|r<<--") 
									end
									TidyPlates:ReloadTheme()
								end
							},
							header2 = {
								order = 5,
								name = "Масштаб и прозрачность заменятся на эти параметры",
								type = 'header',
							},
							Marked_Scale = {
								type = "range",
								width = "full",
								order = 6,
								name = "Масштаб",
								arg = "Marked",
								get = GetNameplateScale,
								set	= SetNameplateScale,
								step = 0.05,
								min = 0.3,
								max = 2,
								isPercent = true,
							},
							Marked_Alpha = {
								type = "range",
								width = "full",
								order = 7,
								name = "Прозрачность",
								arg = "Marked",
								get = GetNameplateAlpha,
								set	= SetNameplateAlpha,
								step = 0.05,
								min = 0,
								max = 1,
								isPercent = true,
							},
						},
					},
					SpecSetting = {
						name = "|cffffffffВетки талантов|r",
						type = "group",
						desc = "Установите роль для каждого набора талантов.",
						order = 4,
						args = {
							header = {
								order = 1,
								name = "Настройка",
								type = "header"
							},
							description = {
								order = 2,
								name = "Выберите роль для каждой специализации.",
								type = "description"
							},
							primary = {
								order = 3,
								name = "Первый набор талантов",
								type = "header"
							},
							primaryTank = {
								order = 4,
								name = "Танк",
								type = "toggle",
								width = "full",
								get = function() return TidyPlatesThreat.db.char.spec.primary end,
								set = function(info,val) 
									TidyPlatesThreat.db.char.spec.primary = true
									if GetActiveTalentGroup() == 1 then
										TidyPlatesThreat.db.char.threat.tanking = true
									end
									
									TidyPlates:ReloadTheme()
								end
							},
							primaryDPS = {
								order = 5,
								name = "ДПС",
								type = "toggle",
								width = "full",
								get = function() return not TidyPlatesThreat.db.char.spec.primary end,
								set = function(info,val) 
									TidyPlatesThreat.db.char.spec.primary = false
									if GetActiveTalentGroup() == 1 then
										TidyPlatesThreat.db.char.threat.tanking = false
									end
									
									TidyPlates:ReloadTheme()
								end
							},
							secondary = {
								order = 6,
								name = "Второй набор талантов",
								type = "header"
							},
							secondaryTank = {
								order = 7,
								name = "Танк",
								type = "toggle",
								width = "full",
								get = function() return TidyPlatesThreat.db.char.spec.secondary end,
								set = function(info,val) 
									TidyPlatesThreat.db.char.spec.secondary = true
									if GetActiveTalentGroup() == 2 then
										TidyPlatesThreat.db.char.threat.tanking = true
									end
									
									TidyPlates:ReloadTheme()
								end
							},
							secondaryDPS = {
								order = 8,
								name = "ДПС",
								type = "toggle",
								width = "full",
								get = function() return not TidyPlatesThreat.db.char.spec.secondary end,
								set = function(info,val) 
									TidyPlatesThreat.db.char.spec.secondary = false
									if GetActiveTalentGroup() == 2 then
										TidyPlatesThreat.db.char.threat.tanking = false
									end
									
									TidyPlates:ReloadTheme()
								end
							},
							secondary2 = {
								order = 9,
								name = "Третий набор талантов",
								type = "header"
							},
							secondary2Tank = {
								order = 10,
								name = "Танк",
								type = "toggle",
								width = "full",
								get = function() return TidyPlatesThreat.db.char.spec.secondary2 end,
								set = function(info,val) 
									TidyPlatesThreat.db.char.spec.secondary2 = true
									if GetActiveTalentGroup() == 3 then
										TidyPlatesThreat.db.char.threat.tanking = true
									end
									
									TidyPlates:ReloadTheme()
								end
							},
							secondary2DPS = {
								order = 11,
								name = "ДПС",
								type = "toggle",
								width = "full",
								get = function() return not TidyPlatesThreat.db.char.spec.secondary2 end,
								set = function(info,val) 
									TidyPlatesThreat.db.char.spec.secondary2 = false
									if GetActiveTalentGroup() == 3 then
										TidyPlatesThreat.db.char.threat.tanking = false
									end
									
									TidyPlates:ReloadTheme()
								end
							},
						},
					},
				},
			},
			About = {
				order = 6,
				type  = "group",
				name  = "Об аддоне",
				args = {
					About = {
						type = "description",
						order = 1,
						name = "Модуль работает только в связке с TidyPlates.",
					},
				},
			},
		},
	}
	
function TidyPlatesThreat:RegisterOptions()
	local profile = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
	local registry = LibStub('AceConfigRegistry-3.0')
	local dialog = LibStub('AceConfigDialog-3.0')

	registry:RegisterOptionsTable("Tidy Plates: Threat Plates", options)
	registry:RegisterOptionsTable("Profiles",  profile)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Tidy Plates: Threat Plates", "Tidy Plates: Threat Plates")
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Profiles", 'Профили', "Tidy Plates: Threat Plates")
	
	self:RegisterChatCommand("tptp", function () InterfaceOptionsFrame_OpenToCategory(self.optionsFrame) end)
end
