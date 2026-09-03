-- ponytail: ultra rewrite — every line earns its place
local Flux = {}
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()

----------------------------------------------------------------
-- Utility
----------------------------------------------------------------
local function tw(obj, props, dur, style, dir)
	TweenService:Create(obj, TweenInfo.new(dur or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

local function create(class, props, children)
	local obj = Instance.new(class)
	for k, v in pairs(props) do obj[k] = v end
	if children then for _, c in ipairs(children) do c.Parent = obj end end
	return obj
end

local function corner(parent, radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius or 6), Parent = parent })
end

local function pad(parent, t, b, l, r)
	return create("UIPadding", { PaddingTop = UDim.new(0,t or 6), PaddingBottom = UDim.new(0,b or 6), PaddingLeft = UDim.new(0,l or 8), PaddingRight = UDim.new(0,r or 8), Parent = parent })
end

local function list(parent, spacing, dir)
	return create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, spacing or 4), FillDirection = dir or Enum.FillDirection.Vertical, Parent = parent })
end

local function clampRGB(v) return math.clamp(math.floor(v), 0, 255) end
local function shift(c3, delta)
	return Color3.fromRGB(clampRGB(c3.R*255+delta), clampRGB(c3.G*255+delta), clampRGB(c3.B*255+delta))
end

local function ripple(btn, color)
	local c = create("Frame", {
		Parent = btn, BackgroundColor3 = color or Color3.new(1,1,1), BackgroundTransparency = 0.7,
		AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0, Mouse.X - btn.AbsolutePosition.X, 0, Mouse.Y - btn.AbsolutePosition.Y),
		Size = UDim2.fromOffset(0,0), ZIndex = btn.ZIndex + 1
	})
	corner(c, 999)
	local size = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2
	tw(c, { Size = UDim2.fromOffset(size, size), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1 }, 0.4)
	task.delay(0.45, function() c:Destroy() end)
end

local function hover(btn, base, delta)
	delta = delta or 10
	btn.MouseEnter:Connect(function() tw(btn, { BackgroundColor3 = shift(base, delta) }, 0.12) end)
	btn.MouseLeave:Connect(function() tw(btn, { BackgroundColor3 = base }, 0.12) end)
end

local function autoCanvas(scroll, layout)
	local function upd() scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8) end
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(upd)
	upd()
end

local function makeDraggable(handle, target)
	local dragging, dragStart, startPos
	handle.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true; dragStart = inp.Position; startPos = target.Position
			inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	UserInput.InputChanged:Connect(function(inp)
		if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
			local d = inp.Position - dragStart
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end

----------------------------------------------------------------
-- Themes — monochromatic foundation + single neutral highlight
----------------------------------------------------------------
local Themes = {
	Obsidian = { Bg = Color3.fromRGB(14,14,16), Surface = Color3.fromRGB(22,22,26), Header = Color3.fromRGB(18,18,22), Text = Color3.fromRGB(210,210,215), Sub = Color3.fromRGB(120,120,130), Accent = Color3.fromRGB(160,160,170) },
	Carbon = { Bg = Color3.fromRGB(20,20,22), Surface = Color3.fromRGB(30,30,34), Header = Color3.fromRGB(24,24,28), Text = Color3.fromRGB(220,220,225), Sub = Color3.fromRGB(110,110,120), Accent = Color3.fromRGB(145,145,155) },
	Slate = { Bg = Color3.fromRGB(28,30,36), Surface = Color3.fromRGB(38,40,48), Header = Color3.fromRGB(32,34,40), Text = Color3.fromRGB(225,225,230), Sub = Color3.fromRGB(130,135,145), Accent = Color3.fromRGB(170,175,185) },
	Graphite = { Bg = Color3.fromRGB(36,36,40), Surface = Color3.fromRGB(48,48,54), Header = Color3.fromRGB(40,40,46), Text = Color3.fromRGB(230,230,235), Sub = Color3.fromRGB(140,140,150), Accent = Color3.fromRGB(180,180,190) },
	Ash = { Bg = Color3.fromRGB(44,44,48), Surface = Color3.fromRGB(58,58,64), Header = Color3.fromRGB(50,50,56), Text = Color3.fromRGB(235,235,240), Sub = Color3.fromRGB(150,150,160), Accent = Color3.fromRGB(190,190,200) },
	Silver = { Bg = Color3.fromRGB(230,230,235), Surface = Color3.fromRGB(240,240,244), Header = Color3.fromRGB(220,220,226), Text = Color3.fromRGB(24,24,28), Sub = Color3.fromRGB(100,100,110), Accent = Color3.fromRGB(80,80,90) },
	Ivory = { Bg = Color3.fromRGB(245,243,240), Surface = Color3.fromRGB(252,250,248), Header = Color3.fromRGB(235,233,230), Text = Color3.fromRGB(30,28,26), Sub = Color3.fromRGB(110,108,104), Accent = Color3.fromRGB(90,88,84) },
	Onyx = { Bg = Color3.fromRGB(8,8,10), Surface = Color3.fromRGB(16,16,20), Header = Color3.fromRGB(12,12,14), Text = Color3.fromRGB(200,200,210), Sub = Color3.fromRGB(100,100,115), Accent = Color3.fromRGB(140,140,155) },
}

local function resolveTheme(t)
	if type(t) == "string" then return Themes[t] or Themes.Obsidian end
	if type(t) == "table" and t.Bg then return t end
	return Themes.Obsidian
end

----------------------------------------------------------------
-- Library
----------------------------------------------------------------
local libId = "Flux_" .. tostring(math.random(1e5, 9e5))

function Flux:ToggleUI()
	local gui = game.CoreGui:FindFirstChild(libId)
	if gui then gui.Enabled = not gui.Enabled end
end

function Flux:Destroy()
	local gui = game.CoreGui:FindFirstChild(libId)
	if gui then gui:Destroy() end
end

function Flux:SetTheme(name)
	-- ponytail: runtime theme swap if needed; users override self._theme
	self._theme = resolveTheme(name)
end

function Flux.new(config)
	config = config or {}
	local title = config.Title or "Flux"
	local theme = resolveTheme(config.Theme)
	local size = config.Size or UDim2.fromOffset(560, 340)

	-- cleanup previous
	for _, v in ipairs(game.CoreGui:GetChildren()) do if v.Name == libId then v:Destroy() end end

	local gui = create("ScreenGui", { Name = libId, Parent = game.CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false })

	local main = create("Frame", { Name = "Main", Parent = gui, BackgroundColor3 = theme.Bg, ClipsDescendants = true, Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2), Size = size, BorderSizePixel = 0 })
	corner(main, 8)
	create("UIStroke", { Parent = main, Color = shift(theme.Surface, 8), Thickness = 1, Transparency = 0.5 })

	-- Header
	local header = create("Frame", { Name = "Header", Parent = main, BackgroundColor3 = theme.Header, Size = UDim2.new(1,0,0,32), BorderSizePixel = 0 })
	makeDraggable(header, main)

	local titleLbl = create("TextLabel", { Parent = header, BackgroundTransparency = 1, Position = UDim2.fromOffset(12,0), Size = UDim2.new(1,-60,1,0), Font = Enum.Font.GothamBold, Text = title, TextColor3 = theme.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })

	local closeBtn = create("TextButton", { Parent = header, BackgroundTransparency = 1, Position = UDim2.new(1,-32,0,0), Size = UDim2.fromOffset(32,32), Font = Enum.Font.GothamBold, Text = "×", TextColor3 = theme.Sub, TextSize = 20, AutoButtonColor = false })
	closeBtn.MouseEnter:Connect(function() tw(closeBtn, {TextColor3 = Color3.fromRGB(220,60,60)}, 0.12) end)
	closeBtn.MouseLeave:Connect(function() tw(closeBtn, {TextColor3 = theme.Sub}, 0.12) end)
	closeBtn.MouseButton1Click:Connect(function()
		tw(main, { Size = UDim2.fromOffset(0,0), Position = UDim2.new(0, main.AbsolutePosition.X + main.AbsoluteSize.X/2, 0, main.AbsolutePosition.Y + main.AbsoluteSize.Y/2) }, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		task.delay(0.25, function() gui:Destroy() end)
	end)

	-- Sidebar
	local sidebar = create("Frame", { Name = "Sidebar", Parent = main, BackgroundColor3 = theme.Header, Position = UDim2.fromOffset(0,32), Size = UDim2.new(0,150,1,-32), BorderSizePixel = 0 })
	local tabHolder = create("ScrollingFrame", { Parent = sidebar, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,6), Size = UDim2.new(1,-2,1,-12), ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Accent, BorderSizePixel = 0, CanvasSize = UDim2.new(0,0,0,0) })
	local tabLayout = list(tabHolder, 3)
	pad(tabHolder, 4, 4, 6, 6)
	autoCanvas(tabHolder, tabLayout)

	-- Page area
	local pageArea = create("Frame", { Name = "Pages", Parent = main, BackgroundTransparency = 1, Position = UDim2.fromOffset(150,32), Size = UDim2.new(1,-150,1,-32), BorderSizePixel = 0 })

	-- Tooltip bar
	local tipBar = create("TextLabel", { Name = "Tip", Parent = main, BackgroundColor3 = shift(theme.Surface, 6), BackgroundTransparency = 0.1, Position = UDim2.new(0,150,1,-26), Size = UDim2.new(1,-150,0,26), BorderSizePixel = 0, Font = Enum.Font.Gotham, Text = "", TextColor3 = theme.Sub, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })
	corner(tipBar, 0)
	pad(tipBar, 0, 0, 10, 0)

	local function showTip(txt) tipBar.Text = txt or "" end

	-- Open animation
	main.Size = UDim2.fromOffset(0,0)
	main.Position = UDim2.new(0.5,0,0.5,0)
	tw(main, { Size = size, Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2) }, 0.3, Enum.EasingStyle.Back)

	local lib = { _gui = gui, _main = main, _theme = theme, _tabs = {}, _activeTab = nil }
	setmetatable(lib, { __index = Flux })

	----------------------------------------------------------------
	-- Tab
	----------------------------------------------------------------
	function lib:Tab(name)
		name = name or "Tab"
		local t = theme

		local btn = create("TextButton", { Parent = tabHolder, BackgroundColor3 = t.Surface, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,28), AutoButtonColor = false, Font = Enum.Font.GothamSemibold, Text = name, TextColor3 = t.Sub, TextSize = 13, ClipsDescendants = true })
		corner(btn, 5)

		local page = create("ScrollingFrame", { Name = name, Parent = pageArea, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,-26), Position = UDim2.fromOffset(0,0), ScrollBarThickness = 3, ScrollBarImageColor3 = theme.Accent, BorderSizePixel = 0, Visible = false, CanvasSize = UDim2.new(0,0,0,0) })
		local pageLayout = list(page, 5)
		pad(page, 8, 8, 10, 10)
		autoCanvas(page, pageLayout)

		local isFirst = #lib._tabs == 0
		if isFirst then
			page.Visible = true
			btn.BackgroundTransparency = 0
			btn.TextColor3 = t.Text
			lib._activeTab = btn
		end

		btn.MouseButton1Click:Connect(function()
			for _, pg in ipairs(pageArea:GetChildren()) do if pg:IsA("ScrollingFrame") then pg.Visible = false end end
			for _, tb in ipairs(tabHolder:GetChildren()) do if tb:IsA("TextButton") then tw(tb, { BackgroundTransparency = 1, TextColor3 = t.Sub }, 0.15) end end
			page.Visible = true
			tw(btn, { BackgroundTransparency = 0, TextColor3 = t.Text }, 0.15)
			lib._activeTab = btn
		end)

		table.insert(lib._tabs, { btn = btn, page = page })
		local tab = { _page = page, _theme = t }

		----------------------------------------------------------------
		-- Section
		----------------------------------------------------------------
		function tab:Section(secName)
			secName = secName or "Section"
			local t = self._theme

			local sec = create("Frame", { Parent = page, BackgroundColor3 = t.Surface, Size = UDim2.new(1,0,0,30), AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0, ClipsDescendants = true })
			corner(sec, 6)

			local secHead = create("TextLabel", { Parent = sec, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,26), Font = Enum.Font.GothamBold, Text = secName, TextColor3 = t.Accent, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left })
			pad(secHead, 0, 0, 10, 0)

			local inner = create("Frame", { Parent = sec, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,26), Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y })
			local innerLayout = list(inner, 3)
			pad(inner, 2, 6, 6, 6)

			local function updateSec()
				sec.Size = UDim2.new(1, 0, 0, 26 + inner.AbsoluteSize.Y + 8)
			end
			innerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSec)
			task.defer(updateSec)

			local elem = {}

			-- shared element frame builder
			local function elemFrame(label, tip)
				local f = create("TextButton", { Parent = inner, BackgroundColor3 = shift(t.Surface, 6), Size = UDim2.new(1,0,0,32), AutoButtonColor = false, Font = Enum.Font.SourceSans, Text = "", ClipsDescendants = true, BorderSizePixel = 0 })
				corner(f, 5)
				hover(f, shift(t.Surface, 6), 8)
				local lbl = create("TextLabel", { Parent = f, BackgroundTransparency = 1, Position = UDim2.fromOffset(10,0), Size = UDim2.new(1,-20,1,0), Font = Enum.Font.GothamSemibold, Text = label or "", TextColor3 = t.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
				if tip then
					f.MouseEnter:Connect(function() showTip(tip) end)
					f.MouseLeave:Connect(function() showTip("") end)
				end
				return f, lbl
			end

			------------------------------------------------------------
			-- Button
			------------------------------------------------------------
			function elem:Button(cfg)
				cfg = cfg or {}
				local f, lbl = elemFrame(cfg.Name or "Button", cfg.Tip)
				local cb = cfg.Callback or function() end
				f.MouseButton1Click:Connect(function() ripple(f, t.Accent); cb() end)
				return { Update = function(_, txt) lbl.Text = txt end }
			end

			------------------------------------------------------------
			-- Toggle
			------------------------------------------------------------
			function elem:Toggle(cfg)
				cfg = cfg or {}
				local f, lbl = elemFrame(cfg.Name or "Toggle", cfg.Tip)
				local toggled = cfg.Default or false
				local cb = cfg.Callback or function() end
				local ind = create("Frame", { Parent = f, AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.fromOffset(36,18), BackgroundColor3 = toggled and t.Accent or shift(t.Surface, 16), BorderSizePixel = 0 })
				corner(ind, 9)
				local knob = create("Frame", { Parent = ind, Position = toggled and UDim2.new(1,-16,0.5,0) or UDim2.new(0,2,0.5,0), AnchorPoint = Vector2.new(0,0.5), Size = UDim2.fromOffset(14,14), BackgroundColor3 = toggled and t.Text or t.Sub, BorderSizePixel = 0 })
				corner(knob, 7)
				local function set(v)
					toggled = v
					tw(ind, { BackgroundColor3 = v and t.Accent or shift(t.Surface, 16) }, 0.15)
					tw(knob, { Position = v and UDim2.new(1,-16,0.5,0) or UDim2.new(0,2,0.5,0), BackgroundColor3 = v and t.Text or t.Sub }, 0.15)
				end
				f.MouseButton1Click:Connect(function() set(not toggled); ripple(f, t.Accent); pcall(cb, toggled) end)
				if toggled then pcall(cb, true) end
				return { Set = function(_, v) set(v); pcall(cb, v) end, Get = function() return toggled end }
			end

			------------------------------------------------------------
			-- Slider
			------------------------------------------------------------
			function elem:Slider(cfg)
				cfg = cfg or {}
				local f, lbl = elemFrame(cfg.Name or "Slider", cfg.Tip)
				f.Size = UDim2.new(1,0,0,38)
				local min, max = cfg.Min or 0, cfg.Max or 100
				local val = math.clamp(cfg.Default or min, min, max)
				local cb = cfg.Callback or function() end

				local valLbl = create("TextLabel", { Parent = f, BackgroundTransparency = 1, Position = UDim2.new(1,-60,0,0), Size = UDim2.fromOffset(50,18), Font = Enum.Font.GothamSemibold, Text = tostring(val), TextColor3 = t.Accent, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right })
				local track = create("Frame", { Parent = f, Position = UDim2.new(0,10,1,-10), Size = UDim2.new(1,-20,0,4), BackgroundColor3 = shift(t.Surface, 14), BorderSizePixel = 0 })
				corner(track, 2)
				local fill = create("Frame", { Parent = track, Size = UDim2.new((val-min)/(max-min),0,1,0), BackgroundColor3 = t.Accent, BorderSizePixel = 0 })
				corner(fill, 2)

				local sliding = false
				local function update(inp)
					local rel = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
					val = math.floor(min + rel * (max - min))
					fill.Size = UDim2.new(rel, 0, 1, 0)
					valLbl.Text = tostring(val)
					pcall(cb, val)
				end
				track.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; update(inp) end end)
				UserInput.InputChanged:Connect(function(inp) if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then update(inp) end end)
				UserInput.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
				return { Set = function(_, v) val = math.clamp(v, min, max); local r = (val-min)/(max-min); fill.Size = UDim2.new(r,0,1,0); valLbl.Text = tostring(val); pcall(cb, val) end, Get = function() return val end }
			end

			------------------------------------------------------------
			-- TextBox
			------------------------------------------------------------
			function elem:TextBox(cfg)
				cfg = cfg or {}
				local f, lbl = elemFrame(cfg.Name or "Input", cfg.Tip)
				local cb = cfg.Callback or function() end
				local box = create("TextBox", { Parent = f, BackgroundColor3 = shift(t.Surface, -4), Position = UDim2.new(0.5,0,0.5,0), AnchorPoint = Vector2.new(0,0.5), Size = UDim2.new(0.45,0,0,22), Font = Enum.Font.Gotham, PlaceholderText = cfg.Placeholder or "Type...", PlaceholderColor3 = t.Sub, Text = cfg.Default or "", TextColor3 = t.Text, TextSize = 12, ClearTextOnFocus = false, BorderSizePixel = 0, ClipsDescendants = true })
				corner(box, 4)
				box.FocusLost:Connect(function(enter) if enter then pcall(cb, box.Text) end end)
				return { Set = function(_, v) box.Text = v end, Get = function() return box.Text end }
			end

			------------------------------------------------------------
			-- Dropdown
			------------------------------------------------------------
			function elem:Dropdown(cfg)
				cfg = cfg or {}
				local items = cfg.Items or {}
				local cb = cfg.Callback or function() end
				local opened = false
				local selected = cfg.Default

				local wrap = create("Frame", { Parent = inner, BackgroundColor3 = shift(t.Surface, 6), Size = UDim2.new(1,0,0,32), ClipsDescendants = true, BorderSizePixel = 0 })
				corner(wrap, 5)

				local head = create("TextButton", { Parent = wrap, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,32), AutoButtonColor = false, Font = Enum.Font.GothamSemibold, Text = "", TextSize = 13, ClipsDescendants = true })
				local headLbl = create("TextLabel", { Parent = head, BackgroundTransparency = 1, Position = UDim2.fromOffset(10,0), Size = UDim2.new(1,-20,1,0), Font = Enum.Font.GothamSemibold, Text = selected or cfg.Name or "Select...", TextColor3 = t.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
				local arrow = create("TextLabel", { Parent = head, BackgroundTransparency = 1, Position = UDim2.new(1,-28,0,0), Size = UDim2.fromOffset(20,32), Font = Enum.Font.GothamBold, Text = "▾", TextColor3 = t.Sub, TextSize = 14 })

				if cfg.Tip then
					head.MouseEnter:Connect(function() showTip(cfg.Tip) end)
					head.MouseLeave:Connect(function() showTip("") end)
				end

				local optContainer = create("Frame", { Parent = wrap, BackgroundTransparency = 1, Position = UDim2.fromOffset(0,32), Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y })
				local optLayout = list(optContainer, 2)
				pad(optContainer, 2, 4, 4, 4)

				local function buildOptions(lst)
					for _, c in ipairs(optContainer:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
					for _, v in ipairs(lst) do
						local opt = create("TextButton", { Parent = optContainer, BackgroundColor3 = shift(t.Surface, 10), Size = UDim2.new(1,0,0,26), AutoButtonColor = false, Font = Enum.Font.Gotham, Text = v, TextColor3 = t.Text, TextSize = 12, ClipsDescendants = true, BorderSizePixel = 0 })
						corner(opt, 4)
						hover(opt, shift(t.Surface, 10), 8)
						opt.MouseButton1Click:Connect(function()
							selected = v; headLbl.Text = v; pcall(cb, v)
							opened = false
							tw(wrap, { Size = UDim2.new(1,0,0,32) }, 0.12)
							tw(arrow, { Rotation = 0 }, 0.12)
						end)
					end
				end
				buildOptions(items)

				head.MouseButton1Click:Connect(function()
					opened = not opened
					if opened then
						local h = 32 + optContainer.AbsoluteSize.Y + 8
						tw(wrap, { Size = UDim2.new(1,0,0,h) }, 0.15)
						tw(arrow, { Rotation = 180 }, 0.12)
					else
						tw(wrap, { Size = UDim2.new(1,0,0,32) }, 0.12)
						tw(arrow, { Rotation = 0 }, 0.12)
					end
				end)

				return {
					Set = function(_, v) selected = v; headLbl.Text = v; pcall(cb, v) end,
					Get = function() return selected end,
					Refresh = function(_, newList) items = newList; buildOptions(newList); if opened then tw(wrap, { Size = UDim2.new(1,0,0,32 + optContainer.AbsoluteSize.Y + 8) }, 0.15) end end
				}
			end

			------------------------------------------------------------
			-- Keybind
			------------------------------------------------------------
			function elem:Keybind(cfg)
				cfg = cfg or {}
				local f, lbl = elemFrame(cfg.Name or "Keybind", cfg.Tip)
				local key = cfg.Default
				local cb = cfg.Callback or function() end
				local keyLbl = create("TextLabel", { Parent = f, BackgroundTransparency = 1, Position = UDim2.new(1,-80,0,0), Size = UDim2.fromOffset(70,32), Font = Enum.Font.GothamSemibold, Text = key and key.Name or "None", TextColor3 = t.Accent, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right })
				local listening = false
				f.MouseButton1Click:Connect(function()
					if listening then return end
					listening = true; keyLbl.Text = "..."
					local inp = UserInput.InputBegan:Wait()
					if inp.KeyCode ~= Enum.KeyCode.Unknown then key = inp.KeyCode; keyLbl.Text = key.Name end
					listening = false
				end)
				UserInput.InputBegan:Connect(function(inp, gpe) if not gpe and key and inp.KeyCode == key then pcall(cb) end end)
				return { Set = function(_, k) key = k; keyLbl.Text = k.Name end, Get = function() return key end }
			end

			------------------------------------------------------------
			-- ColorPicker
			------------------------------------------------------------
			function elem:ColorPicker(cfg)
				cfg = cfg or {}
				local f, lbl = elemFrame(cfg.Name or "Color", cfg.Tip)
				f.Size = UDim2.new(1,0,0,32)
				local color = cfg.Default or Color3.fromRGB(255,255,255)
				local cb = cfg.Callback or function() end
				local opened = false

				local preview = create("Frame", { Parent = f, AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-10,0.5,0), Size = UDim2.fromOffset(32,18), BackgroundColor3 = color, BorderSizePixel = 0 })
				corner(preview, 4)

				local pickerWrap = create("Frame", { Parent = inner, BackgroundColor3 = shift(t.Surface, 6), Size = UDim2.new(1,0,0,0), ClipsDescendants = true, Visible = false, BorderSizePixel = 0 })
				corner(pickerWrap, 5)

				local h, s, v = Color3.toHSV(color)

				local hueBar = create("ImageButton", { Parent = pickerWrap, BackgroundTransparency = 1, Position = UDim2.fromOffset(8,8), Size = UDim2.new(1,-70,0,90), Image = "rbxassetid://6523286724" })
				corner(hueBar, 4)
				local hueCursor = create("Frame", { Parent = hueBar, Size = UDim2.fromOffset(10,10), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5,0.5) })
				corner(hueCursor, 5)

				local valBar = create("ImageButton", { Parent = pickerWrap, BackgroundTransparency = 1, Position = UDim2.new(1,-50,0,8), Size = UDim2.fromOffset(16,90), Image = "rbxassetid://6523291212" })
				corner(valBar, 4)
				local valCursor = create("Frame", { Parent = valBar, Size = UDim2.fromOffset(16,6), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5,0) })
				corner(valCursor, 3)

				local pickingHue, pickingVal = false, false

				local function refresh()
					color = Color3.fromHSV(h, s, v)
					preview.BackgroundColor3 = color
					hueCursor.Position = UDim2.new(h, 0, 1-s, 0)
					valCursor.Position = UDim2.new(0.5, 0, 1-v, 0)
					pcall(cb, color)
				end
				refresh()

				hueBar.MouseButton1Down:Connect(function() pickingHue = true end)
				valBar.MouseButton1Down:Connect(function() pickingVal = true end)
				UserInput.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then pickingHue = false; pickingVal = false end end)
				Mouse.Move:Connect(function()
					if pickingHue then
						local rx = math.clamp((Mouse.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
						local ry = math.clamp((Mouse.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
						h, s = rx, 1 - ry; refresh()
					end
					if pickingVal then
						local ry = math.clamp((Mouse.Y - valBar.AbsolutePosition.Y) / valBar.AbsoluteSize.Y, 0, 1)
						v = 1 - ry; refresh()
					end
				end)

				f.MouseButton1Click:Connect(function()
					opened = not opened
					if opened then pickerWrap.Visible = true; tw(pickerWrap, { Size = UDim2.new(1,0,0,108) }, 0.15)
					else tw(pickerWrap, { Size = UDim2.new(1,0,0,0) }, 0.12); task.delay(0.13, function() pickerWrap.Visible = false end) end
				end)
				return { Set = function(_, c) h,s,v = Color3.toHSV(c); refresh() end, Get = function() return color end }
			end

			------------------------------------------------------------
			-- Label
			------------------------------------------------------------
			function elem:Label(cfg)
				cfg = cfg or {}
				local l = create("TextLabel", { Parent = inner, BackgroundColor3 = t.Accent, BackgroundTransparency = 0.88, Size = UDim2.new(1,0,0,26), Font = Enum.Font.GothamSemibold, Text = cfg.Text or "Label", TextColor3 = t.Accent, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, BorderSizePixel = 0 })
				corner(l, 5)
				return { Update = function(_, txt) l.Text = txt end }
			end

			------------------------------------------------------------
			-- Separator
			------------------------------------------------------------
			function elem:Separator()
				create("Frame", { Parent = inner, BackgroundColor3 = shift(t.Surface, 12), BackgroundTransparency = 0.5, Size = UDim2.new(1,0,0,1), BorderSizePixel = 0 })
			end

			------------------------------------------------------------
			-- Paragraph
			------------------------------------------------------------
			function elem:Paragraph(cfg)
				cfg = cfg or {}
				local p = create("TextLabel", { Parent = inner, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y, Font = Enum.Font.Gotham, Text = cfg.Text or "", TextColor3 = t.Sub, TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, RichText = true, BorderSizePixel = 0 })
				return { Update = function(_, txt) p.Text = txt end }
			end

			return elem
		end

		return tab
	end

	-- Keybind to toggle UI
	if config.ToggleKey then
		UserInput.InputBegan:Connect(function(inp, gpe)
			if not gpe and inp.KeyCode == config.ToggleKey then
				gui.Enabled = not gui.Enabled
			end
		end)
	end

	return lib
end

return Flux
