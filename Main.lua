	--[[
		Vostigar Factory ADDON
		Ranadyla@Brisesol
	]]--

	local toc = ...
	local AddonId = toc.identifier
	local Lang = Library.Translate

	local cellName
	local cellCoord
	local cellStatus
	local VostigarFactoryButton
	local VostigarFactoryWindow 
	local VostigarFactoryContext
	local VostigarFactoryResetPoint
	local VostigarFactoryList = {}

	-- Table of particulars --
	local ChestsData = {
		{coordX = 4477, coordY = 2102, name = Lang.FIRST},
		{coordX = 4253, coordY = 2386, name = Lang.SECOND},
		{coordX = 3959, coordY = 2598, name = Lang.THIRD},
		{coordX = 2850, coordY = 2709, name = Lang.FOURTH},
		{coordX = 2985, coordY = 2198, name = Lang.FIFTH},
		{coordX = 3068, coordY = 2826, name = Lang.SIXTH},
		{coordX = 3259, coordY = 2008, name = Lang.SEVENTH},
	}

	-- Define VostigarFactorySettings table --
	if VostigarFactorySettings == nil then 
		VostigarFactorySettings = {} 
	end

	-- Define VostigarFactorySettings table --
	if VostigarFactorySettings.window == nil then
		VostigarFactorySettings.window = {
			x = math.floor(UIParent:GetWidth() / 3),
			y = math.floor(UIParent:GetHeight() / 3)
		}
	end

	local function dragDown(dragState, frame, event, ...)
		local mouse = Inspect.Mouse()
		dragState.dx = dragState.window:GetLeft() - mouse.x
		dragState.dy = dragState.window:GetTop() - mouse.y
		dragState.dragging = true
	end

	local function dragUp(dragState, frame, event, ...)
		dragState.dragging = false
	end

	local function dragMove(dragState, frame, event, x, y)
		if dragState.dragging then
			dragState.variable.x = x + dragState.dx
			dragState.variable.y = y + dragState.dy
			dragState.window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", dragState.variable.x, dragState.variable.y)
		end
	end

	local function dragAttach(window, variable)
		local 	dragState = { window = window, variable = variable, dragging = false }
				window:EventAttach(Event.UI.Input.Mouse.Right.Down, 		function(...) 	dragDown(dragState, ...) 	end, "dragDown")
				window:EventAttach(Event.UI.Input.Mouse.Right.Up, 			function(...) 	dragUp(dragState, ...) 		end, "dragUp")
				window:EventAttach(Event.UI.Input.Mouse.Right.Upoutside, 	function(...) 	dragUp(dragState, ...) 		end, "dragUpoutside")
				window:EventAttach(Event.UI.Input.Mouse.Cursor.Move, 		function(...) 	dragMove(dragState, ...) 	end, "dragMove")
				window:EventAttach(Event.UI.Input.Mouse.Cursor.Move, 		function(...) 	dragMove(dragState, ...) 	end, "dragMove")
	end

	-- Vostigar Chests --
	local function VostigarFactory()
		-- Create Context --
		VostigarFactoryContext = UI.CreateContext("VostigarFactoryContext")

		-- Create Main Frame --
		VostigarFactoryWindow = UI.CreateFrame("SimpleWindow", "VostigarFactoryWindow", VostigarFactoryContext)
		VostigarFactoryWindow:SetVisible(false)
		VostigarFactoryWindow:SetTitle(Lang.BTBVOSTIGARCHEST)
		VostigarFactoryWindow:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 60, 60)
		VostigarFactoryWindow:SetCloseButtonVisible(false)
		VostigarFactoryWindow:SetWidth(350)
		VostigarFactoryWindow:SetHeight(350)

		-- Create Scrolling Frame --
		VostigarFactoryScrollView = UI.CreateFrame("SimpleScrollView", VostigarFactoryWindow:GetName().."_ScrollView", VostigarFactoryWindow)
		VostigarFactoryScrollView:SetPoint("TOPLEFT", VostigarFactoryWindow, "TOPLEFT", 30, 70)
		VostigarFactoryScrollView:SetWidth(VostigarFactoryWindow:GetWidth() - 60)
		VostigarFactoryScrollView:SetHeight(VostigarFactoryWindow:GetHeight() - 120)

		-- Create Grid Frame --
		VostigarFactoryGrid = UI.CreateFrame("SimpleGrid", VostigarFactoryWindow:GetName().."_Grid", VostigarFactoryScrollView)
		VostigarFactoryGrid:SetPoint("TOPLEFT", VostigarFactoryScrollView, "TOPLEFT")
		VostigarFactoryGrid:SetBackgroundColor(0, 0, 0, 0.5)
		VostigarFactoryGrid:SetWidth(VostigarFactoryWindow:GetWidth())
		VostigarFactoryGrid:SetHeight(VostigarFactoryWindow:GetHeight())
		VostigarFactoryGrid:SetMargin(1)
		VostigarFactoryGrid:SetCellPadding(1)

		-- Create Reset Button  --
		VostigarFactoryResetPoint = UI.CreateFrame("RiftButton", VostigarFactoryWindow:GetName().."_ResetPoint", VostigarFactoryWindow)
		VostigarFactoryResetPoint:SetText(Lang.RESETPOI)
		VostigarFactoryResetPoint:SetPoint("BOTTOMCENTER", VostigarFactoryWindow, "BOTTOMCENTER", 0, -15)

		-- Create Show Button --
		VostigarFactoryButton = UI.CreateFrame("Texture", VostigarFactoryWindow:GetName().."_Button", VostigarFactoryContext)
		VostigarFactoryButton:SetPoint("TOPLEFT", UIParent, "TOPLEFT", VostigarFactorySettings.window.x, VostigarFactorySettings.window.y)
		VostigarFactoryButton:SetTextureAsync( AddonId, "Pictures/ButtonDown.png" )
		VostigarFactoryButton:ClearWidth()
		VostigarFactoryButton:SetWidth(30)
		VostigarFactoryButton:SetHeight(30)
		VostigarFactoryButton:SetVisible(true)

		-- Create Close button --
		VostigarFactoryButtonClose = UI.CreateFrame("RiftButton", VostigarFactoryWindow:GetName().."_ButtonClose", VostigarFactoryWindow)
		VostigarFactoryButtonClose:SetSkin("close")
		VostigarFactoryButtonClose:SetPoint("TOPRIGHT", VostigarFactoryWindow, "TOPRIGHT", -8, 16)

		-- Move VostigarFactoryButton --
		dragAttach(VostigarFactoryButton, VostigarFactorySettings.window)

		-- Write Name and Coord --
		for k, v in pairs(ChestsData) do
			-- Zone Name --
			cellName = UI.CreateFrame("Text", VostigarFactoryWindow:GetName().."_CellName", VostigarFactoryGrid)
			cellName:SetText(tostring(v.name))
			cellName:SetFontSize(14)
			cellName:SetFontColor(0, 255, 0)

			-- Zone Coord --
			cellCoord = UI.CreateFrame("Text", VostigarFactoryWindow:GetName().."_CellCoord", VostigarFactoryGrid)
			cellCoord:SetText(Lang.SPACE .. Lang.SPACE .. Lang.SPACE .. tostring(v.coordX) .. ", " .. tostring(v.coordY))
			cellCoord:SetFontColor(1, 1, 1)
			cellCoord:SetFontSize(14)

			-- Event on Left Clic --
			cellCoord:EventAttach(Event.UI.Input.Mouse.Left.Click, function(self, h)
				-- Restricted Mode --
				VostigarFactoryContext:SetSecureMode("restricted")
				VostigarFactoryWindow:SetSecureMode("restricted")
				VostigarFactoryScrollView:SetSecureMode("restricted")
				VostigarFactoryGrid:SetSecureMode("restricted")
				self:SetSecureMode("restricted")
				-- Launch cmd --
				self:EventMacroSet(Event.UI.Input.Mouse.Left.Click, "/setwaypoint " .. tostring(v.coordX) .. ", " .. tostring(v.coordY))
			end, "Event.UI.Input.Mouse.Left.Click")

			-- Event Mouse in --
			cellCoord:EventAttach(Event.UI.Input.Mouse.Cursor.In, function(self, h)
				-- Apply color --
				self:SetFontColor(0, 255, 0)
			end, "Event.UI.Input.Mouse.Cursor.In")

			-- Event Mouse Out --
			cellCoord:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function(self, h)
				-- Apply color --
				self:SetFontColor(1, 1, 1)
			end, "Event.UI.Input.Mouse.Cursor.Out")

			-- Create table --
			v.row = {cellName, cellCoord}
			-- Add to Grid --
			VostigarFactoryGrid:AddRow(v.row)
		end

		-- Include Text in scroll --
		VostigarFactoryScrollView:SetContent(VostigarFactoryGrid)

		-- Event left Clic on Button --
		function VostigarFactoryButton.Event:LeftClick()
			if not VostigarFactoryWindow.visible then
				VostigarFactoryWindow:SetVisible(true)
			else
				VostigarFactoryWindow:SetVisible(false)
			end	
			-- Apply texture --
			self:SetTextureAsync(AddonId, "Pictures/ButtonUp.png")
			-- on / off button --
			VostigarFactoryWindow.visible = not VostigarFactoryWindow.visible
		end

		-- Event on mouse out button --
		function VostigarFactoryButton.Event:MouseIn()
			if not VostigarFactoryWindow.visible then
				-- Apply texture --
				self:SetTextureAsync(AddonId, "Pictures/ButtonUp.png")
			end
		end

		-- Event on mouse out button --
		function VostigarFactoryButton.Event:MouseOut()
			if not VostigarFactoryWindow.visible then
				-- Apply texture --
				self:SetTextureAsync(AddonId, "Pictures/ButtonDown.png")
			end
		end

		-- Event on close window --
		function VostigarFactoryButtonClose.Event:LeftPress()
			if VostigarFactoryWindow.visible then
				VostigarFactoryButton:SetTextureAsync(AddonId, "Pictures/ButtonDown.png")
				VostigarFactoryWindow:SetVisible(false)
			end	
			-- on / off button --
			VostigarFactoryWindow.visible = not VostigarFactoryWindow.visible
		end

		-- Event on reset waypoint --
		function VostigarFactoryResetPoint.Event:LeftPress()
			-- Restricted Mode --
			VostigarFactoryContext:SetSecureMode("restricted")
			VostigarFactoryWindow:SetSecureMode("restricted")
			self:SetSecureMode("restricted")
			-- Launch cmd --
			self:EventMacroSet(Event.UI.Input.Mouse.Left.Click, "/clearwaypoint")
		end
	end

	-- Display Addon --
	local function showVostigarChestMap()
		if not VostigarFactoryWindow.visible then
			-- Show window --
			VostigarFactoryWindow:SetVisible(true)
			-- Apply texture --
			VostigarFactoryButton:SetTextureAsync(AddonId, "Pictures/ButtonUp.png")
		else
			-- Hide window
			VostigarFactoryWindow:SetVisible(false)
			-- Apply texture --
			VostigarFactoryButton:SetTextureAsync(AddonId, "Pictures/ButtonDown.png")
		end	
		-- on / off button --
		VostigarFactoryWindow.visible = not VostigarFactoryWindow.visible
	end

	-- Register the slash commands --
	table.insert(Command.Slash.Register("vc"), {showVostigarChestMap, AddonId, "Slash command"})

	-- Init Settings --
	local function settingsInitVostigarChests()
		if VostigarFactorySettings == nil then VostigarFactorySettings = {} end
			if VostigarFactorySettings.window == nil then
				VostigarFactorySettings.window = {
					x = math.floor(UIParent:GetWidth() / 4),
					y = math.floor(UIParent:GetHeight() / 4)
				}
		end
	end

	-- Init Addon --
	local function InitVostigarChests(handle, addonIdentifier)
		-- Error if loading bad addon --
		if addonIdentifier ~= AddonId then
			return
		end
		-- Load Addon --
		VostigarFactory()
		-- Load Settings --
		settingsInitVostigarChests()
		-- Load Message --
		print(Lang.SPACE .. Lang.ADDONSTART)
	end

	-- Load Addon at the end of loading game --
	Command.Event.Attach(Event.Addon.Load.End, InitVostigarChests, AddonId .. " initialized")