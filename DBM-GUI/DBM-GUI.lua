-- *********************************************************
-- **               Deadly Boss Mods - GUI                **
-- **            http://www.deadlybossmods.com            **
-- *********************************************************
--
-- This addon is written and copyrighted by:
--    * Paul Emmerich (Tandanu @ EU-Aegwynn) (DBM-Core)
--    * Martin Verges (Nitram @ EU-Azshara) (DBM-GUI)
--    * Adam Williams (Omegal @ US-Whisperwind) (Primary boss mod author) Contact: mysticalosx@gmail.com (Twitter: @MysticalOS)
--
-- The localizations are written by:
--    * enGB/enUS: Tandanu				http://www.deadlybossmods.com
--    * deDE: Tandanu					http://www.deadlybossmods.com
--    * zhCN: Diablohu					http://www.dreamgen.cn | diablohudream@gmail.com
--    * ruRU: Swix						stalker.kgv@gmail.com
--    * ruRU: TOM_RUS
--    * zhTW: Hman						herman_c1@hotmail.com
--    * zhTW: Azael/kc10577				paul.poon.kw@gmail.com
--    * koKR: nBlueWiz					everfinale@gmail.com
--    * esES: Snamor/1nn7erpLaY      	romanscat@hotmail.com
--
-- The ex-translators:
--    * ruRU: BootWin					bootwin@gmail.com
--    * ruRU: Vampik					admin@vampik.ru
--
-- Special thanks to:
--    * Arta
--    * Tennberg (a lot of fixes in the enGB/enUS localization)
--
--
-- The code of this addon is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License. (see license.txt)
-- All included textures and sounds are copyrighted by their respective owners, license information for these media files can be found in the modules that make use of them.
--
--
--  You are free:
--    * to Share - to copy, distribute, display, and perform the work
--    * to Remix - to make derivative works
--  Under the following conditions:
--    * Attribution. You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work). (A link to http://www.deadlybossmods.com is sufficient)
--    * Noncommercial. You may not use this work for commercial purposes.
--    * Share Alike. If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
--
--
local S
if ElvUI then
	local E, L, V, P, G = unpack(ElvUI)
	S = E:GetModule("Skins")
end

local FrameTitle = "DBM_GUI_Option_"	-- all GUI frames get automatically a name FrameTitle..ID

local PanelPrototype = {}
DBM_GUI = {}
setmetatable(PanelPrototype, {__index = DBM_GUI})

local L 	= DBM_GUI_Translations
local CL	= DBM_CORE_L

local modelFrameCreated = false
local soundsRegistered = false

--Hard code STANDARD_TEXT_FONT since skinning mods like to taint it (or worse, set it to nil, wtf?)
local standardFont = "Interface\\AddOns\\DBM-Core\\Fonts\\PTSansNarrow.ttf"

--------------------------------------------------------
--  Cache frequently used global variables in locals  --
--------------------------------------------------------
local tinsert, tremove, tsort, twipe = table.insert, table.remove, table.sort, table.wipe
local mfloor, mmax = math.floor, math.max

function DBM_GUI:ShowHide(forceshow)
	if forceshow == true then
		self:UpdateModList()
		DBM_GUI_OptionsFrame:Show()

	elseif forceshow == false then
		DBM_GUI_OptionsFrame:Hide()

	else
		if DBM_GUI_OptionsFrame:IsShown() then
			DBM_GUI_OptionsFrame:Hide()
		else
			self:UpdateModList()
			DBM_GUI_OptionsFrame:Show()
		end
	end
end

do
	DBM_GUI_OptionsFrameTab1:SetText(L.OTabBosses)
	DBM_GUI_OptionsFrameTab2:SetText(L.OTabOptions)

	local myid = 100
	local prottypemetatable = {__index = PanelPrototype}
	-- This function creates a new entry in the menu
	--
	--  arg1 = Text for the UI Button
	--  arg2 = nil or ("option" or 2)  ... nil will place as a Boss Mod, otherwise as a Option Tab
	--
	function DBM_GUI:CreateNewPanel(FrameName, FrameTyp, showsub, sortID, DisplayName)
		local panel = CreateFrame('Frame', FrameTitle..self:GetNewID(), DBM_GUI_OptionsFramePanelContainer)
		panel.mytype = "panel"
		panel.sortID = self:GetCurrentID()
		panel:SetWidth(DBM_GUI_OptionsFramePanelContainerFOV:GetWidth())
		panel:SetHeight(DBM_GUI_OptionsFramePanelContainerFOV:GetHeight())
		panel:SetPoint("TOPLEFT", DBM_GUI_OptionsFramePanelContainer, "TOPLEFT")

		panel.name = FrameName
		panel.displayname = DisplayName or FrameName
		panel.showsub = (showsub or showsub == nil)

		if (sortID or 0) > 0 then
			panel.sortid = sortID
		else
			myid = myid + 1
			panel.sortid = myid
		end
		panel:Hide()

		if FrameTyp == "option" or FrameTyp == 2 then
			panel.categoryid = DBM_GUI_Options:CreateCategory(panel, self and self.frame and self.frame.name)
			panel.FrameTyp = 2
		else
			panel.categoryid = DBM_GUI_Bosses:CreateCategory(panel, self and self.frame and self.frame.name)
			panel.FrameTyp = 1
		end

		self:SetLastObj(panel)
		self.panels = self.panels or {}
		tinsert(self.panels, {frame = panel, parent = self, framename = FrameTitle..self:GetCurrentID()})
		local obj = self.panels[#self.panels]
		panel.panelid = #self.panels
		return setmetatable(obj, prottypemetatable)
	end

	-- This function don't realy destroy a window, it just hides it
	function PanelPrototype:Destroy()
		if self.frame.FrameTyp == 2 then
			tremove(DBM_GUI_Options.Buttons, self.frame.categoryid)
		else
			tremove(DBM_GUI_Bosses.Buttons, self.frame.categoryid)
		end
		tremove(self.parent.panels, self.frame.panelid)
		self.frame:Hide()
	end

	-- This function renames the Menu Entry for a Panel
	function PanelPrototype:Rename(newname)
		self.frame.name = newname
	end

	-- This function adds areas to group widgets
	--
	--  arg1 = titel of this area
	--  arg2 = width ot the area
	--  arg3 = hight of the area
	--  arg4 = autoplace
	--
	function PanelPrototype:CreateArea(name, width, height, autoplace)
		local area = CreateFrame('Frame', FrameTitle..self:GetNewID(), self.frame, 'OptionsBoxTemplate')
		area.mytype = "area"
		area:SetBackdropBorderColor(0.4, 0.4, 0.4)
		area:SetBackdropColor(0.15, 0.15, 0.15, 0.5)
		_G[FrameTitle..self:GetCurrentID()..'Title']:SetText(name)
		if width ~= nil and width < 0 then
			area:SetWidth( self.frame:GetWidth() -12 + width)
		else
			area:SetWidth(width or self.frame:GetWidth()-12)
		end
		area:SetHeight(height or self.frame:GetHeight()-10)

		if autoplace then
			if select('#', self.frame:GetChildren()) == 1 then
				area:SetPoint('TOPLEFT', self.frame, 5, -20)
			else
				area:SetPoint('TOPLEFT', select(-2, self.frame:GetChildren()) or self.frame, "BOTTOMLEFT", 0, -20)
			end
		end

		self:SetLastObj(area)
		self.areas = self.areas or {}
		tinsert(self.areas, {frame = area, parent = self, framename = FrameTitle..self:GetCurrentID()})
		return setmetatable(self.areas[#self.areas], prottypemetatable)
	end

	function DBM_GUI:GetLastObj()
		return self.lastobject
	end
	function DBM_GUI:SetLastObj(obj)
		self.lastobject = obj
	end
	function DBM_GUI:GetParentsLastObj()
		if self.frame.mytype == "area" then
			return self.parent:GetLastObj()
		else
			return self:GetLastObj()
		end
	end
end

do
	local FrameNames = {}
	function DBM_GUI:AddFrame(FrameName)
		tinsert(FrameNames, FrameName)
	end
	function DBM_GUI:IsPresent(FrameName)
		for k,v in ipairs(FrameNames) do
			if v == FrameName then
				return true
			end
		end
		return false
	end
end


do
	local framecount = 0
	function DBM_GUI:GetNewID()
		framecount = framecount + 1
		return framecount
	end
	function DBM_GUI:GetCurrentID()
		return framecount
	end
end

local function MixinSharedMedia3(mediatype, mediatable)
	if not LibStub then return mediatable end
	if not LibStub("LibSharedMedia-3.0", true) then return mediatable end
	-- register some of our own media
	if not soundsRegistered then
		local LSM = LibStub("LibSharedMedia-3.0")
		soundsRegistered = true
		--Embedded Sound Clip media
		LSM:Register("font",  "PT Sans Narrow", standardFont, LSM.LOCALE_BIT_ruRU + LSM.LOCALE_BIT_western)
		LSM:Register("sound", "Long",	"Interface\\AddOns\\DBM-Core\\sounds\\Long.mp3")
		LSM:Register("sound", "Alert",	"Interface\\AddOns\\DBM-Core\\sounds\\Alert.mp3")
		LSM:Register("sound", "Info",	"Interface\\AddOns\\DBM-Core\\sounds\\Info.mp3")
		LSM:Register("sound", "AirHorn (DBM)", [[Interface\AddOns\DBM-Core\sounds\AirHorn.ogg]])
		LSM:Register("sound", "Jaina: Beware", [[Interface\AddOns\DBM-Core\sounds\SoundClips\beware.ogg]])
		LSM:Register("sound", "Jaina: Beware (reverb)", [[Interface\AddOns\DBM-Core\sounds\SoundClips\beware_with_reverb.ogg]])
		LSM:Register("sound", "Thrall: That's Incredible!", [[Interface\AddOns\DBM-Core\sounds\SoundClips\incredible.ogg]])
		LSM:Register("sound", "Saurfang: Don't Die", [[Interface\AddOns\DBM-Core\sounds\SoundClips\dontdie.ogg]])
		--Blakbyrd
		LSM:Register("sound", "Blakbyrd Alert 1", [[Interface\AddOns\DBM-Core\sounds\BlakbyrdAlerts\Alert1.ogg]])
		LSM:Register("sound", "Blakbyrd Alert 2", [[Interface\AddOns\DBM-Core\sounds\BlakbyrdAlerts\Alert2.ogg]])
		LSM:Register("sound", "Blakbyrd Alert 3", [[Interface\AddOns\DBM-Core\sounds\BlakbyrdAlerts\Alert3.ogg]])
		--User Media
		--IMPORTANT, as of 8.2+, if you register media that doesn't actually exist, it WILL throw Lua errors
		--So use CustomSounds very carefully
		if DBM.Options.CustomSounds >= 1 then
			LSM:Register("sound", "DBM: Custom 1", [[Interface\AddOns\DBM-CustomSounds\Custom1.ogg]])
		end
		if DBM.Options.CustomSounds >= 2 then
			LSM:Register("sound", "DBM: Custom 2", [[Interface\AddOns\DBM-CustomSounds\Custom2.ogg]])
		end
		if DBM.Options.CustomSounds >= 3 then
			LSM:Register("sound", "DBM: Custom 3", [[Interface\AddOns\DBM-CustomSounds\Custom3.ogg]])
		end
		if DBM.Options.CustomSounds >= 4 then
			LSM:Register("sound", "DBM: Custom 4", [[Interface\AddOns\DBM-CustomSounds\Custom4.ogg]])
		end
		if DBM.Options.CustomSounds >= 5 then
			LSM:Register("sound", "DBM: Custom 5", [[Interface\AddOns\DBM-CustomSounds\Custom5.ogg]])
		end
		if DBM.Options.CustomSounds >= 6 then
			LSM:Register("sound", "DBM: Custom 6", [[Interface\AddOns\DBM-CustomSounds\Custom6.ogg]])
		end
		if DBM.Options.CustomSounds >= 7 then
			LSM:Register("sound", "DBM: Custom 7", [[Interface\AddOns\DBM-CustomSounds\Custom7.ogg]])
		end
		if DBM.Options.CustomSounds >= 8 then
			LSM:Register("sound", "DBM: Custom 8", [[Interface\AddOns\DBM-CustomSounds\Custom8.ogg]])
		end
		if DBM.Options.CustomSounds >= 9 then
			LSM:Register("sound", "DBM: Custom 9", [[Interface\AddOns\DBM-CustomSounds\Custom9.ogg]])
			if DBM.Options.CustomSounds > 9 then DBM.Options.CustomSounds = 9 end
		end
	end
	-- sort LibSharedMedia keys alphabetically (case-insensitive)
	local keytable = {}
	for k in next, LibStub("LibSharedMedia-3.0", true):HashTable(mediatype) do
		tinsert(keytable, k)
	end
	tsort(keytable, function (a, b) return a:lower() < b:lower() end);
	-- DBM values (mediatable) first, LibSharedMedia values (sorted alphabetically) afterwards
	local result = mediatable
	for i=1,#keytable do
		local k = keytable[i]
		local v = LibStub("LibSharedMedia-3.0", true):HashTable(mediatype)[k]
		-- lol ace .. playsound accepts empty strings.. quite.mp3 wtf!
		-- NPCScan is a dummy inject of a custom sound in Silverdragon, we don't want that.
		if mediatype ~= "sound" or (k ~= "None" and k ~= "NPCScan") then
			-- filter duplicates
			local insertme = true
			for _, v2 in next, result do
				if v2.value == v then
					insertme = false
					break
				end
			end
			if insertme then
				if mediatype == "statusbar" then
					tinsert(result, {text=k, value=v, texture=v})
				elseif mediatype == "font" then
					tinsert(result, {text=k, value=v, font=v})
				--Only insert paths from addons folder, ignore file data ID, since there is no clean way to handle supporitng both FDID and soundkit at same time
				elseif mediatype == "sound" and type(v) == "string" then
					local search = v:lower()
					if search:find("addons") then
						tinsert(result, {text=k, value=v, sound=true})
					end
				end
			end
		end
	end
	return result
end

-- This function creates a check box
-- Autoplaced buttons will be placed under the last widget
--
--  arg1 = text right to the CheckBox
--  arg2 = autoplaced (true or nil/false)
--  arg3 = text on left side
--  arg4 = DBM.Options[arg4]
--  arg5 = DBM.Bars:SetOption(arg5, ...)
--
do
	local function cursorInHitBox(frame)
		local x = GetCursorPosition()
		local fX = frame:GetCenter()
		local hitBoxSize = -100 -- default value from the default UI template
		return x - fX < hitBoxSize
	end

	local currActiveButton
	local updateFrame = CreateFrame("Frame")
	local function onUpdate(self, elapsed)
		local inHitBox = cursorInHitBox(currActiveButton)
		if currActiveButton.fakeHighlight and not inHitBox then
			currActiveButton:UnlockHighlight()
			currActiveButton.fakeHighlight = nil
		elseif not currActiveButton.fakeHighlight and inHitBox then
			currActiveButton:LockHighlight()
			currActiveButton.fakeHighlight = true
		end
		local x, y = GetCursorPosition()
		local scale = UIParent:GetEffectiveScale()
		x, y = x / scale, y / scale
		GameTooltip:SetPoint("BOTTOMLEFT", nil, "BOTTOMLEFT", x + 5, y + 2)
	end

	local function onHyperlinkClick(self, data, link)
		if IsShiftKeyDown() then
			local msg = link:gsub("|h(.*)|h", "|h[%1]|h")
			local chatWindow = ChatEdit_GetActiveWindow()
			if chatWindow then
				chatWindow:Insert(msg)
			end
		elseif not IsShiftKeyDown() then
			if cursorInHitBox(self:GetParent()) then
				self:GetParent():Click()
			end
		end
	end

	local function onHyperlinkEnter(self, data, link)
		GameTooltip:SetOwner(self, "ANCHOR_NONE") -- I want to anchor BOTTOMLEFT of the tooltip to the cursor... (not BOTTOM as in ANCHOR_CURSOR)
		GameTooltip:SetHyperlink(data)
		GameTooltip:Show()
		currActiveButton = self:GetParent()
		updateFrame:SetScript("OnUpdate", onUpdate)
		if cursorInHitBox(self:GetParent()) then
			self:GetParent().fakeHighlight = true
			self:GetParent():LockHighlight()
		end
	end

	local function onHyperlinkLeave(self, data, link)
		GameTooltip:Hide()
		updateFrame:SetScript("OnUpdate", nil)
		if self:GetParent().fakeHighlight then
			self:GetParent().fakeHighlight = nil
			self:GetParent():UnlockHighlight()
		end
	end

	local function replaceSpellLinks(id)
		local spellId = tonumber(id)
		local spellName = DBM:GetSpellInfo(spellId)
		if not spellName then
			spellName = CL.UNKNOWN
			DBM:Debug("Spell ID does not exist: "..spellId)
		end
		return ("|cff71d5ff|Hspell:%d|h%s|h|r"):format(spellId, spellName)
	end

	local sounds = MixinSharedMedia3("sound", {
		--Inject basically dummy values for ordering special warnings to just use default SW sound assignments
		{sound = true, text = CL.NONE, value = "None"},
		{sound = true, text = "SW 1", value = 1},
		{sound = true, text = "SW 2", value = 2},
		{sound = true, text = "SW 3", value = 3},
		{sound = true, text = "SW 4", value = 4},

		--Inject DBMs custom media that's not available to LibSharedMedia because it uses SoundKit Id (which LSM doesn't support)
		{sound = true, text = "AirHorn (DBM)",	value	= "Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.ogg"},
		{sound = true, text	= "Alert",			value 	= "Interface\\AddOns\\DBM-Core\\sounds\\Alert.mp3"},
		{sound = true, text	= "Info",			value 	= "Interface\\AddOns\\DBM-Core\\sounds\\Info.mp3"},
		{sound = true, text	= "Long",			value 	= "Interface\\AddOns\\DBM-Core\\sounds\\Long.mp3"},
		{sound = true, text = "Algalon: Beware!", value = "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav"},
		{sound = true, text = "BB Wolf: Run Away", value = "Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav"},
		{sound = true, text = "C'Thun: You Will Die!", value = "Sound\\Creature\\CThun\\CThunYouWillDie.wav"},
		{sound = true, text = "Headless Horseman: Laugh", value = "Sound\\Creature\\HeadlessHorseman\\Horseman_Laugh_01.wav"},
		{sound = true, text = "Illidan: Not Prepared", value = "Sound\\Creature\\Illidan\\BLACK_Illidan_04.wav"},
		{sound = true, text = "Kaz'rogal: Marked", value = "Sound\\Creature\\KazRogal\\CAV_Kaz_Mark02.wav"},
		{sound = true, text = "Kil'Jaeden: Destruction", value = "Sound\\Creature\\KilJaeden\\KILJAEDEN02.wav"},
		{sound = true, text = "Loatheb: I see you", value = "Sound\\Creature\\Loathstare\\Loa_Naxx_Aggro02.wav"},
		{sound = true, text = "Lady Malande: Flee", value = "Sound\\Creature\\LadyMalande\\BLCKTMPLE_LadyMal_Aggro01.wav"},
		{sound = true, text = "Milhouse: Light You Up", value = "Sound\\Creature\\MillhouseManastorm\\TEMPEST_Millhouse_Pyro01.wav"},
		{sound = true, text = "Night Elf Bell", value = "Sound\\Doodad\\BellTollNightElf.wav"},
		{sound = true, text = "PvP Flag", value = "Sound\\Spells\\PVPFlagTaken.wav"},
		{sound = true, text = "Void Reaver: Marked", value = "Sound\\Creature\\VoidReaver\\TEMPEST_VoidRvr_Aggro01.wav"},
		{sound = true, text = "Yogg Saron: Laugh", value = "Sound\\Creature\\YoggSaron\\UR_YoggSaron_Slay01.wav"},
})

	local tcolors = {
		{text = L.CBTGeneric, value = 0},
		{text = L.CBTAdd, value = 1},
		{text = L.CBTAOE, value = 2},
		{text = L.CBTTargeted, value = 3},
		{text = L.CBTInterrupt, value = 4},
		{text = L.CBTRole, value = 5},
		{text = L.CBTPhase, value = 6},
		{text = L.CBTImportant, value = 7},
	}

	local function MixinCountTable(baseTable)
		-- DBM values (baseTable) first, mediatable values afterwards
		local result = baseTable
		for i=1,#DBM.Counts do
			local mediatext = DBM.Counts[i].text
			local mediapath = DBM.Counts[i].path
			tinsert(result, {text = mediatext, value = mediapath})
		end
		return result
	end

	local cvoice = MixinCountTable({
		{text = L.None, value = 0},
		{text = L.CVoiceOne, value = 1},
		{text = L.CVoiceTwo, value = 2},
		{text = L.CVoiceThree, value = 3},
	})

	function PanelPrototype:CreateCheckButton(name, autoplace, textleft, dbmvar, dbtvar, mod, modvar, globalvar, isTimer)
		if not name then
			return
		end
		if type(name) == "number" then
			return DBM:AddMsg("CreateCheckButton: error: expected string, received number. You probably called mod:NewTimer(optionId) with a spell id."..name)
		end
		local button = CreateFrame('CheckButton', FrameTitle..self:GetNewID(), self.frame, 'DBMOptionsCheckButtonTemplate')
		local buttonName = button:GetName()
		button.myheight = 25
		button.mytype = "checkbutton"
		if ElvUI and S then
			S:HandleCheckBox(button, true)
		end
		-- font strings do not support hyperlinks, so check if we need one...
		local noteSpellName = name
		if name:find("%$spell:") then
			if not isTimer and modvar then
				local spellId = string.match(name, "spell:(%d+)")
				noteSpellName = DBM:GetSpellInfo(spellId)
			end
			name = name:gsub("%$spell:(%d+)", replaceSpellLinks)
		end
		local dropdown, dropdown2
		local noteButton
		if modvar then--Special warning, has modvar for sound and note
			if isTimer then
				dropdown = self:CreateDropdown(nil, tcolors, nil, nil, function(value)
					mod.Options[modvar.."TColor"] = value
				end, 25, 25, button)
				dropdown:SetScript("OnShow", function(self)
					self:SetSelectedValue(mod.Options[modvar.."TColor"])
				end)
				dropdown2 = self:CreateDropdown(nil, cvoice, nil, nil, function(value)
					mod.Options[modvar.."CVoice"] = value
					if type(value) == "string" then
						DBM:PlayCountSound(1, nil, value)
					elseif value > 0 then
						local countPlay = value == 3 and DBM.Options.CountdownVoice3 or value == 2 and DBM.Options.CountdownVoice2 or DBM.Options.CountdownVoice
						DBM:PlayCountSound(1, countPlay)
					end
				end, 20, 25, button)
				dropdown2:SetScript("OnShow", function(self)
					self:SetSelectedValue(mod.Options[modvar.."CVoice"])
				end)
			else
				dropdown = self:CreateDropdown(nil, sounds, nil, nil, function(value)
					mod.Options[modvar.."SWSound"] = value
					DBM:PlaySpecialWarningSound(value)
				end, 20, 25, button)
				dropdown:SetScript("OnShow", function(self)
					self:SetSelectedValue(mod.Options[modvar.."SWSound"])
				end)
				if mod.Options[modvar .. "SWNote"] then--Mod has note, insert note hack
					noteButton = CreateFrame('Button', FrameTitle..self:GetNewID(), self.frame, 'DBM_GUI_OptionsFramePanelButtonTemplate')
					noteButton:SetWidth(25)
					noteButton:SetHeight(25)
					noteButton.myheight = 0--Tells SetAutoDims that this button needs no additional space
					noteButton:SetText("|TInterface/FriendsFrame/UI-FriendsFrame-Note.blp:18:18:2:-1|t")
					noteButton.mytype = "button"
					noteButton:SetScript("OnClick", function(self)
						local noteText = mod.Options[modvar.."SWNote"]
						if noteText then
							DBM:Debug(tostring(noteText), 2)--Debug only
						end
						DBM:ShowNoteEditor(mod, modvar, noteSpellName)
					end)
				end
			end
		end

		local textpad = 0
		local widthAdjust = 0
		local html
		local textbeside = button
		if dropdown then
			dropdown:SetPoint("LEFT", button, "RIGHT", -20, 2)
			if noteButton then
				noteButton:SetPoint('LEFT', dropdown, "RIGHT", 35, 0)
				textbeside = noteButton
				textpad = 2
				widthAdjust = widthAdjust + dropdown:GetWidth() + noteButton:GetWidth()
			elseif dropdown2 then
				dropdown2:SetPoint('LEFT', dropdown, "RIGHT", 18, 0)
				textbeside = dropdown2
				textpad = 35
				widthAdjust = widthAdjust + dropdown:GetWidth() + dropdown2:GetWidth()
			else
				textbeside = dropdown
				textpad = 35
				widthAdjust = widthAdjust + dropdown:GetWidth()
			end
		end
		if name then -- switch all checkbutton frame to SimpleHTML frame (auto wrap)
			_G[buttonName.."Text"] = CreateFrame("SimpleHTML", buttonName.."Text", button)
			html = _G[buttonName.."Text"]
			html:SetFontObject("GameFontNormal")
			html:SetHyperlinksEnabled(true)
			html:SetScript("OnHyperlinkEnter", onHyperlinkEnter)
			html:SetScript("OnHyperlinkLeave", onHyperlinkLeave)
			html:SetHeight(25)
			-- oscarucb: proper html encoding is required here for hyperlink line wrapping to work correctly
			name = "<html><body><p>"..name.."</p></body></html>"
		end
		_G[buttonName .. 'Text']:SetWidth( self.frame:GetWidth() - 57 - widthAdjust)
		_G[buttonName .. 'Text']:SetText(name or CL.UNKNOWN)

		if textleft then
			_G[buttonName .. 'Text']:ClearAllPoints()
			_G[buttonName .. 'Text']:SetPoint("RIGHT", textbeside, "LEFT", 0, 0)
			_G[buttonName .. 'Text']:SetJustifyH("RIGHT")
		else
			_G[buttonName .. 'Text']:SetJustifyH("LEFT")
		end

		if html and not textleft then
			html:SetHeight(1) -- oscarucb: hack to discover wrapped height, so we can space multi-line options
			html:SetPoint("TOPLEFT",UIParent)
			local ht = select(4,html:GetBoundsRect()) or 25
			html:ClearAllPoints()
			html:SetPoint("TOPLEFT", textbeside, "TOPRIGHT", textpad, -4)
			html:SetHeight(ht)
			button.myheight = mmax(ht+12,button.myheight)
		end

		if dbmvar and DBM.Options[dbmvar] ~= nil then
			button:SetScript("OnShow",  function(self) button:SetChecked(DBM.Options[dbmvar]) end)
			button:SetScript("OnClick", function(self) DBM.Options[dbmvar] = not DBM.Options[dbmvar]
				if dbmvar == "DualProfile" then -- kocTblJIb for dualprofile since overriding Onshow or onClick breaks this hueta
					DBM_UseDualProfile = not DBM_UseDualProfile
					DBM:Debug(tostring( dbmvar ) .. "DBM_UseDualProfile is now " .. tostring( DBM_UseDualProfile ))
					DBM:SpecChanged(true)
				end
			end)
		end

		if dbtvar then
			button:SetScript("OnShow",  function(self) button:SetChecked( DBM.Bars:GetOption(dbtvar) ) end)
			button:SetScript("OnClick", function(self) DBM.Bars:SetOption(dbtvar, not DBM.Bars:GetOption(dbtvar)) end)
		end

		if globalvar and _G[globalvar] ~= nil then
			button:SetScript("OnShow",  function(self) button:SetChecked( _G[globalvar] ) end)
			button:SetScript("OnClick", function(self) _G[globalvar] = not _G[globalvar] end)
		end

		if autoplace then
			local x = self:GetLastObj()
			if x.mytype == "checkbutton" or x.mytype == "line" then
				button:ClearAllPoints()
				button:SetPoint('TOPLEFT', x, "TOPLEFT", 0, -x.myheight)
			else
				button:ClearAllPoints()
				button:SetPoint('TOPLEFT', 10, -12)
			end
		end

		self:SetLastObj(button)
		return button
	end

	function PanelPrototype:CreateLine(text)
		local line = CreateFrame("Frame", FrameTitle..self:GetNewID(), self.frame)
		line:SetSize(self.frame:GetWidth() - 20, 20)
		line:SetPoint("TOPLEFT", 10, -12)
		line.myheight = 20
		line.mytype = "line"

		local linetext = line:CreateFontString(line:GetName().."Text", "ARTWORK", "GameFontNormal")
		linetext:SetPoint("TOPLEFT", line, "TOPLEFT", 0, 0)
		linetext:SetJustifyH("LEFT")
		linetext:SetHeight(18)
		linetext:SetTextColor(0.67, 0.83, 0.48)
		linetext:SetText(text or "")

		local linebg = line:CreateTexture()
		linebg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
		linebg:SetSize(self.frame:GetWidth() - linetext:GetWidth() - 25, 2)
		linebg:SetPoint("RIGHT", line, "RIGHT", 0, 0)

		local x = self:GetLastObj()
		if x.mytype == "checkbutton" or x.mytype == "line" then
			line:ClearAllPoints()
			line:SetPoint('TOPLEFT', x, "TOPLEFT", 0, -x.myheight)
		else
			line:ClearAllPoints()
			line:SetPoint('TOPLEFT', 10, -12)
		end

		self:SetLastObj(line)
		return line
	end
end

do
	local function unfocus(self)
		self:ClearFocus()
	end
	-- This function creates an EditBox
	--
	--  arg1 = Title text, placed ontop of the EditBox
	--  arg2 = Text placed within the EditBox
	--  arg3 = width
	--  arg4 = height
	--
	function PanelPrototype:CreateEditBox(text, value, width, height)
		local textbox = CreateFrame('EditBox', FrameTitle..self:GetNewID(), self.frame, 'DBM_GUI_FrameEditBoxTemplate')
		textbox.mytype = "textbox"
		_G[FrameTitle..self:GetCurrentID().."Text"]:SetText(text)
		textbox:SetWidth(width or 100)
		textbox:SetHeight(height or 20)
		textbox:SetScript("OnEscapePressed", unfocus)
		textbox:SetScript("OnTabPressed", unfocus)
		if type(value) == "string" then
			textbox:SetText(value)
		end
		self:SetLastObj(textbox)
		return textbox
	end
end

-- This function creates a ScrollingMessageFrame (usefull for log entrys)
--
--  arg1 = width of the frame
--  arg2 = height
--  arg3 = insertmode (BOTTOM or TOP)
--  arg4 = enable message fading (default disabled)
--  arg5 = fontobject (font for the messages)
--
function PanelPrototype:CreateScrollingMessageFrame(width, height, insertmode, fading, fontobject)
	local scrollframe = CreateFrame("ScrollingMessageFrame",FrameTitle..self:GetNewID(), self.frame)
	scrollframe:SetWidth(width or 200)
	scrollframe:SetHeight(height or 150)
	scrollframe:SetJustifyH("LEFT")
	if not fading then
		scrollframe:SetFading(false)
	end
	scrollframe:SetInsertMode(insertmode or "BOTTOM")
	scrollframe:SetFontObject(fontobject or "GameFontNormal")
	scrollframe:SetMaxLines(2000)
	scrollframe:EnableMouse(true)
	scrollframe:EnableMouseWheel(1)

	scrollframe:SetScript("OnHyperlinkClick", ChatFrame_OnHyperlinkShow)
	scrollframe:SetScript("OnMouseWheel", function(self, delta)
		if delta == 1 then
			self:ScrollUp()
		elseif delta == -1 then
			self:ScrollDown()
		end
	end)

	self:SetLastObj(scrollframe)
	return scrollframe
end


-- This function creates a slider for numeric values
--
--  arg1 = text ontop of the slider, centered
--  arg2 = lowest value
--  arg3 = highest value
--  arg4 = stepping
--  arg5 = framewidth
--
do
	local function onValueChanged(font, text)
		return function(self, value)
			font:SetFormattedText(text, value)
		end
	end
	function PanelPrototype:CreateSlider(text, low, high, step, framewidth)
		local slider = CreateFrame('Slider', FrameTitle..self:GetNewID(), self.frame, 'OptionsSliderTemplate')
		slider.mytype = "slider"
		slider.myheight = 50
		slider:SetMinMaxValues(low, high)
		slider:SetValueStep(step)
		slider:SetWidth(framewidth or 180)
		_G[FrameTitle..self:GetCurrentID()..'Text']:SetText(text)
		slider:SetScript("OnValueChanged", onValueChanged(_G[FrameTitle..self:GetCurrentID()..'Text'], text))
		self:SetLastObj(slider)
		return slider
	end
end

-- This function creates a color picker
--
--  arg1 = width of the colorcircle (128 default)
--  arg2 = true if you want an alpha selector
--  arg3 = width of the alpha selector (32 default)

function PanelPrototype:CreateColorSelect(dimension, withalpha, alphawidth)
	--- Color select texture with wheel and value
	local colorselect = CreateFrame("ColorSelect", FrameTitle..self:GetNewID(), self.frame)
	colorselect.mytype = "colorselect"
	if withalpha then
		colorselect:SetWidth((dimension or 128)+37)
	else
		colorselect:SetWidth((dimension or 128))
	end
	colorselect:SetHeight(dimension or 128)

	-- create a color wheel
	local colorwheel = colorselect:CreateTexture()
	colorwheel:SetWidth(dimension or 128)
	colorwheel:SetHeight(dimension or 128)
	colorwheel:SetPoint("TOPLEFT", colorselect, "TOPLEFT", 5, 0)
	colorselect:SetColorWheelTexture(colorwheel)

	-- create the colorpicker
	local colorwheelthumbtexture = colorselect:CreateTexture()
	colorwheelthumbtexture:SetTexture("Interface\\Buttons\\UI-ColorPicker-Buttons")
	colorwheelthumbtexture:SetWidth(10)
	colorwheelthumbtexture:SetHeight(10)
	colorwheelthumbtexture:SetTexCoord(0,0.15625, 0, 0.625)
	colorselect:SetColorWheelThumbTexture(colorwheelthumbtexture)

	if withalpha then
		-- create the alpha bar
		local colorvalue = colorselect:CreateTexture()
		colorvalue:SetWidth(alphawidth or 32)
		colorvalue:SetHeight(dimension or 128)
		colorvalue:SetPoint("LEFT", colorwheel, "RIGHT", 10, -3)
		colorselect:SetColorValueTexture(colorvalue)

		-- create the alpha arrows
		local colorvaluethumbtexture = colorselect:CreateTexture()
		colorvaluethumbtexture:SetTexture("Interface\\Buttons\\UI-ColorPicker-Buttons")
		colorvaluethumbtexture:SetWidth( alphawidth/32 * 48)
		colorvaluethumbtexture:SetHeight( alphawidth/32 * 14)
		colorvaluethumbtexture:SetTexCoord(0.25, 1, 0.875, 0)
		colorselect:SetColorValueThumbTexture(colorvaluethumbtexture)
	end

	self:SetLastObj(colorselect)
	return colorselect
end


-- This function creates a button
--
--  arg1 = text on the button "OK", "Cancel",...
--  arg2 = widht
--  arg3 = height
--  arg4 = function to call when clicked
--
function PanelPrototype:CreateButton(title, width, height, onclick, FontObject)
	local button = CreateFrame('Button', FrameTitle..self:GetNewID(), self.frame, 'DBM_GUI_OptionsFramePanelButtonTemplate')
	local buttonName = button:GetName()
	button.mytype = "button"
	button:SetWidth(width or 100)
	button:SetHeight(height or 20)
	button:SetText(title)
	if onclick then
		button:SetScript("OnClick", onclick)
	end
	if FontObject then
		button:SetNormalFontObject(FontObject)
		button:SetHighlightFontObject(FontObject)
	end
	if _G[buttonName.."Text"]:GetStringWidth() > button:GetWidth() then
		button:SetWidth( _G[buttonName.."Text"]:GetStringWidth() + 25 )
	end

	if button.StripTextures and button.SetTemplate then
		button:StripTextures()
		button:SetTemplate("Transparent")
	end

	self:SetLastObj(button)
	return button
end

-- This function creates a text block for descriptions
--
--  arg1 = text to write
--  arg2 = width to set
function PanelPrototype:CreateText(text, width, autoplaced, style, justify)
	local textblock = self.frame:CreateFontString(FrameTitle..self:GetNewID(), "ARTWORK")
	textblock.mytype = "textblock"
	if not style then
		textblock:SetFontObject(GameFontNormal)
	else
		textblock:SetFontObject(style)
	end
	textblock:SetText(text)
	if justify then
		textblock:SetJustifyH(justify)
	else
		textblock:SetJustifyH("CENTER")
	end

	if width then
		textblock:SetWidth( width or 100 )
	else
		textblock:SetWidth( self.frame:GetWidth() )
	end

	if autoplaced then
		textblock:SetPoint('TOPLEFT',self.frame, "TOPLEFT", 10, -10)
	end

	self:SetLastObj(textblock)
	return textblock
end


function PanelPrototype:CreateCreatureModelFrame(width, height, creatureid)
	local ModelFrame = CreateFrame('PlayerModel', FrameTitle..self:GetNewID(), self.frame)
	ModelFrame.mytype = "modelframe"
	ModelFrame:SetWidth(width or 100)
	ModelFrame:SetHeight(height or 200)
	ModelFrame:SetCreature(tonumber(creatureid) or 448)	-- Hogger!!! he kills all of you

	self:SetLastObj(ModelFrame)
	return ModelFrame
end

function PanelPrototype:AutoSetDimension(additionalHeight)
	if not self.frame.mytype == "area" then return end
	local height = self.frame:GetHeight()
	local addHeight = additionalHeight or 0
	local need_height = 25 + addHeight

	local kids = { self.frame:GetChildren() }
	for _, child in pairs(kids) do
		if child.myheight and type(child.myheight) == "number" then
			need_height = need_height + child.myheight
		else
			need_height = need_height + child:GetHeight()
		end
	end

	self.frame.myheight = need_height + 20
	self.frame:SetHeight(need_height)
end

function PanelPrototype:SetMyOwnHeight()
	if not self.frame.mytype == "panel" then return end

	local need_height = self.initheight or 20

	local kids = { self.frame:GetChildren() }
	for _, child in pairs(kids) do
		if child.mytype == "area" and child.myheight then
			need_height = need_height + child.myheight
		elseif child.mytype == "area" then
			need_height = need_height + child:GetHeight() + 20
		elseif child.myheight then
			need_height = need_height + child.myheight
		end
	end
	self.frame.actualHeight = need_height -- HACK: work-around for some strange bug, panels that are overriden (e.g. stats panels when the mod is loaded) are behaving strange since 4.1. GetHeight() will always return the height of the old panel and not of the new...
	self.frame:SetHeight(need_height)
end


local ListFrameButtonsPrototype = {}
-- Prototyp for ListFrame Options Buttons

function ListFrameButtonsPrototype:CreateCategory(frame, parent)
	if not type(frame) == "table" then
		DBM:AddMsg("Failed to create category - frame is not a table")
		DBM:AddMsg(debugstack())
		return false
	elseif not frame.name then
		DBM:AddMsg("Failed to create category - frame.name is missing")
		DBM:AddMsg(debugstack())
		return false
	elseif self:IsPresent(frame.name) then
		DBM:AddMsg("Frame ("..frame.name..") already exists")
		DBM:AddMsg(debugstack())
		return false
	end

	if parent then
		frame.depth = self:GetDepth(parent)
	else
		frame.depth = 1
	end

	self:SetParentHasChilds(parent)

	tinsert(self.Buttons, {
		frame = frame,
		parent = parent
	})
	return #self.Buttons
end

function ListFrameButtonsPrototype:IsPresent(framename)
	for k,v in ipairs(self.Buttons) do
		if v.frame.name == framename then
			return true
		end
	end
	return false
end

function ListFrameButtonsPrototype:GetDepth(framename, depth)
	depth = depth or 1
	for k,v in ipairs(self.Buttons) do
		if v.frame.name == framename then
			if v.parent == nil then
				return depth+1
			else
				depth = depth + self:GetDepth(v.parent, depth)
			end
		end
	end
	return depth
end

function ListFrameButtonsPrototype:SetParentHasChilds(parent)
	if not parent then return end
	for k,v in ipairs(self.Buttons) do
		if v.frame.name == parent then
			v.frame.haschilds = true
		end
	end
end


do
	local mytable = {}
	function ListFrameButtonsPrototype:GetVisibleTabs()
		twipe(mytable)
		for k,v in ipairs(self.Buttons) do
			if v.parent == nil then
				tinsert(mytable, v)

				if v.frame.showsub then
					self:GetVisibleSubTabs(v.frame.name, mytable)
				end
			end
		end
		return mytable
	end
end

function ListFrameButtonsPrototype:GetVisibleSubTabs(parent, t)
	for i, v in ipairs(self.Buttons) do
		if v.parent == parent then
			tinsert(t, v)
			if v.frame.showsub then
				self:GetVisibleSubTabs(v.frame.name, t)
			end
		end
	end
end

local CreateNewFauxScrollFrameList
do
	local mt = {__index = ListFrameButtonsPrototype}
	function CreateNewFauxScrollFrameList()
		return setmetatable({ Buttons={} }, mt)
	end
end

DBM_GUI_Bosses = CreateNewFauxScrollFrameList()
DBM_GUI_Options = CreateNewFauxScrollFrameList()

local function FixCameraAnimationFrame(self, elapsed)
	if self.timer > elapsed then
		self.timer = self.timer - elapsed
		DBM_BossPreview:SetCamera(0)
	else
		self:SetScript("OnUpdate", nil)
	end
end

local UpdateAnimationFrame
function UpdateAnimationFrame(mod)
	DBM_BossPreview.currentMod = mod
	DBM_BossPreview:Show()
	DBM_BossPreview:ClearModel()
	local model = mod.modelId or (mod.multiMobPullDetection and mod.multiMobPullDetection[1] or mod.creatureId)
	if type(model) == "string" then
		DBM_BossPreview:SetModel(model)
	elseif type(model) == "number" then
		DBM_BossPreview:SetCreature(model)
	end
	local modelFile = DBM_BossPreview:GetModel()
	if modelFile and type(modelFile) == "string" and
	(string.find(modelFile, "dragon") or string.find(modelFile, "wurm") or string.find(modelFile, "drake") or string.find(modelFile, "malygos") or string.find(modelFile, "yoggsaron")) then
		DBM_BossPreview.timer = .1
		DBM_BossPreview:SetScript("OnUpdate", FixCameraAnimationFrame)
	else
		local _, y, z = DBM_BossPreview:GetPosition()
		DBM_BossPreview:SetPosition(0.4, y, z)
	end
	if mod.modelSoundShort and DBM.Options.ModelSoundValue == "Short" then
		DBM:PlaySoundFile(mod.modelSoundShort)
	elseif mod.modelSoundLong and DBM.Options.ModelSoundValue == "Long" then
		DBM:PlaySoundFile(mod.modelSoundLong)
	end
end

local function CreateAnimationFrame()
	modelFrameCreated = true
	local mobstyle = CreateFrame('DressUpModel', "DBM_BossPreview", DBM_GUI_OptionsFramePanelContainer)
	mobstyle:SetPoint("BOTTOMRIGHT", DBM_GUI_OptionsFramePanelContainer, "BOTTOMRIGHT", -5, 5)
	mobstyle:SetWidth(300)
	mobstyle:SetHeight(300)
	mobstyle:SetRotation(0)
	mobstyle:SetClampRectInsets(0, 0, 24, 0)
	return mobstyle
end

do
	local function HideScrollBar(frame)
		local frameName = frame:GetName()
		local list = _G[frameName .. "List"]
		list:Hide()
		local listWidth = list:GetWidth()
		for _, button in next, frame.buttons do
			button:SetWidth(button:GetWidth() + listWidth)
		end
	end

	local function DisplayScrollBar(frame)
		local list = _G[frame:GetName() .. "List"]
		list:Show()
		local listWidth = list:GetWidth()
		for _, button in next, frame.buttons do
			button:SetWidth(button:GetWidth() - listWidth)
		end
	end

	-- the functions in this block are only used to
	-- create/update/manage the Fauxscrollframe for Boss/Options Selection
	local displayedElements = {}

	-- This function is for internal use.
	-- Function to update the left scrollframe buttons with the menu entries
	function DBM_GUI_OptionsFrame:UpdateMenuFrame(listframe)
		local frameName = listframe:GetName()
		local offset = _G[frameName.."List"].offset
		local buttons = listframe.buttons
		local TABLE

		if not buttons then return false end

		if listframe:GetParent().tab == 2 then
			TABLE = DBM_GUI_Options:GetVisibleTabs()
		else
			TABLE = DBM_GUI_Bosses:GetVisibleTabs()
		end

		for i, element in ipairs(displayedElements) do
			displayedElements[i] = nil
		end

		for i, element in ipairs(TABLE) do
			tinsert(displayedElements, element.frame)
		end


		local numAddOnCategories = #displayedElements
		local numButtons = #buttons

		if ( numAddOnCategories > numButtons and ( not listframe:IsShown() ) ) then
			DisplayScrollBar(listframe)
		elseif ( numAddOnCategories <= numButtons and ( listframe:IsShown() ) ) then
			HideScrollBar(listframe)
		end

		if ( numAddOnCategories > numButtons ) then
			_G[frameName.."List"]:Show()
			_G[frameName.."ListScrollBar"]:SetMinMaxValues(0, (numAddOnCategories - numButtons) * buttons[1]:GetHeight())
			_G[frameName.."ListScrollBar"]:SetValueStep( buttons[1]:GetHeight() )
		else
			_G[frameName.."ListScrollBar"]:SetValue(0)
			_G[frameName.."List"]:Hide()
		end

		local selection = DBM_GUI_OptionsFrameBossMods.selection
		if ( selection ) then
			DBM_GUI_OptionsFrame:ClearSelection(listframe, listframe.buttons)
		end

		for i = 1, #buttons do
			local element = displayedElements[i + offset]
			if ( not element ) then
				DBM_GUI_OptionsFrame:HideButton(buttons[i])
			else
				DBM_GUI_OptionsFrame:DisplayButton(buttons[i], element)

				if ( selection ) and ( selection == element ) and ( not listframe.selection ) then
					DBM_GUI_OptionsFrame:SelectButton(listframe, buttons[i])
				end
			end
		end
	end

	-- This function is for internal use.
	-- Used to show a button from the list
	function DBM_GUI_OptionsFrame:DisplayButton(button, element)
		button:Show()
		button.element = element

		button.text:ClearAllPoints()
		button.text:SetPoint("LEFT", 12 + 8 * element.depth, 2)
		button.text:SetPoint("RIGHT", 12, 0)
		button.text:SetFontObject(GameFontNormalSmall)
		button.toggle:ClearAllPoints()
		button.toggle:SetPoint("LEFT", 8 * element.depth - 2, 1)

		if element.depth > 2 then
			button:SetNormalFontObject(GameFontHighlightSmall)
			button:SetHighlightFontObject(GameFontHighlightSmall)

		elseif element.depth > 1  then
			button:SetNormalFontObject(GameFontNormalSmall)
			button:SetHighlightFontObject(GameFontNormalSmall)
		else
			button:SetNormalFontObject(GameFontNormal)
			button:SetHighlightFontObject(GameFontNormal)
		end
		button:SetWidth(185)

		if element.haschilds then
			if not element.showsub then
				button.toggle:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP");
				button.toggle:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN");
			else
				button.toggle:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-UP");
				button.toggle:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-DOWN");
			end
			button.toggle:Show()
		else
			button.toggle:Hide()
		end

		button.text:SetText(element.displayname)
		button.text:Show()
	end

	-- This function is for internal use.
	-- Used to hide a button from the list
	function DBM_GUI_OptionsFrame:HideButton(button)
		button:Hide()
	end

	-- This function is for internal use.
	-- Called when a new entry is selected
	function DBM_GUI_OptionsFrame:ClearSelection(listFrame, buttons)
		for _, button in ipairs(buttons) do button:UnlockHighlight() end
		listFrame.selection = nil
	end

	-- This function is for Internal use.
	-- Called when a button is selected
	function DBM_GUI_OptionsFrame:SelectButton(listFrame, button)
		button:LockHighlight()
		listFrame.selection = button.element
	end

	-- This function is for Internal use.
	-- Required to create a list of buttons in the scrollframe
	function DBM_GUI_OptionsFrame:CreateButtons(frame)
		local name = frame:GetName()

		frame.scrollBar = _G[name.."ListScrollBar"]
		frame:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
		_G[name.."Bottom"]:SetVertexColor(0.66, 0.66, 0.66)

		local buttons = {}
		local button = CreateFrame("BUTTON", name.."Button1", frame, "DBM_GUI_FrameButtonTemplate")
		button:SetPoint("TOPLEFT", frame, 0, -8)
		frame.buttonHeight = button:GetHeight()
		tinsert(buttons, button)

		local maxButtons = (frame:GetHeight() - 8) / frame.buttonHeight
		for i = 2, maxButtons do
			button = CreateFrame("BUTTON", name.."Button"..i, frame, "DBM_GUI_FrameButtonTemplate")
			button:SetPoint("TOPLEFT", buttons[#buttons], "BOTTOMLEFT")
			tinsert(buttons, button)
		end
		frame.buttons = buttons
	end

	-- This function is for internal use.
	-- Called when someone clicks a Button
	function DBM_GUI_OptionsFrame:OnButtonClick(button)
		local parent = button:GetParent()
		local buttons = parent.buttons
		local buttonName = DBM_GUI_OptionsFrame:GetName()

		self:ClearSelection(_G[buttonName.."BossMods"],   _G[buttonName.."BossMods"].buttons)
		self:ClearSelection(_G[buttonName.."DBMOptions"], _G[buttonName.."DBMOptions"].buttons)
		self:SelectButton(parent, button)

		DBM_GUI.currentViewing = button.element
		self:DisplayFrame(button.element)
	end

	function DBM_GUI_OptionsFrame:ToggleSubCategories(button)
		local parent = button:GetParent()
		if parent.element.showsub then
			parent.element.showsub = false
		else
			parent.element.showsub = true
		end
		self:UpdateMenuFrame(parent:GetParent())
	end

	-- This function is for internal use.
	-- places the selected tab on the container frame
	function DBM_GUI_OptionsFrame:DisplayFrame(frame, forcechange)
		local container = _G[self:GetName().."PanelContainer"]

		if not (type(frame) == "table" and type(frame[0]) == "userdata") or select("#", frame:GetChildren()) == 0 then
--			DBM:AddMsg(debugstack())
			return
		end

		local changed = forcechange or (container.displayedFrame ~= frame)
		if ( container.displayedFrame ) then
			container.displayedFrame:Hide()
		end
		container.displayedFrame = frame

		DBM_GUI_OptionsFramePanelContainerHeaderText:SetText( frame.displayname )
		DBM_GUI_DropDown:HideMenu()

		local mymax = (frame.actualHeight or frame:GetHeight()) - container:GetHeight()

		if mymax <= 0 then mymax = 0 end
		local frameName = container:GetName()
		if mymax > 0 then
			_G[frameName.."FOV"]:Show()
			_G[frameName.."FOV"]:SetScrollChild(frame)
			_G[frameName.."FOVScrollBar"]:SetMinMaxValues(0, mymax)
			local val = _G[frameName.."FOVScrollBar"]:GetValue() or 0
			if changed then
			  _G[frameName.."FOVScrollBar"]:SetValue(0) -- scroll to top, and ensure widget appears
			end

			if frame.isfixed then
				frame.isfixed = nil
				local listwidth = _G[frameName.."FOVScrollBar"]:GetWidth()
				for i=1, select("#", frame:GetChildren()), 1 do
					local child = select(i, frame:GetChildren())
					if child.mytype == "area" then
						child:SetWidth( child:GetWidth() - listwidth - 1 )
					end
				end
			end
		else
			_G[frameName.."FOV"]:Hide()
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", container ,"TOPLEFT", 5, -5)
			frame:SetPoint("BOTTOMRIGHT", container ,"BOTTOMRIGHT", 0, 0)

			if not frame.isfixed then
				frame.isfixed = true
				local listwidth = _G[frameName.."FOVScrollBar"]:GetWidth()
				for i=1, select("#", frame:GetChildren()), 1 do
					local child = select(i, frame:GetChildren())
					if child.mytype == "area" then
						child:SetWidth( child:GetWidth() + listwidth )
					end
				end
			end
		end
		frame:Show()

		if DBM.Options.EnableModels then
			if not modelFrameCreated then
				CreateAnimationFrame()
			end
			DBM_BossPreview.enabled = false
			DBM_BossPreview:Hide()
			for _, mod in ipairs(DBM.Mods) do
				if mod.panel and mod.panel.frame and mod.panel.frame == frame then
					UpdateAnimationFrame(mod)
				end
			end
		end
	end
end

local function CreateOptionsMenu()
	-- *****************************************************************
	--
	--  begin creating the Option Frames, this is mainly hardcoded
	--  because this allows me to place all the options as I want.
	--
	--  This API can be used to add your own tabs to our menu
	--
	--  To create a new tab please use the following function:
	--
	--    yourframe = DBM_GUI_Frame:CreateNewPanel("title", "option")
	--
	--  You can use the DBM widgets by calling methods like
	--
	--    yourframe:CreateCheckButton("my first checkbox", true)
	--
	--  If you Set the second argument to true, the checkboxes will be
	--  placed automatically.
	--
	-- *****************************************************************


	DBM_GUI_Frame = DBM_GUI:CreateNewPanel(L.TabCategory_Options, "option")
	if DBM.Options.EnableModels then CreateAnimationFrame() end
	do
		----------------------------------------------
		--             General Options              --
		----------------------------------------------
		local generaloptions = DBM_GUI_Frame:CreateArea(L.General, nil, 380, true)

		local StatusEnabled = generaloptions:CreateCheckButton(L.EnableStatus, true, nil, "StatusEnabled")
		local AutoRespond   = generaloptions:CreateCheckButton(L.AutoRespond,  true, nil, "AutoRespond")
		local MiniMapIcon   = generaloptions:CreateCheckButton(L.EnableMiniMapIcon,  true)

		local FixCLEUOnCombatStart		= generaloptions:CreateCheckButton(L.FixCLEUOnCombatStart,  true, nil, "FixCLEUOnCombatStart")
		local DisableCinematics			= generaloptions:CreateCheckButton(L.DisableCinematics, true, nil, "DisableCinematics")
		local ReportRecount				= generaloptions:CreateCheckButton(L.ReportRecount, true, nil, "ReportRecount")
		local ReportSkada				= generaloptions:CreateCheckButton(L.ReportSkada, true, nil, "ReportSkada")

		MiniMapIcon:SetScript("OnClick", function(self)
			DBM:ToggleMinimapButton()
			self:SetChecked( not DBM_MinimapIcon.hide )
		end)
		MiniMapIcon:SetScript("OnShow", function(self)
			self:SetChecked( not DBM_MinimapIcon.hide )
		end)
		local soundChannelsList = {
			{text = L.UseMasterChannel, value = "Master"},
			{text = L.UseDialogChannel, value = "Dialog"},
			{text = L.UseSFXChannel, value = "SFX"},
		}
		local SoundChannelDropdown = generaloptions:CreateDropdown(L.UseSoundChannel, soundChannelsList, "DBM", "UseSoundChannel", function(value)
			DBM.Options.UseSoundChannel = value
		end)
		SoundChannelDropdown:SetPoint("TOPLEFT", generaloptions.frame, "TOPLEFT", 0, -250)

		local bmrange  = generaloptions:CreateButton(L.Button_RangeFrame, 120, 30)
		bmrange:SetPoint('TOPLEFT', SoundChannelDropdown, "BOTTOMLEFT", 15, -5)
		bmrange:SetScript("OnClick", function(self)
			if DBM.RangeCheck:IsShown() then
				DBM.RangeCheck:Hide()
			else
				DBM.RangeCheck:Show()
			end
		end)

		local bminfo = generaloptions:CreateButton(L.Button_InfoFrame, 120, 30)
		bminfo.myheight = 0
		bminfo:SetPoint("LEFT", bmrange, "RIGHT", 2, 0)
		bminfo:SetScript("OnClick", function()
			if DBM.InfoFrame:IsShown() then
				DBM.InfoFrame:Hide()
			else
				DBM.InfoFrame:Show(5, "test")
			end
		end)

		local bmtestmode  = generaloptions:CreateButton(L.Button_TestBars, 150, 30)
		bmtestmode:SetPoint('TOPLEFT', bminfo, "TOPRIGHT", 0, 0)
		bmtestmode:SetScript("OnClick", function(self) DBM:DemoMode() end)

		local latencySlider = generaloptions:CreateSlider(L.Latency_Text, 50, 750, 5, 210)   -- (text , min_value , max_value , step , width)
		latencySlider:SetPoint('BOTTOMLEFT', bmrange, "BOTTOMLEFT", 10, -35)
		latencySlider:HookScript("OnShow", function(self) self:SetValue(DBM.Options.LatencyThreshold) end)
		latencySlider:HookScript("OnValueChanged", function(self) DBM.Options.LatencyThreshold = self:GetValue() end)

		-- Pizza Timer (create your own timer menu)
		local pizzaarea = DBM_GUI_Frame:CreateArea(L.PizzaTimer_Headline, nil, 85)
		pizzaarea.frame:SetPoint('TOPLEFT', generaloptions.frame, "BOTTOMLEFT", 0, -20)

		local textbox = pizzaarea:CreateEditBox(L.PizzaTimer_Title, "Pizza!", 175)
		local hourbox = pizzaarea:CreateEditBox(L.PizzaTimer_Hours, "0", 25)
		local minbox  = pizzaarea:CreateEditBox(L.PizzaTimer_Mins, "15", 25)
		local secbox  = pizzaarea:CreateEditBox(L.PizzaTimer_Secs, "0", 25)

		textbox:SetMaxLetters(17)
		textbox:SetPoint('TOPLEFT', 30, -25)
		hourbox:SetNumeric()
		hourbox:SetMaxLetters(2)
		hourbox:SetPoint('TOPLEFT', textbox, "TOPRIGHT", 20, 0)
		minbox:SetNumeric()
		minbox:SetMaxLetters(2)
		minbox:SetPoint('TOPLEFT', hourbox, "TOPRIGHT", 20, 0)
		secbox:SetNumeric()
		secbox:SetMaxLetters(2)
		secbox:SetPoint('TOPLEFT', minbox, "TOPRIGHT", 20, 0)

		local BcastTimer = pizzaarea:CreateCheckButton(L.PizzaTimer_BroadCast)
		local okbttn  = pizzaarea:CreateButton(L.PizzaTimer_ButtonStart);
		okbttn:SetPoint('TOPLEFT', textbox, "BOTTOMLEFT", -7, -8)
		BcastTimer:SetPoint("TOPLEFT", okbttn, "TOPRIGHT", 10, 3)

		pizzaarea.frame:SetScript("OnShow", function(self)
			if DBM:GetRaidRank() == 0 then
				BcastTimer:Hide()
			else
				BcastTimer:Show()
			end
		end)

		okbttn:SetScript("OnClick", function()
			local time = (hourbox:GetNumber() * 60*60) + (minbox:GetNumber() * 60) + secbox:GetNumber()
			if textbox:GetText() and time > 0 then
				DBM:CreatePizzaTimer(time,  textbox:GetText(), BcastTimer:GetChecked())
			end
		end)

		-- END Pizza Timer
		--

		--Model viewer options
		local modelarea = DBM_GUI_Frame:CreateArea(L.ModelOptions, nil, 48, true)

		local enablemodels	= modelarea:CreateCheckButton(L.EnableModels,  true, nil, "EnableModels")--Needs someone smarter then me to hide/disable this option if not 4.0.6+

		DBM_GUI_Frame:SetMyOwnHeight()
	end

	do
		-------------------------------------------
		--            General Warnings           --
		-------------------------------------------
		local generalWarningPanel = DBM_GUI_Frame:CreateNewPanel(L.Tab_GeneralMessages, "option")
		local generalCoreArea = generalWarningPanel:CreateArea(L.CoreMessages, nil, 120, true)
		generalCoreArea:CreateCheckButton(L.ShowPizzaMessage, true, nil, "ShowPizzaMessage")
		generalCoreArea:CreateCheckButton(L.ShowAllVersions, true, nil, "ShowAllVersions")

		local generalMessagesArea = generalWarningPanel:CreateArea(L.CombatMessages, nil, 135, true)
		generalMessagesArea:CreateCheckButton(L.ShowEngageMessage, true, nil, "ShowEngageMessage")
		generalMessagesArea:CreateCheckButton(L.ShowDefeatMessage, true, nil, "ShowDefeatMessage")
		generalMessagesArea:CreateCheckButton(L.ShowGuildMessages, true, nil, "ShowGuildMessages")
		generalMessagesArea:CreateCheckButton(L.ShowGuildMessagesPlus, true, nil, "ShowGuildMessagesPlus")
		local generalWhispersArea = generalWarningPanel:CreateArea(L.Area_WhisperMessages, nil, 135, true)
		generalWhispersArea:CreateCheckButton(L.AutoRespond, true, nil, "AutoRespond")
		generalWhispersArea:CreateCheckButton(L.WhisperStats, true, nil, "WhisperStats")
		generalWhispersArea:CreateCheckButton(L.DisableStatusWhisper, true, nil, "DisableStatusWhisper")
		generalWhispersArea:CreateCheckButton(L.DisableGuildStatus, true, nil, "DisableGuildStatus")
		generalCoreArea:AutoSetDimension()
		generalMessagesArea:AutoSetDimension()
		generalWhispersArea:AutoSetDimension()
		generalWarningPanel:SetMyOwnHeight()
	end

	do
		-----------------------------------------------
		--            Raid Warning Colors            --
		-----------------------------------------------
		local RaidWarningPanel = DBM_GUI_Frame:CreateNewPanel(L.Tab_RaidWarning, "option")
		local raidwarnoptions = RaidWarningPanel:CreateArea(L.RaidWarning_Header, nil, 500, true)

		local ShowWarningsInChat 	= raidwarnoptions:CreateCheckButton(L.ShowWarningsInChat, true, nil, "ShowWarningsInChat")
		local ShowFakedRaidWarnings = raidwarnoptions:CreateCheckButton(L.ShowFakedRaidWarnings, true, nil, "ShowFakedRaidWarnings")
		local WarningIconLeft		= raidwarnoptions:CreateCheckButton(L.WarningIconLeft,  true, nil, "WarningIconLeft")
		local WarningIconRight 		= raidwarnoptions:CreateCheckButton(L.WarningIconRight,  true, nil, "WarningIconRight")
		local WarningIconChat 		= raidwarnoptions:CreateCheckButton(L.WarningIconChat,  true, nil, "WarningIconChat")
		local WarningAlphabetical	= raidwarnoptions:CreateCheckButton(L.WarningAlphabetical,  true, nil, "WarningAlphabetical")
		local WarningShortText		= raidwarnoptions:CreateCheckButton(L.ShortTextSpellname,  true, nil, "WarningShortText")

		-- RaidWarn Font
		local Fonts = MixinSharedMedia3("font", {
			{text = DEFAULT,	value = standardFont,		font = standardFont},
			{text = "Arial",	value = "Fonts\\ARIALN.TTF",	font = "Fonts\\ARIALN.TTF"},
			{text = "Skurri",	value = "Fonts\\skurri.ttf",	font = "Fonts\\skurri.ttf"},
			{text = "Morpheus",	value = "Fonts\\MORPHEUS.ttf",	font = "Fonts\\MORPHEUS.ttf"},
			{text = "PT Sans Narrow",	value 	= "Interface\\AddOns\\DBM-Core\\Fonts\\PTSansNarrow.ttf",	font = "Interface\\AddOns\\DBM-Core\\Fonts\\PTSansNarrow.ttf"}
		})

		local FontDropDown = raidwarnoptions:CreateDropdown(L.FontType, Fonts, "DBM", "WarningFont", function(value)
			DBM.Options.WarningFont = value
			DBM:UpdateWarningOptions()
			DBM:AddWarning(CL.MOVE_WARNING_MESSAGE)
		end)
		FontDropDown:SetPoint("TOPLEFT", WarningShortText, "BOTTOMLEFT", 0, -30)

		-- RaidWarn Font Style
		local FontStyles = {
			{text = CL.NONE,					value = "None"},
			{text = L.Outline,					value = "OUTLINE"},
			{text = L.ThickOutline,				value = "THICKOUTLINE"},
			{text = L.MonochromeOutline,		value = "MONOCHROME,OUTLINE"},
			{text = L.MonochromeThickOutline,	value = "MONOCHROME,THICKOUTLINE"}
		}

		local FontStyleDropDown = raidwarnoptions:CreateDropdown(L.FontStyle, FontStyles, "DBM", "WarningFontStyle", function(value)
			DBM.Options.WarningFontStyle = value
			DBM:UpdateWarningOptions()
			DBM:AddWarning(CL.MOVE_WARNING_MESSAGE)
		end)
		FontStyleDropDown:SetPoint("TOPLEFT", FontDropDown, "BOTTOMLEFT", 0, -10)

		-- RaidWarn Font Shadow
		local FontShadow = raidwarnoptions:CreateCheckButton(L.FontShadow, nil, nil, "WarningFontShadow")
		FontShadow:SetScript("OnClick", function()
			DBM.Options.WarningFontShadow = not DBM.Options.WarningFontShadow
			DBM:UpdateWarningOptions()
			DBM:AddWarning(CL.MOVE_WARNING_MESSAGE)
		end)
		FontShadow:SetPoint("LEFT", FontStyleDropDown, "RIGHT", 35, 0)

		-- RaidWarn Sound
		local Sounds = MixinSharedMedia3("sound", {
			{text = L.NoSound,		value = ""},
			{text = "RaidWarning",	value = "Sound\\interface\\RaidWarning.wav",		sound = true},
			{text = "Classic",		value = "Sound\\Doodad\\BellTollNightElf.wav",		sound = true},
			{text = "Ding",			value = "Sound\\interface\\AlarmClockWarning3.wav",	sound = true}
		})

		local RaidWarnSoundDropDown = raidwarnoptions:CreateDropdown(L.RaidWarnSound, Sounds, "DBM", "RaidWarningSound", function(value)
			DBM.Options.RaidWarningSound = value
		end)
		RaidWarnSoundDropDown:SetPoint("TOPLEFT", FontStyleDropDown, "BOTTOMLEFT", 0, -10)

		-- RaidWarn Font Size
		local fontSizeSlider = raidwarnoptions:CreateSlider(L.FontSize, 8, 60, 1, 200)
		fontSizeSlider:SetPoint('TOPLEFT', FontDropDown, "TOPLEFT", 20, -130)
		do
			local firstshow = true
			fontSizeSlider:SetScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.WarningFontSize)
			end)
			fontSizeSlider:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.WarningFontSize = self:GetValue()
				DBM:UpdateWarningOptions()
				DBM:AddWarning(L.MOVE_WARNING_MESSAGE)
			end)
		end

		-- RaidWarn Duration
		local durationSlider = raidwarnoptions:CreateSlider(L.Warn_Duration, 1, 10, 0.5, 200)
		durationSlider:SetPoint('TOPLEFT', FontDropDown, "TOPLEFT", 20, -170)
		do
			local firstshow = true
			durationSlider:SetScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.WarningDuration2)
			end)
			durationSlider:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.WarningDuration2 = self:GetValue()
				DBM:UpdateWarningOptions()
				DBM:AddWarning(CL.MOVE_WARNING_MESSAGE)
			end)
		end

		local movemebutton = raidwarnoptions:CreateButton(L.MoveMe, 100, 16)
		movemebutton:SetPoint('TOPRIGHT', raidwarnoptions.frame, "TOPRIGHT", -5, -5)
		movemebutton:SetNormalFontObject(GameFontNormalSmall)
		movemebutton:SetHighlightFontObject(GameFontNormalSmall)
		movemebutton:SetScript("OnClick", function() DBM:MoveWarning() end)

		--Raid Warning Colors
		local raidwarncolors = RaidWarningPanel:CreateArea(L.RaidWarnColors, nil, 150, true)

		local color1 = raidwarncolors:CreateColorSelect(64)
		local color2 = raidwarncolors:CreateColorSelect(64)
		local color3 = raidwarncolors:CreateColorSelect(64)
		local color4 = raidwarncolors:CreateColorSelect(64)
		local color1text = raidwarncolors:CreateText(L.RaidWarnColor_1, 64)
		local color2text = raidwarncolors:CreateText(L.RaidWarnColor_2, 64)
		local color3text = raidwarncolors:CreateText(L.RaidWarnColor_3, 64)
		local color4text = raidwarncolors:CreateText(L.RaidWarnColor_4, 64)
		local color1reset = raidwarncolors:CreateButton(L.Reset, 60, 10, nil, GameFontNormalSmall)
		local color2reset = raidwarncolors:CreateButton(L.Reset, 60, 10, nil, GameFontNormalSmall)
		local color3reset = raidwarncolors:CreateButton(L.Reset, 60, 10, nil, GameFontNormalSmall)
		local color4reset = raidwarncolors:CreateButton(L.Reset, 60, 10, nil, GameFontNormalSmall)

		color1:SetPoint('TOPLEFT', 30, -10)
		color2:SetPoint('TOPLEFT', color1, "TOPRIGHT", 30, 0)
		color3:SetPoint('TOPLEFT', color2, "TOPRIGHT", 30, 0)
		color4:SetPoint('TOPLEFT', color3, "TOPRIGHT", 30, 0)

		local function UpdateColor(self)
			local r, g, b = self:GetColorRGB()
			self.textid:SetTextColor(r, g, b)
			DBM.Options.WarningColors[self.myid].r = r
			DBM.Options.WarningColors[self.myid].g = g
			DBM.Options.WarningColors[self.myid].b = b
		end
		local function ResetColor(id, frame)
			return function(self)
				DBM.Options.WarningColors[id].r = DBM.DefaultOptions.WarningColors[id].r
				DBM.Options.WarningColors[id].g = DBM.DefaultOptions.WarningColors[id].g
				DBM.Options.WarningColors[id].b = DBM.DefaultOptions.WarningColors[id].b
				frame:SetColorRGB(DBM.Options.WarningColors[id].r, DBM.Options.WarningColors[id].g, DBM.Options.WarningColors[id].b)
			end
		end
		local function UpdateColorFrames(color, text, rset, id)
			color.textid = text
			color.myid = id
			color:SetScript("OnColorSelect", UpdateColor)
			color:SetColorRGB(DBM.Options.WarningColors[id].r, DBM.Options.WarningColors[id].g, DBM.Options.WarningColors[id].b)
			text:SetPoint('TOPLEFT', color, "BOTTOMLEFT", 3, -10)
			text:SetJustifyH("CENTER")
			rset:SetPoint("TOP", text, "BOTTOM", 0, -5)
			rset:SetScript("OnClick", ResetColor(id, color))
		end
		UpdateColorFrames(color1, color1text, color1reset, 1)
		UpdateColorFrames(color2, color2text, color2reset, 2)
		UpdateColorFrames(color3, color3text, color3reset, 3)
		UpdateColorFrames(color4, color4text, color4reset, 4)

		local infotext = raidwarncolors:CreateText(L.InfoRaidWarning, 380, false, GameFontNormalSmall, "LEFT")
		infotext:SetPoint('BOTTOMLEFT', raidwarncolors.frame, "BOTTOMLEFT", 10, 10)

		RaidWarningPanel:SetMyOwnHeight()
	end

	do
		--------------------------------------
		--            Bar Options           --
		--------------------------------------
		local BarSetupPanel = DBM_GUI_Frame:CreateNewPanel(L.BarSetup, "option")

		local BarColors = BarSetupPanel:CreateArea(L.AreaTitle_BarColors, nil, 635, true)
		local movemebutton = BarColors:CreateButton(L.MoveMe, 100, 16)
		movemebutton:SetPoint('BOTTOMRIGHT', BarColors.frame, "TOPRIGHT", 0, -1)
		movemebutton:SetNormalFontObject(GameFontNormalSmall)
		movemebutton:SetHighlightFontObject(GameFontNormalSmall)
		movemebutton:SetScript("OnClick", function() DBM.Bars:ShowMovableBar() end)

		--Color Type 1 (Adds)
		local color1Type1 = BarColors:CreateColorSelect(64)
		local color2Type1 = BarColors:CreateColorSelect(64)
		color1Type1:SetPoint('TOPLEFT', BarColors.frame, "TOPLEFT", 30, -65)
		color2Type1:SetPoint('TOPLEFT', color1Type1, "TOPRIGHT", 20, 0)

		local color1Type1reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		local color2Type1reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color1Type1reset:SetPoint('TOP', color1Type1, "BOTTOM", 5, -10)
		color2Type1reset:SetPoint('TOP', color2Type1, "BOTTOM", 5, -10)
		color1Type1reset:SetScript("OnClick", function(self)
			color1Type1:SetColorRGB(DBM.Bars:GetDefaultOption("StartColorAR"), DBM.Bars:GetDefaultOption("StartColorAG"), DBM.Bars:GetDefaultOption("StartColorAB"))
		end)
		color2Type1reset:SetScript("OnClick", function(self)
			color2Type1:SetColorRGB(DBM.Bars:GetDefaultOption("EndColorAR"), DBM.Bars:GetDefaultOption("EndColorAG"), DBM.Bars:GetDefaultOption("EndColorAB"))
		end)

		local color1Type1text = BarColors:CreateText(L.BarStartColorAdd, 80)
		local color2Type1text = BarColors:CreateText(L.BarEndColorAdd, 80)
		color1Type1text:SetPoint("BOTTOM", color1Type1, "TOP", 0, 4)
		color2Type1text:SetPoint("BOTTOM", color2Type1, "TOP", 0, 4)
		color1Type1:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("StartColorAR"),
			DBM.Bars:GetOption("StartColorAG"),
			DBM.Bars:GetOption("StartColorAB"))
			color1Type1text:SetTextColor(
			DBM.Bars:GetOption("StartColorAR"),
			DBM.Bars:GetOption("StartColorAG"),
			DBM.Bars:GetOption("StartColorAB")
			)
		end)
		color2Type1:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("EndColorAR"),
			DBM.Bars:GetOption("EndColorAG"),
			DBM.Bars:GetOption("EndColorAB"))
			color2Type1text:SetTextColor(
			DBM.Bars:GetOption("EndColorAR"),
			DBM.Bars:GetOption("EndColorAG"),
			DBM.Bars:GetOption("EndColorAB")
			)
		end)
		color1Type1:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("StartColorAR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorAG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorAB", select(3, self:GetColorRGB()))
			color1Type1text:SetTextColor(self:GetColorRGB())
		end)
		color2Type1:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("EndColorAR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorAG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorAB", select(3, self:GetColorRGB()))
			color2Type1text:SetTextColor(self:GetColorRGB())
		end)

		local dummybarcolor1 = DBM.Bars:CreateDummyBar(1, nil, L.CBTAdd)
		dummybarcolor1.frame:SetParent(BarColors.frame)
		dummybarcolor1.frame:SetPoint("TOP", color2Type1text, "LEFT", 10, 40)
		dummybarcolor1.frame:SetScript("OnUpdate", function(self, elapsed) dummybarcolor1:Update(elapsed) end)
		do
			-- little hook to prevent this bar from changing size/scale
			local old = dummybarcolor1.ApplyStyle
			function dummybarcolor1:ApplyStyle(...)
				old(self, ...)
				self.frame:SetWidth(183)
				self.frame:SetScale(0.9)
				_G[self.frame:GetName().."Bar"]:SetWidth(183)
			end
		end
		--Color Type 2 (AOE)
		local color1Type2 = BarColors:CreateColorSelect(64)
		local color2Type2 = BarColors:CreateColorSelect(64)
		color1Type2:SetPoint('TOPLEFT', BarColors.frame, "TOPLEFT", 250, -65)
		color2Type2:SetPoint('TOPLEFT', color1Type2, "TOPRIGHT", 20, 0)

		local color1Type2reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		local color2Type2reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color1Type2reset:SetPoint('TOP', color1Type2, "BOTTOM", 5, -10)
		color2Type2reset:SetPoint('TOP', color2Type2, "BOTTOM", 5, -10)
		color1Type2reset:SetScript("OnClick", function(self)
			color1Type2:SetColorRGB(DBM.Bars:GetDefaultOption("StartColorAER"), DBM.Bars:GetDefaultOption("StartColorAEG"), DBM.Bars:GetDefaultOption("StartColorAEB"))
		end)
		color2Type2reset:SetScript("OnClick", function(self)
			color2Type2:SetColorRGB(DBM.Bars:GetDefaultOption("EndColorAER"), DBM.Bars:GetDefaultOption("EndColorAEG"), DBM.Bars:GetDefaultOption("EndColorAEB"))
		end)

		local color1Type2text = BarColors:CreateText(L.BarStartColorAOE, 80)
		local color2Type2text = BarColors:CreateText(L.BarEndColorAOE, 80)
		color1Type2text:SetPoint("BOTTOM", color1Type2, "TOP", 0, 4)
		color2Type2text:SetPoint("BOTTOM", color2Type2, "TOP", 0, 4)
		color1Type2:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("StartColorAER"),
			DBM.Bars:GetOption("StartColorAEG"),
			DBM.Bars:GetOption("StartColorAEB"))
			color1Type2text:SetTextColor(
			DBM.Bars:GetOption("StartColorAER"),
			DBM.Bars:GetOption("StartColorAEG"),
			DBM.Bars:GetOption("StartColorAEB")
			)
		end)
		color2Type2:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("EndColorAER"),
			DBM.Bars:GetOption("EndColorAEG"),
			DBM.Bars:GetOption("EndColorAEB"))
			color2Type2text:SetTextColor(
			DBM.Bars:GetOption("EndColorAER"),
			DBM.Bars:GetOption("EndColorAEG"),
			DBM.Bars:GetOption("EndColorAEB")
			)
		end)
		color1Type2:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("StartColorAER", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorAEG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorAEB", select(3, self:GetColorRGB()))
			color1Type2text:SetTextColor(self:GetColorRGB())
		end)
		color2Type2:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("EndColorAER", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorAEG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorAEB", select(3, self:GetColorRGB()))
			color2Type2text:SetTextColor(self:GetColorRGB())
		end)

		local dummybarcolor2 = DBM.Bars:CreateDummyBar(2, nil, L.CBTAOE)
		dummybarcolor2.frame:SetParent(BarColors.frame)
		dummybarcolor2.frame:SetPoint("TOP", color2Type2text, "LEFT", 10, 40)
		dummybarcolor2.frame:SetScript("OnUpdate", function(self, elapsed) dummybarcolor2:Update(elapsed) end)
		do
			-- little hook to prevent this bar from changing size/scale
			local old = dummybarcolor2.ApplyStyle
			function dummybarcolor2:ApplyStyle(...)
				old(self, ...)
				self.frame:SetWidth(183)
				self.frame:SetScale(0.9)
				_G[self.frame:GetName().."Bar"]:SetWidth(183)
			end
		end
		--Color Type 3 (Debuff)
		local color1Type3 = BarColors:CreateColorSelect(64)
		local color2Type3 = BarColors:CreateColorSelect(64)
		color1Type3:SetPoint('TOPLEFT', BarColors.frame, "TOPLEFT", 30, -220)
		color2Type3:SetPoint('TOPLEFT', color1Type3, "TOPRIGHT", 20, 0)

		local color1Type3reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		local color2Type3reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color1Type3reset:SetPoint('TOP', color1Type3, "BOTTOM", 5, -10)
		color2Type3reset:SetPoint('TOP', color2Type3, "BOTTOM", 5, -10)
		color1Type3reset:SetScript("OnClick", function(self)
			color1Type3:SetColorRGB(DBM.Bars:GetDefaultOption("StartColorDR"), DBM.Bars:GetDefaultOption("StartColorDG"), DBM.Bars:GetDefaultOption("StartColorDB"))
		end)
		color2Type3reset:SetScript("OnClick", function(self)
			color2Type3:SetColorRGB(DBM.Bars:GetDefaultOption("EndColorDR"), DBM.Bars:GetDefaultOption("EndColorDG"), DBM.Bars:GetDefaultOption("EndColorDB"))
		end)

		local color1Type3text = BarColors:CreateText(L.BarStartColorDebuff, 80)
		local color2Type3text = BarColors:CreateText(L.BarEndColorDebuff, 80)
		color1Type3text:SetPoint("BOTTOM", color1Type3, "TOP", 0, 4)
		color2Type3text:SetPoint("BOTTOM", color2Type3, "TOP", 0, 4)
		color1Type3:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("StartColorDR"),
			DBM.Bars:GetOption("StartColorDG"),
			DBM.Bars:GetOption("StartColorDB"))
			color1Type3text:SetTextColor(
			DBM.Bars:GetOption("StartColorDR"),
			DBM.Bars:GetOption("StartColorDG"),
			DBM.Bars:GetOption("StartColorDB")
			)
		end)
		color2Type3:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("EndColorDR"),
			DBM.Bars:GetOption("EndColorDG"),
			DBM.Bars:GetOption("EndColorDB"))
			color2Type3text:SetTextColor(
			DBM.Bars:GetOption("EndColorDR"),
			DBM.Bars:GetOption("EndColorDG"),
			DBM.Bars:GetOption("EndColorDB")
			)
		end)
		color1Type3:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("StartColorDR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorDG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorDB", select(3, self:GetColorRGB()))
			color1Type3text:SetTextColor(self:GetColorRGB())
		end)
		color2Type3:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("EndColorDR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorDG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorDB", select(3, self:GetColorRGB()))
			color2Type3text:SetTextColor(self:GetColorRGB())
		end)

		local dummybarcolor3 = DBM.Bars:CreateDummyBar(3, nil, L.CBTTargeted)
		dummybarcolor3.frame:SetParent(BarColors.frame)
		dummybarcolor3.frame:SetPoint("TOP", color2Type3text, "LEFT", 10, 40)
		dummybarcolor3.frame:SetScript("OnUpdate", function(self, elapsed) dummybarcolor3:Update(elapsed) end)
		do
			-- little hook to prevent this bar from changing size/scale
			local old = dummybarcolor3.ApplyStyle
			function dummybarcolor3:ApplyStyle(...)
				old(self, ...)
				self.frame:SetWidth(183)
				self.frame:SetScale(0.9)
				_G[self.frame:GetName().."Bar"]:SetWidth(183)
			end
		end
		--Color Type 4 (Interrupt)
		local color1Type4 = BarColors:CreateColorSelect(64)
		local color2Type4 = BarColors:CreateColorSelect(64)
		color1Type4:SetPoint('TOPLEFT', BarColors.frame, "TOPLEFT", 250, -220)
		color2Type4:SetPoint('TOPLEFT', color1Type4, "TOPRIGHT", 20, 0)

		local color1Type4reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		local color2Type4reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color1Type4reset:SetPoint('TOP', color1Type4, "BOTTOM", 5, -10)
		color2Type4reset:SetPoint('TOP', color2Type4, "BOTTOM", 5, -10)
		color1Type4reset:SetScript("OnClick", function(self)
			color1Type4:SetColorRGB(DBM.Bars:GetDefaultOption("StartColorIR"), DBM.Bars:GetDefaultOption("StartColorIG"), DBM.Bars:GetDefaultOption("StartColorIB"))
		end)
		color2Type4reset:SetScript("OnClick", function(self)
			color2Type4:SetColorRGB(DBM.Bars:GetDefaultOption("EndColorIR"), DBM.Bars:GetDefaultOption("EndColorIG"), DBM.Bars:GetDefaultOption("EndColorIB"))
		end)

		local color1Type4text = BarColors:CreateText(L.BarStartColorInterrupt, 80)
		local color2Type4text = BarColors:CreateText(L.BarEndColorInterrupt, 80)
		color1Type4text:SetPoint("BOTTOM", color1Type4, "TOP", 0, 4)
		color2Type4text:SetPoint("BOTTOM", color2Type4, "TOP", 0, 4)
		color1Type4:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("StartColorIR"),
			DBM.Bars:GetOption("StartColorIG"),
			DBM.Bars:GetOption("StartColorIB"))
			color1Type4text:SetTextColor(
			DBM.Bars:GetOption("StartColorIR"),
			DBM.Bars:GetOption("StartColorIG"),
			DBM.Bars:GetOption("StartColorIB")
			)
		end)
		color2Type4:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("EndColorIR"),
			DBM.Bars:GetOption("EndColorIG"),
			DBM.Bars:GetOption("EndColorIB"))
			color2Type4text:SetTextColor(
			DBM.Bars:GetOption("EndColorIR"),
			DBM.Bars:GetOption("EndColorIG"),
			DBM.Bars:GetOption("EndColorIB")
			)
		end)
		color1Type4:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("StartColorIR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorIG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorIB", select(3, self:GetColorRGB()))
			color1Type4text:SetTextColor(self:GetColorRGB())
		end)
		color2Type4:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("EndColorIR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorIG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorIB", select(3, self:GetColorRGB()))
			color2Type4text:SetTextColor(self:GetColorRGB())
		end)

		local dummybarcolor4 = DBM.Bars:CreateDummyBar(4, nil, L.CBTInterrupt)
		dummybarcolor4.frame:SetParent(BarColors.frame)
		dummybarcolor4.frame:SetPoint("TOP", color2Type4text, "LEFT", 10, 40)
		dummybarcolor4.frame:SetScript("OnUpdate", function(self, elapsed) dummybarcolor4:Update(elapsed) end)
		do
			-- little hook to prevent this bar from changing size/scale
			local old = dummybarcolor4.ApplyStyle
			function dummybarcolor4:ApplyStyle(...)
				old(self, ...)
				self.frame:SetWidth(183)
				self.frame:SetScale(0.9)
				_G[self.frame:GetName().."Bar"]:SetWidth(183)
			end
		end
		--Color Type 5 (Role)
		local color1Type5 = BarColors:CreateColorSelect(64)
		local color2Type5 = BarColors:CreateColorSelect(64)
		color1Type5:SetPoint('TOPLEFT', BarColors.frame, "TOPLEFT", 30, -375)
		color2Type5:SetPoint('TOPLEFT', color1Type5, "TOPRIGHT", 20, 0)

		local color1Type5reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		local color2Type5reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color1Type5reset:SetPoint('TOP', color1Type5, "BOTTOM", 5, -10)
		color2Type5reset:SetPoint('TOP', color2Type5, "BOTTOM", 5, -10)
		color1Type5reset:SetScript("OnClick", function(self)
			color1Type5:SetColorRGB(DBM.Bars:GetDefaultOption("StartColorRR"), DBM.Bars:GetDefaultOption("StartColorRG"), DBM.Bars:GetDefaultOption("StartColorRB"))
		end)
		color2Type5reset:SetScript("OnClick", function(self)
			color2Type5:SetColorRGB(DBM.Bars:GetDefaultOption("EndColorRR"), DBM.Bars:GetDefaultOption("EndColorRG"), DBM.Bars:GetDefaultOption("EndColorRB"))
		end)

		local color1Type5text = BarColors:CreateText(L.BarStartColorRole, 80)
		local color2Type5text = BarColors:CreateText(L.BarEndColorRole, 80)
		color1Type5text:SetPoint("BOTTOM", color1Type5, "TOP", 0, 4)
		color2Type5text:SetPoint("BOTTOM", color2Type5, "TOP", 0, 4)
		color1Type5:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("StartColorRR"),
			DBM.Bars:GetOption("StartColorRG"),
			DBM.Bars:GetOption("StartColorRB"))
			color1Type5text:SetTextColor(
			DBM.Bars:GetOption("StartColorRR"),
			DBM.Bars:GetOption("StartColorRG"),
			DBM.Bars:GetOption("StartColorRB")
			)
		end)
		color2Type5:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("EndColorRR"),
			DBM.Bars:GetOption("EndColorRG"),
			DBM.Bars:GetOption("EndColorRB"))
			color2Type5text:SetTextColor(
			DBM.Bars:GetOption("EndColorRR"),
			DBM.Bars:GetOption("EndColorRG"),
			DBM.Bars:GetOption("EndColorRB")
			)
		end)
		color1Type5:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("StartColorRR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorRG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorRB", select(3, self:GetColorRGB()))
			color1Type5text:SetTextColor(self:GetColorRGB())
		end)
		color2Type5:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("EndColorRR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorRG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorRB", select(3, self:GetColorRGB()))
			color2Type5text:SetTextColor(self:GetColorRGB())
		end)

		local dummybarcolor5 = DBM.Bars:CreateDummyBar(5, nil, L.CBTRole)
		dummybarcolor5.frame:SetParent(BarColors.frame)
		dummybarcolor5.frame:SetPoint("TOP", color2Type5text, "LEFT", 10, 40)
		dummybarcolor5.frame:SetScript("OnUpdate", function(self, elapsed) dummybarcolor5:Update(elapsed) end)
		do
			-- little hook to prevent this bar from changing size/scale
			local old = dummybarcolor5.ApplyStyle
			function dummybarcolor5:ApplyStyle(...)
				old(self, ...)
				self.frame:SetWidth(183)
				self.frame:SetScale(0.9)
				_G[self.frame:GetName().."Bar"]:SetWidth(183)
			end
		end
		--Color Type 6 (Phase)
		local color1Type6 = BarColors:CreateColorSelect(64)
		local color2Type6 = BarColors:CreateColorSelect(64)
		color1Type6:SetPoint('TOPLEFT', BarColors.frame, "TOPLEFT", 250, -375)
		color2Type6:SetPoint('TOPLEFT', color1Type6, "TOPRIGHT", 20, 0)

		local color1Type6reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		local color2Type6reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color1Type6reset:SetPoint('TOP', color1Type6, "BOTTOM", 5, -10)
		color2Type6reset:SetPoint('TOP', color2Type6, "BOTTOM", 5, -10)
		color1Type6reset:SetScript("OnClick", function(self)
			color1Type6:SetColorRGB(DBM.Bars:GetDefaultOption("StartColorPR"), DBM.Bars:GetDefaultOption("StartColorPG"), DBM.Bars:GetDefaultOption("StartColorPB"))
		end)
		color2Type6reset:SetScript("OnClick", function(self)
			color2Type6:SetColorRGB(DBM.Bars:GetDefaultOption("EndColorPR"), DBM.Bars:GetDefaultOption("EndColorPG"), DBM.Bars:GetDefaultOption("EndColorPB"))
		end)

		local color1Type6text = BarColors:CreateText(L.BarStartColorPhase, 80)
		local color2Type6text = BarColors:CreateText(L.BarEndColorPhase, 80)
		color1Type6text:SetPoint("BOTTOM", color1Type6, "TOP", 0, 4)
		color2Type6text:SetPoint("BOTTOM", color2Type6, "TOP", 0, 4)
		color1Type6:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("StartColorPR"),
			DBM.Bars:GetOption("StartColorPG"),
			DBM.Bars:GetOption("StartColorPB"))
			color1Type6text:SetTextColor(
			DBM.Bars:GetOption("StartColorPR"),
			DBM.Bars:GetOption("StartColorPG"),
			DBM.Bars:GetOption("StartColorPB")
			)
		end)
		color2Type6:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("EndColorPR"),
			DBM.Bars:GetOption("EndColorPG"),
			DBM.Bars:GetOption("EndColorPB"))
			color2Type6text:SetTextColor(
			DBM.Bars:GetOption("EndColorPR"),
			DBM.Bars:GetOption("EndColorPG"),
			DBM.Bars:GetOption("EndColorPB")
			)
		end)
		color1Type6:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("StartColorPR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorPG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorPB", select(3, self:GetColorRGB()))
			color1Type6text:SetTextColor(self:GetColorRGB())
		end)
		color2Type6:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("EndColorPR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorPG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorPB", select(3, self:GetColorRGB()))
			color2Type6text:SetTextColor(self:GetColorRGB())
		end)

		local dummybarcolor6 = DBM.Bars:CreateDummyBar(6, nil, L.CBTPhase)
		dummybarcolor6.frame:SetParent(BarColors.frame)
		dummybarcolor6.frame:SetPoint("TOP", color2Type6text, "LEFT", 10, 40)
		dummybarcolor6.frame:SetScript("OnUpdate", function(self, elapsed) dummybarcolor6:Update(elapsed) end)
		do
			-- little hook to prevent this bar from changing size/scale
			local old = dummybarcolor6.ApplyStyle
			function dummybarcolor6:ApplyStyle(...)
				old(self, ...)
				self.frame:SetWidth(183)
				self.frame:SetScale(0.9)
				_G[self.frame:GetName().."Bar"]:SetWidth(183)
			end
		end

		--Color Type 7 (Important (User))
		local color1Type7 = BarColors:CreateColorSelect(64)
		local color2Type7 = BarColors:CreateColorSelect(64)
		color1Type7:SetPoint('TOPLEFT', BarColors.frame, "TOPLEFT", 30, -530)
		color2Type7:SetPoint('TOPLEFT', color1Type7, "TOPRIGHT", 20, 0)

		local color1Type7reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		local color2Type7reset = BarColors:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color1Type7reset:SetPoint('TOP', color1Type7, "BOTTOM", 5, -10)
		color2Type7reset:SetPoint('TOP', color2Type7, "BOTTOM", 5, -10)
		color1Type7reset:SetScript("OnClick", function(self)
			color1Type7:SetColorRGB(DBM.Bars:GetDefaultOption("StartColorUIR"), DBM.Bars:GetDefaultOption("StartColorUIG"), DBM.Bars:GetDefaultOption("StartColorUIB"))
		end)
		color2Type7reset:SetScript("OnClick", function(self)
			color2Type7:SetColorRGB(DBM.Bars:GetDefaultOption("EndColorUIR"), DBM.Bars:GetDefaultOption("EndColorUIG"), DBM.Bars:GetDefaultOption("EndColorUIB"))
		end)

		local color1Type7text = BarColors:CreateText(L.BarStartColorUI, 80)
		local color2Type7text = BarColors:CreateText(L.BarEndColorUI, 80)
		color1Type7text:SetPoint("BOTTOM", color1Type7, "TOP", 0, 4)
		color2Type7text:SetPoint("BOTTOM", color2Type7, "TOP", 0, 4)
		color1Type7:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("StartColorUIR"),
			DBM.Bars:GetOption("StartColorUIG"),
			DBM.Bars:GetOption("StartColorUIB"))
			color1Type7text:SetTextColor(
			DBM.Bars:GetOption("StartColorUIR"),
			DBM.Bars:GetOption("StartColorUIG"),
			DBM.Bars:GetOption("StartColorUIB")
			)
		end)
		color2Type7:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("EndColorUIR"),
			DBM.Bars:GetOption("EndColorUIG"),
			DBM.Bars:GetOption("EndColorUIB"))
			color2Type7text:SetTextColor(
			DBM.Bars:GetOption("EndColorUIR"),
			DBM.Bars:GetOption("EndColorUIG"),
			DBM.Bars:GetOption("EndColorUIB")
			)
		end)
		color1Type7:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("StartColorUIR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorUIG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorUIB", select(3, self:GetColorRGB()))
			color1Type7text:SetTextColor(self:GetColorRGB())
		end)
		color2Type7:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("EndColorUIR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorUIG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorUIB", select(3, self:GetColorRGB()))
			color2Type7text:SetTextColor(self:GetColorRGB())
		end)

		local dummybarcolor7 = DBM.Bars:CreateDummyBar(7, nil, L.CBTImportant)
		dummybarcolor7.frame:SetParent(BarColors.frame)
		dummybarcolor7.frame:SetPoint("TOP", color2Type7text, "LEFT", 10, 40)
		dummybarcolor7.frame:SetScript("OnUpdate", function(self, elapsed) dummybarcolor7:Update(elapsed) end)
		do
			-- little hook to prevent this bar from changing size/scale
			local old = dummybarcolor7.ApplyStyle
			function dummybarcolor7:ApplyStyle(...)
				old(self, ...)
				self.frame:SetWidth(183)
				self.frame:SetScale(0.9)
				_G[self.frame:GetName().."Bar"]:SetWidth(183)
			end
		end

		--Type 7 Extra Options
		local bar7OptionsText = BarColors:CreateText(L.Bar7Header, 405, nil, nil, "LEFT")
		bar7OptionsText:SetPoint("TOPLEFT", color2Type7text, "TOPLEFT", 150, 0)
		local forceLarge = BarColors:CreateCheckButton(L.Bar7ForceLarge, false, nil, nil, "Bar7ForceLarge")
		forceLarge:SetPoint("TOPLEFT", bar7OptionsText, "BOTTOMLEFT", 0, 0)
		local customInline = BarColors:CreateCheckButton(L.Bar7CustomInline, false, nil, nil, "Bar7CustomInline")
		customInline:SetPoint("TOPLEFT", forceLarge, "BOTTOMLEFT", 0, 0)
		local bar7OptionsText2 = BarColors:CreateText(L.Bar7Footer, 405, nil, nil, "LEFT")
		bar7OptionsText2:SetPoint("TOPLEFT", customInline, "TOPLEFT", 0, -60)

		---------------------
		-- Bar Appearance --
		---------------------
		local BarSetup = BarSetupPanel:CreateArea(L.AreaTitle_BarSetup, nil, 325, true)

		local color1 = BarSetup:CreateColorSelect(64)
		local color2 = BarSetup:CreateColorSelect(64)
		color1:SetPoint('TOPLEFT', BarSetup.frame, "TOPLEFT", 30, -80)
		color2:SetPoint('TOPLEFT', color1, "TOPRIGHT", 20, 0)

		local color1reset = BarSetup:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		local color2reset = BarSetup:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color1reset:SetPoint('TOP', color1, "BOTTOM", 5, -10)
		color2reset:SetPoint('TOP', color2, "BOTTOM", 5, -10)
		color1reset:SetScript("OnClick", function(self)
			color1:SetColorRGB(DBM.Bars:GetDefaultOption("StartColorR"), DBM.Bars:GetDefaultOption("StartColorG"), DBM.Bars:GetDefaultOption("StartColorB"))
		end)
		color2reset:SetScript("OnClick", function(self)
			color2:SetColorRGB(DBM.Bars:GetDefaultOption("EndColorR"), DBM.Bars:GetDefaultOption("EndColorG"), DBM.Bars:GetDefaultOption("EndColorB"))
		end)

		local color1text = BarSetup:CreateText(L.BarStartColor, 80)
		local color2text = BarSetup:CreateText(L.BarEndColor, 80)
		color1text:SetPoint("BOTTOM", color1, "TOP", 0, 4)
		color2text:SetPoint("BOTTOM", color2, "TOP", 0, 4)
		color1:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("StartColorR"),
			DBM.Bars:GetOption("StartColorG"),
			DBM.Bars:GetOption("StartColorB"))
			color1text:SetTextColor(
			DBM.Bars:GetOption("StartColorR"),
			DBM.Bars:GetOption("StartColorG"),
			DBM.Bars:GetOption("StartColorB")
			)
		end)
		color2:SetScript("OnShow", function(self) self:SetColorRGB(
			DBM.Bars:GetOption("EndColorR"),
			DBM.Bars:GetOption("EndColorG"),
			DBM.Bars:GetOption("EndColorB"))
			color2text:SetTextColor(
			DBM.Bars:GetOption("EndColorR"),
			DBM.Bars:GetOption("EndColorG"),
			DBM.Bars:GetOption("EndColorB")
			)
		end)
		color1:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("StartColorR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("StartColorB", select(3, self:GetColorRGB()))
			color1text:SetTextColor(self:GetColorRGB())
		end)
		color2:SetScript("OnColorSelect", function(self)
			DBM.Bars:SetOption("EndColorR", select(1, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorG", select(2, self:GetColorRGB()))
			DBM.Bars:SetOption("EndColorB", select(3, self:GetColorRGB()))
			color2text:SetTextColor(self:GetColorRGB())
		end)

		local maindummybar = DBM.Bars:CreateDummyBar(nil, nil, L.Small)
		maindummybar.frame:SetParent(BarSetup.frame)
		maindummybar.frame:SetPoint("TOP", color2text, "LEFT", 10, 60)
		maindummybar.frame:SetScript("OnUpdate", function(self, elapsed) maindummybar:Update(elapsed) end)
		do
			-- little hook to prevent this bar from changing size/scale
			local old = maindummybar.ApplyStyle
			function maindummybar:ApplyStyle(...)
				old(self, ...)
				self.frame:SetWidth(183)
				self.frame:SetScale(0.9)
				_G[self.frame:GetName().."Bar"]:SetWidth(183)
			end
		end
		local maindummybarHuge = DBM.Bars:CreateDummyBar(nil, nil, L.Large)
		maindummybarHuge.frame:SetParent(BarSetup.frame)
		maindummybarHuge.frame:SetPoint("TOP", color2text, "LEFT", 10, 35)
		maindummybarHuge.frame:SetScript("OnUpdate", function(self, elapsed) maindummybarHuge:Update(elapsed) end)
		maindummybarHuge.enlarged = true
		maindummybarHuge.enlargeHack = true
		maindummybarHuge:ApplyStyle()
		do
			-- little hook to prevent this bar from changing size/scale
			local old = maindummybarHuge.ApplyStyle
			function maindummybarHuge:ApplyStyle(...)
				old(self, ...)
				self.frame:SetWidth(183)
				self.frame:SetScale(0.9)
				_G[self.frame:GetName().."Bar"]:SetWidth(183)
			end
		end
		local Styles = {
			{	text	= L.BarDBM,				value	= "DBM" },
			{	text	= L.BarSimple,			value 	= "NoAnim" }
		}

		local StyleDropDown = BarSetup:CreateDropdown(L.BarStyle, Styles, "DBT", "BarStyle", function(value)
			DBM.Bars:SetOption("BarStyle", value)
		end, 210)
		StyleDropDown:SetPoint("TOPLEFT", BarSetup.frame, "TOPLEFT", 210, -25)

		local Textures = MixinSharedMedia3("statusbar", {
			{	text	= DEFAULT,				value 	= "Interface\\AddOns\\DBM-DefaultSkin\\textures\\default.blp", 	texture	= "Interface\\AddOns\\DBM-DefaultSkin\\textures\\default.blp"	},
			{	text	= "Blizzad",			value 	= "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar", 	texture	= 136570	},
			{	text	= "Glaze",				value 	= "Interface\\AddOns\\DBM-Core\\textures\\glaze.blp", 			texture	= "Interface\\AddOns\\DBM-Core\\textures\\glaze.blp"	},
			{	text	= "Otravi",				value 	= "Interface\\AddOns\\DBM-Core\\textures\\otravi.blp", 			texture	= "Interface\\AddOns\\DBM-Core\\textures\\otravi.blp"	},
			{	text	= "Smooth",				value 	= "Interface\\AddOns\\DBM-Core\\textures\\smooth.blp", 			texture	= "Interface\\AddOns\\DBM-Core\\textures\\smooth.blp"	}
		})

		local TextureDropDown = BarSetup:CreateDropdown(L.BarTexture, Textures, "DBT", "Texture", function(value)
			DBM.Bars:SetOption("Texture", value)
		end)
		TextureDropDown:SetPoint("TOPLEFT", StyleDropDown, "BOTTOMLEFT", 0, -10)

		local Fonts = MixinSharedMedia3("font", {
			{	text	= DEFAULT,				value 	= standardFont,					font = standardFont	},
			{	text	= "Arial",				value 	= "Fonts\\ARIALN.TTF",			font = "Fonts\\ARIALN.TTF"		},
			{	text	= "Skurri",				value 	= "Fonts\\skurri.ttf",			font = "Fonts\\skurri.ttf"		},
			{	text	= "Morpheus",			value 	= "Fonts\\MORPHEUS.ttf",		font = "Fonts\\MORPHEUS.ttf"	}
		})

		local FontDropDown = BarSetup:CreateDropdown(L.FontType, Fonts, "DBT", "Font", function(value)
			DBM.Bars:SetOption("Font", value)
		end)
		FontDropDown:SetPoint("TOPLEFT", TextureDropDown, "BOTTOMLEFT", 0, -10)

		local FontFlags = {
			{	text	= CL.NONE,					value 	= "None"						},
			{	text	= L.Outline,				value 	= "OUTLINE"						},
			{	text	= L.ThickOutline,			value 	= "THICKOUTLINE"				},
			{	text	= L.MonochromeOutline,		value 	= "MONOCHROME,OUTLINE"			},
			{	text	= L.MonochromeThickOutline,	value 	= "MONOCHROME,THICKOUTLINE"		}
		}

		local FontFlagDropDown = BarSetup:CreateDropdown(L.FontStyle, FontFlags, "DBT", "FontFlag",
			function(value)
				DBM.Bars:SetOption("FontFlag", value)
			end)
		FontFlagDropDown:SetPoint("TOPLEFT", FontDropDown, "BOTTOMLEFT", 0, -10)

		local iconleft = BarSetup:CreateCheckButton(L.BarIconLeft, nil, nil, nil, "IconLeft")
		iconleft:SetPoint("TOPLEFT", FontFlagDropDown, "BOTTOMLEFT", 10, 0)

		local iconright = BarSetup:CreateCheckButton(L.BarIconRight, nil, nil, nil, "IconRight")
		iconright:SetPoint("LEFT", iconleft, "LEFT", 130, 0)

		local SparkBars = BarSetup:CreateCheckButton(L.BarSpark, false, nil, nil, "Spark")
		SparkBars:SetPoint("TOPLEFT", iconleft, "BOTTOMLEFT", 0, 0)

		local FlashBars = BarSetup:CreateCheckButton(L.BarFlash, false, nil, nil, "FlashBar")
		FlashBars:SetPoint("TOPLEFT", SparkBars, "BOTTOMLEFT", 0, 0)

		local ColorBars = BarSetup:CreateCheckButton(L.BarColorByType, false, nil, nil, "ColorByType")
		ColorBars:SetPoint("TOPLEFT", FlashBars, "BOTTOMLEFT", 0, 0)

		local InlineIcons = BarSetup:CreateCheckButton(L.BarInlineIcons, false, nil, nil, "InlineIcons")
		InlineIcons:SetPoint("LEFT", ColorBars, "LEFT", 130, 0)

		-- Functions for bar setup
		local function createDBTOnShowHandler(option)
			return function(self)
				self:SetValue(DBM.Bars:GetOption(option))
			end
		end
		local function createDBTOnValueChangedHandler(option)
			return function(self)
				DBM.Bars:SetOption(option, self:GetValue())
				self:SetValue(DBM.Bars:GetOption(option))
			end
		end

		local function resetDBTValueToDefault(slider, option)
			DBM.Bars:SetOption(option, DBM.Bars:GetDefaultOption(option))
			slider:SetValue(DBM.Bars:GetOption(option))
		end

		local FontSizeSlider = BarSetup:CreateSlider(L.FontSize, 7, 18, 1)
		FontSizeSlider:SetPoint("TOPLEFT", BarSetup.frame, "TOPLEFT", 20, -175)
		FontSizeSlider:SetScript("OnShow", createDBTOnShowHandler("FontSize"))
		FontSizeSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("FontSize"))

		local BarHeightSlider = BarSetup:CreateSlider(L.Bar_Height, 10, 35, 1)
		BarHeightSlider:SetPoint("TOPLEFT", BarSetup.frame, "TOPLEFT", 20, -220)
		BarHeightSlider:SetScript("OnShow", createDBTOnShowHandler("Height"))
		BarHeightSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("Height"))

		local DisableBarFade = BarSetup:CreateCheckButton(L.NoBarFade, false, nil, nil, "NoBarFade")
		DisableBarFade:SetPoint("TOPLEFT", BarHeightSlider, "BOTTOMLEFT", 0, -50)

		-----------------------
		-- Bar Behaviors --
		-----------------------
		local BarBehaviors = BarSetupPanel:CreateArea(L.AreaTitle_Behavior, nil, 225, true)

		local DecimalSlider = BarBehaviors:CreateSlider(L.Bar_Decimal, 5, 60, 1)
		DecimalSlider:SetPoint("TOPLEFT", BarBehaviors.frame, "TOPLEFT", 20, -25)
		DecimalSlider:SetScript("OnShow", createDBTOnShowHandler("TDecimal"))
		DecimalSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("TDecimal"))

		local EnlargeTimeSlider = BarBehaviors:CreateSlider(L.Bar_EnlargeTime, 6, 30, 1)
		EnlargeTimeSlider:SetPoint("TOPLEFT", BarBehaviors.frame, "TOPLEFT", 230, -25)
		EnlargeTimeSlider:SetScript("OnShow", createDBTOnShowHandler("EnlargeBarTime"))
		EnlargeTimeSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("EnlargeBarTime"))

		local ClickThrough = BarBehaviors:CreateCheckButton(L.ClickThrough, false, nil, nil, "ClickThrough")
		ClickThrough:SetPoint("TOPLEFT", DecimalSlider, "BOTTOMLEFT", 0, -15)

		local SortBars = BarBehaviors:CreateCheckButton(L.BarSort, false, nil, nil, "Sort")
		SortBars:SetPoint("TOPLEFT", ClickThrough, "BOTTOMLEFT", 0, 0)

		local ShortTimers = BarBehaviors:CreateCheckButton(L.ShortTimerText, false, nil, "ShortTimerText")
		ShortTimers:SetPoint("TOPLEFT", SortBars, "BOTTOMLEFT", 0, 0)

		local StripTimers = BarBehaviors:CreateCheckButton(L.StripTimerText, false, nil, nil, "StripCDText")
		StripTimers:SetPoint("TOPLEFT", ShortTimers, "BOTTOMLEFT", 0, 0)

		local KeepTimers = BarBehaviors:CreateCheckButton(L.KeepBar, false, nil, nil, "KeepBars")
		KeepTimers:SetPoint("TOPLEFT", StripTimers, "BOTTOMLEFT", 0, 0)

		--local KeepTimers2 = BarBehaviors:CreateText(L.KeepBar2, 405, nil, nil, "LEFT")
		--KeepTimers2:SetPoint("TOPLEFT", KeepTimers, "BOTTOMLEFT", 25, 10)

		local FadeTimers = BarBehaviors:CreateCheckButton(L.FadeBar, false, nil, nil, "FadeBars")
		FadeTimers:SetPoint("TOPLEFT", KeepTimers, "BOTTOMLEFT", 0, 0)

		--local FadeTimers2 = BarBehaviors:CreateText(L.KeepBar2, 405, nil, nil, "LEFT")
		--FadeTimers2:SetPoint("TOPLEFT", FadeTimers, "BOTTOMLEFT", 25, 10)

		-----------------------
		-- Small Bar Options --
		-----------------------
		local BarSetupSmall = BarSetupPanel:CreateArea(L.AreaTitle_BarSetupSmall, nil, 205, true)

		local smalldummybar = DBM.Bars:CreateDummyBar(nil, nil, L.Small)
		smalldummybar.frame:SetParent(BarSetupSmall.frame)
		smalldummybar.frame:SetPoint('BOTTOM', BarSetupSmall.frame, "TOP", 0, -35)
		smalldummybar.frame:SetScript("OnUpdate", function(self, elapsed) smalldummybar:Update(elapsed) end)

		local ExpandUpwards = BarSetup:CreateCheckButton(L.ExpandUpwards, false, nil, nil, "ExpandUpwards")
		ExpandUpwards:SetPoint("TOPLEFT", smalldummybar.frame, "BOTTOMLEFT", -50, -15)

		local FillUpBars = BarSetup:CreateCheckButton(L.FillUpBars, false, nil, nil, "FillUpBars")
		FillUpBars:SetPoint("TOPLEFT", smalldummybar.frame, "BOTTOMLEFT", 100, -15)

		local BarWidthSlider = BarSetup:CreateSlider(L.Slider_BarWidth, 100, 400, 1, 310)
		BarWidthSlider:SetPoint("TOPLEFT", BarSetupSmall.frame, "TOPLEFT", 20, -90)
		BarWidthSlider:SetScript("OnShow", createDBTOnShowHandler("Width"))
		BarWidthSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("Width"))

		local BarScaleSlider = BarSetup:CreateSlider(L.Slider_BarScale, 0.75, 2, 0.05, 310)
		BarScaleSlider:SetPoint("TOPLEFT", BarWidthSlider, "BOTTOMLEFT", 0, -10)
		BarScaleSlider:SetScript("OnShow", createDBTOnShowHandler("Scale"))
		BarScaleSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("Scale"))

		local AlphaSlider = BarSetup:CreateSlider(L.Bar_Alpha, 0, 1, 0.1)
		AlphaSlider:SetPoint("TOPLEFT", BarScaleSlider, "BOTTOMLEFT", 0, -10)
		AlphaSlider:SetScript("OnShow", createDBTOnShowHandler("Alpha"))
		AlphaSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("Alpha"))

		local BarOffsetXSlider = BarSetup:CreateSlider(L.Slider_BarOffSetX, -50, 50, 1, 120)
		BarOffsetXSlider:SetPoint("TOPLEFT", BarSetupSmall.frame, "TOPLEFT", 350, -90)
		BarOffsetXSlider:SetScript("OnShow", createDBTOnShowHandler("BarXOffset"))
		BarOffsetXSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("BarXOffset"))

		local BarOffsetYSlider = BarSetup:CreateSlider(L.Slider_BarOffSetY, -5, 35, 1, 120)
		BarOffsetYSlider:SetPoint("TOPLEFT", BarOffsetXSlider, "BOTTOMLEFT", 0, -10)
		BarOffsetYSlider:SetScript("OnShow", createDBTOnShowHandler("BarYOffset"))
		BarOffsetYSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("BarYOffset"))

		local barResetbutton = BarSetup:CreateButton(L.SpecWarn_ResetMe, 120, 16)
		barResetbutton:SetPoint('BOTTOMRIGHT', BarSetupSmall.frame, "BOTTOMRIGHT", -5, 5)
		barResetbutton:SetNormalFontObject(GameFontNormalSmall)
		barResetbutton:SetHighlightFontObject(GameFontNormalSmall)
		barResetbutton:SetScript("OnClick", function()
			resetDBTValueToDefault(BarWidthSlider, "Width")
			resetDBTValueToDefault(BarScaleSlider, "Scale")
			resetDBTValueToDefault(BarOffsetXSlider, "BarXOffset")
			resetDBTValueToDefault(BarOffsetYSlider, "BarYOffset")
			resetDBTValueToDefault(AlphaSlider, "Alpha")
			--TimerX
			--TimerY
			--TimerPoint
		end)

		-----------------------
		-- Huge Bar Options --
		-----------------------
		local BarSetupHuge = BarSetupPanel:CreateArea(L.AreaTitle_BarSetupHuge, nil, 220, true)

		local enablebar = BarSetupHuge:CreateCheckButton(L.EnableHugeBar, true, nil, nil, "HugeBarsEnabled")

		local hugedummybar = DBM.Bars:CreateDummyBar(nil, nil, L.Large)
		hugedummybar.frame:SetParent(BarSetupSmall.frame)
		hugedummybar.frame:SetPoint('BOTTOM', BarSetupHuge.frame, "TOP", 0, -50)
		hugedummybar.frame:SetScript("OnUpdate", function(self, elapsed) hugedummybar:Update(elapsed) end)
		hugedummybar.enlarged = true
		hugedummybar.enlargeHack = true
		hugedummybar:ApplyStyle()

		local ExpandUpwardsLarge = BarSetup:CreateCheckButton(L.ExpandUpwards, false, nil, nil, "ExpandUpwardsLarge")
		ExpandUpwardsLarge:SetPoint("TOPLEFT", hugedummybar.frame, "BOTTOMLEFT", -50, -15)

		local FillUpBarsLarge = BarSetup:CreateCheckButton(L.FillUpBars, false, nil, nil, "FillUpLargeBars")
		FillUpBarsLarge:SetPoint("TOPLEFT", hugedummybar.frame, "BOTTOMLEFT", 100, -15)

		local HugeBarWidthSlider = BarSetupHuge:CreateSlider(L.Slider_BarWidth, 100, 400, 1, 310)
		HugeBarWidthSlider:SetPoint("TOPLEFT", BarSetupHuge.frame, "TOPLEFT", 20, -105)
		HugeBarWidthSlider:SetScript("OnShow", createDBTOnShowHandler("HugeWidth"))
		HugeBarWidthSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("HugeWidth"))

		local HugeBarScaleSlider = BarSetupHuge:CreateSlider(L.Slider_BarScale, 0.75, 2, 0.05, 310)
		HugeBarScaleSlider:SetPoint("TOPLEFT", HugeBarWidthSlider, "BOTTOMLEFT", 0, -10)
		HugeBarScaleSlider:SetScript("OnShow", createDBTOnShowHandler("HugeScale"))
		HugeBarScaleSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("HugeScale"))

		local HugeAlphaSlider = BarSetup:CreateSlider(L.Bar_Alpha, 0.1, 1, 0.1)
		HugeAlphaSlider:SetPoint("TOPLEFT", HugeBarScaleSlider, "BOTTOMLEFT", 0, -10)
		HugeAlphaSlider:SetScript("OnShow", createDBTOnShowHandler("HugeAlpha"))
		HugeAlphaSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("HugeAlpha"))

		local HugeBarOffsetXSlider = BarSetupHuge:CreateSlider(L.Slider_BarOffSetX, -50, 50, 1, 120)
		HugeBarOffsetXSlider:SetPoint("TOPLEFT", BarSetupHuge.frame, "TOPLEFT", 350, -105)
		HugeBarOffsetXSlider:SetScript("OnShow", createDBTOnShowHandler("HugeBarXOffset"))
		HugeBarOffsetXSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("HugeBarXOffset"))

		local HugeBarOffsetYSlider = BarSetupHuge:CreateSlider(L.Slider_BarOffSetY, -5, 35, 1, 120)
		HugeBarOffsetYSlider:SetPoint("TOPLEFT", HugeBarOffsetXSlider, "BOTTOMLEFT", 0, -10)
		HugeBarOffsetYSlider:SetScript("OnShow", createDBTOnShowHandler("HugeBarYOffset"))
		HugeBarOffsetYSlider:HookScript("OnValueChanged", createDBTOnValueChangedHandler("HugeBarYOffset"))

		local hugeBarResetbutton = BarSetupHuge:CreateButton(L.SpecWarn_ResetMe, 120, 16)
		hugeBarResetbutton:SetPoint('BOTTOMRIGHT', BarSetupHuge.frame, "BOTTOMRIGHT", -5, 5)
		hugeBarResetbutton:SetNormalFontObject(GameFontNormalSmall)
		hugeBarResetbutton:SetHighlightFontObject(GameFontNormalSmall)
		hugeBarResetbutton:SetScript("OnClick", function()
			resetDBTValueToDefault(HugeBarWidthSlider, "HugeWidth")
			resetDBTValueToDefault(HugeBarScaleSlider, "HugeScale")
			resetDBTValueToDefault(HugeBarOffsetXSlider, "HugeBarXOffset")
			resetDBTValueToDefault(HugeBarOffsetYSlider, "HugeBarYOffset")
			resetDBTValueToDefault(HugeAlphaSlider, "HugeAlpha")
			--HugeTimerPoint
			--HugeTimerX
			--HugeTimerY
		end)

		BarSetupPanel:SetMyOwnHeight()
	end

	do
		local specPanel = DBM_GUI_Frame:CreateNewPanel(L.Panel_SpecWarnFrame, "option")
		local specArea = specPanel:CreateArea(L.Area_SpecWarn, nil, 350, true)
		local check1 = specArea:CreateCheckButton(L.SpecWarn_ClassColor, true, nil, "SWarnClassColor")
		local check2 = specArea:CreateCheckButton(L.WarningAlphabetical, true, nil, "SWarningAlphabetical")
		local check3 = specArea:CreateCheckButton(L.ShowSWarningsInChat, true, nil, "ShowSWarningsInChat")
		local check4 = specArea:CreateCheckButton(L.SWarnNameInNote, true, nil, "SWarnNameInNote")
		local check5 = specArea:CreateCheckButton(L.SpecialWarningIcon, true, nil, "SpecialWarningIcon")
		local check6 = specArea:CreateCheckButton(L.ShortTextSpellname, true, nil, "SpecialWarningShortText")

		local movemebutton = specArea:CreateButton(L.MoveMe, 120, 16)
		movemebutton:SetPoint('TOPRIGHT', specArea.frame, "TOPRIGHT", 0, -5)
		movemebutton:SetNormalFontObject(GameFontNormalSmall)
		movemebutton:SetHighlightFontObject(GameFontNormalSmall)
		movemebutton:SetScript("OnClick", function() DBM:MoveSpecialWarning() end)

		local color0 = specArea:CreateColorSelect(64)
		color0:SetPoint('TOPLEFT', specArea.frame, "TOPLEFT", 20, -250)
		local color0text = specArea:CreateText(L.FontColor, 80)
		color0text:SetPoint("BOTTOM", color0, "TOP", 5, 4)
		local color0reset = specArea:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color0reset:SetPoint('TOP', color0, "BOTTOM", 5, -10)
		color0reset:SetScript("OnClick", function(self)
				DBM.Options.SpecialWarningFontCol[1] = DBM.DefaultOptions.SpecialWarningFontCol[1]
				DBM.Options.SpecialWarningFontCol[2] = DBM.DefaultOptions.SpecialWarningFontCol[2]
				DBM.Options.SpecialWarningFontCol[3] = DBM.DefaultOptions.SpecialWarningFontCol[3]
				color0:SetColorRGB(DBM.Options.SpecialWarningFontCol[1], DBM.Options.SpecialWarningFontCol[2], DBM.Options.SpecialWarningFontCol[3])
				DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning(nil, 1)
		end)
		do
			local firstshow = true
			color0:SetScript("OnShow", function(self)
					firstshow = true
					self:SetColorRGB(DBM.Options.SpecialWarningFontCol[1], DBM.Options.SpecialWarningFontCol[2], DBM.Options.SpecialWarningFontCol[3])
			end)
			color0:SetScript("OnColorSelect", function(self)
					if firstshow then firstshow = false return end
					DBM.Options.SpecialWarningFontCol[1] = select(1, self:GetColorRGB())
					DBM.Options.SpecialWarningFontCol[2] = select(2, self:GetColorRGB())
					DBM.Options.SpecialWarningFontCol[3] = select(3, self:GetColorRGB())
					color0text:SetTextColor(self:GetColorRGB())
					DBM:UpdateSpecialWarningOptions()
					--DBM:ShowTestSpecialWarning(nil, 1)
			end)
		end

		local Fonts = MixinSharedMedia3("font", {
			{	text	= DEFAULT,		value 	= standardFont,			font = standardFont	},
			{	text	= "Arial",			value 	= "Fonts\\ARIALN.TTF",			font = "Fonts\\ARIALN.TTF"		},
			{	text	= "Skurri",			value 	= "Fonts\\skurri.ttf",			font = "Fonts\\skurri.ttf"		},
			{	text	= "Morpheus",		value 	= "Fonts\\MORPHEUS.ttf",		font = "Fonts\\MORPHEUS.ttf"	}
		})

		local FontDropDown = specArea:CreateDropdown(L.FontType, Fonts, "DBM", "SpecialWarningFont", function(value)
			DBM.Options.SpecialWarningFont = value
			DBM:UpdateSpecialWarningOptions()
			DBM:ShowTestSpecialWarning(nil, 1)
		end)
		FontDropDown:SetPoint("TOPLEFT", specArea.frame, "TOPLEFT", 100, -235)

		local FontStyles = {
			{	text	= CL.NONE,					value 	= "None"						},
			{	text	= L.Outline,				value 	= "OUTLINE"						},
			{	text	= L.ThickOutline,			value 	= "THICKOUTLINE"				},
			{	text	= L.MonochromeOutline,		value 	= "MONOCHROME,OUTLINE"			},
			{	text	= L.MonochromeThickOutline,	value 	= "MONOCHROME,THICKOUTLINE"		}
		}

		local FontStyleDropDown = specArea:CreateDropdown(L.FontStyle, FontStyles, "DBM", "SpecialWarningFontStyle", function(value)
			DBM.Options.SpecialWarningFontStyle = value
			DBM:UpdateSpecialWarningOptions()
			DBM:ShowTestSpecialWarning(nil, 1)
		end)
		FontStyleDropDown:SetPoint("LEFT", FontDropDown, "RIGHT", 25, 0)

		local FontShadow = specArea:CreateCheckButton(L.FontShadow, nil, nil, "SpecialWarningFontShadow")
		FontShadow:SetScript("OnClick", function()
			DBM.Options.SpecialWarningFontShadow = not DBM.Options.SpecialWarningFontShadow
			DBM:UpdateSpecialWarningOptions()
			DBM:ShowTestSpecialWarning(nil, 1)
		end)
		FontShadow:SetPoint("LEFT", FontStyleDropDown, "RIGHT", -35, 25)

		local fontSizeSlider = specArea:CreateSlider(L.FontSize, 8, 60, 1, 150)
		fontSizeSlider:SetPoint('TOPLEFT', FontDropDown, "TOPLEFT", 20, -45)
		do
			local firstshow = true
			fontSizeSlider:SetScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.SpecialWarningFontSize2)
			end)
			fontSizeSlider:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.SpecialWarningFontSize2 = self:GetValue()
				DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning()--Pass with no sound, disabling both flash and sound play. This is a font slider so it only needs font
			end)
		end

		local durationSlider = specArea:CreateSlider(L.Warn_Duration, 1, 10, 0.5, 150)
		durationSlider:SetPoint("LEFT", fontSizeSlider, "RIGHT", 20, 0)
		do
			local firstshow = true
			durationSlider:SetScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.SpecialWarningDuration2)
			end)
			durationSlider:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.SpecialWarningDuration2 = self:GetValue()
				DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning()--Pass with no sound, disabling both flash and sound play. This is a duration slider so it only needs font
			end)
		end

		local Sounds = MixinSharedMedia3("sound", {
			{text = L.NoSound, value = ""},
			--Inject DBMs custom media that's not available to LibSharedMedia because it uses SoundKit Id (which LSM doesn't support)
			{sound = true, text = "AirHorn (DBM)", value = "Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.ogg"},
			{sound = true, text = "Algalon: Beware!", value = "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav"},
			{sound = true, text = "BB Wolf: Run Away", value = "Sound\\Creature\\HoodWolf\\HoodWolfTransformPlayer01.wav"},
			{sound = true, text = "C'Thun: You Will Die!", value = "Sound\\Creature\\CThun\\CThunYouWillDie.wav"},
			{sound = true, text = "Headless Horseman: Laugh", value = "Sound\\Creature\\HeadlessHorseman\\Horseman_Laugh_01.wav"},
			{sound = true, text = "Illidan: Not Prepared", value = "Sound\\Creature\\Illidan\\BLACK_Illidan_04.wav"},
			{sound = true, text = "Kaz'rogal: Marked", value = "Sound\\Creature\\KazRogal\\CAV_Kaz_Mark02.wav"},
			{sound = true, text = "Kil'Jaeden: Destruction", value = "Sound\\Creature\\KilJaeden\\KILJAEDEN02.wav"},
			{sound = true, text = "Loatheb: I see you", value = "Sound\\Creature\\Loathstare\\Loa_Naxx_Aggro02.wav"},
			{sound = true, text = "Lady Malande: Flee", value = "Sound\\Creature\\LadyMalande\\BLCKTMPLE_LadyMal_Aggro01.wav"},
			{sound = true, text = "Milhouse: Light You Up", value = "Sound\\Creature\\MillhouseManastorm\\TEMPEST_Millhouse_Pyro01.wav"},
			{sound = true, text = "Night Elf Bell", value = "Sound\\Doodad\\BellTollNightElf.wav"},
			{sound = true, text = "PvP Flag", value = "Sound\\Spells\\PVPFlagTaken.wav"},
			{sound = true, text = "Void Reaver: Marked", value = "Sound\\Creature\\VoidReaver\\TEMPEST_VoidRvr_Aggro01.wav"},
			{sound = true, text = "Yogg Saron: Laugh", value = "Sound\\Creature\\YoggSaron\\UR_YoggSaron_Slay01.wav"},
		})

		local specWarnOne = specPanel:CreateArea(L.SpecialWarnHeader1, nil, 160, true)

		local showbuttonOne = specWarnOne:CreateButton(L.SpecWarn_DemoButton, 120, 16)
		showbuttonOne:SetPoint('BOTTOMRIGHT', specWarnOne.frame, "BOTTOMRIGHT", -5, 5)
		showbuttonOne:SetNormalFontObject(GameFontNormalSmall)
		showbuttonOne:SetHighlightFontObject(GameFontNormalSmall)
		showbuttonOne:SetScript("OnClick", function() DBM:ShowTestSpecialWarning(nil, 1) end)

		local color1 = specWarnOne:CreateColorSelect(64)
		color1:SetPoint('TOPLEFT', specWarnOne.frame, "TOPLEFT", 20, -30)
		local color1text = specWarnOne:CreateText(L.SpecWarn_FlashColor:format(1), 140)
		color1text:SetPoint("BOTTOM", color1, "TOP", 5, 4)
		local color1reset = specWarnOne:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color1reset:SetPoint('TOP', color1, "BOTTOM", 5, -10)
		color1reset:SetScript("OnClick", function(self)
				DBM.Options.SpecialWarningFlashCol1[1] = DBM.DefaultOptions.SpecialWarningFlashCol1[1]
				DBM.Options.SpecialWarningFlashCol1[2] = DBM.DefaultOptions.SpecialWarningFlashCol1[2]
				DBM.Options.SpecialWarningFlashCol1[3] = DBM.DefaultOptions.SpecialWarningFlashCol1[3]
				color1:SetColorRGB(DBM.Options.SpecialWarningFlashCol1[1], DBM.Options.SpecialWarningFlashCol1[2], DBM.Options.SpecialWarningFlashCol1[3])
				DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning(nil, 1)
		end)
		do
			local firstshow = true
			color1:SetScript("OnShow", function(self)
					firstshow = true
					self:SetColorRGB(DBM.Options.SpecialWarningFlashCol1[1], DBM.Options.SpecialWarningFlashCol1[2], DBM.Options.SpecialWarningFlashCol1[3])
			end)
			color1:SetScript("OnColorSelect", function(self)
					if firstshow then firstshow = false return end
					DBM.Options.SpecialWarningFlashCol1[1] = select(1, self:GetColorRGB())
					DBM.Options.SpecialWarningFlashCol1[2] = select(2, self:GetColorRGB())
					DBM.Options.SpecialWarningFlashCol1[3] = select(3, self:GetColorRGB())
					color1text:SetTextColor(self:GetColorRGB())
					DBM:UpdateSpecialWarningOptions()
					--DBM:ShowTestSpecialWarning(nil, 1)
			end)
		end

		local SpecialWarnSoundDropDown = specWarnOne:CreateDropdown(L.SpecialWarnSoundOption, Sounds, "DBM", "SpecialWarningSound", function(value)
			DBM.Options.SpecialWarningSound = value
		end)
		SpecialWarnSoundDropDown:SetPoint("TOPLEFT", specWarnOne.frame, "TOPLEFT", 100, -28)
		local flashCheck1 = specWarnOne:CreateCheckButton(L.SpecWarn_Flash, nil, nil, "SpecialWarningFlash1")
		flashCheck1:SetPoint("BOTTOMLEFT", SpecialWarnSoundDropDown, "BOTTOMLEFT", 220, 4)

		local flashdurSlider = specWarnOne:CreateSlider(L.SpecWarn_FlashDur, 0.2, 2, 0.2, 120)   -- (text , min_value , max_value , step , width)
		flashdurSlider:SetPoint('TOPLEFT', SpecialWarnSoundDropDown, "TOPLEFT", 20, -45)
		do
			local firstshow = true
			flashdurSlider:HookScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.SpecialWarningFlashDura1)
			end)
			flashdurSlider:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.SpecialWarningFlashDura1 = self:GetValue()
				--DBM:ShowTestSpecialWarning(nil, 1, true)--Pass with flash but no sound
			end)
		end

		local flashdalphaSlider = specWarnOne:CreateSlider(L.SpecWarn_FlashAlpha, 0.1, 1, 0.1, 120)   -- (text , min_value , max_value , step , width)
		flashdalphaSlider:SetPoint('BOTTOMLEFT', flashdurSlider, "BOTTOMLEFT", 150, -0)
		do
			local firstshow = true
			flashdalphaSlider:HookScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.SpecialWarningFlashAlph1)
			end)
			flashdalphaSlider:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.SpecialWarningFlashAlph1 = self:GetValue()
				--DBM:ShowTestSpecialWarning(nil, 1, true)--Pass with flash but no sound
			end)
		end

		local flashRepSlider = specWarnOne:CreateSlider(L.SpecWarn_FlashFrameRepeat, 1, 4, 1, 120)
		flashRepSlider:SetPoint('TOPLEFT', flashdurSlider, "TOPLEFT", 70, -45)
		flashRepSlider:HookScript("OnShow", function(self) self:SetValue(mfloor(DBM.Options.SpecialWarningFlashCount1)) end)
		flashRepSlider:HookScript("OnValueChanged", function(self)
			DBM.Options.SpecialWarningFlashCount1 = mfloor(self:GetValue())
			--self:SetValue(DBM.Options.SpecialWarningFlashCount1)
		end)

		--Special Warning Area 2
		local specWarnTwo = specPanel:CreateArea(L.SpecialWarnHeader2, nil, 160, true)

		local showbuttonTwo = specWarnTwo:CreateButton(L.SpecWarn_DemoButton, 120, 16)
		showbuttonTwo:SetPoint('BOTTOMRIGHT', specWarnTwo.frame, "BOTTOMRIGHT", -5, 5)
		showbuttonTwo:SetNormalFontObject(GameFontNormalSmall)
		showbuttonTwo:SetHighlightFontObject(GameFontNormalSmall)
		showbuttonTwo:SetScript("OnClick", function() DBM:ShowTestSpecialWarning(nil, 2) end)

		local color2 = specWarnTwo:CreateColorSelect(64)
		color2:SetPoint('TOPLEFT', specWarnTwo.frame, "TOPLEFT", 20, -30)
		local color2text = specWarnTwo:CreateText(L.SpecWarn_FlashColor:format(2), 140)
		color2text:SetPoint("BOTTOM", color2, "TOP", 5, 4)
		local color2reset = specWarnTwo:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color2reset:SetPoint('TOP', color2, "BOTTOM", 5, -10)
		color2reset:SetScript("OnClick", function(self)
				DBM.Options.SpecialWarningFlashCol2[1] = DBM.DefaultOptions.SpecialWarningFlashCol2[1]
				DBM.Options.SpecialWarningFlashCol2[2] = DBM.DefaultOptions.SpecialWarningFlashCol2[2]
				DBM.Options.SpecialWarningFlashCol2[3] = DBM.DefaultOptions.SpecialWarningFlashCol2[3]
				color2:SetColorRGB(DBM.Options.SpecialWarningFlashCol2[1], DBM.Options.SpecialWarningFlashCol2[2], DBM.Options.SpecialWarningFlashCol2[3])
				--DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning(nil, 2)
		end)
		do
			local firstshow = true
			color2:SetScript("OnShow", function(self)
					firstshow = true
					self:SetColorRGB(DBM.Options.SpecialWarningFlashCol2[1], DBM.Options.SpecialWarningFlashCol2[2], DBM.Options.SpecialWarningFlashCol2[3])
			end)
			color2:SetScript("OnColorSelect", function(self)
					if firstshow then firstshow = false return end
					DBM.Options.SpecialWarningFlashCol2[1] = select(1, self:GetColorRGB())
					DBM.Options.SpecialWarningFlashCol2[2] = select(2, self:GetColorRGB())
					DBM.Options.SpecialWarningFlashCol2[3] = select(3, self:GetColorRGB())
					color2text:SetTextColor(self:GetColorRGB())
					DBM:UpdateSpecialWarningOptions()
					--DBM:ShowTestSpecialWarning(nil, 2)
			end)
		end

		local SpecialWarnSoundDropDown2 = specWarnTwo:CreateDropdown(L.SpecialWarnSoundOption, Sounds, "DBM", "SpecialWarningSound2", function(value)
			DBM.Options.SpecialWarningSound2 = value
		end)
		SpecialWarnSoundDropDown2:SetPoint("TOPLEFT", specWarnTwo.frame, "TOPLEFT", 100, -28)
		local flashCheck2 = specWarnTwo:CreateCheckButton(L.SpecWarn_Flash, nil, nil, "SpecialWarningFlash2")
		flashCheck2:SetPoint("BOTTOMLEFT", SpecialWarnSoundDropDown2, "BOTTOMLEFT", 220, 4)

		local flashdurSlider2 = specWarnTwo:CreateSlider(L.SpecWarn_FlashDur, 0.2, 2, 0.2, 120)   -- (text , min_value , max_value , step , width)
		flashdurSlider2:SetPoint('TOPLEFT', SpecialWarnSoundDropDown2, "TOPLEFT", 20, -45)
		do
			local firstshow = true
			flashdurSlider2:HookScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.SpecialWarningFlashDura2)
			end)
			flashdurSlider2:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.SpecialWarningFlashDura2 = self:GetValue()
				--DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning(nil, 2, true)--Pass with flash but no sound
			end)
		end

		local flashdalphaSlider2 = specWarnTwo:CreateSlider(L.SpecWarn_FlashAlpha, 0.1, 1, 0.1, 120)   -- (text , min_value , max_value , step , width)
		flashdalphaSlider2:SetPoint('BOTTOMLEFT', flashdurSlider2, "BOTTOMLEFT", 150, -0)
		do
			local firstshow = true
			flashdalphaSlider2:HookScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.SpecialWarningFlashAlph2)
			end)
			flashdalphaSlider2:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.SpecialWarningFlashAlph2 = self:GetValue()
				--DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning(nil, 2, true)--Pass with flash but no sound
			end)
		end

		local flashRepSlider2 = specWarnOne:CreateSlider(L.SpecWarn_FlashFrameRepeat, 1, 4, 1, 120)
		flashRepSlider2:SetPoint('TOPLEFT', flashdurSlider2, "TOPLEFT", 60, -45)
		flashRepSlider2:HookScript("OnShow", function(self) self:SetValue(mfloor(DBM.Options.SpecialWarningFlashCount2)) end)
		flashRepSlider2:HookScript("OnValueChanged", function(self)
			DBM.Options.SpecialWarningFlashCount2 = mfloor(self:GetValue())
			DBM:UpdateSpecialWarningOptions()
			--self:SetValue(DBM.Options.SpecialWarningFlashCount2)
		end)

		--Special Warning Area 3
		local specWarnThree = specPanel:CreateArea(L.SpecialWarnHeader3, nil, 160, true)

		local showbuttonThree = specWarnThree:CreateButton(L.SpecWarn_DemoButton, 120, 16)
		showbuttonThree:SetPoint('BOTTOMRIGHT', specWarnThree.frame, "BOTTOMRIGHT", -5, 5)
		showbuttonThree:SetNormalFontObject(GameFontNormalSmall)
		showbuttonThree:SetHighlightFontObject(GameFontNormalSmall)
		showbuttonThree:SetScript("OnClick", function() DBM:ShowTestSpecialWarning(nil, 3) end)

		local color3 = specWarnThree:CreateColorSelect(64)
		color3:SetPoint('TOPLEFT', specWarnThree.frame, "TOPLEFT", 20, -30)
		local color3text = specWarnThree:CreateText(L.SpecWarn_FlashColor:format(3), 140)
		color3text:SetPoint("BOTTOM", color3, "TOP", 5, 4)
		local color3reset = specWarnThree:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color3reset:SetPoint('TOP', color3, "BOTTOM", 5, -10)
		color3reset:SetScript("OnClick", function(self)
				DBM.Options.SpecialWarningFlashCol3[1] = DBM.DefaultOptions.SpecialWarningFlashCol3[1]
				DBM.Options.SpecialWarningFlashCol3[2] = DBM.DefaultOptions.SpecialWarningFlashCol3[2]
				DBM.Options.SpecialWarningFlashCol3[3] = DBM.DefaultOptions.SpecialWarningFlashCol3[3]
				color3:SetColorRGB(DBM.Options.SpecialWarningFlashCol3[1], DBM.Options.SpecialWarningFlashCol3[2], DBM.Options.SpecialWarningFlashCol3[3])
				DBM:UpdateSpecialWarningOptions()
				DBM:ShowTestSpecialWarning(nil, 3)
		end)
		do
			local firstshow = true
			color3:SetScript("OnShow", function(self)
					firstshow = true
					self:SetColorRGB(DBM.Options.SpecialWarningFlashCol3[1], DBM.Options.SpecialWarningFlashCol3[2], DBM.Options.SpecialWarningFlashCol3[3])
			end)
			color3:SetScript("OnColorSelect", function(self)
					if firstshow then firstshow = false return end
					DBM.Options.SpecialWarningFlashCol3[1] = select(1, self:GetColorRGB())
					DBM.Options.SpecialWarningFlashCol3[2] = select(2, self:GetColorRGB())
					DBM.Options.SpecialWarningFlashCol3[3] = select(3, self:GetColorRGB())
					color3text:SetTextColor(self:GetColorRGB())
					DBM:UpdateSpecialWarningOptions()
					DBM:ShowTestSpecialWarning(nil, 3)
			end)
		end

		local SpecialWarnSoundDropDown3 = specWarnThree:CreateDropdown(L.SpecialWarnSoundOption, Sounds, "DBM", "SpecialWarningSound3", function(value)
			DBM.Options.SpecialWarningSound3 = value
		end)
		SpecialWarnSoundDropDown3:SetPoint("TOPLEFT", specWarnThree.frame, "TOPLEFT", 100, -28)
		local flashCheck3 = specWarnThree:CreateCheckButton(L.SpecWarn_Flash, nil, nil, "SpecialWarningFlash3")
		flashCheck3:SetPoint("BOTTOMLEFT", SpecialWarnSoundDropDown3, "BOTTOMLEFT", 220, 4)

		local flashdurSlider3 = specWarnThree:CreateSlider(L.SpecWarn_FlashDur, 0.2, 2, 0.2, 120)   -- (text , min_value , max_value , step , width)
		flashdurSlider3:SetPoint('TOPLEFT', SpecialWarnSoundDropDown3, "TOPLEFT", 20, -45)
		do
			local firstshow = true
			flashdurSlider3:HookScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.SpecialWarningFlashDura3)
			end)
			flashdurSlider3:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.SpecialWarningFlashDura3 = self:GetValue()
				--DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning(nil, 3, true)--Pass with flash but no sound
			end)
		end

		local flashdalphaSlider3 = specWarnThree:CreateSlider(L.SpecWarn_FlashAlpha, 0.1, 1, 0.1, 120)   -- (text , min_value , max_value , step , width)
		flashdalphaSlider3:SetPoint('BOTTOMLEFT', flashdurSlider3, "BOTTOMLEFT", 150, -0)
		do
			local firstshow = true
			flashdalphaSlider3:HookScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.SpecialWarningFlashAlph3)
			end)
			flashdalphaSlider3:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.SpecialWarningFlashAlph3 = self:GetValue()
				--DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning(nil, 3, true)--Pass with flash but no sound
			end)
		end

		local flashRepSlider3 = specWarnOne:CreateSlider(L.SpecWarn_FlashFrameRepeat, 1, 4, 1, 120)
		flashRepSlider3:SetPoint('TOPLEFT', flashdurSlider3, "TOPLEFT", 70, -45)
		flashRepSlider3:HookScript("OnShow", function(self) self:SetValue(mfloor(DBM.Options.SpecialWarningFlashCount3)) end)
		flashRepSlider3:HookScript("OnValueChanged", function(self)
			DBM.Options.SpecialWarningFlashCount3 = mfloor(self:GetValue())
			DBM:UpdateSpecialWarningOptions()
			--self:SetValue(DBM.Options.SpecialWarningFlashCount3)
		end)

		local specWarnFour = specPanel:CreateArea(L.SpecialWarnHeader4, nil, 160, true)

		local showbuttonFour = specWarnFour:CreateButton(L.SpecWarn_DemoButton, 120, 16)
		showbuttonFour:SetPoint('BOTTOMRIGHT', specWarnFour.frame, "BOTTOMRIGHT", -5, 5)
		showbuttonFour:SetNormalFontObject(GameFontNormalSmall)
		showbuttonFour:SetHighlightFontObject(GameFontNormalSmall)
		showbuttonFour:SetScript("OnClick", function() DBM:ShowTestSpecialWarning(nil, 4) end)

		local color4 = specWarnFour:CreateColorSelect(64)
		color4:SetPoint('TOPLEFT', specWarnFour.frame, "TOPLEFT", 20, -30)
		local color4text = specWarnFour:CreateText(L.SpecWarn_FlashColor:format(4), 140)
		color4text:SetPoint("BOTTOM", color4, "TOP", 5, 4)
		local color4reset = specWarnFour:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color4reset:SetPoint('TOP', color4, "BOTTOM", 5, -10)
		color4reset:SetScript("OnClick", function(self)
				DBM.Options.SpecialWarningFlashCol4[1] = DBM.DefaultOptions.SpecialWarningFlashCol4[1]
				DBM.Options.SpecialWarningFlashCol4[2] = DBM.DefaultOptions.SpecialWarningFlashCol4[2]
				DBM.Options.SpecialWarningFlashCol4[3] = DBM.DefaultOptions.SpecialWarningFlashCol4[3]
				color4:SetColorRGB(DBM.Options.SpecialWarningFlashCol4[1], DBM.Options.SpecialWarningFlashCol4[2], DBM.Options.SpecialWarningFlashCol4[3])
				DBM:UpdateSpecialWarningOptions()
				DBM:ShowTestSpecialWarning(nil, 4)
		end)
		do
			local firstshow = true
			color4:SetScript("OnShow", function(self)
					firstshow = true
					self:SetColorRGB(DBM.Options.SpecialWarningFlashCol4[1], DBM.Options.SpecialWarningFlashCol4[2], DBM.Options.SpecialWarningFlashCol4[3])
			end)
			color4:SetScript("OnColorSelect", function(self)
					if firstshow then firstshow = false return end
					DBM.Options.SpecialWarningFlashCol4[1] = select(1, self:GetColorRGB())
					DBM.Options.SpecialWarningFlashCol4[2] = select(2, self:GetColorRGB())
					DBM.Options.SpecialWarningFlashCol4[3] = select(3, self:GetColorRGB())
					color4text:SetTextColor(self:GetColorRGB())
					DBM:UpdateSpecialWarningOptions()
					DBM:ShowTestSpecialWarning(nil, 4)
			end)
		end

		local SpecialWarnSoundDropDown4 = specWarnFour:CreateDropdown(L.SpecialWarnSoundOption, Sounds, "DBM", "SpecialWarningSound4", function(value)
			DBM.Options.SpecialWarningSound4 = value
		end)
		SpecialWarnSoundDropDown4:SetPoint("TOPLEFT", specWarnFour.frame, "TOPLEFT", 100, -28)
		local flashCheck4 = specWarnFour:CreateCheckButton(L.SpecWarn_Flash, nil, nil, "SpecialWarningFlash4")
		flashCheck4:SetPoint("BOTTOMLEFT", SpecialWarnSoundDropDown4, "BOTTOMLEFT", 220, 4)

		local flashdurSlider4 = specWarnFour:CreateSlider(L.SpecWarn_FlashDur, 0.2, 2, 0.2, 120)   -- (text , min_value , max_value , step , width)
		flashdurSlider4:SetPoint('TOPLEFT', SpecialWarnSoundDropDown4, "TOPLEFT", 20, -45)
		do
			local firstshow = true
			flashdurSlider4:HookScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.SpecialWarningFlashDura4)
			end)
			flashdurSlider4:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.SpecialWarningFlashDura4 = self:GetValue()
				--DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning(nil, 4, true)--Pass with flash but no sound
			end)
		end

		local flashdalphaSlider4 = specWarnFour:CreateSlider(L.SpecWarn_FlashAlpha, 0.1, 1, 0.1, 120)   -- (text , min_value , max_value , step , width)
		flashdalphaSlider4:SetPoint('BOTTOMLEFT', flashdurSlider4, "BOTTOMLEFT", 150, -0)
		do
			local firstshow = true
			flashdalphaSlider4:HookScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.SpecialWarningFlashAlph4)
			end)
			flashdalphaSlider4:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.SpecialWarningFlashAlph4 = self:GetValue()
				--DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning(nil, 4, true)--Pass with flash but no sound
			end)
		end

		local flashRepSlider4 = specWarnOne:CreateSlider(L.SpecWarn_FlashFrameRepeat, 1, 4, 1, 120)
		flashRepSlider4:SetPoint('TOPLEFT', flashdurSlider4, "TOPLEFT", 70, -45)
		flashRepSlider4:HookScript("OnShow", function(self) self:SetValue(mfloor(DBM.Options.SpecialWarningFlashCount4)) end)
		flashRepSlider4:HookScript("OnValueChanged", function(self)
			DBM.Options.SpecialWarningFlashCount4 = mfloor(self:GetValue())
			DBM:UpdateSpecialWarningOptions()
			--self:SetValue(DBM.Options.SpecialWarningFlashCount4)
		end)

		local specWarnFive = specPanel:CreateArea(L.SpecialWarnHeader5, nil, 160, true)

		local showbuttonFive = specWarnFive:CreateButton(L.SpecWarn_DemoButton, 120, 16)
		showbuttonFive:SetPoint('BOTTOMRIGHT', specWarnFive.frame, "BOTTOMRIGHT", -5, 5)
		showbuttonFive:SetNormalFontObject(GameFontNormalSmall)
		showbuttonFive:SetHighlightFontObject(GameFontNormalSmall)
		showbuttonFive:SetScript("OnClick", function() DBM:ShowTestSpecialWarning(nil, 5) end)

		local color5 = specWarnFive:CreateColorSelect(64)
		color5:SetPoint('TOPLEFT', specWarnFive.frame, "TOPLEFT", 20, -30)
		local color5text = specWarnFive:CreateText(L.SpecWarn_FlashColor:format(5), 140)
		color5text:SetPoint("BOTTOM", color5, "TOP", 5, 4)
		local color5reset = specWarnFive:CreateButton(L.Reset, 64, 10, nil, GameFontNormalSmall)
		color5reset:SetPoint('TOP', color5, "BOTTOM", 5, -10)
		color5reset:SetScript("OnClick", function(self)
				DBM.Options.SpecialWarningFlashCol5[1] = DBM.DefaultOptions.SpecialWarningFlashCol5[1]
				DBM.Options.SpecialWarningFlashCol5[2] = DBM.DefaultOptions.SpecialWarningFlashCol5[2]
				DBM.Options.SpecialWarningFlashCol5[3] = DBM.DefaultOptions.SpecialWarningFlashCol5[3]
				color5:SetColorRGB(DBM.Options.SpecialWarningFlashCol5[1], DBM.Options.SpecialWarningFlashCol5[2], DBM.Options.SpecialWarningFlashCol5[3])
				DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning(nil, 5)
		end)
		do
			local firstshow = true
			color5:SetScript("OnShow", function(self)
					firstshow = true
					self:SetColorRGB(DBM.Options.SpecialWarningFlashCol5[1], DBM.Options.SpecialWarningFlashCol5[2], DBM.Options.SpecialWarningFlashCol5[3])
			end)
			color5:SetScript("OnColorSelect", function(self)
					if firstshow then firstshow = false return end
					DBM.Options.SpecialWarningFlashCol5[1] = select(1, self:GetColorRGB())
					DBM.Options.SpecialWarningFlashCol5[2] = select(2, self:GetColorRGB())
					DBM.Options.SpecialWarningFlashCol5[3] = select(3, self:GetColorRGB())
					color5text:SetTextColor(self:GetColorRGB())
					DBM:UpdateSpecialWarningOptions()
					--DBM:ShowTestSpecialWarning(nil, 5)
			end)
		end

		local SpecialWarnSoundDropDown5 = specWarnFive:CreateDropdown(L.SpecialWarnSoundOption, Sounds, "DBM", "SpecialWarningSound5", function(value)
			DBM.Options.SpecialWarningSound5 = value
		end)
		SpecialWarnSoundDropDown5:SetPoint("TOPLEFT", specWarnFive.frame, "TOPLEFT", 100, -28)
		local flashCheck5 = specWarnFive:CreateCheckButton(L.SpecWarn_Flash, nil, nil, "SpecialWarningFlash5")
		flashCheck5:SetPoint("BOTTOMLEFT", SpecialWarnSoundDropDown5, "BOTTOMLEFT", 220, 4)

		local flashdurSlider5 = specWarnFive:CreateSlider(L.SpecWarn_FlashDur, 0.2, 2, 0.2, 120)   -- (text , min_value , max_value , step , width)
		flashdurSlider5:SetPoint('TOPLEFT', SpecialWarnSoundDropDown5, "TOPLEFT", 20, -45)
		do
			local firstshow = true
			flashdurSlider5:HookScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.SpecialWarningFlashDura5)
			end)
			flashdurSlider5:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.SpecialWarningFlashDura5 = self:GetValue()
				--DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning(nil, 5, true)--Pass with flash but no sound
			end)
		end

		local flashdalphaSlider5 = specWarnFive:CreateSlider(L.SpecWarn_FlashAlpha, 0.1, 1, 0.1, 120)   -- (text , min_value , max_value , step , width)
		flashdalphaSlider5:SetPoint('BOTTOMLEFT', flashdurSlider5, "BOTTOMLEFT", 150, -0)
		do
			local firstshow = true
			flashdalphaSlider5:HookScript("OnShow", function(self)
				firstshow = true
				self:SetValue(DBM.Options.SpecialWarningFlashAlph5)
			end)
			flashdalphaSlider5:HookScript("OnValueChanged", function(self)
				if firstshow then firstshow = false return end
				DBM.Options.SpecialWarningFlashAlph5 = self:GetValue()
				--DBM:UpdateSpecialWarningOptions()
				--DBM:ShowTestSpecialWarning(nil, 5, true)--Pass with flash but no sound
			end)
		end

		local flashRepSlider5 = specWarnOne:CreateSlider(L.SpecWarn_FlashFrameRepeat, 1, 4, 1, 120)
		flashRepSlider5:SetPoint('TOPLEFT', flashdurSlider5, "TOPLEFT", 70, -45)
		flashRepSlider5:HookScript("OnShow", function(self) self:SetValue(mfloor(DBM.Options.SpecialWarningFlashCount5)) end)
		flashRepSlider5:HookScript("OnValueChanged", function(self)
			DBM.Options.SpecialWarningFlashCount5 = mfloor(self:GetValue())
			DBM:UpdateSpecialWarningOptions()
			--self:SetValue(DBM.DefaultOptions.SpecialWarningFlashCount5)
		end)

		local resetbutton = specArea:CreateButton(L.SpecWarn_ResetMe, 120, 16)
		resetbutton:SetPoint('BOTTOMRIGHT', specArea.frame, "BOTTOMRIGHT", -5, 5)
		resetbutton:SetNormalFontObject(GameFontNormalSmall)
		resetbutton:SetHighlightFontObject(GameFontNormalSmall)
		resetbutton:SetScript("OnClick", function()
			--Set Options
			DBM.Options.SWarnNameInNote = DBM.DefaultOptions.SWarnNameInNote
			DBM.Options.SpecialWarningFont = DBM.DefaultOptions.SpecialWarningFont
			DBM.Options.SpecialWarningSound = DBM.DefaultOptions.SpecialWarningSound
			DBM.Options.SpecialWarningSound2 = DBM.DefaultOptions.SpecialWarningSound2
			DBM.Options.SpecialWarningSound3 = DBM.DefaultOptions.SpecialWarningSound3
			DBM.Options.SpecialWarningSound4 = DBM.DefaultOptions.SpecialWarningSound4
			DBM.Options.SpecialWarningSound5 = DBM.DefaultOptions.SpecialWarningSound5
			DBM.Options.SpecialWarningFlash1 = DBM.DefaultOptions.SpecialWarningFlash1
			DBM.Options.SpecialWarningFlash2 = DBM.DefaultOptions.SpecialWarningFlash2
			DBM.Options.SpecialWarningFlash3 = DBM.DefaultOptions.SpecialWarningFlash3
			DBM.Options.SpecialWarningFlash4 = DBM.DefaultOptions.SpecialWarningFlash4
			DBM.Options.SpecialWarningFlash5 = DBM.DefaultOptions.SpecialWarningFlash5
			DBM.Options.SpecialWarningFlashCount1 = DBM.DefaultOptions.SpecialWarningFlashCount1
			DBM.Options.SpecialWarningFlashCount2 = DBM.DefaultOptions.SpecialWarningFlashCount2
			DBM.Options.SpecialWarningFlashCount3 = DBM.DefaultOptions.SpecialWarningFlashCount3
			DBM.Options.SpecialWarningFlashCount4 = DBM.DefaultOptions.SpecialWarningFlashCount4
			DBM.Options.SpecialWarningFlashCount5 = DBM.DefaultOptions.SpecialWarningFlashCount5
			DBM.Options.SpecialWarningFontSize2 = DBM.DefaultOptions.SpecialWarningFontSize2
			DBM.Options.SpecialWarningFlashCol1[1] = DBM.DefaultOptions.SpecialWarningFlashCol1[1]
			DBM.Options.SpecialWarningFlashCol1[2] = DBM.DefaultOptions.SpecialWarningFlashCol1[2]
			DBM.Options.SpecialWarningFlashCol1[3] = DBM.DefaultOptions.SpecialWarningFlashCol1[3]
			DBM.Options.SpecialWarningFlashCol2[1] = DBM.DefaultOptions.SpecialWarningFlashCol2[1]
			DBM.Options.SpecialWarningFlashCol2[2] = DBM.DefaultOptions.SpecialWarningFlashCol2[2]
			DBM.Options.SpecialWarningFlashCol2[3] = DBM.DefaultOptions.SpecialWarningFlashCol2[3]
			DBM.Options.SpecialWarningFlashCol3[1] = DBM.DefaultOptions.SpecialWarningFlashCol3[1]
			DBM.Options.SpecialWarningFlashCol3[2] = DBM.DefaultOptions.SpecialWarningFlashCol3[2]
			DBM.Options.SpecialWarningFlashCol3[3] = DBM.DefaultOptions.SpecialWarningFlashCol3[3]
			DBM.Options.SpecialWarningFlashCol4[1] = DBM.DefaultOptions.SpecialWarningFlashCol4[1]
			DBM.Options.SpecialWarningFlashCol4[2] = DBM.DefaultOptions.SpecialWarningFlashCol4[2]
			DBM.Options.SpecialWarningFlashCol4[3] = DBM.DefaultOptions.SpecialWarningFlashCol4[3]
			DBM.Options.SpecialWarningFlashCol5[1] = DBM.DefaultOptions.SpecialWarningFlashCol5[1]
			DBM.Options.SpecialWarningFlashCol5[2] = DBM.DefaultOptions.SpecialWarningFlashCol5[2]
			DBM.Options.SpecialWarningFlashCol5[3] = DBM.DefaultOptions.SpecialWarningFlashCol5[3]
			DBM.Options.SpecialWarningFlashDura1 = DBM.DefaultOptions.SpecialWarningFlashDura1
			DBM.Options.SpecialWarningFlashDura2 = DBM.DefaultOptions.SpecialWarningFlashDura2
			DBM.Options.SpecialWarningFlashDura3 = DBM.DefaultOptions.SpecialWarningFlashDura3
			DBM.Options.SpecialWarningFlashDura4 = DBM.DefaultOptions.SpecialWarningFlashDura4
			DBM.Options.SpecialWarningFlashDura5 = DBM.DefaultOptions.SpecialWarningFlashDura5
			DBM.Options.SpecialWarningFlashAlph1 = DBM.DefaultOptions.SpecialWarningFlashAlph1
			DBM.Options.SpecialWarningFlashAlph2 = DBM.DefaultOptions.SpecialWarningFlashAlph2
			DBM.Options.SpecialWarningFlashAlph3 = DBM.DefaultOptions.SpecialWarningFlashAlph3
			DBM.Options.SpecialWarningFlashAlph4 = DBM.DefaultOptions.SpecialWarningFlashAlph4
			DBM.Options.SpecialWarningFlashAlph5 = DBM.DefaultOptions.SpecialWarningFlashAlph5
			DBM.Options.SpecialWarningPoint = DBM.DefaultOptions.SpecialWarningPoint
			DBM.Options.SpecialWarningX = DBM.DefaultOptions.SpecialWarningX
			DBM.Options.SpecialWarningY = DBM.DefaultOptions.SpecialWarningY
			--Set UI visuals
			check1:SetChecked(DBM.Options.SWarnClassColor)
			check2:SetChecked(DBM.Options.SWarningAlphabetical)
			check3:SetChecked(DBM.Options.ShowSWarningsInChat)
			check4:SetChecked(DBM.Options.SWarnNameInNote)
			check5:SetChecked(DBM.Options.SpecialWarningIcon)
			check6:SetChecked(DBM.Options.SpecialWarningShortText)
			FontDropDown:SetSelectedValue(DBM.Options.SpecialWarningFont)
			SpecialWarnSoundDropDown:SetSelectedValue(DBM.Options.SpecialWarningSound)
			SpecialWarnSoundDropDown2:SetSelectedValue(DBM.Options.SpecialWarningSound2)
			SpecialWarnSoundDropDown3:SetSelectedValue(DBM.Options.SpecialWarningSound3)
			SpecialWarnSoundDropDown4:SetSelectedValue(DBM.Options.SpecialWarningSound4)
			SpecialWarnSoundDropDown5:SetSelectedValue(DBM.Options.SpecialWarningSound5)
			fontSizeSlider:SetValue(DBM.DefaultOptions.SpecialWarningFontSize2)
			color0:SetColorRGB(DBM.Options.SpecialWarningFontCol[1], DBM.Options.SpecialWarningFontCol[2], DBM.Options.SpecialWarningFontCol[3])
			color1:SetColorRGB(DBM.Options.SpecialWarningFlashCol1[1], DBM.Options.SpecialWarningFlashCol1[2], DBM.Options.SpecialWarningFlashCol1[3])
			color2:SetColorRGB(DBM.Options.SpecialWarningFlashCol2[1], DBM.Options.SpecialWarningFlashCol2[2], DBM.Options.SpecialWarningFlashCol2[3])
			color3:SetColorRGB(DBM.Options.SpecialWarningFlashCol3[1], DBM.Options.SpecialWarningFlashCol3[2], DBM.Options.SpecialWarningFlashCol3[3])
			color4:SetColorRGB(DBM.Options.SpecialWarningFlashCol4[1], DBM.Options.SpecialWarningFlashCol4[2], DBM.Options.SpecialWarningFlashCol4[3])
			color5:SetColorRGB(DBM.Options.SpecialWarningFlashCol5[1], DBM.Options.SpecialWarningFlashCol5[2], DBM.Options.SpecialWarningFlashCol5[3])
			flashCheck1:SetChecked(DBM.Options.SpecialWarningFlash1)
			flashCheck2:SetChecked(DBM.Options.SpecialWarningFlash2)
			flashCheck3:SetChecked(DBM.Options.SpecialWarningFlash3)
			flashCheck4:SetChecked(DBM.Options.SpecialWarningFlash4)
			flashCheck5:SetChecked(DBM.Options.SpecialWarningFlash5)
			flashdurSlider:SetValue(DBM.DefaultOptions.SpecialWarningFlashDura1)
			flashdurSlider2:SetValue(DBM.DefaultOptions.SpecialWarningFlashDura2)
			flashdurSlider3:SetValue(DBM.DefaultOptions.SpecialWarningFlashDura3)
			flashdurSlider4:SetValue(DBM.DefaultOptions.SpecialWarningFlashDura4)
			flashdurSlider5:SetValue(DBM.DefaultOptions.SpecialWarningFlashDura5)
			flashdalphaSlider:SetValue(DBM.DefaultOptions.SpecialWarningFlashAlph1)
			flashdalphaSlider2:SetValue(DBM.DefaultOptions.SpecialWarningFlashAlph2)
			flashdalphaSlider3:SetValue(DBM.DefaultOptions.SpecialWarningFlashAlph3)
			flashdalphaSlider4:SetValue(DBM.DefaultOptions.SpecialWarningFlashAlph4)
			flashdalphaSlider5:SetValue(DBM.DefaultOptions.SpecialWarningFlashAlph5)
			flashRepSlider:SetValue(DBM.DefaultOptions.SpecialWarningFlashCount1)
			flashRepSlider2:SetValue(DBM.DefaultOptions.SpecialWarningFlashCount2)
			flashRepSlider3:SetValue(DBM.DefaultOptions.SpecialWarningFlashCount3)
			flashRepSlider4:SetValue(DBM.DefaultOptions.SpecialWarningFlashCount4)
			flashRepSlider5:SetValue(DBM.DefaultOptions.SpecialWarningFlashCount5)
			DBM:UpdateSpecialWarningOptions()
		end)

		specPanel:SetMyOwnHeight()
	end

	do
		local spokenAlertsPanel 	= DBM_GUI_Frame:CreateNewPanel(L.Panel_SpokenAlerts, "option")
		local spokenGeneralArea		= spokenAlertsPanel:CreateArea(L.Area_VoiceSelection, nil, 105, true)

		local CountSoundDropDown = spokenGeneralArea:CreateDropdown(L.CountdownVoice, DBM.Counts, "DBM", "CountdownVoice", function(value)
			DBM.Options.CountdownVoice = value
			DBM:PlayCountSound(1, DBM.Options.CountdownVoice)
			DBM:BuildVoiceCountdownCache()
		end, 180)
		CountSoundDropDown:SetPoint("TOPLEFT", spokenGeneralArea.frame, "TOPLEFT", 0, -20)

		local CountSoundDropDown2 = spokenGeneralArea:CreateDropdown(L.CountdownVoice2, DBM.Counts, "DBM", "CountdownVoice2", function(value)
			DBM.Options.CountdownVoice2 = value
			DBM:PlayCountSound(1, DBM.Options.CountdownVoice2)
			DBM:BuildVoiceCountdownCache()
		end, 180)
		CountSoundDropDown2:SetPoint("LEFT", CountSoundDropDown, "RIGHT", 45, 0)

		local CountSoundDropDown3 = spokenGeneralArea:CreateDropdown(L.CountdownVoice3, DBM.Counts, "DBM", "CountdownVoice3", function(value)
			DBM.Options.CountdownVoice3 = value
			DBM:PlayCountSound(1, DBM.Options.CountdownVoice3)
			DBM:BuildVoiceCountdownCache()
		end, 180)
		CountSoundDropDown3:SetPoint("TOPLEFT", CountSoundDropDown, "TOPLEFT", 0, -45)

		local VoiceDropDown = spokenGeneralArea:CreateDropdown(L.VoicePackChoice, DBM.Voices, "DBM", "ChosenVoicePack", function(value)
			DBM.Options.ChosenVoicePack = value
			DBM:Debug("DBM.Options.ChosenVoicePack is set to "..DBM.Options.ChosenVoicePack)
			DBM:CheckVoicePackVersion(value)
		end, 180)
		VoiceDropDown:SetPoint("TOPLEFT", CountSoundDropDown2, "TOPLEFT", 0, -45)

		local voiceFilterArea		= spokenAlertsPanel:CreateArea(L.Area_VoicePackOptions, nil, 115, true)
		local VPF1 					= voiceFilterArea:CreateCheckButton(L.SpecWarn_AlwaysVoice, true, nil, "AlwaysPlayVoice")
		local voiceSWOptions = {
			{	text	= L.SWFNever,		value 	= "None"},
			{	text	= L.SWFDefaultOnly,	value 	= "DefaultOnly"},
			{	text	= L.SWFAll,			value 	= "All"},
		}
		local SWFilterDropDown		= voiceFilterArea:CreateDropdown(L.SpecWarn_NoSoundsWVoice, voiceSWOptions, "DBM", "VoiceOverSpecW2", function(value)
			DBM.Options.VoiceOverSpecW2 = value
		end, 420)
		SWFilterDropDown:SetPoint("TOPLEFT", VPF1, "TOPLEFT", 0, -65)

		local VPUrlArea1		= spokenAlertsPanel:CreateArea(L.Area_GetVEM, nil, 28, true)
		local VPDownloadUrl1	= VPUrlArea1:CreateText(L.VEMDownload, 405, nil, nil, "LEFT")
		VPDownloadUrl1:SetPoint("TOPLEFT", VPUrlArea1.frame, "TOPLEFT", 10, -7)
		VPUrlArea1.frame:SetScript("OnMouseUp", function(...) DBM:ShowUpdateReminder(nil, nil, L.Area_GetVEM, "https://wow.curseforge.com/projects/dbm-voicepack-vem") end)

		local VPUrlArea2		= spokenAlertsPanel:CreateArea(L.Area_BrowseOtherVP, nil, 40, true)
		local VPDownloadUrl2	= VPUrlArea2:CreateText(L.BrowseOtherVPs, 405, nil, nil, "LEFT")
		VPDownloadUrl2:SetPoint("TOPLEFT", VPUrlArea2.frame, "TOPLEFT", 10, -7)
		VPUrlArea2.frame:SetScript("OnMouseUp", function(...) DBM:ShowUpdateReminder(nil, nil, L.Area_BrowseOtherVP, "https://wow.curseforge.com/search?search=dbm+voice") end)

		local VPUrlArea3		= spokenAlertsPanel:CreateArea(L.Area_BrowseOtherCT, nil, 40, true)
		local VPDownloadUrl3	= VPUrlArea3:CreateText(L.BrowseOtherCTs, 405, nil, nil, "LEFT")
		VPDownloadUrl3:SetPoint("TOPLEFT", VPUrlArea3.frame, "TOPLEFT", 10, -7)
		VPUrlArea3.frame:SetScript("OnMouseUp", function(...) DBM:ShowUpdateReminder(nil, nil, L.Area_BrowseOtherCT, "https://wow.curseforge.com/search?search=dbm+count+pack") end)

		spokenAlertsPanel:SetMyOwnHeight()
	end

	do
		local Sounds = MixinSharedMedia3("sound", {
			{text = L.NoSound,			value = "None"},
			{text = "Muradin: Charge",	value = "Sound\\Creature\\MuradinBronzebeard\\IC_Muradin_Saurfang02.wav", sound = true},
		})

		local eventSoundsPanel	 	= DBM_GUI_Frame:CreateNewPanel(L.Panel_EventSounds, "option")
		local eventSoundsGeneralArea	= eventSoundsPanel:CreateArea(L.Area_SoundSelection, nil, 145, true)

		local VictorySoundDropdown = eventSoundsGeneralArea:CreateDropdown(L.EventVictorySound, DBM.Victory, "DBM", "EventSoundVictory2", function(value)
			DBM.Options.EventSoundVictory2 = value
			if value ~= "Random" then
				DBM:PlaySoundFile(value)
			end
		end, 180)
		VictorySoundDropdown:SetPoint("TOPLEFT", eventSoundsGeneralArea.frame, "TOPLEFT", 0, -20)

		local VictorySoundDropdown2 = eventSoundsGeneralArea:CreateDropdown(L.EventWipeSound, DBM.Defeat, "DBM", "EventSoundWipe", function(value)
			DBM.Options.EventSoundWipe = value
			if value ~= "Random" then
				DBM:PlaySoundFile(value)
			end
		end, 180)
		VictorySoundDropdown2:SetPoint("LEFT", VictorySoundDropdown, "RIGHT", 45, 0)

		local useCombined = DBM.Options.EventSoundMusicCombined
		local DungeonMusicDropDown = eventSoundsGeneralArea:CreateDropdown(L.EventDungeonMusic, useCombined and DBM.Music or DBM.DungeonMusic, "DBM", "EventSoundDungeonBGM", function(value)
			DBM.Options.EventSoundDungeonBGM = value
			if value ~= "Random" then
				if not DBM.Options.tempMusicSetting then
					DBM.Options.tempMusicSetting = tonumber(GetCVar("Sound_EnableMusic"))
					if DBM.Options.tempMusicSetting == 0 then
						SetCVar("Sound_EnableMusic", 1)
					else
						DBM.Options.tempMusicSetting = nil--Don't actually need it
					end
				end
				PlayMusic(value)
				DBM.Options.musicPlaying = true
			end
		end, 180)
		DungeonMusicDropDown:SetPoint("TOPLEFT", VictorySoundDropdown, "TOPLEFT", 0, -45)

		local MusicDropDown = eventSoundsGeneralArea:CreateDropdown(L.EventEngageMusic, useCombined and DBM.Music or DBM.BattleMusic, "DBM", "EventSoundMusic", function(value)
			DBM.Options.EventSoundMusic = value
			if value ~= "Random" then
				if not DBM.Options.tempMusicSetting then
					DBM.Options.tempMusicSetting = tonumber(GetCVar("Sound_EnableMusic"))
					if DBM.Options.tempMusicSetting == 0 then
						SetCVar("Sound_EnableMusic", 1)
					else
						DBM.Options.tempMusicSetting = nil--Don't actually need it
					end
				end
				PlayMusic(value)
				DBM.Options.musicPlaying = true
			end
		end, 180)
		MusicDropDown:SetPoint("TOPLEFT", VictorySoundDropdown2, "TOPLEFT", 0, -45)

		local VictorySoundDropdown3 = eventSoundsGeneralArea:CreateDropdown(L.EventEngageSound, Sounds, "DBM", "EventSoundEngage2", function(value)
			DBM.Options.EventSoundEngage2 = value
			DBM:PlaySoundFile(DBM.Options.EventSoundEngage2)
		end, 180)
		VictorySoundDropdown3:SetPoint("TOPLEFT", DungeonMusicDropDown, "TOPLEFT", 0, -45)

		local eventSoundsExtrasArea	= eventSoundsPanel:CreateArea(L.Area_EventSoundsExtras, nil, 70, true)
		local combineMusic			= eventSoundsExtrasArea:CreateCheckButton(L.EventMusicCombined, true, nil, "EventSoundMusicCombined")

		eventSoundsPanel:SetMyOwnHeight()
	end

	do
		local hpPanel = DBM_GUI_Frame:CreateNewPanel(L.Panel_HPFrame, "option")
		local hpArea = hpPanel:CreateArea(L.Area_HPFrame, nil, 150, true)
		hpArea:CreateCheckButton(L.HP_Enabled, true, nil, "AlwaysShowHealthFrame")
		local growbttn = hpArea:CreateCheckButton(L.HP_GrowUpwards, true)
		growbttn:SetScript("OnShow",  function(self) self:SetChecked(DBM.Options.HealthFrameGrowUp) end)
		growbttn:SetScript("OnClick", function(self)
				DBM.Options.HealthFrameGrowUp = not not self:GetChecked()
				DBM.BossHealth:UpdateSettings()
		end)


		local BarWidthSlider = hpArea:CreateSlider(L.BarWidth, 150, 275, 1)
		BarWidthSlider:SetPoint("TOPLEFT", hpArea.frame, "TOPLEFT", 20, -105)
		BarWidthSlider:SetScript("OnShow", function(self) self:SetValue(DBM.Options.HealthFrameWidth or 100) end)
		BarWidthSlider:HookScript("OnValueChanged", function(self)
				DBM.Options.HealthFrameWidth = self:GetValue()
				DBM.BossHealth:UpdateSettings()
		end)

		local resetbutton = hpArea:CreateButton(L.Reset, 120, 16)
		resetbutton:SetPoint('BOTTOMRIGHT', hpArea.frame, "BOTTOMRIGHT", -5, 5)
		resetbutton:SetNormalFontObject(GameFontNormalSmall);
		resetbutton:SetHighlightFontObject(GameFontNormalSmall);
		resetbutton:SetScript("OnClick", function()
				DBM.Options.HPFramePoint = DBM.DefaultOptions.HPFramePoint
				DBM.Options.HPFrameX = DBM.DefaultOptions.HPFrameX
				DBM.Options.HPFrameY = DBM.DefaultOptions.HPFrameY
				DBM.Options.HealthFrameGrowUp = DBM.DefaultOptions.HealthFrameGrowUp
				DBM.Options.HealthFrameWidth = DBM.DefaultOptions.HealthFrameWidth
				DBM.BossHealth:UpdateSettings()
		end)

		local function createDummyFunc(i) return function() return i end end
		local showbutton = hpArea:CreateButton(L.HP_ShowDemo, 120, 16)
		showbutton:SetPoint('BOTTOM', resetbutton, "TOP", 0, 5)
		showbutton:SetNormalFontObject(GameFontNormalSmall);
		showbutton:SetHighlightFontObject(GameFontNormalSmall);
		showbutton:SetScript("OnClick", function()
				DBM.BossHealth:Show("Health Frame")
				DBM.BossHealth:AddBoss(createDummyFunc(25), "TestBoss 1")
				DBM.BossHealth:AddBoss(createDummyFunc(50), "TestBoss 2")
				DBM.BossHealth:AddBoss(createDummyFunc(75), "TestBoss 3")
				DBM.BossHealth:AddBoss(createDummyFunc(100), "TestBoss 4")
		end)
	end

	do
		local spamPanel = DBM_GUI_Frame:CreateNewPanel(L.Panel_SpamFilter, "option")
		local spamOutArea = spamPanel:CreateArea(L.Area_SpamFilter_Outgoing, nil, 250, true)
		spamOutArea:CreateCheckButton(L.SpamBlockNoShowAnnounce, true, nil, "DontShowBossAnnounces")
		spamOutArea:CreateCheckButton(L.SpamBlockNoShowTgtAnnounce, true, nil, "DontShowTargetAnnouncements")
		spamOutArea:CreateCheckButton(L.SpamBlockNoSpecWarn, true, nil, "DontShowSpecialWarnings")
		spamOutArea:CreateCheckButton(L.SpamBlockNoSpecWarnText, true, nil, "DontShowSpecialWarningText")
		spamOutArea:CreateCheckButton(L.SpamBlockNoShowTimers, true, nil, "DontShowBossTimers")
		spamOutArea:CreateCheckButton(L.SpamBlockNoShowUTimers, true, nil, "DontShowUserTimers")
		spamOutArea:CreateCheckButton(L.SpamBlockNoSetIcon, true, nil, "DontSetIcons")
		spamOutArea:CreateCheckButton(L.SpamBlockNoRangeFrame, true, nil, "DontShowRangeFrame")
		spamOutArea:CreateCheckButton(L.SpamBlockNoInfoFrame, true, nil, "DontShowInfoFrame")
		spamOutArea:CreateCheckButton(L.SpamBlockNoHudMap, true, nil, "DontShowHudMap2")
		spamOutArea:CreateCheckButton(L.SpamBlockNoCountdowns, true, nil, "DontPlayCountdowns")
		spamOutArea:CreateCheckButton(L.SpamBlockNoYells, true, nil, "DontSendYells")
		spamOutArea:CreateCheckButton(L.SpamBlockNoNoteSync, true, nil, "BlockNoteShare")
		spamOutArea:CreateCheckButton(L.SpamBlockNoReminders, true, nil, "DontShowReminders")

		local spamRestoreArea = spamPanel:CreateArea(L.Area_Restore, nil, 170, true)
		spamRestoreArea:CreateCheckButton(L.SpamBlockNoIconRestore, true, nil, "DontRestoreIcons")
		spamRestoreArea:CreateCheckButton(L.SpamBlockNoRangeRestore, true, nil, "DontRestoreRange")

		local spamArea = spamPanel:CreateArea(L.Area_SpamFilter, nil, 210, true)
		spamArea:CreateCheckButton(L.DontShowFarWarnings, true, nil, "DontShowFarWarnings")
		spamArea:CreateCheckButton(L.FilterVoidFormSay, true, nil, "FilterVoidFormSay")
		spamArea:CreateCheckButton(L.HideBossEmoteFrame, true, nil, "HideBossEmoteFrame")
		spamArea:CreateCheckButton(L.SpamBlockRaidWarning, true, nil, "SpamBlockRaidWarning")
		spamArea:CreateCheckButton(L.SpamBlockBossWhispers, true, nil, "SpamBlockBossWhispers")

		local spamSpecArea = spamPanel:CreateArea(L.Area_SpecFilter, nil, 200, true)
		spamSpecArea:CreateCheckButton(L.FilterTankSpec, true, nil, "FilterTankSpec")
		spamSpecArea:CreateCheckButton(L.FilterDispels, true, nil, "FilterDispel")
		spamSpecArea:CreateCheckButton(L.FilterTrashWarnings, true, nil, "FilterTrashWarnings2")
		local FilterInterruptNote = spamSpecArea:CreateCheckButton(L.FilterInterruptNoteName, true, nil, "FilterInterruptNoteName")

		local interruptOptions = {
			{	text	= L.SWFNever,			value 	= "None"},
			{	text	= L.FilterInterrupts,	value 	= "onlyTandF"},
			{	text	= L.FilterInterrupts2,	value 	= "TandFandBossCooldown"},
			{	text	= L.FilterInterrupts3,	value 	= "TandFandAllCooldown"},
			{	text	= L.FilterInterrupts4,	value 	= "Always"},
		}
		local interruptDropDown		= spamSpecArea:CreateDropdown(L.FilterInterruptsHeader, interruptOptions, "DBM", "FilterInterrupt2", function(value)
			DBM.Options.FilterInterrupt2 = value
		end, 410)
		interruptDropDown:SetPoint("TOPLEFT", FilterInterruptNote, "TOPLEFT", 0, -55)

		local spamPTArea = spamPanel:CreateArea(L.Area_PullTimer, nil, 180, true)
		spamPTArea:CreateCheckButton(L.DontShowPTNoID, true, nil, "DontShowPTNoID")
		spamPTArea:CreateCheckButton(L.DontShowPT, true, nil, "DontShowPT2")
		spamPTArea:CreateCheckButton(L.DontShowPTText, true, nil, "DontShowPTText")
		spamPTArea:CreateCheckButton(L.DontShowPTCountdownText, true, nil, "DontShowPTCountdownText")
		local SPTCDA = spamPTArea:CreateCheckButton(L.DontPlayPTCountdown, true, nil, "DontPlayPTCountdown")

		local PTSlider = spamPTArea:CreateSlider(L.PT_Threshold, 1, 10, 1, 300)   -- (text , min_value , max_value , step , width)
		PTSlider:SetPoint('BOTTOMLEFT', SPTCDA, "BOTTOMLEFT", 80, -40)--Position based on slider, text anchored to slider. English has large text, so must move slider to middle :\
		PTSlider:HookScript("OnShow", function(self) self:SetValue(mfloor(DBM.Options.PTCountThreshold2)) end)
		PTSlider:HookScript("OnValueChanged", function(self) DBM.Options.PTCountThreshold2 = mfloor(self:GetValue()) end)

		spamPTArea:AutoSetDimension()
		spamRestoreArea:AutoSetDimension()
		spamArea:AutoSetDimension()
		spamSpecArea:AutoSetDimension()
		spamOutArea:AutoSetDimension()
		spamPanel:SetMyOwnHeight()
	end

	do
		local extraFeaturesPanel 	= DBM_GUI_Frame:CreateNewPanel(L.Panel_ExtraFeatures, "option")
		local chatAlertsArea		= extraFeaturesPanel:CreateArea(L.Area_ChatAlerts, nil, 100, true)
		local RoleSpecAlert			= chatAlertsArea:CreateCheckButton(L.RoleSpecAlert, true, nil, "RoleSpecAlert")
		local CheckGear				= chatAlertsArea:CreateCheckButton(L.CheckGear, true, nil, "CheckGear")
		local WorldBossAlert		= chatAlertsArea:CreateCheckButton(L.WorldBossAlert, true, nil, "WorldBossAlert")

		local soundAlertsArea		= extraFeaturesPanel:CreateArea(L.Area_SoundAlerts, nil, 100, true)
		local LFDEnhance			= soundAlertsArea:CreateCheckButton(L.LFDEnhance, true, nil, "LFDEnhance")
		local WorldBossNearAlert	= soundAlertsArea:CreateCheckButton(L.WorldBossNearAlert, true, nil, "WorldBossNearAlert")
		local RLReadyCheckSound		= soundAlertsArea:CreateCheckButton(L.RLReadyCheckSound, true, nil, "RLReadyCheckSound")
		local AFKHealthWarning		= soundAlertsArea:CreateCheckButton(L.AFKHealthWarning, true, nil, "AFKHealthWarning")
		local AutoReplySound		= soundAlertsArea:CreateCheckButton(L.AutoReplySound, true, nil, "AutoReplySound")

		local generaltimeroptions	= extraFeaturesPanel:CreateArea(L.TimerGeneral, nil, 105, true)

		local SKT_Enabled		= generaltimeroptions:CreateCheckButton(L.SKT_Enabled, true, nil, "AlwaysShowSpeedKillTimer2")
		local RespawnTimer		= generaltimeroptions:CreateCheckButton(L.ShowRespawn, true, nil, "ShowRespawn")
		local QueueTimer		= generaltimeroptions:CreateCheckButton(L.ShowQueuePop, true, nil, "ShowQueuePop")

		local bossLoggingArea		= extraFeaturesPanel:CreateArea(L.Area_AutoLogging, nil, 120, true)
		local AutologBosses			= bossLoggingArea:CreateCheckButton(L.AutologBosses, true, nil, "AutologBosses")
		if Transcriptor then
			local AdvancedAutologBosses	= bossLoggingArea:CreateCheckButton(L.AdvancedAutologBosses, true, nil, "AdvancedAutologBosses")
		end
		local RecordOnlyBosses		= bossLoggingArea:CreateCheckButton(L.RecordOnlyBosses, true, nil, "RecordOnlyBosses")
		local LogOnlyNonTrivial		= bossLoggingArea:CreateCheckButton(L.LogOnlyNonTrivial, true, nil, "LogOnlyNonTrivial")

		local thirdPartyArea
		if BigBrother and type(BigBrother.ConsumableCheck) == "function" then
			thirdPartyArea			= extraFeaturesPanel:CreateArea(L.Area_3rdParty, nil, 100, true)
			thirdPartyArea:CreateCheckButton(L.ShowBBOnCombatStart, true, nil, "ShowBigBrotherOnCombatStart")
			thirdPartyArea:CreateCheckButton(L.BigBrotherAnnounceToRaid, true, nil, "BigBrotherAnnounceToRaid")
		end

		local inviteArea			= extraFeaturesPanel:CreateArea(L.Area_Invite, nil, 100, true)
		local AutoAcceptFriendInvite= inviteArea:CreateCheckButton(L.AutoAcceptFriendInvite, true, nil, "AutoAcceptFriendInvite")
		local AutoAcceptGuildInvite	= inviteArea:CreateCheckButton(L.AutoAcceptGuildInvite, true, nil, "AutoAcceptGuildInvite")

		local advancedArea			= extraFeaturesPanel:CreateArea(L.Area_Advanced, nil, 100, true)
		local FakeBW				= advancedArea:CreateCheckButton(L.FakeBW, true, nil, "FakeBWVersion")
		local AITimers				= advancedArea:CreateCheckButton(L.AITimer, true, nil, "AITimer")

		chatAlertsArea:AutoSetDimension()
		soundAlertsArea:AutoSetDimension()
		generaltimeroptions:AutoSetDimension()
		bossLoggingArea:AutoSetDimension()
		if thirdPartyArea then
			thirdPartyArea:AutoSetDimension()
		end
		inviteArea:AutoSetDimension()
		advancedArea:AutoSetDimension()
		extraFeaturesPanel:SetMyOwnHeight()
	end

	do
		local profileDropdown = {}

		local profilePanel			= DBM_GUI_Frame:CreateNewPanel(L.Panel_Profile, "option")
		local createProfileArea		= profilePanel:CreateArea(L.Area_CreateProfile, nil, 65, true)
		local createTextbox			= createProfileArea:CreateEditBox(L.EnterProfileName, "", 175)
		createTextbox:SetMaxLetters(20)
		createTextbox:SetPoint('TOPLEFT', 30, -25)
		createTextbox:SetScript("OnEnterPressed", function() DBM_GUI.dbm_profilePanel_create() end)

		local createButton			= createProfileArea:CreateButton(L.CreateProfile)
		createButton:SetPoint('LEFT', createTextbox, "RIGHT", 10, 0)
		createButton:SetScript("OnClick", function() DBM_GUI.dbm_profilePanel_create() end)
		createButton:SetScript("OnShow", function()
			twipe(profileDropdown)
			for name, tb in pairs(DBM_AllSavedOptions) do
				local dropdown = { text = name, value = name }
				tinsert(profileDropdown, dropdown)
			end
		end)

		local applyProfileArea		= profilePanel:CreateArea(L.Area_ApplyProfile, nil, 65, true)
		local applyProfile			= applyProfileArea:CreateDropdown(L.SelectProfileToApply, profileDropdown, nil, nil, function(value)
			DBM_UsedProfile = value
			DBM:ApplyProfile(value)
			DBM_GUI:dbm_profilePanel_refresh()
		end)
		applyProfile:SetPoint("TOPLEFT", 0, -20)
		applyProfile:SetScript("OnShow", function()
			applyProfile:SetSelectedValue(DBM_UsedProfile)
		end)

		local copyProfileArea		= profilePanel:CreateArea(L.Area_CopyProfile, nil, 65, true)
		local copyProfile			= copyProfileArea:CreateDropdown(L.SelectProfileToCopy, profileDropdown, nil, nil, function(value)
			DBM:CopyProfile(value)
			DBM:Schedule(0.05, DBM_GUI.dbm_profilePanel_refresh)
		end)
		copyProfile:SetPoint("TOPLEFT", 0, -20)
		copyProfile:SetScript("OnShow", function()
			copyProfile.value = nil
			copyProfile.text = nil
			_G[copyProfile:GetName().."Text"]:SetText("")
		end)

		local deleteProfileArea		= profilePanel:CreateArea(L.Area_DeleteProfile, nil, 65, true)
		local deleteProfile			= deleteProfileArea:CreateDropdown(L.SelectProfileToDelete, profileDropdown, nil, nil, function(value)
			DBM:DeleteProfile(value)
			DBM:Schedule(0.05, DBM_GUI.dbm_profilePanel_refresh)
		end)
		deleteProfile:SetPoint("TOPLEFT", 0, -20)
		deleteProfile:SetScript("OnShow", function()
			deleteProfile.value = nil
			deleteProfile.text = nil
			_G[deleteProfile:GetName().."Text"]:SetText("")
		end)

		local dualProfileArea		= profilePanel:CreateArea(L.Area_DualProfile, nil, 140, true)
		local dualProfile			= dualProfileArea:CreateCheckButton(L.DualProfile, true, nil, "DualProfile")
		local PerCharacterSettings	= dualProfileArea:CreateCheckButton(L.PerCharacterSettings, true, nil, "PerCharacterSettings")


		function DBM_GUI:dbm_profilePanel_create()
			if createTextbox:GetText() then
				local text = createTextbox:GetText()
				text = text:gsub(" ", "")
				if text ~= "" then
					DBM:CreateProfile(createTextbox:GetText())
					createTextbox:SetText("")
					createTextbox:ClearFocus()
					DBM_GUI:dbm_profilePanel_refresh()
				end
			end
		end

		function DBM_GUI:dbm_profilePanel_refresh()
			createButton:GetScript("OnShow")()
			applyProfile:GetScript("OnShow")()
			copyProfile:GetScript("OnShow")()
			deleteProfile:GetScript("OnShow")()
		end
		profilePanel:SetMyOwnHeight()
	end

	-- Set Revision // please don't translate this!
	if DBM.NewerVersion then
		DBM_GUI_OptionsFrameRevision:SetText(DBM.DisplayVersion.." ("..DBM.Version.."). |cffff0000Version "..DBM.NewerVersion.." is available.|r")
	else
		DBM_GUI_OptionsFrameRevision:SetText(DBM.DisplayVersion.." ("..DBM.Version..")")
	end
	if L.TranslationBy then
		DBM_GUI_OptionsFrameTranslation:SetText(L.TranslationByPrefix .. L.TranslationBy)
	end
	DBM_GUI_OptionsFrameWebsite:SetText(L.Website)
	local frame = CreateFrame("Button", nil, DBM_GUI_OptionsFrame)
	frame:SetAllPoints(DBM_GUI_OptionsFrameWebsite)
	frame:SetScript("OnMouseUp", function(...) DBM:ShowUpdateReminder(nil, nil, CL.COPY_URL_DIALOG, "https://discord.gg/RH7ZE6e6rH") end)
end
DBM:RegisterOnGuiLoadCallback(CreateOptionsMenu, 1)

do
	local function OnShowGetStats(bossid, statsType, top1value1, top1value2, top1value3, top2value1, top2value2, top2value3, bottom1value1, bottom1value2, bottom1value3, bottom2value1, bottom2value2, bottom2value3)
		return function(self)
			local mod = DBM:GetModByName(bossid)
			local stats = mod.stats
			if statsType == 1 then -- Party: normal, heroic
				top1value1:SetText( stats.normalKills )
				top1value2:SetText( stats.normalPulls - stats.normalKills )
				top1value3:SetText( stats.normalBestTime and ("%d:%02d"):format(mfloor(stats.normalBestTime / 60), stats.normalBestTime % 60) or "-" )
				top2value1:SetText( stats.heroicKills )
				top2value2:SetText( stats.heroicPulls-stats.heroicKills )
				top2value3:SetText( stats.heroicBestTime and ("%d:%02d"):format(mfloor(stats.heroicBestTime / 60), stats.heroicBestTime % 60) or "-" )
			elseif statsType == 2 and stats.normal25Pulls and stats.normal25Pulls > 0 and stats.normal25Pulls > stats.normalPulls then--Fix for BC instance
				top1value1:SetText( stats.normal25Kills )
				top1value2:SetText( stats.normal25Pulls - stats.normal25Kills )
				top1value3:SetText( stats.normal25BestTime and ("%d:%02d"):format(mfloor(stats.normal25BestTime / 60), stats.normal25BestTime % 60) or "-" )
			elseif statsType == 3 then
				top1value1:SetText( stats.normalKills )
				top1value2:SetText( stats.normalPulls - stats.normalKills )
				top1value3:SetText( stats.normalBestTime and ("%d:%02d"):format(mfloor(stats.normalBestTime / 60), stats.normalBestTime % 60) or "-" )
				top2value1:SetText( stats.heroicKills )
				top2value2:SetText( stats.heroicPulls-stats.heroicKills )
				top2value3:SetText( stats.heroicBestTime and ("%d:%02d"):format(mfloor(stats.heroicBestTime / 60), stats.heroicBestTime % 60) or "-" )
			else
				top1value1:SetText(stats.normalKills)
				top1value2:SetText(stats.normalPulls - stats.normalKills)
				top1value3:SetText(stats.normalBestTime and ("%d:%02d"):format(mfloor(stats.normalBestTime / 60), stats.normalBestTime % 60) or "-")
				top2value1:SetText(stats.normal25Kills)
				top2value2:SetText(stats.normal25Pulls - stats.normal25Kills)
				top2value3:SetText(stats.normal25BestTime and ("%d:%02d"):format(mfloor(stats.normal25BestTime / 60), stats.normal25BestTime % 60) or "-")
				bottom1value1:SetText(stats.heroicKills)
				bottom1value2:SetText(stats.heroicPulls-stats.heroicKills)
				bottom1value3:SetText(stats.heroicBestTime and ("%d:%02d"):format(mfloor(stats.heroicBestTime / 60), stats.heroicBestTime % 60) or "-")
				bottom2value1:SetText(stats.heroic25Kills)
				bottom2value2:SetText(stats.heroic25Pulls-stats.heroic25Kills)
				bottom2value3:SetText(stats.heroic25BestTime and ("%d:%02d"):format(mfloor(stats.heroic25BestTime / 60), stats.heroic25BestTime % 60) or "-")
			end
		end
	end

	local function CreateBossModTab(addon, panel, subtab)
		if not panel then
			error("Panel is nil", 2)
		end

		local modProfileArea
		if not subtab then
			local modProfileDropdown = {}
			modProfileArea = panel:CreateArea(L.Area_ModProfile, panel.frame:GetWidth(), 135, true)
			modProfileArea.frame:SetPoint("TOPLEFT", 10, -25)
			local resetButton = modProfileArea:CreateButton(L.ModAllReset, 200, 20)
			resetButton:SetPoint('TOPLEFT', 10, -14)
			resetButton:SetScript("OnClick", function() DBM:LoadAllModDefaultOption(addon.modId) end)
			resetButton:SetScript("OnShow", function()
				twipe(modProfileDropdown)
				local savedVarsName = addon.modId:gsub("-", "").."_AllSavedVars"
				for charname, charTable in pairs(_G[savedVarsName]) do
					for bossid, optionTable in pairs(charTable) do
						if type(optionTable) == "table" then
							for i = 0, 3 do
								if optionTable[i] then
									local displayText = (i == 0 and charname.." ("..ALL..")") or charname.." ("..TALENTS..i.."-"..(charTable["talent"..i] or "")..")"
									local dropdown = { text = displayText, value = charname.."|"..tostring(i) }
									tinsert(modProfileDropdown, dropdown)
								end
							end
							break
						end
					end
				end
			end)

			local resetStatButton = modProfileArea:CreateButton(L.ModAllStatReset, 200, 20)
			resetStatButton:SetPoint('LEFT', resetButton, "RIGHT", 40, 0)
			resetStatButton:SetScript("OnClick", function() DBM:ClearAllStats(addon.modId) end)

			local copyModProfile = modProfileArea:CreateDropdown(L.SelectModProfileCopy, modProfileDropdown, nil, nil, function(value)
				local name, profile = strsplit("|", value)
				DBM:CopyAllModOption(addon.modId, name, tonumber(profile))
				DBM:Schedule(0.05, DBM_GUI.dbm_modProfilePanel_refresh)
			end, 100)
			copyModProfile:SetPoint("TOPLEFT", -7, -54)
			copyModProfile:SetScript("OnShow", function()
				copyModProfile.value = nil
				copyModProfile.text = nil
				_G[copyModProfile:GetName().."Text"]:SetText("")
			end)

			local copyModSoundProfile = modProfileArea:CreateDropdown(L.SelectModProfileCopySound, modProfileDropdown, nil, nil, function(value)
				local name, profile = strsplit("|", value)
				DBM:CopyAllModTypeOption(addon.modId, name, tonumber(profile), "SWSound")
				DBM:Schedule(0.10, DBM_GUI.dbm_modProfilePanel_refresh)
			end, 100)
			copyModSoundProfile:SetPoint("LEFT", copyModProfile, "RIGHT", 27, 0)
			copyModSoundProfile:SetScript("OnShow", function()
				copyModSoundProfile.value = nil
				copyModSoundProfile.text = nil
				_G[copyModSoundProfile:GetName().."Text"]:SetText("")
			end)

			local copyModNoteProfile = modProfileArea:CreateDropdown(L.SelectModProfileCopyNote, modProfileDropdown, nil, nil, function(value)
				local name, profile = strsplit("|", value)
				DBM:CopyAllModTypeOption(addon.modId, name, tonumber(profile), "SWNote")
				DBM:Schedule(0.10, DBM_GUI.dbm_modProfilePanel_refresh)
			end, 100)
			copyModNoteProfile:SetPoint("LEFT", copyModSoundProfile, "RIGHT", 27, 0)
			copyModNoteProfile:SetScript("OnShow", function()
				copyModNoteProfile.value = nil
				copyModNoteProfile.text = nil
				_G[copyModNoteProfile:GetName().."Text"]:SetText("")
			end)

			local deleteModProfile = modProfileArea:CreateDropdown(L.SelectModProfileDelete, modProfileDropdown, nil, nil, function(value)
				local name, profile = strsplit("|", value)
				DBM:DeleteAllModOption(addon.modId, name, tonumber(profile))
				DBM:Schedule(0.05, DBM_GUI.dbm_modProfilePanel_refresh)
			end, 100)

			deleteModProfile:SetPoint("TOPLEFT", copyModSoundProfile, "BOTTOMLEFT", 0, -10)
			deleteModProfile:SetScript("OnShow", function()
				deleteModProfile.value = nil
				deleteModProfile.text = nil
				_G[deleteModProfile:GetName().."Text"]:SetText("")
			end)

			function DBM_GUI:dbm_modProfilePanel_refresh()
				resetButton:GetScript("OnShow")()
				copyModProfile:GetScript("OnShow")()
				copyModSoundProfile:GetScript("OnShow")()
				copyModNoteProfile:GetScript("OnShow")()
				deleteModProfile:GetScript("OnShow")()
			end
		end

		if addon.noStatistics then return end

		local ptext = panel:CreateText(L.BossModLoaded:format(subtab and addon.subTabs[subtab] or addon.name), nil, nil, GameFontNormal)
		ptext:SetPoint('TOPLEFT', panel.frame, "TOPLEFT", 10, modProfileArea and -165 or -10)

		local singleline = 0
		local doubleline = 0
		local area = panel:CreateArea(nil, panel.frame:GetWidth(), 10)
		area.frame:SetPoint("TOPLEFT", 10, modProfileArea and -180 or -25)
		area.onshowcall = {}

		for _, mod in ipairs(DBM.Mods) do
			if mod.modId == addon.modId and (not subtab or subtab == mod.subTab) and not mod.isTrashMod and not mod.noStatistics then
				local statsType = 0
				if not mod.stats then
					mod.stats = { }
				end
				local stats = mod.stats
				stats.normalKills = stats.normalKills or 0
				stats.normalPulls = stats.normalPulls or 0
				stats.heroicKills = stats.heroicKills or 0
				stats.heroicPulls = stats.heroicPulls or 0
				stats.normal25Kills = stats.normal25Kills or 0
				stats.normal25Pulls = stats.normal25Pulls or 0
				stats.heroic25Kills = stats.heroic25Kills or 0
				stats.heroic25Pulls = stats.heroic25Pulls or 0

				--Create Frames
				local Title			= area:CreateText(mod.localization.general.name, nil, nil, GameFontHighlight, "LEFT")

				local top1header		= area:CreateText("", nil, nil, GameFontHighlightSmall, "LEFT")--Row 1, 1st column
				local top1text1			= area:CreateText(L.Statistic_Kills, nil, nil, GameFontNormalSmall, "LEFT")
				local top1text2			= area:CreateText(L.Statistic_Wipes, nil, nil, GameFontNormalSmall, "LEFT")
				local top1text3			= area:CreateText(L.Statistic_BestKill, nil, nil, GameFontNormalSmall, "LEFT")
				local top1value1		= area:CreateText("", nil, nil, GameFontNormalSmall, "LEFT")
				local top1value2		= area:CreateText("", nil, nil, GameFontNormalSmall, "LEFT")
				local top1value3		= area:CreateText("", nil, nil, GameFontNormalSmall, "LEFT")
				local top2header		= area:CreateText("", nil, nil, GameFontHighlightSmall, "LEFT")--Row 1, 2nd column
				local top2text1			= area:CreateText(L.Statistic_Kills, nil, nil, GameFontNormalSmall, "LEFT")
				local top2text2			= area:CreateText(L.Statistic_Wipes, nil, nil, GameFontNormalSmall, "LEFT")
				local top2text3			= area:CreateText(L.Statistic_BestKill, nil, nil, GameFontNormalSmall, "LEFT")
				local top2value1		= area:CreateText("", nil, nil, GameFontNormalSmall, "LEFT")
				local top2value2		= area:CreateText("", nil, nil, GameFontNormalSmall, "LEFT")
				local top2value3		= area:CreateText("", nil, nil, GameFontNormalSmall, "LEFT")

				local bottom1header		= area:CreateText("", nil, nil, GameFontHighlightSmall, "LEFT")--Row 2, 1st column
				local bottom1text1		= area:CreateText(L.Statistic_Kills, nil, nil, GameFontNormalSmall, "LEFT")
				local bottom1text2		= area:CreateText(L.Statistic_Wipes, nil, nil, GameFontNormalSmall, "LEFT")
				local bottom1text3		= area:CreateText(L.Statistic_BestKill, nil, nil, GameFontNormalSmall, "LEFT")
				local bottom1value1		= area:CreateText("", nil, nil, GameFontNormalSmall, "LEFT")
				local bottom1value2		= area:CreateText("", nil, nil, GameFontNormalSmall, "LEFT")
				local bottom1value3		= area:CreateText("", nil, nil, GameFontNormalSmall, "LEFT")
				local bottom2header		= area:CreateText("", nil, nil, GameFontHighlightSmall, "LEFT")--Row 2, 2nd column
				local bottom2text1		= area:CreateText(L.Statistic_Kills, nil, nil, GameFontNormalSmall, "LEFT")
				local bottom2text2		= area:CreateText(L.Statistic_Wipes, nil, nil, GameFontNormalSmall, "LEFT")
				local bottom2text3		= area:CreateText(L.Statistic_BestKill, nil, nil, GameFontNormalSmall, "LEFT")
				local bottom2value1		= area:CreateText("", nil, nil, GameFontNormalSmall, "LEFT")
				local bottom2value2		= area:CreateText("", nil, nil, GameFontNormalSmall, "LEFT")
				local bottom2value3		= area:CreateText("", nil, nil, GameFontNormalSmall, "LEFT")

				--Set enable or disable per mods.
				if mod.addon.oneFormat then -- Classic/BC Raids
					statsType = 3
					if mod.addon.noHeroic then
						--Do not use top1 header.
						top1text1:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 20, -5)
						top1text2:SetPoint("TOPLEFT", top1text1, "BOTTOMLEFT", 0, -5)
						top1text3:SetPoint("TOPLEFT", top1text2, "BOTTOMLEFT", 0, -5)
						top1value1:SetPoint("TOPLEFT", top1text1, "TOPLEFT", 80, 0)
						top1value2:SetPoint("TOPLEFT", top1text2, "TOPLEFT", 80, 0)
						top1value3:SetPoint("TOPLEFT", top1text3, "TOPLEFT", 80, 0)
					else
						--Use top1 and top2 area.
						top1header:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 20, -5)
						top1text1:SetPoint("TOPLEFT", top1header, "BOTTOMLEFT", 20, -5)
						top1text2:SetPoint("TOPLEFT", top1text1, "BOTTOMLEFT", 0, -5)
						top1text3:SetPoint("TOPLEFT", top1text2, "BOTTOMLEFT", 0, -5)
						top1value1:SetPoint("TOPLEFT", top1text1, "TOPLEFT", 80, 0)
						top1value2:SetPoint("TOPLEFT", top1text2, "TOPLEFT", 80, 0)
						top1value3:SetPoint("TOPLEFT", top1text3, "TOPLEFT", 80, 0)
						top2header:SetPoint("LEFT", top1header, "LEFT", 220, 0)
						top2text1:SetPoint("LEFT", top1text1, "LEFT", 220, 0)
						top2text2:SetPoint("LEFT", top1text2, "LEFT", 220, 0)
						top2text3:SetPoint("LEFT", top1text3, "LEFT", 220, 0)
						top2value1:SetPoint("TOPLEFT", top2text1, "TOPLEFT", 80, 0)
						top2value2:SetPoint("TOPLEFT", top2text2, "TOPLEFT", 80, 0)
						top2value3:SetPoint("TOPLEFT", top2text3, "TOPLEFT", 80, 0)
						--Set header text.
						top1header:SetText(PLAYER_DIFFICULTY1)
						top2header:SetText(PLAYER_DIFFICULTY2)
					end
					--Set Dims
					Title:SetPoint("TOPLEFT", area.frame, "TOPLEFT", 10, -10-(L.FontHeight*6*singleline))
					area.frame:SetHeight( area.frame:GetHeight() + L.FontHeight*6 )
					singleline = singleline + 1
				elseif mod.addon.type == "PARTY" then -- If party instance have no heroic, we should use oneFormat.
					statsType = 1
					if mod.oneFormat then
						top1header:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 20, -5)
						top1text1:SetPoint("TOPLEFT", top1header, "BOTTOMLEFT", 20, -5)
						top1text2:SetPoint("TOPLEFT", top1text1, "BOTTOMLEFT", 0, -5)
						top1text3:SetPoint("TOPLEFT", top1text2, "BOTTOMLEFT", 0, -5)
						top1value1:SetPoint("TOPLEFT", top1text1, "TOPLEFT", 80, 0)
						top1value2:SetPoint("TOPLEFT", top1text2, "TOPLEFT", 80, 0)
						top1value3:SetPoint("TOPLEFT", top1text3, "TOPLEFT", 80, 0)
						--Set header text.
						top1header:SetText(PLAYER_DIFFICULTY1)
						--Set Dims
						Title:SetPoint("TOPLEFT", area.frame, "TOPLEFT", 10, -10-(L.FontHeight*6*singleline))
						area.frame:SetHeight( area.frame:GetHeight() + L.FontHeight*6 )
						singleline = singleline + 1
					elseif mod.onlyHeroic then
						top2header:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 20, -5)
						top2text1:SetPoint("TOPLEFT", top2header, "BOTTOMLEFT", 20, -5)
						top2text2:SetPoint("TOPLEFT", top2text1, "BOTTOMLEFT", 0, -5)
						top2text3:SetPoint("TOPLEFT", top2text2, "BOTTOMLEFT", 0, -5)
						top2value1:SetPoint("TOPLEFT", top2text1, "TOPLEFT", 80, 0)
						top2value2:SetPoint("TOPLEFT", top2text2, "TOPLEFT", 80, 0)
						top2value3:SetPoint("TOPLEFT", top2text3, "TOPLEFT", 80, 0)
						--Set header text.
						top2header:SetText(PLAYER_DIFFICULTY2)
						--Set Dims
						Title:SetPoint("TOPLEFT", area.frame, "TOPLEFT", 10, -10-(L.FontHeight*6*singleline))
						area.frame:SetHeight( area.frame:GetHeight() + L.FontHeight*6 )
						singleline = singleline + 1
					else--Dungeons that are Normal, Heroic
						--Use top1 and top2 area. (normal, Heroic)
						top1header:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 20, -5)
						top1text1:SetPoint("TOPLEFT", top1header, "BOTTOMLEFT", 20, -5)
						top1text2:SetPoint("TOPLEFT", top1text1, "BOTTOMLEFT", 0, -5)
						top1text3:SetPoint("TOPLEFT", top1text2, "BOTTOMLEFT", 0, -5)
						top1value1:SetPoint("TOPLEFT", top1text1, "TOPLEFT", 80, 0)
						top1value2:SetPoint("TOPLEFT", top1text2, "TOPLEFT", 80, 0)
						top1value3:SetPoint("TOPLEFT", top1text3, "TOPLEFT", 80, 0)
						top2header:SetPoint("LEFT", top1header, "LEFT", 220, 0)
						top2text1:SetPoint("LEFT", top1text1, "LEFT", 220, 0)
						top2text2:SetPoint("LEFT", top1text2, "LEFT", 220, 0)
						top2text3:SetPoint("LEFT", top1text3, "LEFT", 220, 0)
						top2value1:SetPoint("TOPLEFT", top2text1, "TOPLEFT", 80, 0)
						top2value2:SetPoint("TOPLEFT", top2text2, "TOPLEFT", 80, 0)
						top2value3:SetPoint("TOPLEFT", top2text3, "TOPLEFT", 80, 0)
						--Set header text.
						top1header:SetText(PLAYER_DIFFICULTY1)
						top2header:SetText(PLAYER_DIFFICULTY2)
						--Set Dims
						Title:SetPoint("TOPLEFT", area.frame, "TOPLEFT", 10, -10-(L.FontHeight*6*singleline))
						area.frame:SetHeight( area.frame:GetHeight() + L.FontHeight*6 )
						singleline = singleline + 1
					end
				else
					Title:SetPoint("TOPLEFT", area.frame, "TOPLEFT", 10, -10-(L.FontHeight*6*singleline)-(L.FontHeight*10*doubleline))
					if mod.onlyNormal or mod.addon.noHeroic then
						--Use top1, top2 area
						--10 Player, 25 Player
						top1header:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 20, -5)
						top1text1:SetPoint("TOPLEFT", top1header, "BOTTOMLEFT", 20, -5)
						top1text2:SetPoint("TOPLEFT", top1text1, "BOTTOMLEFT", 0, -5)
						top1text3:SetPoint("TOPLEFT", top1text2, "BOTTOMLEFT", 0, -5)
						top1value1:SetPoint("TOPLEFT", top1text1, "TOPLEFT", 80, 0)
						top1value2:SetPoint("TOPLEFT", top1text2, "TOPLEFT", 80, 0)
						top1value3:SetPoint("TOPLEFT", top1text3, "TOPLEFT", 80, 0)
						top2header:SetPoint("LEFT", top1header, "LEFT", 220, 0)
						top2text1:SetPoint("LEFT", top1text1, "LEFT", 220, 0)
						top2text2:SetPoint("LEFT", top1text2, "LEFT", 220, 0)
						top2text3:SetPoint("LEFT", top1text3, "LEFT", 220, 0)
						top2value1:SetPoint("TOPLEFT", top2text1, "TOPLEFT", 80, 0)
						top2value2:SetPoint("TOPLEFT", top2text2, "TOPLEFT", 80, 0)
						top2value3:SetPoint("TOPLEFT", top2text3, "TOPLEFT", 80, 0)
						--Set header text.
						top1header:SetText(RAID_DIFFICULTY1)
						top2header:SetText(RAID_DIFFICULTY2)
						--Set Dims
						area.frame:SetHeight( area.frame:GetHeight() + L.FontHeight*6 )
						singleline = singleline + 1
					else
						--Use top1, top2, bottom1 and bottom2 area.
						--10 Player, 25 Player, 10 Player Heroic, 25 Player Heroic
						top1header:SetPoint("TOPLEFT", Title, "BOTTOMLEFT", 20, -5)
						top1text1:SetPoint("TOPLEFT", top1header, "BOTTOMLEFT", 20, -5)
						top1text2:SetPoint("TOPLEFT", top1text1, "BOTTOMLEFT", 0, -5)
						top1text3:SetPoint("TOPLEFT", top1text2, "BOTTOMLEFT", 0, -5)
						top1value1:SetPoint("TOPLEFT", top1text1, "TOPLEFT", 80, 0)
						top1value2:SetPoint("TOPLEFT", top1text2, "TOPLEFT", 80, 0)
						top1value3:SetPoint("TOPLEFT", top1text3, "TOPLEFT", 80, 0)
						top2header:SetPoint("LEFT", top1header, "LEFT", 220, 0)
						top2text1:SetPoint("LEFT", top1text1, "LEFT", 220, 0)
						top2text2:SetPoint("LEFT", top1text2, "LEFT", 220, 0)
						top2text3:SetPoint("LEFT", top1text3, "LEFT", 220, 0)
						top2value1:SetPoint("TOPLEFT", top2text1, "TOPLEFT", 80, 0)
						top2value2:SetPoint("TOPLEFT", top2text2, "TOPLEFT", 80, 0)
						top2value3:SetPoint("TOPLEFT", top2text3, "TOPLEFT", 80, 0)
						bottom1header:SetPoint("TOPLEFT", top1text3, "BOTTOMLEFT", -20, -5)
						bottom1text1:SetPoint("TOPLEFT", bottom1header, "BOTTOMLEFT", 20, -5)
						bottom1text2:SetPoint("TOPLEFT", bottom1text1, "BOTTOMLEFT", 0, -5)
						bottom1text3:SetPoint("TOPLEFT", bottom1text2, "BOTTOMLEFT", 0, -5)
						bottom1value1:SetPoint("TOPLEFT", bottom1text1, "TOPLEFT", 80, 0)
						bottom1value2:SetPoint("TOPLEFT", bottom1text2, "TOPLEFT", 80, 0)
						bottom1value3:SetPoint("TOPLEFT", bottom1text3, "TOPLEFT", 80, 0)
						bottom2header:SetPoint("LEFT", bottom1header, "LEFT", 220, 0)
						bottom2text1:SetPoint("LEFT", bottom1text1, "LEFT", 220, 0)
						bottom2text2:SetPoint("LEFT", bottom1text2, "LEFT", 220, 0)
						bottom2text3:SetPoint("LEFT", bottom1text3, "LEFT", 220, 0)
						bottom2value1:SetPoint("TOPLEFT", bottom2text1, "TOPLEFT", 80, 0)
						bottom2value2:SetPoint("TOPLEFT", bottom2text2, "TOPLEFT", 80, 0)
						bottom2value3:SetPoint("TOPLEFT", bottom2text3, "TOPLEFT", 80, 0)
						--Set header text.
						top1header:SetText(RAID_DIFFICULTY1)
						top2header:SetText(RAID_DIFFICULTY2)
						bottom1header:SetText(PLAYER_DIFFICULTY2)
						bottom2header:SetText(PLAYER_DIFFICULTY2)
						--Set Dims
						area.frame:SetHeight(area.frame:GetHeight() + L.FontHeight*10)
						doubleline = doubleline + 1
					end
				end

				tinsert(area.onshowcall, OnShowGetStats(mod.id, statsType, top1value1, top1value2, top1value3, top2value1, top2value2, top2value3, bottom1value1, bottom1value2, bottom1value3, bottom2value1, bottom2value2, bottom2value3))
			end
		end
		area.frame:SetScript("OnShow", function(self)
			for _,v in pairs(area.onshowcall) do
				v()
			end
		end)
		panel:SetMyOwnHeight()
		DBM_GUI_OptionsFrame:DisplayFrame(panel.frame, true)
	end

	local function LoadAddOn_Button(self)
		if DBM:LoadMod(self.modid, true) then
			self:Hide()
			self.headline:Hide()
			CreateBossModTab(self.modid, self.modid.panel)
			DBM_GUI_OptionsFrameBossMods:Hide()
			DBM_GUI_OptionsFrameBossMods:Show()
		end
	end

	local category = {}
	local subTabId = 0
	local expansions = {
		"CLASSIC", "BC", "WOTLK"
	}

	function DBM_GUI:UpdateModList()
		for _, addon in ipairs(DBM.AddOns) do
			local cat = addon.category:upper()
			if not category[cat] then
				-- Create a Panel for "Wrath of the Lich King", "The Burning Crusade", "Classic" or "Other"
				category[cat] = DBM_GUI:CreateNewPanel(_G["EXPANSION_NAME" .. (tIndexOf(expansions, cat) or 99) - 1] or L.TabCategory_OTHER, nil, cat == expansions[GetExpansionLevel() + 1])
			end

			if not addon.panel then
				-- Create a Panel for "Naxxramas" "Eye of Eternity" ...
				addon.panel = category[cat]:CreateNewPanel(addon.modId or "Error: No-modId", nil, false, nil, addon.name)

				if not IsAddOnLoaded(addon.modId) then
					local button = addon.panel:CreateButton(L.Button_LoadMod, 200, 30)
					button.modid = addon
					button.headline = addon.panel:CreateText(L.BossModLoad_now, 350)
					button.headline:SetHeight(50)
					button.headline:SetPoint("CENTER", button, "CENTER", 0, 80)

					button:SetScript("OnClick", LoadAddOn_Button)
					button:SetPoint("CENTER", 0, -20)
				else
					CreateBossModTab(addon, addon.panel)
				end
			end

			if addon.panel and addon.subTabs and IsAddOnLoaded(addon.modId) then
				-- Create a Panel for "Arachnid Quarter" "Plague Quarter" ...
				if not addon.subPanels then addon.subPanels = {} end

				for k,v in pairs(addon.subTabs) do
					if not addon.subPanels[k] then
						subTabId = subTabId + 1
						addon.subPanels[k] = addon.panel:CreateNewPanel("SubTab"..subTabId, nil, false, nil, v)
						CreateBossModTab(addon, addon.subPanels[k], k)
					end
				end
			end

			for _, mod in ipairs(DBM.Mods) do
				if mod.modId == addon.modId then
					if not mod.panel and (not addon.subTabs or (addon.subPanels and addon.subPanels[mod.subTab])) then
						if addon.subTabs and addon.subPanels[mod.subTab] then
							mod.panel = addon.subPanels[mod.subTab]:CreateNewPanel(mod.id or "Error: DBM.Mods", nil, nil, nil, mod.localization.general.name)
						else
							mod.panel = addon.panel:CreateNewPanel(mod.id or "Error: DBM.Mods", nil, nil, nil, mod.localization.general.name)
						end
						DBM_GUI:CreateBossModPanel(mod)
					end
				end
			end
		end
		if DBM_GUI_OptionsFrame:IsShown() then
			DBM_GUI_OptionsFrame:Hide()
			DBM_GUI_OptionsFrame:Show()
		end
	end


	function DBM_GUI:CreateBossModPanel(mod)
		if not mod.panel then
			DBM:AddMsg("Couldn't create boss mod panel for "..mod.localization.general.name)
			return false
		end
		local panel = mod.panel
		panel.initheight = 35
		local category

		local iconstat = panel.frame:CreateFontString("DBM_GUI_Mod_Icons"..mod.localization.general.name, "ARTWORK")
		iconstat:SetPoint("TOPRIGHT", panel.frame, "TOPRIGHT", -168, -10)
		iconstat:SetFontObject(GameFontNormal)
		iconstat:SetText(L.IconsInUse)
		for i=1, 8, 1 do
			local icon = panel.frame:CreateTexture()
			icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons.blp")
			icon:SetPoint("TOPRIGHT", panel.frame, "TOPRIGHT", -150-(i*18), -26)
			icon:SetWidth(16)
			icon:SetHeight(16)
			if not mod.usedIcons or not mod.usedIcons[i] then		icon:SetAlpha(0.25)		end
			if 		i == 1 then		icon:SetTexCoord(0,		0.25,	0,		0.25)
			elseif	i == 2 then		icon:SetTexCoord(0.25,	0.5,	0,		0.25)
			elseif	i == 3 then		icon:SetTexCoord(0.5, 	0.75,	0,		0.25)
			elseif	i == 4 then		icon:SetTexCoord(0.75,	1,		0,		0.25)
			elseif	i == 5 then		icon:SetTexCoord(0,		0.25,	0.25,	0.5)
			elseif	i == 6 then		icon:SetTexCoord(0.25,	0.5,	0.25,	0.5)
			elseif	i == 7 then		icon:SetTexCoord(0.5,	0.75,	0.25,	0.5)
			elseif	i == 8 then		icon:SetTexCoord(0.75,	1,		0.25,	0.5)
			end
		end

		local reset  = panel:CreateButton(L.Mod_Reset, 155, 30, nil, GameFontNormalSmall)
		reset:SetPoint('TOPRIGHT', panel.frame, "TOPRIGHT", -6, -6)
		reset:SetScript("OnClick", function(self)
			DBM:LoadModDefaultOption(mod)
		end)
		local button = panel:CreateCheckButton(L.Mod_Enabled, true)
		button:SetScript("OnShow",  function(self) self:SetChecked(mod.Options.Enabled) end)
		button:SetPoint('TOPLEFT', panel.frame, "TOPLEFT", 8, -14)
		button:SetScript("OnClick", function(self) mod:Toggle()	end)

		for _, catident in pairs(mod.categorySort) do
			category = mod.optionCategories[catident]
			if category then
				local catpanel = panel:CreateArea(mod.localization.cats[catident], nil, nil, true)
				local catbutton, lastButton, addSpacer
				local hasDropdowns = 0
				for _, v in ipairs(category) do
					if v == DBM_OPTION_SPACER then
						addSpacer = true
					else
						lastButton = catbutton
						if v.line then
							catbutton = catpanel:CreateLine(v.text)
						elseif type(mod.Options[v]) == "boolean" then
							if mod.Options[v .. "TColor"] then
								catbutton = catpanel:CreateCheckButton(mod.localization.options[v], true, nil, nil, nil, mod, v, nil, true)
							elseif mod.Options[v .. "SWSound"] then
								catbutton = catpanel:CreateCheckButton(mod.localization.options[v], true, nil, nil, nil, mod, v)
							else
								catbutton = catpanel:CreateCheckButton(mod.localization.options[v], true)
							end
							catbutton:SetScript("OnShow", function(self)
								self:SetChecked(mod.Options[v])
							end)
							catbutton:SetScript("OnClick", function(self)
								mod.Options[v] = not mod.Options[v]
								if mod.optionFuncs and mod.optionFuncs[v] then
									mod.optionFuncs[v]()
								end
							end)
						elseif mod.buttons and mod.buttons[v] then
							local but = mod.buttons[v]
							catbutton = catpanel:CreateButton(v, but.width, but.height, but.onClick, but.fontObject)
						elseif mod.editboxes and mod.editboxes[v] then
							local editBox = mod.editboxes[v]
							catbutton = catpanel:CreateEditBox(mod.localization.options[v], mod.Options[v], editBox.width, editBox.height)
							catbutton:SetScript("OnEnterPressed", function(self)
								if mod.optionFuncs and mod.optionFuncs[v] then
									mod.optionFuncs[v]()
								end
							end)
						elseif mod.sliders and mod.sliders[v] then
							local slider = mod.sliders[v]
							catbutton = catpanel:CreateSlider(mod.localization.options[v], slider.minValue, slider.maxValue, slider.valueStep)
							catbutton:SetScript("OnShow", function(self)
								self:SetValue(mod.Options[v])
							end)
							catbutton:HookScript("OnValueChanged", function(self)
								if mod.optionFuncs and mod.optionFuncs[v] then
									mod.optionFuncs[v]()
								end
							end)
						elseif mod.dropdowns and mod.dropdowns[v] then
							local dropdownOptions = {}
							for i, val in ipairs(mod.dropdowns[v]) do
								dropdownOptions[#dropdownOptions + 1] = { text = mod.localization.options[val], value = val }
							end
							catbutton = catpanel:CreateDropdown(mod.localization.options[v], dropdownOptions, mod, v, function(value)
								mod.Options[v] = value
								if mod.optionFuncs and mod.optionFuncs[v] then
									mod.optionFuncs[v]()
								end
							end, nil, 32)
							if not addSpacer then
								hasDropdowns = hasDropdowns + 7--Add 7 extra pixels per dropdown, because autodims is only reserving 25 per line, and dropdowns are 32
								catbutton:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, -10)
							end
						end
						if addSpacer then
							catbutton:SetPoint("TOPLEFT", lastButton, "BOTTOMLEFT", 0, -6)
							addSpacer = false
						end
					end
				end
				catpanel:AutoSetDimension(hasDropdowns)
				panel:SetMyOwnHeight()
			end
		end
	end
end
