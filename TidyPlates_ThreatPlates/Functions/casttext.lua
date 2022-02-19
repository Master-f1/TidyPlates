local function SetSpecialText2(unit)
	local spellname
	if unit.isCasting then 
		spellname = UnitCastingInfo("target") or UnitChannelInfo("target")
		return spellname
	else return ""
	end
end

TidyPlatesThreat.SetSpecialText2 = SetSpecialText2
