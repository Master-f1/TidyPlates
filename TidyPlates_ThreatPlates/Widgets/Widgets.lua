-- Set Global Table
if not ThreatPlatesWidgets then ThreatPlatesWidgets = {} end
local Media = LibStub("LibSharedMedia-3.0")

-- Name Text
local function CreateNameText(frame)
	--print("Name Text Created")
	local db = TidyPlatesThreat.db.profile.settings
	local text = frame:CreateFontString(nil, 'OVERLAY', 'GameFontNormalLarge')
	text:SetText(nil)
	text:SetJustifyH(db.name.align)
	text:SetJustifyV(db.name.vertical)
	text:SetTextColor(1, 1, 1, 1)
	text:SetWidth(db.name.width)
	text:SetHeight(db.name.height)
	text:SetFont(Media:Fetch('font', db.name.typeface), db.name.size, db.name.flags)
	text:SetPoint("CENTER",frame,"CENTER", db.name.x, db.name.y)
	text:SetShadowOffset(1, -1)
	if db.name.shadow then text:SetShadowColor(0,0,0,1)
	else text:SetShadowColor(0,0,0,0) end
	return text
end

--DebuffFilterFunction
local function DebuffFilter(debuff)
	local db = TidyPlatesThreat.db.profile.debuffWidget
	local spells = db.filter
	if db.mode == "whitelist" then
		if tContains(spells, (debuff.name)) then 
			return true 
		end
	elseif db.mode == "blacklist" then
		if tContains(spells, (debuff.name)) then
			return false
		else
			return true
		end
	elseif db.mode == "all" then
		return true
	end
end


local function OnInitialize(plate)
	if not plate.widgets.WidgetDebuff then
		plate.widgets.WidgetDebuff = TidyPlatesWidgets.CreateAuraWidget(plate)
		plate.widgets.WidgetDebuff:SetPoint("CENTER", plate, TidyPlatesThreat.db.profile.debuffWidget.x, TidyPlatesThreat.db.profile.debuffWidget.y)
		plate.widgets.WidgetDebuff:SetFrameLevel(plate:GetFrameLevel())
		plate.widgets.WidgetDebuff.Filter = DebuffFilter
	end
	if not plate.widgets.TankedWidget then
		plate.widgets.TankedWidget = TidyPlatesWidgets.CreateTankedWidget(plate)		
		plate.widgets.TankedWidget:SetPoint("CENTER", plate, TidyPlatesThreat.db.profile.tankedWidget.x, TidyPlatesThreat.db.profile.tankedWidget.y)
	end
end

local function ThreatPlatesExtensions(plate, unit)
	local db = TidyPlatesThreat.db.profile.settings
	-- Target Art
	if not plate.widgets.TargetArt then plate.widgets.TargetArt = ThreatPlatesWidgets.CreateTargetFrameArt(plate) end
	plate.widgets.TargetArt:SetFrameLevel(TidyPlatesThreat.db.profile.targetWidget.level)
	plate.widgets.TargetArt:Update(unit)
	plate.widgets.TargetArt:SetPoint("CENTER", plate, 0, 0)
	-- Elite Texture
	if not plate.widgets.EliteArt then plate.widgets.EliteArt = ThreatPlatesWidgets.CreateEliteFrameArt(plate) end
	plate.widgets.EliteArt:SetFrameLevel(TidyPlatesThreat.db.profile.eliteWidget.level)
	plate.widgets.EliteArt:SetHeight(TidyPlatesThreat.db.profile.eliteWidget.scale)
	plate.widgets.EliteArt:SetWidth(TidyPlatesThreat.db.profile.eliteWidget.scale)
	plate.widgets.EliteArt:SetPoint("CENTER",plate,(TidyPlatesThreat.db.profile.eliteWidget.anchor), (TidyPlatesThreat.db.profile.eliteWidget.x), (TidyPlatesThreat.db.profile.eliteWidget.y))
	plate.widgets.EliteArt:Update(unit)
	-- Name Text
	if db.options.showName then
		if not plate.widgets.NameText then plate.widgets.NameText = CreateNameText(plate) end
		local c = db.name.color
		plate.widgets.NameText:SetText(unit.name)
		plate.widgets.NameText:SetFont((Media:Fetch('font', db.name.typeface)), db.name.size, db.name.flags)
		plate.widgets.NameText:SetPoint("CENTER", plate, "CENTER", db.name.x, db.name.y)
		plate.widgets.NameText:SetJustifyH(db.name.align)
		plate.widgets.NameText:SetJustifyV(db.name.vertical)
		plate.widgets.NameText:SetWidth(db.name.width)
		plate.widgets.NameText:SetHeight(db.name.height)
		plate.widgets.NameText:SetTextColor(c.r, c.g, c.b)
		plate.widgets.NameText:SetShadowOffset(1, -1)
		if db.name.shadow then 
			plate.widgets.NameText:SetShadowColor(0,0,0,1)
		else 
			plate.widgets.NameText:SetShadowColor(0,0,0,0) 
		end	
	else
	end
	if TidyPlatesThreat.db.profile.debuffWidget.ON then
		if not plate.widgets.WidgetDebuff then plate.widgets.WidgetDebuff = TidyPlatesWidgets.CreateAuraWidget(plate) end
		plate.widgets.WidgetDebuff:SetPoint("CENTER", plate, TidyPlatesThreat.db.profile.debuffWidget.x, TidyPlatesThreat.db.profile.debuffWidget.y)
		plate.widgets.WidgetDebuff:Update(unit)
	end	
	-- Class Icons
	if not plate.widgets.ClassIconWidget then plate.widgets.ClassIconWidget = ThreatPlatesWidgets.CreateClassIconWidget(plate) end
		plate.widgets.ClassIconWidget:Update(unit)
		plate.widgets.ClassIconWidget:SetHeight(TidyPlatesThreat.db.profile.classWidget.scale)
		plate.widgets.ClassIconWidget:SetWidth(TidyPlatesThreat.db.profile.classWidget.scale)		
		plate.widgets.ClassIconWidget:SetPoint((TidyPlatesThreat.db.profile.classWidget.anchor), plate, (TidyPlatesThreat.db.profile.classWidget.x), (TidyPlatesThreat.db.profile.classWidget.y))
	-- Totem Icons
	if not plate.widgets.TotemIconWidget then plate.widgets.TotemIconWidget = ThreatPlatesWidgets.CreateTotemIconWidget(plate) end
		plate.widgets.TotemIconWidget:Update(unit)
		plate.widgets.TotemIconWidget:SetHeight(TidyPlatesThreat.db.profile.totemWidget.scale)
		plate.widgets.TotemIconWidget:SetWidth(TidyPlatesThreat.db.profile.totemWidget.scale)
		plate.widgets.TotemIconWidget:SetFrameLevel(TidyPlatesThreat.db.profile.totemWidget.level)
		plate.widgets.TotemIconWidget:SetPoint(TidyPlatesThreat.db.profile.totemWidget.anchor, plate, (TidyPlatesThreat.db.profile.totemWidget.x), (TidyPlatesThreat.db.profile.totemWidget.y))
	-- Unique Icons
	if not plate.widgets.UniqueIconWidget then plate.widgets.UniqueIconWidget = ThreatPlatesWidgets.CreateUniqueIconWidget(plate) end
		plate.widgets.UniqueIconWidget:Update(unit)
		plate.widgets.UniqueIconWidget:SetHeight(TidyPlatesThreat.db.profile.uniqueWidget.scale)
		plate.widgets.UniqueIconWidget:SetWidth(TidyPlatesThreat.db.profile.uniqueWidget.scale)
		plate.widgets.UniqueIconWidget:SetFrameLevel(TidyPlatesThreat.db.profile.uniqueWidget.level)
		plate.widgets.UniqueIconWidget:SetPoint(TidyPlatesThreat.db.profile.uniqueWidget.anchor, plate, (TidyPlatesThreat.db.profile.uniqueWidget.x), (TidyPlatesThreat.db.profile.uniqueWidget.y))
	-- Threat Widget
	if TidyPlatesThreat.db.profile.threat.ON then 
		if not plate.widgets.threatWidget then plate.widgets.threatWidget = ThreatPlatesWidgets.CreateThreatWidget(plate) end
		plate.widgets.threatWidget:Update(unit)
		plate.widgets.threatWidget:SetPoint("CENTER", plate, 0, 0)
	end
	--Threat Line Widget
	if TidyPlatesThreat.db.profile.threatWidget.ON and unit.class == "UNKNOWN" then
		if not plate.widgets.ThreatLineWidget then plate.widgets.ThreatLineWidget = TidyPlatesWidgets.CreateThreatLineWidget(plate) end
		plate.widgets.ThreatLineWidget:Update(unit)
		plate.widgets.ThreatLineWidget:SetPoint("CENTER", plate, (TidyPlatesThreat.db.profile.threatWidget.x), TidyPlatesThreat.db.profile.threatWidget.y)
	end
	-- Tanked Widget
	if TidyPlatesThreat.db.profile.tankedWidget.ON and TidyPlatesThreat.db.char.threat.tanking and InCombatLockdown() then
		plate.widgets.TankedWidget:SetPoint("CENTER", plate, TidyPlatesThreat.db.profile.tankedWidget.x, TidyPlatesThreat.db.profile.tankedWidget.y)
		plate.widgets.TankedWidget:Update(unit)
	end
	-- Combo Points
	if not plate.widgets.ComboPoints then plate.widgets.ComboPoints = ThreatPlatesWidgets.CreateComboPointWidget(plate) end
	plate.widgets.ComboPoints:Update(unit)
	plate.widgets.ComboPoints:SetPoint("CENTER", plate, (TidyPlatesThreat.db.profile.comboWidget.x), TidyPlatesThreat.db.profile.comboWidget.y)
end

local setExtended = CreateFrame("Frame")
local themeEvent = {}

function themeEvent:ADDON_LOADED()
	if arg1 == "TidyPlates_ThreatPlates" then
		TidyPlatesThemeList["Threat Plates"].OnInitialize = OnInitialize
		TidyPlatesThemeList["Threat Plates"].OnUpdate = ThreatPlatesExtensions
	end
end

setExtended:SetScript("OnEvent", function(self, event) themeEvent[event]() end)
setExtended:RegisterEvent("ADDON_LOADED")