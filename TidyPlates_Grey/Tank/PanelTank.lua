local theme = TidyPlatesThemeList["Grey/Tank"]
TidyPlatesGreyTankSavedVariables = {}

---------------
-- Helpers
---------------
local copytable = TidyPlatesUtility.copyTable
local updatetable = TidyPlatesUtility.updateTable
local PanelHelpers = TidyPlatesUtility.PanelHelpers

local function CreateBasePanel( Name, Title )  
	local panel = PanelHelpers:CreatePanelFrame( Name.."_InterfaceOptionsPanel", Title )
	panel:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", insets = { left = 2, right = 2, top = 2, bottom = 2 },})
	panel:SetBackdropColor(0.05, 0.05, 0.05, .7)

	
	panel.TankModeButton = CreateFrame("Button", Name.."_TankModeButton", panel, "UIPanelButtonTemplate2")
	panel.TankModeButton:SetPoint("TOPLEFT", 16, -52)
	panel.TankModeButton:SetText("Настроить режим танка")
	panel.TankModeButton:SetWidth(280)
	panel.TankModeButton:SetScript("OnClick", function() InterfaceOptionsFrame_OpenToCategory("Grey/Tank") end)
	
	panel.DPSModeButton = CreateFrame("Button", Name.."_DPSModeButton", panel, "UIPanelButtonTemplate2")
	panel.DPSModeButton:SetPoint("TOPLEFT", panel.TankModeButton, "BOTTOMLEFT", 0, -16 )
	panel.DPSModeButton:SetText("Настроить режим дпс")
	panel.DPSModeButton:SetWidth(280)
	panel.DPSModeButton:SetScript("OnClick", function() InterfaceOptionsFrame_OpenToCategory("Grey/DPS") end)

	return panel
end

local BasePanel = CreateBasePanel( "TidyPlatesGrey", "Tidy Plates: Grey", nil ) 

------------------------------------------------------------------
-- Interface Options Panel
------------------------------------------------------------------
local TextModes = { { text = "Нет", notCheckable = 1 },
					{ text = "Процент", notCheckable = 1 } ,
					{ text = "Текст", notCheckable = 1 } ,
					{ text = "Нанесённый урон", notCheckable = 1 } ,
					{ text = "Текст и проценты", notCheckable = 1 } ,
					{ text = "Плюс и минус", notCheckable = 1 } ,
					}
-------------------
-- Main Panel
-------------------
local panel = PanelHelpers:CreatePanelFrame( "TidyPlatesGreyTank_InterfaceOptionsPanel", "Танк" )
--panel.parent = "Tidy Plates"
panel.parent = "Tidy Plates: Grey"
panel:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", insets = { left = 2, right = 2, top = 2, bottom = 2 },})
panel:SetBackdropColor(0.05, 0.05, 0.05, .7)

local column1, column2 = -90, -100
-------------------
-- Opacity
-------------------
-- Non-Targets Opacity Slider
panel.OpacityNonTarget = PanelHelpers:CreateSliderFrame("TidyPlatesGreyTank_OpacityNonTargets", panel, "Нет цели:", .5, 0, 1, .1)
panel.OpacityNonTarget:SetPoint("CENTER", -37+column1, 133)
-- Hide Neutral Units Checkbox
panel.OpacityHideNeutral = PanelHelpers:CreateCheckButton("TidyPlatesGreyTank_OpacityHideNeutral", panel, "Скрыть нейтральных")
panel.OpacityHideNeutral:SetPoint("CENTER", -81+column1, 95)
-- Hide Non-Elites Checkbox
panel.OpacityHideNonElites = PanelHelpers:CreateCheckButton("TidyPlatesGreyTank_OpacityHideNonElites", panel, "Скрыть не элитных")
panel.OpacityHideNonElites:SetPoint("CENTER", -81+column1, 71)
-------------------
-- Scale
-------------------
-- General Scale
local adjustGeneral = 25
panel.ScaleGeneral = PanelHelpers:CreateSliderFrame("TidyPlatesGreyTank_ScaleGeneral", panel, "Общий масштаб:", 1, .5, 2, .1)
panel.ScaleGeneral:SetPoint("CENTER", -35+column1, 34-adjustGeneral)
-- Loose Units Scale
panel.ScaleLoose = PanelHelpers:CreateSliderFrame("TidyPlatesGreyTank_ScaleLoose", panel, "Масштаб при потери угрозы:", 1.5, 1, 2, .1)
panel.ScaleLoose:SetPoint("CENTER", -35+column1, -24-adjustGeneral)
-- Hide Non-Elites Checkbox
panel.ScaleIgnoreNonElite = PanelHelpers:CreateCheckButton("TidyPlatesGreyTank_ScaleIgnoreNonElite", panel, "Игнорировать не элитных")
panel.ScaleIgnoreNonElite:SetPoint("CENTER", -81+column1, -62-adjustGeneral)
-------------------
-- Threat Widget
-------------------
local widgetx, widgety = 175, 80
-- Description
panel.WidgetDesc = PanelHelpers:CreateDescriptionFrame("TidyPlatesGreyTank_WidgetDesc", panel, "Виджеты:", "")
panel.WidgetDesc:SetPoint("CENTER", -11+column1+widgetx+22, -136+widgety+62)
-- Selection Box
panel.WidgetSelect = PanelHelpers:CreateCheckButton("TidyPlatesGreyTank_WidgetSelect", panel, "Выбор коробки")
panel.WidgetSelect:SetPoint("CENTER", -74+column1+widgetx, -99+widgety)
-- Tug-o'-Threat
panel.WidgetTug = PanelHelpers:CreateCheckButton("TidyPlatesGreyTank_WidgetTug", panel, "Оправдание")
panel.WidgetTug:SetPoint("CENTER", -74+column1+widgetx, -123+widgety)
-- Threat Wheel/Spinner
panel.WidgetWheel = PanelHelpers:CreateCheckButton("TidyPlatesGreyTank_WidgetWheel", panel, "Колесо угрозы")
panel.WidgetWheel:SetPoint("CENTER", -74+column1+widgetx, -147+widgety)
-- Tanked Icon
panel.WidgetTanked = PanelHelpers:CreateCheckButton("TidyPlatesGreyTank_WidgetTanked", panel, "Танк значок")
panel.WidgetTanked:SetPoint("CENTER", -74+column1+widgetx, -171+widgety)
-- Debuffs
panel.WidgetDebuff = PanelHelpers:CreateCheckButton("TidyPlatesGreyTank_WidgetDebuff", panel, "Короткие дебаффы")
panel.WidgetDebuff:SetPoint("CENTER", -74+column1+widgetx, -195+widgety)
-- Level
panel.LevelText = PanelHelpers:CreateCheckButton("TidyPlatesGreyTank_LevelText", panel, "Уровень")
panel.LevelText:SetPoint("CENTER", -74+column1+widgetx, -195-24+widgety)

-------------------
-- Aggro
-------------------
panel.AggroDesc = PanelHelpers:CreateDescriptionFrame("TidyPlatesGreyTank_AggroDesc", panel, "Индикатор угрозы:", "")
panel.AggroDesc:SetPoint("CENTER", 170+column2+26, 92+58)
-- Health Bar
panel.AggroHealth = PanelHelpers:CreateCheckButton("TidyPlatesGreyTank_AggroHealth", panel, "Цвет полосы здоровья")
panel.AggroHealth:SetPoint("CENTER", 112+column2, 126)
-- Border
panel.AggroBorder = PanelHelpers:CreateCheckButton("TTidyPlatesGreyTank_AggroBorder", panel, "Свечение")
panel.AggroBorder:SetPoint("CENTER", 112+column2, 102)
-- Loose Units
panel.AggroLooseColor = PanelHelpers:CreateColorBox("TidyPlatesGreyTank_AggroLooseColor", panel, "Потеря", 0, .5, 1, 1)
panel.AggroLooseColor:SetPoint("CENTER", 137+column2, 71)
-- Tanked Units
panel.AggroTankedColor = PanelHelpers:CreateColorBox("TidyPlatesGreyTank_AggroTanked", panel, "Цвет танков", 0, .5, 1, 1)
panel.AggroTankedColor:SetPoint("CENTER", 137+column2, 44)
-------------------
-- Health Text
-------------------
panel.HealthText = PanelHelpers:CreateDropdownFrame("TidyPlatesGreyTank_HealthText", panel, TextModes, 1, "Текст полос хп:")
panel.HealthText:SetPoint("CENTER", -87+column1, -160)
-------------------
-- Apply Button
-------------------
panel.apply = CreateFrame("Button", "TidyPlatesGreyTank_ApplyButton", panel, "UIPanelButtonTemplate2")
panel.apply:SetPoint("BOTTOMRIGHT", panel, -15, 15)
panel.apply:SetText("Применить")
panel.apply:SetWidth(80)

local function UpdateAggroColors()
	theme.options.showAggroGlow = TidyPlatesGreyTankVariables.AggroBorder
	theme.threatcolor.LOW = TidyPlatesGreyTankVariables.AggroLooseColor
	theme.threatcolor.MEDIUM = TidyPlatesGreyTankVariables.AggroLooseColor
	theme.threatcolor.HIGH = TidyPlatesGreyTankVariables.AggroTankedColor
	theme.options.showLevel = TidyPlatesGreyTankVariables.LevelText
	if theme.options.showLevel then theme.name = { width = 88, }
	else theme.name = { width = 100, } end
	-- Force Style Update
	TidyPlates:ReloadTheme()
end

local function GetPanelValues()
	local index, value
	for index, value in pairs(TidyPlatesGreyTankVariables) do
		TidyPlatesGreyTankVariables[index] = panel[index]:GetValue()
		TidyPlatesGreyTankSavedVariables[index] = TidyPlatesGreyTankVariables[index]
	end
end

local function SetPanelValues()
	local index, value
	for index, value in pairs(TidyPlatesGreyTankVariables) do
		panel[index]:SetValue(TidyPlatesGreyTankVariables[index])
	end
end

local function GetSavedVariables()
	local index, value
	TidyPlatesGreyTankVariables = updatetable(TidyPlatesGreyTankVariables, TidyPlatesGreyTankSavedVariables)
end

-- Update Variables
panel.okay = function ()
	GetPanelValues()
	TidyPlates:ForceUpdate()
	UpdateAggroColors()
end

panel.apply:SetScript("OnClick",panel.okay)
panel.refresh = SetPanelValues

-- Login
panel:SetScript("OnEvent", function(self, event, ...) 
	if event == "PLAYER_LOGIN" then 
		InterfaceOptions_AddCategory(BasePanel)
		InterfaceOptions_AddCategory(panel)
	elseif event == "PLAYER_ENTERING_WORLD" then -- "PLAYER_ENTERING_WORLD"
		GetSavedVariables()
		UpdateAggroColors()
	end
	
end)
panel:RegisterEvent("PLAYER_LOGIN")
panel:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Slash Command
function slash_TidyGrey(arg) InterfaceOptionsFrame_OpenToCategory(panel); end
SLASH_GREYTANK1 = '/greytank'
SlashCmdList['GREYTANK'] = slash_TidyGrey;


