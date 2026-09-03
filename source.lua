--// Kavo UI Library — Windows 98 Edition
--// ponytail: ultra — faithful 98.css recreation in Roblox UI instances
local Kavo = {}
local UIS = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local function mk(c,p) local o=Instance.new(c); for k,v in pairs(p) do o[k]=v end; return o end
local function list(p,s,d) return mk("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,s or 0),FillDirection=d or Enum.FillDirection.Vertical,Parent=p}) end
local function pad(p,t,b,l,r) return mk("UIPadding",{PaddingTop=UDim.new(0,t),PaddingBottom=UDim.new(0,b),PaddingLeft=UDim.new(0,l),PaddingRight=UDim.new(0,r),Parent=p}) end
local fl,cl = math.floor, math.clamp

local function scrollFit(s,l)
	local function u() s.CanvasSize=UDim2.fromOffset(0,l.AbsoluteContentSize.Y+4) end
	l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(u); u()
end

local function drag(h,t)
	local d,ds,fs
	h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=true;ds=i.Position;fs=t.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end) end end)
	UIS.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then local dt=i.Position-ds;t.Position=UDim2.new(fs.X.Scale,fs.X.Offset+dt.X,fs.Y.Scale,fs.Y.Offset+dt.Y) end end)
end

-- Win98 palette
local W98 = {
	Face     = Color3.fromRGB(192,192,192), -- button face / window bg
	HiLight  = Color3.fromRGB(255,255,255), -- raised top/left
	Shadow   = Color3.fromRGB(128,128,128), -- raised bottom/right inner
	DkShadow = Color3.fromRGB(0,0,0),       -- raised bottom/right outer / text
	Window   = Color3.fromRGB(255,255,255), -- sunken input bg
	Title    = Color3.fromRGB(0,0,128),     -- active title bar
	TitleTx  = Color3.fromRGB(255,255,255), -- title text
	Text     = Color3.fromRGB(0,0,0),       -- body text
	Select   = Color3.fromRGB(0,0,128),     -- selection highlight
	SelectTx = Color3.fromRGB(255,255,255), -- selected text
	InTitle  = Color3.fromRGB(128,128,128), -- inactive title bar
}

-- 3D border: the core of Win98's look
-- "raised" = buttons, window frame  |  "sunken" = inputs, wells
local function border98(parent, style)
	-- 4 edge lines. Raised: white TL, dark BR. Sunken: dark TL, white BR.
	local tl, br, tli, bri
	if style == "raised" then
		tl, br = W98.HiLight, W98.DkShadow
		tli, bri = W98.Face, W98.Shadow
	else -- sunken
		tl, br = W98.Shadow, W98.HiLight
		tli, bri = W98.DkShadow, W98.Face
	end
	-- outer top
	mk("Frame",{Parent=parent,BackgroundColor3=tl,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0,0),ZIndex=parent.ZIndex+1})
	-- outer left
	mk("Frame",{Parent=parent,BackgroundColor3=tl,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(0,0,0,0),ZIndex=parent.ZIndex+1})
	-- outer bottom
	mk("Frame",{Parent=parent,BackgroundColor3=br,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),ZIndex=parent.ZIndex+1})
	-- outer right
	mk("Frame",{Parent=parent,BackgroundColor3=br,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),ZIndex=parent.ZIndex+1})
	-- inner top
	mk("Frame",{Parent=parent,BackgroundColor3=tli,BorderSizePixel=0,Size=UDim2.new(1,-2,0,1),Position=UDim2.new(0,1,0,1),ZIndex=parent.ZIndex+1})
	-- inner left
	mk("Frame",{Parent=parent,BackgroundColor3=tli,BorderSizePixel=0,Size=UDim2.new(0,1,1,-2),Position=UDim2.new(0,1,0,1),ZIndex=parent.ZIndex+1})
	-- inner bottom
	mk("Frame",{Parent=parent,BackgroundColor3=bri,BorderSizePixel=0,Size=UDim2.new(1,-2,0,1),Position=UDim2.new(0,1,1,-2),ZIndex=parent.ZIndex+1})
	-- inner right
	mk("Frame",{Parent=parent,BackgroundColor3=bri,BorderSizePixel=0,Size=UDim2.new(0,1,1,-2),Position=UDim2.new(1,-2,0,1),ZIndex=parent.ZIndex+1})
end

-- Win98 title bar button (minimize/maximize/close) — small raised rect with glyph
local function titleBtn(parent, glyph, onClick)
	local b = mk("TextButton",{Parent=parent,BackgroundColor3=W98.Face,Size=UDim2.fromOffset(16,14),AutoButtonColor=false,Font=Enum.Font.RobotoMono,Text=glyph,TextColor3=W98.Text,TextSize=10,BorderSizePixel=0,LayoutOrder=1})
	border98(b,"raised")
	b.MouseButton1Down:Connect(function()
		-- clear old borders, draw sunken
		for _,c in ipairs(b:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
		border98(b,"sunken")
	end)
	b.MouseButton1Up:Connect(function()
		for _,c in ipairs(b:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
		border98(b,"raised")
	end)
	if onClick then b.MouseButton1Click:Connect(onClick) end
	return b
end

-- Etched border for group boxes (sections) — double line sunken+raised
local function etchedBorder(parent)
	-- top dark then light
	mk("Frame",{Parent=parent,BackgroundColor3=W98.Shadow,BorderSizePixel=0,Size=UDim2.new(1,-4,0,1),Position=UDim2.new(0,2,0,0),ZIndex=parent.ZIndex+1})
	mk("Frame",{Parent=parent,BackgroundColor3=W98.HiLight,BorderSizePixel=0,Size=UDim2.new(1,-4,0,1),Position=UDim2.new(0,2,0,1),ZIndex=parent.ZIndex+1})
	-- left
	mk("Frame",{Parent=parent,BackgroundColor3=W98.Shadow,BorderSizePixel=0,Size=UDim2.new(0,1,1,-4),Position=UDim2.new(0,0,0,2),ZIndex=parent.ZIndex+1})
	mk("Frame",{Parent=parent,BackgroundColor3=W98.HiLight,BorderSizePixel=0,Size=UDim2.new(0,1,1,-4),Position=UDim2.new(0,1,0,2),ZIndex=parent.ZIndex+1})
	-- bottom
	mk("Frame",{Parent=parent,BackgroundColor3=W98.Shadow,BorderSizePixel=0,Size=UDim2.new(1,-4,0,1),Position=UDim2.new(0,2,1,-2),ZIndex=parent.ZIndex+1})
	mk("Frame",{Parent=parent,BackgroundColor3=W98.HiLight,BorderSizePixel=0,Size=UDim2.new(1,-4,0,1),Position=UDim2.new(0,2,1,-1),ZIndex=parent.ZIndex+1})
	-- right
	mk("Frame",{Parent=parent,BackgroundColor3=W98.Shadow,BorderSizePixel=0,Size=UDim2.new(0,1,1,-4),Position=UDim2.new(1,-2,0,2),ZIndex=parent.ZIndex+1})
	mk("Frame",{Parent=parent,BackgroundColor3=W98.HiLight,BorderSizePixel=0,Size=UDim2.new(0,1,1,-4),Position=UDim2.new(1,-1,0,2),ZIndex=parent.ZIndex+1})
end

local LID="Kavo_"..math.random(1e5,9e5)
function Kavo:ToggleUI() local g=game.CoreGui:FindFirstChild(LID); if g then g.Enabled=not g.Enabled end end
function Kavo:ChangeColor() end -- ponytail: no-op, Win98 has one look

function Kavo.CreateLib(title, _themeIn)
	title = title or "Library"
	Kavo._theme = {} -- ponytail: kept for compat, unused
	for _,v in ipairs(game.CoreGui:GetChildren()) do if v.Name==LID then v:Destroy() end end

	local gui = mk("ScreenGui",{Name=LID,Parent=game.CoreGui,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,ResetOnSpawn=false})

	-- Main window frame
	local main = mk("Frame",{Name="Main",Parent=gui,BackgroundColor3=W98.Face,ClipsDescendants=true,Position=UDim2.new(0.5,-260,0.5,-180),Size=UDim2.fromOffset(520,360),BorderSizePixel=0})
	border98(main,"raised")

	-- Title bar
	local hdr = mk("Frame",{Parent=main,BackgroundColor3=W98.Title,Size=UDim2.new(1,-4,0,18),Position=UDim2.fromOffset(2,2),BorderSizePixel=0})
	drag(hdr,main)
	mk("TextLabel",{Parent=hdr,BackgroundTransparency=1,Position=UDim2.fromOffset(2,0),Size=UDim2.new(1,-54,1,0),Font=Enum.Font.SourceSansBold,Text=title,RichText=true,TextColor3=W98.TitleTx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left})

	-- Title bar buttons container
	local btnBar = mk("Frame",{Parent=hdr,BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-2,0.5,0),Size=UDim2.fromOffset(54,14)})
	list(btnBar,2,Enum.FillDirection.Horizontal)
	titleBtn(btnBar,"_",nil)
	titleBtn(btnBar,"□",nil)
	titleBtn(btnBar,"×",function() gui:Destroy() end)

	-- Menu bar area (thin separator line)
	mk("Frame",{Parent=main,BackgroundColor3=W98.Shadow,Size=UDim2.new(1,-4,0,1),Position=UDim2.fromOffset(2,21),BorderSizePixel=0})

	-- Tab row (horizontal, below title bar)
	local tabRow = mk("Frame",{Parent=main,BackgroundTransparency=1,Position=UDim2.fromOffset(2,24),Size=UDim2.new(1,-4,0,22),BorderSizePixel=0})
	list(tabRow,0,Enum.FillDirection.Horizontal)

	-- Content area
	local content = mk("Frame",{Parent=main,BackgroundColor3=W98.Face,Position=UDim2.fromOffset(2,45),Size=UDim2.new(1,-4,1,-49),BorderSizePixel=0})
	border98(content,"sunken")

	-- Status bar
	local statusBar = mk("Frame",{Parent=main,BackgroundColor3=W98.Face,Position=UDim2.new(0,2,1,-18),Size=UDim2.new(1,-4,0,16),BorderSizePixel=0})
	border98(statusBar,"sunken")
	local statusTx = mk("TextLabel",{Parent=statusBar,BackgroundTransparency=1,Position=UDim2.fromOffset(4,0),Size=UDim2.new(1,-8,1,0),Font=Enum.Font.SourceSans,Text="Ready",TextColor3=W98.Text,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left})

	-- Notification holder
	local nHolder = mk("Frame",{Parent=gui,BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-8,0,8),Size=UDim2.fromOffset(250,400)})
	list(nHolder,4)

	function Kavo:Notify(cfg)
		cfg = cfg or {}
		-- Win98 message box style
		local n = mk("Frame",{Parent=nHolder,BackgroundColor3=W98.Face,Size=UDim2.new(1,0,0,60),BorderSizePixel=0})
		border98(n,"raised")
		local nh = mk("Frame",{Parent=n,BackgroundColor3=W98.Title,Size=UDim2.new(1,-4,0,18),Position=UDim2.fromOffset(2,2),BorderSizePixel=0})
		mk("TextLabel",{Parent=nh,BackgroundTransparency=1,Position=UDim2.fromOffset(2,0),Size=UDim2.new(1,-4,1,0),Font=Enum.Font.SourceSansBold,Text=cfg.Title or "Notice",TextColor3=W98.TitleTx,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
		mk("TextLabel",{Parent=n,BackgroundTransparency=1,Position=UDim2.fromOffset(6,24),Size=UDim2.new(1,-12,0,30),Font=Enum.Font.SourceSans,Text=cfg.Text or "",TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true})
		task.delay(cfg.Duration or 4, function() n:Destroy() end)
	end

	local W = {}; local first = true

	function W:NewTab(name)
		name = name or "Tab"

		-- Tab button — raised 3D, active tab gets merged-into-body look
		local btn = mk("TextButton",{Parent=tabRow,BackgroundColor3=W98.Face,Size=UDim2.new(0,0,1,2),AutomaticSize=Enum.AutomaticSize.X,AutoButtonColor=false,Font=Enum.Font.SourceSans,Text=name,TextColor3=W98.Text,TextSize=12,BorderSizePixel=0,LayoutOrder=#tabRow:GetChildren()})
		pad(btn,2,2,8,8)
		-- Tab top/left/right raised borders (no bottom when active)
		local tabTopOuter = mk("Frame",{Parent=btn,BackgroundColor3=W98.HiLight,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0,0),ZIndex=btn.ZIndex+1})
		local tabLeftOuter = mk("Frame",{Parent=btn,BackgroundColor3=W98.HiLight,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(0,0,0,0),ZIndex=btn.ZIndex+1})
		local tabRightOuter = mk("Frame",{Parent=btn,BackgroundColor3=W98.DkShadow,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),ZIndex=btn.ZIndex+1})
		local tabTopInner = mk("Frame",{Parent=btn,BackgroundColor3=W98.HiLight,BorderSizePixel=0,Size=UDim2.new(1,-2,0,1),Position=UDim2.new(0,1,0,1),ZIndex=btn.ZIndex+1})
		local tabRightInner = mk("Frame",{Parent=btn,BackgroundColor3=W98.Shadow,BorderSizePixel=0,Size=UDim2.new(0,1,1,-1),Position=UDim2.new(1,-2,0,1),ZIndex=btn.ZIndex+1})
		local tabBottom = mk("Frame",{Parent=btn,BackgroundColor3=W98.Face,BorderSizePixel=0,Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),ZIndex=btn.ZIndex+2})

		-- Page
		local pg = mk("ScrollingFrame",{Parent=content,BackgroundColor3=W98.Face,BackgroundTransparency=0,Size=UDim2.new(1,-4,1,-4),Position=UDim2.fromOffset(2,2),ScrollBarThickness=16,ScrollBarImageColor3=W98.Face,BorderSizePixel=0,Visible=false,CanvasSize=UDim2.fromOffset(0,0)})
		local pgLay = list(pg,4); pad(pg,6,6,8,8); scrollFit(pg,pgLay)

		local function activate()
			-- Deactivate all tabs
			for _,b in ipairs(tabRow:GetChildren()) do
				if b:IsA("TextButton") then
					b.Font = Enum.Font.SourceSans
					b.Size = UDim2.new(0,0,1,0)
					b.Position = UDim2.new(b.Position.X.Scale, b.Position.X.Offset, 0, 2)
					-- Show bottom line (inactive tab)
					for _,ch in ipairs(b:GetChildren()) do
						if ch.Name == "TabBottom" then ch.Visible = false end
					end
				end
			end
			for _,p in ipairs(content:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible=false end end

			-- Activate this tab
			btn.Font = Enum.Font.SourceSansBold
			btn.Size = UDim2.new(0,0,1,2)
			btn.Position = UDim2.new(btn.Position.X.Scale, btn.Position.X.Offset, 0, 0)
			tabBottom.Visible = true
			pg.Visible = true
		end

		tabBottom.Name = "TabBottom"
		if first then first=false; activate() else tabBottom.Visible=false; btn.Size=UDim2.new(0,0,1,0); btn.Position=UDim2.fromOffset(0,2) end

		btn.MouseButton1Click:Connect(activate)

		local Tab = {}

		function Tab:NewSection(secName)
			secName = secName or "Section"

			-- GroupBox wrapper with etched border
			local box = mk("Frame",{Parent=pg,BackgroundColor3=W98.Face,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BorderSizePixel=0})
			pad(box,12,6,0,0)
			etchedBorder(box)

			-- Legend label (sits on top edge of etched border)
			mk("TextLabel",{Parent=box,BackgroundColor3=W98.Face,Position=UDim2.fromOffset(8,-8),Size=UDim2.new(0,0,0,14),AutomaticSize=Enum.AutomaticSize.X,Font=Enum.Font.SourceSans,Text="  "..secName.."  ",RichText=true,TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,ZIndex=box.ZIndex+2})

			local inner = mk("Frame",{Parent=box,BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,Position=UDim2.fromOffset(0,4)})
			list(inner,1); pad(inner,4,6,8,8)

			local S = {}
			function S:UpdateSection(t)
				for _,c in ipairs(box:GetChildren()) do
					if c:IsA("TextLabel") and c.Position.Y.Offset < 0 then c.Text="  "..t.."  " end
				end
			end

			-- Row helper: flat frame, no hover effects (Win98 doesn't do hover on list items)
			local function row()
				return mk("Frame",{Parent=inner,BackgroundTransparency=1,Size=UDim2.new(1,0,0,22),BorderSizePixel=0})
			end
			local function label(p,t)
				return mk("TextLabel",{Parent=p,BackgroundTransparency=1,Position=UDim2.fromOffset(0,0),Size=UDim2.new(1,-80,1,0),Font=Enum.Font.SourceSans,Text=t,RichText=true,TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
			end

			function S:NewButton(n,tip,cb) n=n or "Button";cb=cb or function()end
				local f = row()
				local b = mk("TextButton",{Parent=f,BackgroundColor3=W98.Face,AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(1,0,0,22),AutoButtonColor=false,Font=Enum.Font.SourceSans,Text=n,TextColor3=W98.Text,TextSize=12,BorderSizePixel=0})
				border98(b,"raised")
				b.MouseButton1Down:Connect(function()
					for _,c in ipairs(b:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
					border98(b,"sunken")
				end)
				b.MouseButton1Up:Connect(function()
					for _,c in ipairs(b:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
					border98(b,"raised")
				end)
				b.MouseButton1Click:Connect(function() cb() end)
				local Fn={}; function Fn:UpdateButton(t) b.Text=t end; return Fn
			end

			function S:NewToggle(n,tip,cb) n=n or "Toggle";cb=cb or function()end; local on=false
				local f = row()
				-- Win98 checkbox: sunken 13x13 square
				local chk = mk("Frame",{Parent=f,BackgroundColor3=W98.Window,AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(13,13),BorderSizePixel=0})
				border98(chk,"sunken")
				local mark = mk("TextLabel",{Parent=chk,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Font=Enum.Font.SourceSansBold,Text="",TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Center})
				local lbl = mk("TextLabel",{Parent=f,BackgroundTransparency=1,Position=UDim2.fromOffset(18,0),Size=UDim2.new(1,-18,1,0),Font=Enum.Font.SourceSans,Text=n,RichText=true,TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
				-- Click area over whole row
				local hit = mk("TextButton",{Parent=f,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text="",BorderSizePixel=0,ZIndex=f.ZIndex+3})
				local function set(v) on=v; mark.Text=v and "✓" or "" end
				hit.MouseButton1Click:Connect(function() set(not on); pcall(cb,on) end)
				local Fn={}; function Fn:UpdateToggle(t,s) if t then lbl.Text=t end; if s~=nil then set(s);pcall(cb,s) end end; return Fn
			end

			function S:NewSlider(n,tip,maxV,minV,cb) n=n or "Slider";maxV=maxV or 100;minV=minV or 0;cb=cb or function()end
				local f = mk("Frame",{Parent=inner,BackgroundTransparency=1,Size=UDim2.new(1,0,0,36),BorderSizePixel=0})
				local sl = mk("TextLabel",{Parent=f,BackgroundTransparency=1,Position=UDim2.fromOffset(0,0),Size=UDim2.new(0.5,0,0,14),Font=Enum.Font.SourceSans,Text=n,TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
				local vl = mk("TextLabel",{Parent=f,BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,0,0,0),Size=UDim2.fromOffset(40,14),Font=Enum.Font.SourceSans,Text=tostring(minV),TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right})
				-- Sunken track
				local track = mk("Frame",{Parent=f,BackgroundColor3=W98.Shadow,Position=UDim2.new(0,0,0,18),Size=UDim2.new(1,0,0,4),BorderSizePixel=0})
				border98(track,"sunken")
				-- Raised thumb
				local thumb = mk("Frame",{Parent=f,BackgroundColor3=W98.Face,Position=UDim2.new(0,0,0,14),Size=UDim2.fromOffset(11,12),BorderSizePixel=0,ZIndex=f.ZIndex+2})
				border98(thumb,"raised")
				local dragging = false
				local function upd(i)
					local r = cl((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
					thumb.Position = UDim2.new(r, -5, 0, 14)
					local v = fl(minV + r * (maxV - minV))
					vl.Text = tostring(v); pcall(cb, v)
				end
				track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;upd(i) end end)
				thumb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
				UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i) end end)
				UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
			end

			function S:NewTextBox(n,tip,cb) n=n or "Input";cb=cb or function()end
				local f = row()
				mk("TextLabel",{Parent=f,BackgroundTransparency=1,Size=UDim2.new(0.35,0,1,0),Font=Enum.Font.SourceSans,Text=n,TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
				-- Sunken white input field
				local bx = mk("TextBox",{Parent=f,BackgroundColor3=W98.Window,Position=UDim2.new(0.38,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),Size=UDim2.new(0.62,0,0,18),Font=Enum.Font.SourceSans,PlaceholderText="",PlaceholderColor3=W98.Shadow,Text="",TextColor3=W98.Text,TextSize=12,ClearTextOnFocus=false,BorderSizePixel=0,ClipsDescendants=true})
				border98(bx,"sunken")
				bx.FocusLost:Connect(function(e) if e then pcall(cb,bx.Text); bx.Text="" end end)
			end

			function S:NewKeybind(n,tip,dk,cb) n=n or "Keybind";cb=cb or function()end; local key=dk
				local f = row()
				mk("TextLabel",{Parent=f,BackgroundTransparency=1,Size=UDim2.new(1,-60,1,0),Font=Enum.Font.SourceSans,Text=n,TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
				-- Sunken key display
				local kd = mk("Frame",{Parent=f,BackgroundColor3=W98.Window,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.fromOffset(56,18),BorderSizePixel=0})
				border98(kd,"sunken")
				local kl = mk("TextLabel",{Parent=kd,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Font=Enum.Font.SourceSans,Text=key and key.Name or "-",TextColor3=W98.Text,TextSize=11,TextXAlignment=Enum.TextXAlignment.Center})
				local listening = false
				local hit = mk("TextButton",{Parent=f,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text="",BorderSizePixel=0,ZIndex=f.ZIndex+3})
				hit.MouseButton1Click:Connect(function() if listening then return end; listening=true;kl.Text="..."; local i=UIS.InputBegan:Wait(); if i.KeyCode~=Enum.KeyCode.Unknown then key=i.KeyCode;kl.Text=key.Name end; listening=false end)
				UIS.InputBegan:Connect(function(i,g) if not g and key and i.KeyCode==key then pcall(cb) end end)
			end

			function S:NewDropdown(n,tip,items,cb) n=n or "Select";items=items or {};cb=cb or function()end; local open=false
				local wrap = mk("Frame",{Parent=inner,BackgroundTransparency=1,Size=UDim2.new(1,0,0,22),ClipsDescendants=true,BorderSizePixel=0})

				-- Header row: label + sunken select box + arrow button
				local head = mk("Frame",{Parent=wrap,BackgroundTransparency=1,Size=UDim2.new(1,0,0,22),BorderSizePixel=0})
				mk("TextLabel",{Parent=head,BackgroundTransparency=1,Size=UDim2.new(0.35,0,1,0),Font=Enum.Font.SourceSans,Text=n,TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
				-- Sunken display
				local disp = mk("Frame",{Parent=head,BackgroundColor3=W98.Window,Position=UDim2.new(0.38,0,0,1),Size=UDim2.new(0.62,-18,0,20),BorderSizePixel=0})
				border98(disp,"sunken")
				local dispTx = mk("TextLabel",{Parent=disp,BackgroundTransparency=1,Position=UDim2.fromOffset(3,0),Size=UDim2.new(1,-6,1,0),Font=Enum.Font.SourceSans,Text="",TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true})
				-- Arrow button
				local arr = mk("TextButton",{Parent=head,BackgroundColor3=W98.Face,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,0,0,1),Size=UDim2.fromOffset(16,20),AutoButtonColor=false,Font=Enum.Font.SourceSans,Text="▼",TextColor3=W98.Text,TextSize=8,BorderSizePixel=0})
				border98(arr,"raised")

				-- Options list (below header)
				local opts = mk("Frame",{Parent=wrap,BackgroundColor3=W98.Window,Position=UDim2.fromOffset(fl(wrap.AbsoluteSize.X*0.38),22),Size=UDim2.new(0.62,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BorderSizePixel=0,Visible=false,ZIndex=wrap.ZIndex+5})
				border98(opts,"sunken")

				-- Defer positioning until layout settles
				task.defer(function()
					opts.Position = UDim2.new(0.38,0,0,22)
				end)

				local function build(lst)
					for _,c in ipairs(opts:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
					for idx,v in ipairs(lst) do
						local o = mk("TextButton",{Parent=opts,BackgroundColor3=W98.Window,Size=UDim2.new(1,-4,0,16),Position=UDim2.fromOffset(2,(idx-1)*16+2),AutoButtonColor=false,Font=Enum.Font.SourceSans,Text=v,TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,ZIndex=opts.ZIndex+1})
						pad(o,0,0,2,0)
						o.MouseEnter:Connect(function() o.BackgroundColor3=W98.Select; o.TextColor3=W98.SelectTx end)
						o.MouseLeave:Connect(function() o.BackgroundColor3=W98.Window; o.TextColor3=W98.Text end)
						o.MouseButton1Click:Connect(function() dispTx.Text=v;pcall(cb,v);open=false;opts.Visible=false;wrap.Size=UDim2.new(1,0,0,22);wrap.ClipsDescendants=true end)
					end
				end; build(items)

				local headHit = mk("TextButton",{Parent=head,BackgroundTransparency=1,Position=UDim2.new(0.38,0,0,0),Size=UDim2.new(0.62,0,1,0),Text="",BorderSizePixel=0,ZIndex=head.ZIndex+3})
				headHit.MouseButton1Click:Connect(function()
					open = not open
					opts.Visible = open
					if open then
						wrap.ClipsDescendants = false
						wrap.Size = UDim2.new(1,0,0,22)
					else
						wrap.ClipsDescendants = true
						wrap.Size = UDim2.new(1,0,0,22)
					end
				end)
				local Fn={}; function Fn:Refresh(nl) build(nl) end; return Fn
			end

			function S:NewColorPicker(n,tip,dc,cb) n=n or "Color";dc=dc or Color3.new(1,1,1);cb=cb or function()end
				local h,s,v = Color3.toHSV(dc); local cpO = false
				local wrap = mk("Frame",{Parent=inner,BackgroundTransparency=1,Size=UDim2.new(1,0,0,22),ClipsDescendants=true,BorderSizePixel=0})

				local head = mk("Frame",{Parent=wrap,BackgroundTransparency=1,Size=UDim2.new(1,0,0,22),BorderSizePixel=0})
				mk("TextLabel",{Parent=head,BackgroundTransparency=1,Size=UDim2.new(1,-30,1,0),Font=Enum.Font.SourceSans,Text=n,TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
				-- Color preview swatch (sunken)
				local pre = mk("Frame",{Parent=head,BackgroundColor3=dc,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.fromOffset(22,14),BorderSizePixel=0})
				border98(pre,"sunken")

				-- HSV picker area
				local hi = mk("ImageButton",{Parent=wrap,BackgroundTransparency=1,Position=UDim2.fromOffset(4,26),Size=UDim2.new(0.55,0,0,60),Image="rbxassetid://6523286724"})
				local hc = mk("Frame",{Parent=hi,Size=UDim2.fromOffset(6,6),BackgroundColor3=W98.DkShadow,BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5)})
				border98(hc,"raised")
				local vi = mk("ImageButton",{Parent=wrap,BackgroundTransparency=1,Position=UDim2.new(0.58,4,0,26),Size=UDim2.fromOffset(12,60),Image="rbxassetid://6523291212"})
				local vc = mk("Frame",{Parent=vi,Size=UDim2.fromOffset(12,3),BackgroundColor3=W98.DkShadow,BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0)})

				local pH,pV = false,false
				local function ref()
					local c = Color3.fromHSV(h,s,v)
					pre.BackgroundColor3 = c
					hc.Position = UDim2.new(h,0,1-s,0)
					vc.Position = UDim2.new(0.5,0,1-v,0)
					pcall(cb,c)
				end; ref()
				hi.MouseButton1Down:Connect(function() pH=true end)
				vi.MouseButton1Down:Connect(function() pV=true end)
				UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then pH=false;pV=false end end)
				Mouse.Move:Connect(function()
					if pH then h=cl((Mouse.X-hi.AbsolutePosition.X)/hi.AbsoluteSize.X,0,1);s=1-cl((Mouse.Y-hi.AbsolutePosition.Y)/hi.AbsoluteSize.Y,0,1);ref() end
					if pV then v=1-cl((Mouse.Y-vi.AbsolutePosition.Y)/vi.AbsoluteSize.Y,0,1);ref() end
				end)

				local headHit = mk("TextButton",{Parent=head,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text="",BorderSizePixel=0,ZIndex=head.ZIndex+3})
				headHit.MouseButton1Click:Connect(function()
					cpO = not cpO
					wrap.Size = UDim2.new(1,0,0, cpO and 92 or 22)
				end)
			end

			function S:NewLabel(txt)
				local l = mk("TextLabel",{Parent=inner,BackgroundTransparency=1,Size=UDim2.new(1,0,0,16),Font=Enum.Font.SourceSans,Text=txt or "",RichText=true,TextColor3=W98.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0})
				local Fn={}; function Fn:UpdateLabel(t) l.Text=t end; return Fn
			end

			return S
		end
		return Tab
	end
	return W
end

return Kavo
