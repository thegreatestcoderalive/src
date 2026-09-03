--// Kavo UI Library — Ultra-optimized rewrite
--// API-compatible with original Kavo by xHeptc
--// Edited by imonfent — added themes, cleaned internals, zero polling

local Kavo = {}
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

----------------------------------------------------------------
-- Core Utilities
----------------------------------------------------------------
local Info = TweenInfo.new
local function tw(obj, props, dur, style, dir)
	TweenService:Create(obj, Info(dur or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

local function new(class, props)
	local obj = Instance.new(class)
	for k, v in pairs(props) do obj[k] = v end
	return obj
end

local function corner(p, r) return new("UICorner", {CornerRadius = UDim.new(0, r or 4), Parent = p}) end
local function stroke(p, c) return new("UIStroke", {Parent = p, Color = c, Thickness = 1, Transparency = 0.6}) end
local function padding(p, t, b, l, r) return new("UIPadding", {PaddingTop = UDim.new(0,t or 0), PaddingBottom = UDim.new(0,b or 0), PaddingLeft = UDim.new(0,l or 0), PaddingRight = UDim.new(0,r or 0), Parent = p}) end
local function layout(p, sp) return new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, sp or 3), Parent = p}) end

local floor, clamp, max = math.floor, math.clamp, math.max
local function c255(v) return clamp(floor(v), 0, 255) end
local function shift(c, d) return Color3.fromRGB(c255(c.R*255+d), c255(c.G*255+d), c255(c.B*255+d)) end

local function ripple(btn, col)
	local f = new("Frame", {Parent = btn, BackgroundColor3 = col, BackgroundTransparency = 0.7, AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0, Mouse.X - btn.AbsolutePosition.X, 0, Mouse.Y - btn.AbsolutePosition.Y), Size = UDim2.fromOffset(0,0), ZIndex = btn.ZIndex + 1})
	corner(f, 999)
	local s = max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2
	tw(f, {Size = UDim2.fromOffset(s,s), Position = UDim2.new(0.5,0,0.5,0), BackgroundTransparency = 1}, 0.4)
	task.delay(0.45, f.Destroy, f)
end

local function bindHover(btn, base, d)
	d = d or 8
	btn.MouseEnter:Connect(function() tw(btn, {BackgroundColor3 = shift(base, d)}, 0.1) end)
	btn.MouseLeave:Connect(function() tw(btn, {BackgroundColor3 = base}, 0.1) end)
end

local function autoCanvas(scroll, ly)
	local function u() scroll.CanvasSize = UDim2.fromOffset(0, ly.AbsoluteContentSize.Y + 8) end
	ly:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(u); u()
end

local function makeDrag(handle, target)
	local dragging, dStart, fStart
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true; dStart = i.Position; fStart = target.Position
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	UserInput.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - dStart
			target.Position = UDim2.new(fStart.X.Scale, fStart.X.Offset + d.X, fStart.Y.Scale, fStart.Y.Offset + d.Y)
		end
	end)
end

----------------------------------------------------------------
-- Themes — monochromatic foundation + single accent highlight
----------------------------------------------------------------
local themeStyles = {
	DarkTheme   = {SchemeColor = Color3.fromRGB(64,64,64),   Background = Color3.fromRGB(0,0,0),       Header = Color3.fromRGB(0,0,0),       TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(20,20,20)},
	LightTheme  = {SchemeColor = Color3.fromRGB(150,150,150),Background = Color3.fromRGB(255,255,255), Header = Color3.fromRGB(200,200,200), TextColor = Color3.fromRGB(0,0,0),       ElementColor = Color3.fromRGB(224,224,224)},
	BloodTheme  = {SchemeColor = Color3.fromRGB(227,27,27),  Background = Color3.fromRGB(10,10,10),    Header = Color3.fromRGB(5,5,5),       TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(20,20,20)},
	GrapeTheme  = {SchemeColor = Color3.fromRGB(166,71,214), Background = Color3.fromRGB(64,50,71),    Header = Color3.fromRGB(36,28,41),    TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(74,58,84)},
	Ocean       = {SchemeColor = Color3.fromRGB(86,76,251),  Background = Color3.fromRGB(26,32,58),    Header = Color3.fromRGB(38,45,71),    TextColor = Color3.fromRGB(200,200,200), ElementColor = Color3.fromRGB(38,45,71)},
	Midnight    = {SchemeColor = Color3.fromRGB(26,189,158), Background = Color3.fromRGB(44,62,82),    Header = Color3.fromRGB(57,81,105),   TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(52,74,95)},
	Sentinel    = {SchemeColor = Color3.fromRGB(230,35,69),  Background = Color3.fromRGB(32,32,32),    Header = Color3.fromRGB(24,24,24),    TextColor = Color3.fromRGB(119,209,138), ElementColor = Color3.fromRGB(24,24,24)},
	Synapse     = {SchemeColor = Color3.fromRGB(46,48,43),   Background = Color3.fromRGB(13,15,12),    Header = Color3.fromRGB(36,38,35),    TextColor = Color3.fromRGB(152,99,53),   ElementColor = Color3.fromRGB(24,24,24)},
	Serpent     = {SchemeColor = Color3.fromRGB(0,166,58),   Background = Color3.fromRGB(31,41,43),    Header = Color3.fromRGB(22,29,31),    TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(22,29,31)},
	Aurora      = {SchemeColor = Color3.fromRGB(0,200,180),  Background = Color3.fromRGB(12,12,18),    Header = Color3.fromRGB(8,8,14),      TextColor = Color3.fromRGB(220,240,235), ElementColor = Color3.fromRGB(18,18,26)},
	Cyberpunk   = {SchemeColor = Color3.fromRGB(255,0,128),  Background = Color3.fromRGB(10,2,16),     Header = Color3.fromRGB(14,4,22),     TextColor = Color3.fromRGB(0,255,200),   ElementColor = Color3.fromRGB(18,6,28)},
	Sunset      = {SchemeColor = Color3.fromRGB(255,100,50), Background = Color3.fromRGB(18,10,8),     Header = Color3.fromRGB(24,14,10),    TextColor = Color3.fromRGB(255,220,200), ElementColor = Color3.fromRGB(30,18,14)},
	Forest      = {SchemeColor = Color3.fromRGB(34,139,34),  Background = Color3.fromRGB(10,18,10),    Header = Color3.fromRGB(14,24,14),    TextColor = Color3.fromRGB(200,230,200), ElementColor = Color3.fromRGB(18,30,18)},
	Candy       = {SchemeColor = Color3.fromRGB(255,105,180),Background = Color3.fromRGB(20,8,14),     Header = Color3.fromRGB(28,12,20),    TextColor = Color3.fromRGB(255,220,235), ElementColor = Color3.fromRGB(32,14,24)},
	Royal       = {SchemeColor = Color3.fromRGB(120,80,200), Background = Color3.fromRGB(12,8,20),     Header = Color3.fromRGB(18,12,30),    TextColor = Color3.fromRGB(220,210,255), ElementColor = Color3.fromRGB(22,16,36)},
	Neon        = {SchemeColor = Color3.fromRGB(57,255,20),  Background = Color3.fromRGB(4,4,4),       Header = Color3.fromRGB(8,8,8),       TextColor = Color3.fromRGB(57,255,20),   ElementColor = Color3.fromRGB(14,14,14)},
	Desert      = {SchemeColor = Color3.fromRGB(210,160,60), Background = Color3.fromRGB(22,18,12),    Header = Color3.fromRGB(28,24,16),    TextColor = Color3.fromRGB(240,225,190), ElementColor = Color3.fromRGB(34,28,20)},
	Ice         = {SchemeColor = Color3.fromRGB(100,180,255),Background = Color3.fromRGB(8,12,20),     Header = Color3.fromRGB(12,18,28),    TextColor = Color3.fromRGB(200,225,255), ElementColor = Color3.fromRGB(16,22,34)},
	Matrix      = {SchemeColor = Color3.fromRGB(0,255,65),   Background = Color3.fromRGB(0,4,0),       Header = Color3.fromRGB(0,8,0),       TextColor = Color3.fromRGB(0,255,65),    ElementColor = Color3.fromRGB(0,12,0)},
	Halloween   = {SchemeColor = Color3.fromRGB(255,120,0),  Background = Color3.fromRGB(14,6,2),      Header = Color3.fromRGB(20,8,4),      TextColor = Color3.fromRGB(255,200,140), ElementColor = Color3.fromRGB(26,12,6)},
	Pastel      = {SchemeColor = Color3.fromRGB(180,160,210),Background = Color3.fromRGB(240,235,245), Header = Color3.fromRGB(225,218,232), TextColor = Color3.fromRGB(60,50,70),    ElementColor = Color3.fromRGB(230,224,238)},
	Space       = {SchemeColor = Color3.fromRGB(90,60,220),  Background = Color3.fromRGB(6,4,14),      Header = Color3.fromRGB(10,8,22),     TextColor = Color3.fromRGB(200,190,240), ElementColor = Color3.fromRGB(14,10,28)},
}

local defaultTheme = {SchemeColor = Color3.fromRGB(74,99,135), Background = Color3.fromRGB(36,37,43), Header = Color3.fromRGB(28,29,34), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(32,32,38)}

local function resolveTheme(t)
	if type(t) == "string" and themeStyles[t] then return themeStyles[t] end
	if type(t) == "table" then
		local r = {}
		for k, v in pairs(defaultTheme) do r[k] = t[k] or v end
		return r
	end
	return defaultTheme
end

----------------------------------------------------------------
-- Library Core
----------------------------------------------------------------
local LibId = "Kavo_" .. tostring(math.random(1e5, 9e5))

function Kavo:ToggleUI()
	local g = game.CoreGui:FindFirstChild(LibId)
	if g then g.Enabled = not g.Enabled end
end

function Kavo:ChangeColor(prop, color)
	if self._theme and self._theme[prop] then
		self._theme[prop] = color
	end
end

function Kavo.CreateLib(title, themeInput)
	title = title or "Library"
	local T = resolveTheme(themeInput)
	Kavo._theme = T

	-- Cleanup previous instances
	for _, v in ipairs(game.CoreGui:GetChildren()) do
		if v.Name == LibId then v:Destroy() end
	end

	local gui = new("ScreenGui", {Name = LibId, Parent = game.CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false})

	-- Main Window
	local main = new("Frame", {Name = "Main", Parent = gui, BackgroundColor3 = T.Background, ClipsDescendants = true, Position = UDim2.new(0.5, -262, 0.5, -159), Size = UDim2.fromOffset(525, 318), BorderSizePixel = 0})
	corner(main, 6)
	stroke(main, shift(T.Header, 12))

	-- Header bar
	local header = new("Frame", {Name = "Header", Parent = main, BackgroundColor3 = T.Header, Size = UDim2.new(1, 0, 0, 30), BorderSizePixel = 0})
	makeDrag(header, main)

	new("TextLabel", {Parent = header, BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -44, 1, 0), Font = Enum.Font.GothamBold, Text = title, RichText = true, TextColor3 = Color3.fromRGB(245, 245, 245), TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left})

	local closeBtn = new("TextButton", {Parent = header, BackgroundTransparency = 1, Position = UDim2.new(1, -30, 0, 0), Size = UDim2.fromOffset(30, 30), Font = Enum.Font.GothamBold, Text = "×", TextColor3 = shift(T.TextColor, -80), TextSize = 18, AutoButtonColor = false})
	closeBtn.MouseEnter:Connect(function() tw(closeBtn, {TextColor3 = Color3.fromRGB(220, 60, 60)}, 0.1) end)
	closeBtn.MouseLeave:Connect(function() tw(closeBtn, {TextColor3 = shift(T.TextColor, -80)}, 0.1) end)
	closeBtn.MouseButton1Click:Connect(function()
		tw(main, {Size = UDim2.fromOffset(0, 0), Position = UDim2.new(0, main.AbsolutePosition.X + main.AbsoluteSize.X / 2, 0, main.AbsolutePosition.Y + main.AbsoluteSize.Y / 2)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		task.delay(0.25, gui.Destroy, gui)
	end)

	-- Sidebar
	local sidebar = new("Frame", {Name = "Sidebar", Parent = main, BackgroundColor3 = T.Header, Position = UDim2.fromOffset(0, 30), Size = UDim2.new(0, 140, 1, -30), BorderSizePixel = 0})
	local tabHolder = new("ScrollingFrame", {Parent = sidebar, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 4), Size = UDim2.new(1, 0, 1, -8), ScrollBarThickness = 2, ScrollBarImageColor3 = T.SchemeColor, BorderSizePixel = 0, CanvasSize = UDim2.fromOffset(0, 0)})
	local tabLay = layout(tabHolder, 3)
	padding(tabHolder, 4, 4, 6, 6)
	autoCanvas(tabHolder, tabLay)

	-- Pages container
	local pageArea = new("Frame", {Name = "Pages", Parent = main, BackgroundTransparency = 1, Position = UDim2.fromOffset(140, 30), Size = UDim2.new(1, -140, 1, -30), BorderSizePixel = 0})

	-- Tooltip bar
	local tipBar = new("TextLabel", {Name = "Tip", Parent = main, BackgroundColor3 = shift(T.Background, 6), BackgroundTransparency = 0.1, Position = UDim2.new(0, 140, 1, -24), Size = UDim2.new(1, -140, 0, 24), BorderSizePixel = 0, Font = Enum.Font.Gotham, Text = "", TextColor3 = shift(T.TextColor, -60), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left})
	padding(tipBar, 0, 0, 10, 0)
	local function showTip(t) tipBar.Text = t or "" end

	-- Open animation
	main.Size = UDim2.fromOffset(0, 0)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	tw(main, {Size = UDim2.fromOffset(525, 318), Position = UDim2.new(0.5, -262, 0.5, -159)}, 0.3, Enum.EasingStyle.Back)

	local Window = {}
	local firstTab = true

	----------------------------------------------------------------
	-- Tab
	----------------------------------------------------------------
	function Window:NewTab(tabName)
		tabName = tabName or "Tab"

		local tabBtn = new("TextButton", {Parent = tabHolder, BackgroundColor3 = T.SchemeColor, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28), AutoButtonColor = false, Font = Enum.Font.GothamSemibold, Text = tabName, TextColor3 = T.TextColor, TextSize = 13, ClipsDescendants = true})
		corner(tabBtn, 5)

		local page = new("ScrollingFrame", {Name = tabName, Parent = pageArea, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -24), ScrollBarThickness = 3, ScrollBarImageColor3 = shift(T.SchemeColor, -20), BorderSizePixel = 0, Visible = false, CanvasSize = UDim2.fromOffset(0, 0)})
		local pageLay = layout(page, 5)
		padding(page, 6, 6, 8, 8)
		autoCanvas(page, pageLay)

		if firstTab then
			firstTab = false
			page.Visible = true
			tabBtn.BackgroundTransparency = 0
		end

		tabBtn.MouseButton1Click:Connect(function()
			for _, pg in ipairs(pageArea:GetChildren()) do
				if pg:IsA("ScrollingFrame") then pg.Visible = false end
			end
			for _, tb in ipairs(tabHolder:GetChildren()) do
				if tb:IsA("TextButton") then tw(tb, {BackgroundTransparency = 1}, 0.15) end
			end
			page.Visible = true
			tw(tabBtn, {BackgroundTransparency = 0}, 0.15)
		end)

		local Tab = {}

		----------------------------------------------------------------
		-- Section
		----------------------------------------------------------------
		function Tab:NewSection(secName, hidden)
			secName = secName or "Section"
			hidden = hidden or false

			local sec = new("Frame", {Parent = page, BackgroundColor3 = T.Background, Size = UDim2.new(1, 0, 0, 30), AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0, ClipsDescendants = true})

			local secHead = new("Frame", {Parent = sec, BackgroundColor3 = T.SchemeColor, Size = UDim2.new(1, 0, 0, 30), Visible = not hidden, BorderSizePixel = 0})
			corner(secHead, 4)
			local secTitle = new("TextLabel", {Parent = secHead, BackgroundTransparency = 1, Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -16, 1, 0), Font = Enum.Font.GothamBold, Text = secName, RichText = true, TextColor3 = T.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})

			local inner = new("Frame", {Parent = sec, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, hidden and 0 or 33), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y})
			local innerLay = layout(inner, 3)
			padding(inner, 2, 4, 0, 0)

			local function updateSec()
				local top = hidden and 0 or 33
				inner.Position = UDim2.fromOffset(0, top)
				sec.Size = UDim2.new(1, 0, 0, top + inner.AbsoluteSize.Y + 6)
			end
			innerLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSec)
			task.defer(updateSec)

			-- Shared element builders
			local function mkElem(tip)
				local f = new("TextButton", {Parent = inner, BackgroundColor3 = T.ElementColor, Size = UDim2.new(1, 0, 0, 33), AutoButtonColor = false, Font = Enum.Font.SourceSans, Text = "", ClipsDescendants = true, BorderSizePixel = 0})
				corner(f, 4)
				bindHover(f, T.ElementColor)
				if tip then
					f.MouseEnter:Connect(function() showTip(tip) end)
					f.MouseLeave:Connect(function() showTip("") end)
				end
				return f
			end

			local function mkIcon(parent, rOff, rSize)
				return new("ImageLabel", {Parent = parent, BackgroundTransparency = 1, Position = UDim2.fromOffset(7, 6), Size = UDim2.fromOffset(21, 21), Image = "rbxassetid://3926305904", ImageColor3 = T.SchemeColor, ImageRectOffset = rOff or Vector2.new(84, 204), ImageRectSize = rSize or Vector2.new(36, 36)})
			end

			local function mkLabel(parent, text)
				return new("TextLabel", {Parent = parent, BackgroundTransparency = 1, Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -68, 1, 0), Font = Enum.Font.GothamSemibold, Text = text, RichText = true, TextColor3 = T.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left})
			end

			local Section = {}

			function Section:UpdateSection(newTitle)
				secTitle.Text = newTitle
			end

			-- Button
			function Section:NewButton(bname, bTip, callback)
				bname = bname or "Button"; callback = callback or function() end
				local f = mkElem(bTip)
				mkIcon(f, Vector2.new(84, 204), Vector2.new(36, 36))
				local lbl = mkLabel(f, bname)
				f.MouseButton1Click:Connect(function() ripple(f, T.SchemeColor); callback() end)
				local Fn = {}
				function Fn:UpdateButton(t) lbl.Text = t end
				return Fn
			end

			-- Toggle
			function Section:NewToggle(tname, tTip, callback)
				tname = tname or "Toggle"; callback = callback or function() end
				local toggled = false
				local f = mkElem(tTip)
				mkIcon(f, Vector2.new(628, 420), Vector2.new(48, 48))
				local lbl = mkLabel(f, tname)

				local track = new("Frame", {Parent = f, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(36, 18), BackgroundColor3 = shift(T.ElementColor, 16), BorderSizePixel = 0})
				corner(track, 9)
				local knob = new("Frame", {Parent = track, Position = UDim2.new(0, 2, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(14, 14), BackgroundColor3 = shift(T.TextColor, -60), BorderSizePixel = 0})
				corner(knob, 7)

				local function vis(v)
					toggled = v
					tw(track, {BackgroundColor3 = v and T.SchemeColor or shift(T.ElementColor, 16)}, 0.15)
					tw(knob, {Position = v and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = v and T.TextColor or shift(T.TextColor, -60)}, 0.15)
				end

				f.MouseButton1Click:Connect(function() vis(not toggled); ripple(f, T.SchemeColor); pcall(callback, toggled) end)

				local Fn = {}
				function Fn:UpdateToggle(newText, state)
					if newText then lbl.Text = newText end
					if state ~= nil then vis(state); pcall(callback, state) end
				end
				return Fn
			end

			-- Slider
			function Section:NewSlider(sName, sTip, maxVal, minVal, callback)
				sName = sName or "Slider"; maxVal = maxVal or 100; minVal = minVal or 0; callback = callback or function() end
				local f = mkElem(sTip)
				f.Size = UDim2.new(1, 0, 0, 38)
				mkIcon(f, Vector2.new(404, 164), Vector2.new(36, 36))
				local lbl = mkLabel(f, sName)
				lbl.Size = UDim2.new(0.35, 0, 0, 18); lbl.Position = UDim2.fromOffset(34, 2)

				local valLbl = new("TextLabel", {Parent = f, BackgroundTransparency = 1, Position = UDim2.fromOffset(34, 2), Size = UDim2.new(0.3, 0, 0, 18), Font = Enum.Font.GothamSemibold, Text = tostring(minVal), TextColor3 = T.SchemeColor, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right})

				local bar = new("Frame", {Parent = f, Position = UDim2.new(0.42, 0, 1, -10), Size = UDim2.new(0.54, 0, 0, 4), BackgroundColor3 = shift(T.ElementColor, 8), BorderSizePixel = 0})
				corner(bar, 2)
				local fill = new("Frame", {Parent = bar, Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = T.SchemeColor, BorderSizePixel = 0})
				corner(fill, 2)

				local sliding = false
				local function upd(inp)
					local rel = clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					local val = floor(minVal + rel * (maxVal - minVal))
					fill.Size = UDim2.new(rel, 0, 1, 0)
					valLbl.Text = tostring(val)
					pcall(callback, val)
				end

				bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; upd(i) end end)
				UserInput.InputChanged:Connect(function(i) if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then upd(i) end end)
				UserInput.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
			end

			-- TextBox
			function Section:NewTextBox(tName, tTip, callback)
				tName = tName or "Textbox"; callback = callback or function() end
				local f = mkElem(tTip)
				mkIcon(f, Vector2.new(324, 604), Vector2.new(36, 36))
				mkLabel(f, tName).Size = UDim2.new(0.38, 0, 1, 0)

				local box = new("TextBox", {Parent = f, BackgroundColor3 = shift(T.ElementColor, -6), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.new(0.44, 0, 0, 20), Font = Enum.Font.Gotham, PlaceholderText = "Type here!", PlaceholderColor3 = shift(T.SchemeColor, -30), Text = "", TextColor3 = T.SchemeColor, TextSize = 12, ClearTextOnFocus = false, BorderSizePixel = 0, ClipsDescendants = true})
				corner(box, 4)

				box.FocusLost:Connect(function(enter)
					if enter then pcall(callback, box.Text); task.wait(0.15); box.Text = "" end
				end)
			end

			-- Keybind
			function Section:NewKeybind(kText, kTip, defaultKey, callback)
				kText = kText or "Keybind"; callback = callback or function() end
				local key = defaultKey
				local f = mkElem(kTip)
				mkIcon(f, Vector2.new(364, 284), Vector2.new(36, 36))
				mkLabel(f, kText)

				local keyLbl = new("TextLabel", {Parent = f, BackgroundTransparency = 1, Position = UDim2.new(1, -78, 0, 0), Size = UDim2.fromOffset(70, 33), Font = Enum.Font.GothamSemibold, Text = key and key.Name or "None", TextColor3 = T.SchemeColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right})

				local listening = false
				f.MouseButton1Click:Connect(function()
					if listening then return end
					listening = true; keyLbl.Text = "..."
					local inp = UserInput.InputBegan:Wait()
					if inp.KeyCode ~= Enum.KeyCode.Unknown then key = inp.KeyCode; keyLbl.Text = key.Name end
					listening = false
				end)

				UserInput.InputBegan:Connect(function(inp, gpe)
					if not gpe and key and inp.KeyCode == key then pcall(callback) end
				end)
			end

			-- Dropdown
			function Section:NewDropdown(dName, dTip, list, callback)
				dName = dName or "Dropdown"; list = list or {}; callback = callback or function() end
				local opened = false

				local wrap = new("Frame", {Parent = inner, BackgroundColor3 = T.Background, Size = UDim2.new(1, 0, 0, 33), ClipsDescendants = true, BorderSizePixel = 0})
				corner(wrap, 4)

				local head = new("TextButton", {Parent = wrap, BackgroundColor3 = T.ElementColor, Size = UDim2.new(1, 0, 0, 33), AutoButtonColor = false, Font = Enum.Font.SourceSans, Text = "", ClipsDescendants = true, BorderSizePixel = 0})
				corner(head, 4)
				bindHover(head, T.ElementColor)
				mkIcon(head, Vector2.new(644, 364), Vector2.new(36, 36))
				local headLbl = mkLabel(head, dName)

				local arrow = new("TextLabel", {Parent = head, BackgroundTransparency = 1, Position = UDim2.new(1, -26, 0, 0), Size = UDim2.fromOffset(20, 33), Font = Enum.Font.GothamBold, Text = "▾", TextColor3 = shift(T.TextColor, -60), TextSize = 14})

				if dTip then
					head.MouseEnter:Connect(function() showTip(dTip) end)
					head.MouseLeave:Connect(function() showTip("") end)
				end

				local optFrame = new("Frame", {Parent = wrap, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 33), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y})
				local optLay = layout(optFrame, 2)
				padding(optFrame, 2, 4, 4, 4)

				local function buildOpts(lst)
					for _, c in ipairs(optFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
					for _, v in ipairs(lst) do
						local opt = new("TextButton", {Parent = optFrame, BackgroundColor3 = T.ElementColor, Size = UDim2.new(1, 0, 0, 28), AutoButtonColor = false, Font = Enum.Font.GothamSemibold, Text = "  " .. v, TextColor3 = shift(T.TextColor, -6), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ClipsDescendants = true, BorderSizePixel = 0})
						corner(opt, 4)
						bindHover(opt, T.ElementColor)
						opt.MouseButton1Click:Connect(function()
							headLbl.Text = v; pcall(callback, v); opened = false
							tw(wrap, {Size = UDim2.new(1, 0, 0, 33)}, 0.12)
							tw(arrow, {Rotation = 0}, 0.12)
						end)
					end
				end
				buildOpts(list)

				head.MouseButton1Click:Connect(function()
					opened = not opened
					if opened then
						tw(wrap, {Size = UDim2.new(1, 0, 0, 33 + optFrame.AbsoluteSize.Y + 8)}, 0.15)
						tw(arrow, {Rotation = 180}, 0.12)
					else
						tw(wrap, {Size = UDim2.new(1, 0, 0, 33)}, 0.12)
						tw(arrow, {Rotation = 0}, 0.12)
					end
				end)

				local Fn = {}
				function Fn:Refresh(newList)
					list = newList; buildOpts(newList)
					if opened then
						tw(wrap, {Size = UDim2.new(1, 0, 0, 33 + optFrame.AbsoluteSize.Y + 8)}, 0.15)
					else
						tw(wrap, {Size = UDim2.new(1, 0, 0, 33)}, 0.12)
					end
				end
				return Fn
			end

			-- ColorPicker
			function Section:NewColorPicker(cText, cTip, defColor, callback)
				cText = cText or "Color"; defColor = defColor or Color3.new(1, 1, 1); callback = callback or function() end
				local h, s, v = Color3.toHSV(defColor)
				local cpOpen = false

				local wrap = new("Frame", {Parent = inner, BackgroundColor3 = T.ElementColor, Size = UDim2.new(1, 0, 0, 33), ClipsDescendants = true, BorderSizePixel = 0})
				corner(wrap, 4)

				local head = new("TextButton", {Parent = wrap, BackgroundColor3 = T.ElementColor, Size = UDim2.new(1, 0, 0, 33), AutoButtonColor = false, Text = "", ClipsDescendants = true, BorderSizePixel = 0})
				corner(head, 4)
				bindHover(head, T.ElementColor)
				mkIcon(head, Vector2.new(44, 964), Vector2.new(36, 36))
				mkLabel(head, cText)
				if cTip then head.MouseEnter:Connect(function() showTip(cTip) end); head.MouseLeave:Connect(function() showTip("") end) end

				local preview = new("Frame", {Parent = head, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(36, 18), BackgroundColor3 = defColor, BorderSizePixel = 0})
				corner(preview, 4)

				local body = new("Frame", {Parent = wrap, BackgroundColor3 = T.ElementColor, Position = UDim2.fromOffset(0, 36), Size = UDim2.new(1, 0, 0, 100), BorderSizePixel = 0})

				local hueImg = new("ImageButton", {Parent = body, BackgroundTransparency = 1, Position = UDim2.fromOffset(8, 5), Size = UDim2.new(0.6, 0, 0, 90), Image = "rbxassetid://6523286724"})
				corner(hueImg, 4)
				local hueCur = new("Frame", {Parent = hueImg, Size = UDim2.fromOffset(10, 10), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5)})
				corner(hueCur, 5)

				local valImg = new("ImageButton", {Parent = body, BackgroundTransparency = 1, Position = UDim2.new(0.66, 0, 0, 5), Size = UDim2.fromOffset(16, 90), Image = "rbxassetid://6523291212"})
				corner(valImg, 4)
				local valCur = new("Frame", {Parent = valImg, Size = UDim2.fromOffset(16, 6), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0)})
				corner(valCur, 3)

				-- Rainbow
				local rbOn, rbConn, counter = false, nil, 0
				local rbBtn = new("TextButton", {Parent = body, Position = UDim2.new(0.76, 0, 0, 8), Size = UDim2.fromOffset(60, 20), BackgroundColor3 = shift(T.ElementColor, 10), AutoButtonColor = false, Font = Enum.Font.Gotham, Text = "Rainbow", TextColor3 = T.TextColor, TextSize = 11, BorderSizePixel = 0})
				corner(rbBtn, 4)

				local pickH, pickV = false, false
				local zigzag = function(x) return math.acos(math.cos(x * math.pi)) / math.pi end

				local function refresh()
					local c = Color3.fromHSV(h, s, v)
					preview.BackgroundColor3 = c
					hueCur.Position = UDim2.new(h, 0, 1 - s, 0)
					valCur.Position = UDim2.new(0.5, 0, 1 - v, 0)
					pcall(callback, c)
				end
				refresh()

				hueImg.MouseButton1Down:Connect(function() pickH = true end)
				valImg.MouseButton1Down:Connect(function() pickV = true end)
				UserInput.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then pickH = false; pickV = false end end)

				Mouse.Move:Connect(function()
					if pickH then
						h = clamp((Mouse.X - hueImg.AbsolutePosition.X) / hueImg.AbsoluteSize.X, 0, 1)
						s = 1 - clamp((Mouse.Y - hueImg.AbsolutePosition.Y) / hueImg.AbsoluteSize.Y, 0, 1)
						refresh()
					end
					if pickV then
						v = 1 - clamp((Mouse.Y - valImg.AbsolutePosition.Y) / valImg.AbsoluteSize.Y, 0, 1)
						refresh()
					end
				end)

				rbBtn.MouseButton1Click:Connect(function()
					rbOn = not rbOn
					tw(rbBtn, {BackgroundColor3 = rbOn and T.SchemeColor or shift(T.ElementColor, 10)}, 0.15)
					if rbOn then
						rbConn = RunService.RenderStepped:Connect(function() counter = counter + 0.01; h = zigzag(counter); s = 1; refresh() end)
					elseif rbConn then
						rbConn:Disconnect()
					end
				end)

				head.MouseButton1Click:Connect(function()
					cpOpen = not cpOpen
					tw(wrap, {Size = UDim2.new(1, 0, 0, cpOpen and 140 or 33)}, cpOpen and 0.15 or 0.12)
				end)
			end

			-- Label
			function Section:NewLabel(labelText)
				local l = new("TextLabel", {Parent = inner, BackgroundColor3 = T.SchemeColor, Size = UDim2.new(1, 0, 0, 30), Font = Enum.Font.GothamSemibold, Text = "  " .. (labelText or "Label"), RichText = true, TextColor3 = T.TextColor, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, ClipsDescendants = true})
				corner(l, 4)
				local Fn = {}
				function Fn:UpdateLabel(t) l.Text = "  " .. t end
				return Fn
			end

			return Section
		end

		return Tab
	end

	return Window
end

return Kavo
