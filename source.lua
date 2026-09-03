--// Kavo UI Library — Clean rewrite
--// API-compatible · No broken icons · Sleek text · Notifications
local Kavo = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

-- Core
local I = TweenInfo.new
local function tw(o,p,d,s,dir) TS:Create(o,I(d or 0.2,s or Enum.EasingStyle.Quint,dir or Enum.EasingDirection.Out),p):Play() end
local function mk(c,p) local o=Instance.new(c); for k,v in pairs(p) do o[k]=v end; return o end
local function corner(p,r) return mk("UICorner",{CornerRadius=UDim.new(0,r or 8),Parent=p}) end
local function pad(p,t,b,l,r) return mk("UIPadding",{PaddingTop=UDim.new(0,t or 0),PaddingBottom=UDim.new(0,b or 0),PaddingLeft=UDim.new(0,l or 0),PaddingRight=UDim.new(0,r or 0),Parent=p}) end
local function lay(p,s) return mk("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,s or 4),Parent=p}) end
local fl,cl,mx = math.floor, math.clamp, math.max
local function sh(c,d) return Color3.fromRGB(cl(fl(c.R*255+d),0,255),cl(fl(c.G*255+d),0,255),cl(fl(c.B*255+d),0,255)) end

local function autoScroll(s,l)
	local function u() s.CanvasSize=UDim2.fromOffset(0,l.AbsoluteContentSize.Y+10) end
	l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(u); u()
end

local function drag(h,t)
	local d,ds,fs
	h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=true;ds=i.Position;fs=t.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end) end end)
	UIS.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then local dt=i.Position-ds;t.Position=UDim2.new(fs.X.Scale,fs.X.Offset+dt.X,fs.Y.Scale,fs.Y.Offset+dt.Y) end end)
end

-- Themes
local T = {
	DarkTheme   = {Sc=Color3.fromRGB(64,64,64),   Bg=Color3.fromRGB(14,14,16),    Hd=Color3.fromRGB(10,10,12),    Tx=Color3.fromRGB(230,230,235), El=Color3.fromRGB(22,22,26)},
	LightTheme  = {Sc=Color3.fromRGB(140,140,150), Bg=Color3.fromRGB(245,245,248), Hd=Color3.fromRGB(235,235,238), Tx=Color3.fromRGB(20,20,24),    El=Color3.fromRGB(232,232,236)},
	BloodTheme  = {Sc=Color3.fromRGB(200,30,30),   Bg=Color3.fromRGB(12,10,10),    Hd=Color3.fromRGB(8,6,6),       Tx=Color3.fromRGB(235,230,230), El=Color3.fromRGB(22,18,18)},
	GrapeTheme  = {Sc=Color3.fromRGB(160,70,210),  Bg=Color3.fromRGB(18,14,22),    Hd=Color3.fromRGB(14,10,18),    Tx=Color3.fromRGB(235,230,240), El=Color3.fromRGB(28,22,34)},
	Ocean       = {Sc=Color3.fromRGB(70,80,240),   Bg=Color3.fromRGB(12,14,24),    Hd=Color3.fromRGB(10,12,20),    Tx=Color3.fromRGB(210,215,235), El=Color3.fromRGB(20,22,36)},
	Midnight    = {Sc=Color3.fromRGB(26,180,150),   Bg=Color3.fromRGB(14,18,24),    Hd=Color3.fromRGB(10,14,20),    Tx=Color3.fromRGB(225,235,232), El=Color3.fromRGB(22,28,34)},
	Sentinel    = {Sc=Color3.fromRGB(220,35,65),    Bg=Color3.fromRGB(14,14,14),    Hd=Color3.fromRGB(10,10,10),    Tx=Color3.fromRGB(230,230,230), El=Color3.fromRGB(22,22,22)},
	Synapse     = {Sc=Color3.fromRGB(150,95,50),    Bg=Color3.fromRGB(10,12,10),    Hd=Color3.fromRGB(8,10,8),      Tx=Color3.fromRGB(200,180,150), El=Color3.fromRGB(18,20,18)},
	Serpent     = {Sc=Color3.fromRGB(0,160,55),     Bg=Color3.fromRGB(12,16,14),    Hd=Color3.fromRGB(8,12,10),     Tx=Color3.fromRGB(220,235,225), El=Color3.fromRGB(18,24,20)},
	Aurora      = {Sc=Color3.fromRGB(0,190,170),    Bg=Color3.fromRGB(10,12,16),    Hd=Color3.fromRGB(6,8,12),      Tx=Color3.fromRGB(215,235,230), El=Color3.fromRGB(16,20,26)},
	Cyberpunk   = {Sc=Color3.fromRGB(245,0,120),    Bg=Color3.fromRGB(8,4,12),      Hd=Color3.fromRGB(6,2,10),      Tx=Color3.fromRGB(0,245,190),   El=Color3.fromRGB(14,8,20)},
	Sunset      = {Sc=Color3.fromRGB(245,95,45),    Bg=Color3.fromRGB(16,10,8),     Hd=Color3.fromRGB(12,8,6),      Tx=Color3.fromRGB(250,220,200), El=Color3.fromRGB(26,16,12)},
	Forest      = {Sc=Color3.fromRGB(34,130,34),    Bg=Color3.fromRGB(8,14,8),      Hd=Color3.fromRGB(6,10,6),      Tx=Color3.fromRGB(200,225,200), El=Color3.fromRGB(14,24,14)},
	Candy       = {Sc=Color3.fromRGB(245,100,170),  Bg=Color3.fromRGB(16,8,12),     Hd=Color3.fromRGB(12,6,10),     Tx=Color3.fromRGB(250,215,230), El=Color3.fromRGB(26,14,20)},
	Royal       = {Sc=Color3.fromRGB(115,75,195),   Bg=Color3.fromRGB(10,8,16),     Hd=Color3.fromRGB(8,6,14),      Tx=Color3.fromRGB(215,208,245), El=Color3.fromRGB(18,14,28)},
	Neon        = {Sc=Color3.fromRGB(55,245,20),    Bg=Color3.fromRGB(4,4,4),       Hd=Color3.fromRGB(2,2,2),       Tx=Color3.fromRGB(55,245,20),   El=Color3.fromRGB(10,10,10)},
	Desert      = {Sc=Color3.fromRGB(200,155,55),   Bg=Color3.fromRGB(18,14,10),    Hd=Color3.fromRGB(14,12,8),     Tx=Color3.fromRGB(235,220,185), El=Color3.fromRGB(28,22,16)},
	Ice         = {Sc=Color3.fromRGB(95,175,245),   Bg=Color3.fromRGB(8,10,16),     Hd=Color3.fromRGB(6,8,14),      Tx=Color3.fromRGB(200,220,248), El=Color3.fromRGB(14,18,28)},
	Matrix      = {Sc=Color3.fromRGB(0,245,60),     Bg=Color3.fromRGB(2,4,2),       Hd=Color3.fromRGB(0,2,0),       Tx=Color3.fromRGB(0,245,60),    El=Color3.fromRGB(4,10,4)},
	Halloween   = {Sc=Color3.fromRGB(245,115,0),    Bg=Color3.fromRGB(12,6,2),      Hd=Color3.fromRGB(10,4,2),      Tx=Color3.fromRGB(248,195,135), El=Color3.fromRGB(22,10,4)},
	Pastel      = {Sc=Color3.fromRGB(175,155,205),  Bg=Color3.fromRGB(238,234,242), Hd=Color3.fromRGB(225,220,232), Tx=Color3.fromRGB(55,48,65),    El=Color3.fromRGB(230,224,236)},
	Space       = {Sc=Color3.fromRGB(85,55,215),    Bg=Color3.fromRGB(6,4,12),      Hd=Color3.fromRGB(4,2,10),      Tx=Color3.fromRGB(195,188,235), El=Color3.fromRGB(12,8,22)},
}
local def = {Sc=Color3.fromRGB(74,99,135),Bg=Color3.fromRGB(14,14,16),Hd=Color3.fromRGB(10,10,12),Tx=Color3.fromRGB(230,230,235),El=Color3.fromRGB(22,22,26)}

local function theme(t)
	if type(t)=="string" and T[t] then return T[t] end
	if type(t)=="table" then
		return {Sc=t.SchemeColor or def.Sc, Bg=t.Background or def.Bg, Hd=t.Header or def.Hd, Tx=t.TextColor or def.Tx, El=t.ElementColor or def.El}
	end
	return def
end

local LID = "Kavo_"..math.random(1e5,9e5)

function Kavo:ToggleUI()
	local g=game.CoreGui:FindFirstChild(LID)
	if g then g.Enabled=not g.Enabled end
end

function Kavo:ChangeColor(prop,color)
	if self._t then
		local map={SchemeColor="Sc",Background="Bg",Header="Hd",TextColor="Tx",ElementColor="El"}
		if map[prop] then self._t[map[prop]]=color end
	end
end

function Kavo.CreateLib(title,themeIn)
	title=title or "Library"
	local C=theme(themeIn)
	Kavo._t=C

	for _,v in ipairs(game.CoreGui:GetChildren()) do if v.Name==LID then v:Destroy() end end

	local gui=mk("ScreenGui",{Name=LID,Parent=game.CoreGui,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,ResetOnSpawn=false})
	local main=mk("Frame",{Name="Main",Parent=gui,BackgroundColor3=C.Bg,ClipsDescendants=true,Position=UDim2.new(0.5,-262,0.5,-170),Size=UDim2.fromOffset(525,340),BorderSizePixel=0})
	corner(main,10)
	mk("UIStroke",{Parent=main,Color=sh(C.Hd,8),Thickness=1,Transparency=0.7})

	-- Header
	local hd=mk("Frame",{Parent=main,BackgroundColor3=C.Hd,Size=UDim2.new(1,0,0,36),BorderSizePixel=0})
	corner(hd,10)
	-- fix bottom corners
	mk("Frame",{Parent=hd,BackgroundColor3=C.Hd,Position=UDim2.new(0,0,1,-10),Size=UDim2.new(1,0,0,10),BorderSizePixel=0})
	drag(hd,main)

	mk("TextLabel",{Parent=hd,BackgroundTransparency=1,Position=UDim2.fromOffset(14,0),Size=UDim2.new(1,-50,1,0),Font=Enum.Font.GothamBold,Text=title,RichText=true,TextColor3=C.Tx,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left})

	local cls=mk("TextButton",{Parent=hd,BackgroundTransparency=1,Position=UDim2.new(1,-36,0,0),Size=UDim2.fromOffset(36,36),Font=Enum.Font.GothamBold,Text="×",TextColor3=sh(C.Tx,-80),TextSize=18,AutoButtonColor=false})
	cls.MouseEnter:Connect(function() tw(cls,{TextColor3=Color3.fromRGB(220,60,60)},0.12) end)
	cls.MouseLeave:Connect(function() tw(cls,{TextColor3=sh(C.Tx,-80)},0.12) end)
	cls.MouseButton1Click:Connect(function()
		tw(main,{BackgroundTransparency=1},0.2)
		for _,c in ipairs(main:GetDescendants()) do pcall(function() tw(c,{BackgroundTransparency=1,TextTransparency=1,ImageTransparency=1},0.15) end) end
		task.delay(0.25,gui.Destroy,gui)
	end)

	-- Sidebar
	local sb=mk("Frame",{Parent=main,BackgroundColor3=C.Hd,Position=UDim2.fromOffset(0,36),Size=UDim2.new(0,140,1,-36),BorderSizePixel=0})
	local th=mk("ScrollingFrame",{Parent=sb,BackgroundTransparency=1,Position=UDim2.fromOffset(0,6),Size=UDim2.new(1,0,1,-12),ScrollBarThickness=0,BorderSizePixel=0,CanvasSize=UDim2.fromOffset(0,0)})
	local tl=lay(th,2); pad(th,4,4,8,8); autoScroll(th,tl)

	-- Pages
	local pa=mk("Frame",{Parent=main,BackgroundTransparency=1,Position=UDim2.fromOffset(140,36),Size=UDim2.new(1,-140,1,-36),BorderSizePixel=0})

	-- Notification system
	local notifHolder=mk("Frame",{Parent=gui,BackgroundTransparency=1,AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-20,1,-20),Size=UDim2.fromOffset(280,400)})
	local notifLay=lay(notifHolder,6)
	notifLay.VerticalAlignment=Enum.VerticalAlignment.Bottom

	function Kavo:Notify(cfg)
		cfg=cfg or {}
		local dur=cfg.Duration or 4
		local n=mk("Frame",{Parent=notifHolder,BackgroundColor3=C.Hd,Size=UDim2.new(1,0,0,0),ClipsDescendants=true,BorderSizePixel=0,BackgroundTransparency=0.05})
		corner(n,8)
		mk("UIStroke",{Parent=n,Color=C.Sc,Thickness=1,Transparency=0.7})
		local ntitle=mk("TextLabel",{Parent=n,BackgroundTransparency=1,Position=UDim2.fromOffset(12,8),Size=UDim2.new(1,-24,0,16),Font=Enum.Font.GothamBold,Text=cfg.Title or "Notification",TextColor3=C.Sc,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextTransparency=1})
		local nbody=mk("TextLabel",{Parent=n,BackgroundTransparency=1,Position=UDim2.fromOffset(12,26),Size=UDim2.new(1,-24,0,28),Font=Enum.Font.Gotham,Text=cfg.Text or "",TextColor3=sh(C.Tx,-20),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,TextTransparency=1})
		-- slide in
		tw(n,{Size=UDim2.new(1,0,0,60)},0.3,Enum.EasingStyle.Back)
		task.delay(0.1,function() tw(ntitle,{TextTransparency=0},0.2); tw(nbody,{TextTransparency=0},0.25) end)
		task.delay(dur,function()
			tw(ntitle,{TextTransparency=1},0.15); tw(nbody,{TextTransparency=1},0.15)
			tw(n,{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1},0.25)
			task.delay(0.3,n.Destroy,n)
		end)
	end

	-- Open anim
	main.BackgroundTransparency=1; main.Size=UDim2.fromOffset(525,340)
	for _,c in ipairs(main:GetDescendants()) do pcall(function() if c:IsA("GuiObject") then c.BackgroundTransparency=1; if c:IsA("TextLabel") or c:IsA("TextButton") or c:IsA("TextBox") then c.TextTransparency=1 end end end) end
	tw(main,{BackgroundTransparency=0},0.3)
	task.delay(0.05,function()
		for _,c in ipairs(main:GetDescendants()) do
			pcall(function()
				if c:IsA("Frame") or c:IsA("ScrollingFrame") then tw(c,{BackgroundTransparency=c.Name=="Pages" and 1 or 0},0.25) end
				if c:IsA("TextLabel") then tw(c,{TextTransparency=0},0.3) end
				if c:IsA("UIStroke") then tw(c,{Transparency=0.7},0.3) end
			end)
		end
	end)

	local W={}; local first=true

	-- Tab
	function W:NewTab(tabName)
		tabName=tabName or "Tab"
		local btn=mk("TextButton",{Parent=th,BackgroundTransparency=1,Size=UDim2.new(1,0,0,30),AutoButtonColor=false,Font=Enum.Font.GothamSemibold,Text=tabName,TextColor3=sh(C.Tx,-60),TextSize=13,ClipsDescendants=true,BorderSizePixel=0})
		corner(btn,6)

		local pg=mk("ScrollingFrame",{Parent=pa,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ScrollBarThickness=2,ScrollBarImageColor3=sh(C.Sc,-30),BorderSizePixel=0,Visible=false,CanvasSize=UDim2.fromOffset(0,0)})
		local pl=lay(pg,6); pad(pg,8,8,10,10); autoScroll(pg,pl)

		if first then first=false; pg.Visible=true; btn.TextColor3=C.Tx; btn.BackgroundColor3=sh(C.El,6); btn.BackgroundTransparency=0 end

		btn.MouseButton1Click:Connect(function()
			for _,p in ipairs(pa:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible=false end end
			for _,b in ipairs(th:GetChildren()) do if b:IsA("TextButton") then tw(b,{BackgroundTransparency=1,TextColor3=sh(C.Tx,-60)},0.15) end end
			pg.Visible=true; tw(btn,{BackgroundTransparency=0,TextColor3=C.Tx},0.15); btn.BackgroundColor3=sh(C.El,6)
		end)

		btn.MouseEnter:Connect(function() if not pg.Visible then tw(btn,{TextColor3=sh(C.Tx,-20)},0.1) end end)
		btn.MouseLeave:Connect(function() if not pg.Visible then tw(btn,{TextColor3=sh(C.Tx,-60)},0.1) end end)

		local Tab={}

		-- Section
		function Tab:NewSection(secName)
			secName=secName or "Section"
			local sec=mk("Frame",{Parent=pg,BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BorderSizePixel=0})

			local secLbl=mk("TextLabel",{Parent=sec,BackgroundTransparency=1,Size=UDim2.new(1,0,0,22),Font=Enum.Font.GothamBold,Text=string.upper(secName),RichText=true,TextColor3=sh(C.Tx,-70),TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,LetterSpacing=0})
			pad(secLbl,0,0,2,0)

			local inn=mk("Frame",{Parent=sec,BackgroundTransparency=1,Position=UDim2.fromOffset(0,22),Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y})
			local il=lay(inn,3)

			local S={}

			function S:UpdateSection(t) secLbl.Text=string.upper(t) end

			-- shared
			local function row(tip)
				local f=mk("TextButton",{Parent=inn,BackgroundColor3=C.El,BackgroundTransparency=0.3,Size=UDim2.new(1,0,0,34),AutoButtonColor=false,Text="",ClipsDescendants=true,BorderSizePixel=0})
				corner(f,7)
				f.MouseEnter:Connect(function() tw(f,{BackgroundTransparency=0},0.1) end)
				f.MouseLeave:Connect(function() tw(f,{BackgroundTransparency=0.3},0.1) end)
				return f
			end

			local function lbl(p,txt)
				return mk("TextLabel",{Parent=p,BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-24,1,0),Font=Enum.Font.GothamSemibold,Text=txt,RichText=true,TextColor3=C.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left})
			end

			-- Button
			function S:NewButton(n,tip,cb) n=n or "Button"; cb=cb or function()end
				local f=row(tip); local l=lbl(f,n)
				f.MouseButton1Click:Connect(function()
					tw(f,{BackgroundTransparency=0.6},0.06)
					task.delay(0.06,function() tw(f,{BackgroundTransparency=0.3},0.15) end)
					cb()
				end)
				local Fn={}; function Fn:UpdateButton(t) l.Text=t end; return Fn
			end

			-- Toggle
			function S:NewToggle(n,tip,cb) n=n or "Toggle"; cb=cb or function()end
				local on=false; local f=row(tip); lbl(f,n)
				local track=mk("Frame",{Parent=f,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=UDim2.fromOffset(34,18),BackgroundColor3=sh(C.El,14),BorderSizePixel=0})
				corner(track,9)
				local knob=mk("Frame",{Parent=track,Position=UDim2.new(0,2,0.5,0),AnchorPoint=Vector2.new(0,0.5),Size=UDim2.fromOffset(14,14),BackgroundColor3=sh(C.Tx,-80),BorderSizePixel=0})
				corner(knob,7)
				local function set(v) on=v
					tw(track,{BackgroundColor3=v and C.Sc or sh(C.El,14)},0.18)
					tw(knob,{Position=v and UDim2.new(1,-16,0.5,0) or UDim2.new(0,2,0.5,0),BackgroundColor3=v and C.Tx or sh(C.Tx,-80)},0.18)
				end
				f.MouseButton1Click:Connect(function() set(not on); pcall(cb,on) end)
				local Fn={}
				function Fn:UpdateToggle(t,s) if t then for _,c in ipairs(f:GetChildren()) do if c:IsA("TextLabel") then c.Text=t end end end; if s~=nil then set(s);pcall(cb,s) end end
				return Fn
			end

			-- Slider
			function S:NewSlider(n,tip,maxV,minV,cb) n=n or "Slider";maxV=maxV or 100;minV=minV or 0;cb=cb or function()end
				local f=row(tip); f.Size=UDim2.new(1,0,0,42)
				local l=lbl(f,n); l.Size=UDim2.new(0.5,0,0,20); l.Position=UDim2.fromOffset(12,2)
				local vl=mk("TextLabel",{Parent=f,BackgroundTransparency=1,Position=UDim2.fromOffset(12,2),Size=UDim2.new(0.4,0,0,20),Font=Enum.Font.GothamSemibold,Text=tostring(minV),TextColor3=C.Sc,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right})
				local bar=mk("Frame",{Parent=f,Position=UDim2.new(0,12,1,-12),Size=UDim2.new(1,-24,0,4),BackgroundColor3=sh(C.El,10),BorderSizePixel=0})
				corner(bar,2)
				local fill=mk("Frame",{Parent=bar,Size=UDim2.new(0,0,1,0),BackgroundColor3=C.Sc,BorderSizePixel=0})
				corner(fill,2)
				local s=false
				local function upd(i) local r=cl((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1); local v=fl(minV+r*(maxV-minV)); fill.Size=UDim2.new(r,0,1,0); vl.Text=tostring(v); pcall(cb,v) end
				bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then s=true;upd(i) end end)
				UIS.InputChanged:Connect(function(i) if s and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i) end end)
				UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then s=false end end)
			end

			-- TextBox
			function S:NewTextBox(n,tip,cb) n=n or "Input";cb=cb or function()end
				local f=row(tip); lbl(f,n).Size=UDim2.new(0.4,0,1,0)
				local box=mk("TextBox",{Parent=f,BackgroundColor3=sh(C.El,-4),BackgroundTransparency=0.3,Position=UDim2.new(0.5,4,0.5,0),AnchorPoint=Vector2.new(0,0.5),Size=UDim2.new(0.44,0,0,22),Font=Enum.Font.Gotham,PlaceholderText="...",PlaceholderColor3=sh(C.Tx,-80),Text="",TextColor3=C.Tx,TextSize=12,ClearTextOnFocus=false,BorderSizePixel=0,ClipsDescendants=true})
				corner(box,6)
				box.FocusLost:Connect(function(e) if e then pcall(cb,box.Text); task.wait(0.1); box.Text="" end end)
			end

			-- Keybind
			function S:NewKeybind(n,tip,dk,cb) n=n or "Keybind";cb=cb or function()end
				local key=dk; local f=row(tip); lbl(f,n)
				local kl=mk("TextLabel",{Parent=f,BackgroundTransparency=1,Position=UDim2.new(1,-80,0,0),Size=UDim2.fromOffset(68,34),Font=Enum.Font.GothamSemibold,Text=key and key.Name or "—",TextColor3=C.Sc,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right})
				local listening=false
				f.MouseButton1Click:Connect(function()
					if listening then return end; listening=true; kl.Text="..."
					local i=UIS.InputBegan:Wait()
					if i.KeyCode~=Enum.KeyCode.Unknown then key=i.KeyCode;kl.Text=key.Name end; listening=false
				end)
				UIS.InputBegan:Connect(function(i,g) if not g and key and i.KeyCode==key then pcall(cb) end end)
			end

			-- Dropdown
			function S:NewDropdown(n,tip,list,cb) n=n or "Select";list=list or {};cb=cb or function()end
				local opened=false
				local wrap=mk("Frame",{Parent=inn,BackgroundColor3=C.El,BackgroundTransparency=0.3,Size=UDim2.new(1,0,0,34),ClipsDescendants=true,BorderSizePixel=0})
				corner(wrap,7)
				local head=mk("TextButton",{Parent=wrap,BackgroundTransparency=1,Size=UDim2.new(1,0,0,34),AutoButtonColor=false,Text="",BorderSizePixel=0})
				local hl=mk("TextLabel",{Parent=head,BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-40,1,0),Font=Enum.Font.GothamSemibold,Text=n,RichText=true,TextColor3=C.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left})
				local arr=mk("TextLabel",{Parent=head,BackgroundTransparency=1,Position=UDim2.new(1,-28,0,0),Size=UDim2.fromOffset(20,34),Font=Enum.Font.GothamBold,Text="›",TextColor3=sh(C.Tx,-60),TextSize=16,Rotation=90})
				local of=mk("Frame",{Parent=wrap,BackgroundTransparency=1,Position=UDim2.fromOffset(0,34),Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y})
				local ol=lay(of,2); pad(of,2,6,6,6)
				local function build(lst)
					for _,c in ipairs(of:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
					for _,v in ipairs(lst) do
						local o=mk("TextButton",{Parent=of,BackgroundColor3=sh(C.El,6),BackgroundTransparency=0.4,Size=UDim2.new(1,0,0,28),AutoButtonColor=false,Font=Enum.Font.Gotham,Text="  "..v,TextColor3=sh(C.Tx,-10),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0})
						corner(o,5)
						o.MouseEnter:Connect(function() tw(o,{BackgroundTransparency=0},0.08) end)
						o.MouseLeave:Connect(function() tw(o,{BackgroundTransparency=0.4},0.08) end)
						o.MouseButton1Click:Connect(function() hl.Text=v;pcall(cb,v);opened=false;tw(wrap,{Size=UDim2.new(1,0,0,34)},0.15);tw(arr,{Rotation=90},0.12) end)
					end
				end; build(list)
				head.MouseButton1Click:Connect(function()
					opened=not opened
					if opened then tw(wrap,{Size=UDim2.new(1,0,0,34+of.AbsoluteSize.Y+10)},0.2);tw(arr,{Rotation=270},0.12)
					else tw(wrap,{Size=UDim2.new(1,0,0,34)},0.15);tw(arr,{Rotation=90},0.12) end
				end)
				local Fn={}; function Fn:Refresh(nl) list=nl;build(nl);if opened then tw(wrap,{Size=UDim2.new(1,0,0,34+of.AbsoluteSize.Y+10)},0.15) end end; return Fn
			end

			-- ColorPicker
			function S:NewColorPicker(n,tip,dc,cb) n=n or "Color";dc=dc or Color3.new(1,1,1);cb=cb or function()end
				local h,s,v=Color3.toHSV(dc); local cpO=false
				local wrap=mk("Frame",{Parent=inn,BackgroundColor3=C.El,BackgroundTransparency=0.3,Size=UDim2.new(1,0,0,34),ClipsDescendants=true,BorderSizePixel=0})
				corner(wrap,7)
				local head=mk("TextButton",{Parent=wrap,BackgroundTransparency=1,Size=UDim2.new(1,0,0,34),AutoButtonColor=false,Text="",BorderSizePixel=0})
				mk("TextLabel",{Parent=head,BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-60,1,0),Font=Enum.Font.GothamSemibold,Text=n,RichText=true,TextColor3=C.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left})
				local pre=mk("Frame",{Parent=head,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=UDim2.fromOffset(28,16),BackgroundColor3=dc,BorderSizePixel=0})
				corner(pre,5)
				local hi=mk("ImageButton",{Parent=wrap,BackgroundTransparency=1,Position=UDim2.fromOffset(10,40),Size=UDim2.new(0.6,0,0,80),Image="rbxassetid://6523286724"})
				corner(hi,6)
				local hc=mk("Frame",{Parent=hi,Size=UDim2.fromOffset(10,10),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5)})
				corner(hc,5)
				local vi=mk("ImageButton",{Parent=wrap,BackgroundTransparency=1,Position=UDim2.new(0.66,4,0,40),Size=UDim2.fromOffset(14,80),Image="rbxassetid://6523291212"})
				corner(vi,4)
				local vc=mk("Frame",{Parent=vi,Size=UDim2.fromOffset(14,5),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0)})
				corner(vc,3)
				local pH,pV=false,false
				local rbOn,rbC,ctr=false,nil,0
				local rbB=mk("TextButton",{Parent=wrap,Position=UDim2.new(0.78,0,0,44),Size=UDim2.fromOffset(52,18),BackgroundColor3=sh(C.El,8),AutoButtonColor=false,Font=Enum.Font.Gotham,Text="Rainbow",TextColor3=sh(C.Tx,-40),TextSize=10,BorderSizePixel=0})
				corner(rbB,5)
				local zz=function(x) return math.acos(math.cos(x*math.pi))/math.pi end
				local function ref() local c=Color3.fromHSV(h,s,v); pre.BackgroundColor3=c; hc.Position=UDim2.new(h,0,1-s,0); vc.Position=UDim2.new(0.5,0,1-v,0); pcall(cb,c) end; ref()
				hi.MouseButton1Down:Connect(function() pH=true end)
				vi.MouseButton1Down:Connect(function() pV=true end)
				UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then pH=false;pV=false end end)
				Mouse.Move:Connect(function()
					if pH then h=cl((Mouse.X-hi.AbsolutePosition.X)/hi.AbsoluteSize.X,0,1);s=1-cl((Mouse.Y-hi.AbsolutePosition.Y)/hi.AbsoluteSize.Y,0,1);ref() end
					if pV then v=1-cl((Mouse.Y-vi.AbsolutePosition.Y)/vi.AbsoluteSize.Y,0,1);ref() end
				end)
				rbB.MouseButton1Click:Connect(function() rbOn=not rbOn;tw(rbB,{BackgroundColor3=rbOn and C.Sc or sh(C.El,8),TextColor3=rbOn and C.Tx or sh(C.Tx,-40)},0.15)
					if rbOn then rbC=RS.RenderStepped:Connect(function() ctr=ctr+0.01;h=zz(ctr);s=1;ref() end) elseif rbC then rbC:Disconnect() end
				end)
				head.MouseButton1Click:Connect(function() cpO=not cpO;tw(wrap,{Size=UDim2.new(1,0,0,cpO and 130 or 34)},cpO and 0.2 or 0.15) end)
			end

			-- Label
			function S:NewLabel(txt)
				local l=mk("TextLabel",{Parent=inn,BackgroundTransparency=1,Size=UDim2.new(1,0,0,24),Font=Enum.Font.GothamBold,Text=txt or "Label",RichText=true,TextColor3=C.Sc,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0})
				pad(l,0,0,12,0)
				local Fn={}; function Fn:UpdateLabel(t) l.Text=t end; return Fn
			end

			return S
		end
		return Tab
	end
	return W
end

return Kavo
