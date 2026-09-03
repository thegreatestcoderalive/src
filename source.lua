--// Kavo UI Library — Clean, working, no over-engineering
local Kavo = {}
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local I = TweenInfo.new
local function tw(o,p,d) TS:Create(o,I(d or 0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),p):Play() end
local function mk(c,p) local o=Instance.new(c); for k,v in pairs(p) do o[k]=v end; return o end
local function corner(p,r) return mk("UICorner",{CornerRadius=UDim.new(0,r or 6),Parent=p}) end
local function pad(p,t,b,l,r) return mk("UIPadding",{PaddingTop=UDim.new(0,t),PaddingBottom=UDim.new(0,b),PaddingLeft=UDim.new(0,l),PaddingRight=UDim.new(0,r),Parent=p}) end
local function list(p,s) return mk("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,s or 4),Parent=p}) end
local fl,cl = math.floor, math.clamp
local function sh(c,d) return Color3.fromRGB(cl(fl(c.R*255+d),0,255),cl(fl(c.G*255+d),0,255),cl(fl(c.B*255+d),0,255)) end

local function scrollFit(s,l)
	local function u() s.CanvasSize=UDim2.fromOffset(0,l.AbsoluteContentSize.Y+8) end
	l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(u); u()
end

local function drag(h,t)
	local d,ds,fs
	h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=true;ds=i.Position;fs=t.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end) end end)
	UIS.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then local dt=i.Position-ds;t.Position=UDim2.new(fs.X.Scale,fs.X.Offset+dt.X,fs.Y.Scale,fs.Y.Offset+dt.Y) end end)
end

-- Themes
local Themes = {
	DarkTheme={Sc=Color3.fromRGB(64,64,64),Bg=Color3.fromRGB(18,18,20),Hd=Color3.fromRGB(12,12,14),Tx=Color3.fromRGB(230,230,235),El=Color3.fromRGB(28,28,32)},
	LightTheme={Sc=Color3.fromRGB(140,140,150),Bg=Color3.fromRGB(242,242,245),Hd=Color3.fromRGB(232,232,236),Tx=Color3.fromRGB(20,20,24),El=Color3.fromRGB(225,225,230)},
	BloodTheme={Sc=Color3.fromRGB(200,30,30),Bg=Color3.fromRGB(16,12,12),Hd=Color3.fromRGB(10,8,8),Tx=Color3.fromRGB(235,230,230),El=Color3.fromRGB(28,20,20)},
	GrapeTheme={Sc=Color3.fromRGB(160,70,210),Bg=Color3.fromRGB(20,16,24),Hd=Color3.fromRGB(14,10,18),Tx=Color3.fromRGB(235,230,240),El=Color3.fromRGB(30,24,36)},
	Ocean={Sc=Color3.fromRGB(70,80,240),Bg=Color3.fromRGB(14,16,28),Hd=Color3.fromRGB(10,12,22),Tx=Color3.fromRGB(210,215,235),El=Color3.fromRGB(22,24,40)},
	Midnight={Sc=Color3.fromRGB(26,180,150),Bg=Color3.fromRGB(16,20,26),Hd=Color3.fromRGB(12,16,22),Tx=Color3.fromRGB(225,235,232),El=Color3.fromRGB(24,30,36)},
	Sentinel={Sc=Color3.fromRGB(220,35,65),Bg=Color3.fromRGB(16,16,16),Hd=Color3.fromRGB(10,10,10),Tx=Color3.fromRGB(230,230,230),El=Color3.fromRGB(26,26,26)},
	Synapse={Sc=Color3.fromRGB(150,95,50),Bg=Color3.fromRGB(14,16,14),Hd=Color3.fromRGB(10,12,10),Tx=Color3.fromRGB(200,180,150),El=Color3.fromRGB(22,24,22)},
	Serpent={Sc=Color3.fromRGB(0,160,55),Bg=Color3.fromRGB(14,18,16),Hd=Color3.fromRGB(10,14,12),Tx=Color3.fromRGB(220,235,225),El=Color3.fromRGB(22,28,24)},
	Aurora={Sc=Color3.fromRGB(0,190,170),Bg=Color3.fromRGB(12,14,18),Hd=Color3.fromRGB(8,10,14),Tx=Color3.fromRGB(215,235,230),El=Color3.fromRGB(20,24,30)},
	Cyberpunk={Sc=Color3.fromRGB(245,0,120),Bg=Color3.fromRGB(10,6,14),Hd=Color3.fromRGB(8,4,12),Tx=Color3.fromRGB(0,245,190),El=Color3.fromRGB(18,10,24)},
	Sunset={Sc=Color3.fromRGB(245,95,45),Bg=Color3.fromRGB(18,12,10),Hd=Color3.fromRGB(14,10,8),Tx=Color3.fromRGB(250,220,200),El=Color3.fromRGB(30,20,16)},
	Forest={Sc=Color3.fromRGB(34,130,34),Bg=Color3.fromRGB(10,16,10),Hd=Color3.fromRGB(8,12,8),Tx=Color3.fromRGB(200,225,200),El=Color3.fromRGB(18,28,18)},
	Candy={Sc=Color3.fromRGB(245,100,170),Bg=Color3.fromRGB(18,10,14),Hd=Color3.fromRGB(14,8,12),Tx=Color3.fromRGB(250,215,230),El=Color3.fromRGB(30,18,24)},
	Royal={Sc=Color3.fromRGB(115,75,195),Bg=Color3.fromRGB(14,10,20),Hd=Color3.fromRGB(10,8,16),Tx=Color3.fromRGB(215,208,245),El=Color3.fromRGB(22,18,32)},
	Neon={Sc=Color3.fromRGB(55,245,20),Bg=Color3.fromRGB(6,6,6),Hd=Color3.fromRGB(4,4,4),Tx=Color3.fromRGB(55,245,20),El=Color3.fromRGB(14,14,14)},
	Desert={Sc=Color3.fromRGB(200,155,55),Bg=Color3.fromRGB(20,16,12),Hd=Color3.fromRGB(16,14,10),Tx=Color3.fromRGB(235,220,185),El=Color3.fromRGB(32,26,18)},
	Ice={Sc=Color3.fromRGB(95,175,245),Bg=Color3.fromRGB(10,14,20),Hd=Color3.fromRGB(8,10,16),Tx=Color3.fromRGB(200,220,248),El=Color3.fromRGB(18,22,32)},
	Matrix={Sc=Color3.fromRGB(0,245,60),Bg=Color3.fromRGB(4,6,4),Hd=Color3.fromRGB(2,4,2),Tx=Color3.fromRGB(0,245,60),El=Color3.fromRGB(8,14,8)},
	Halloween={Sc=Color3.fromRGB(245,115,0),Bg=Color3.fromRGB(16,10,6),Hd=Color3.fromRGB(12,8,4),Tx=Color3.fromRGB(248,195,135),El=Color3.fromRGB(28,16,8)},
	Pastel={Sc=Color3.fromRGB(175,155,205),Bg=Color3.fromRGB(238,234,242),Hd=Color3.fromRGB(225,220,232),Tx=Color3.fromRGB(55,48,65),El=Color3.fromRGB(215,210,224)},
	Space={Sc=Color3.fromRGB(85,55,215),Bg=Color3.fromRGB(8,6,16),Hd=Color3.fromRGB(6,4,12),Tx=Color3.fromRGB(195,188,235),El=Color3.fromRGB(16,12,28)},
}
local def={Sc=Color3.fromRGB(74,99,135),Bg=Color3.fromRGB(18,18,20),Hd=Color3.fromRGB(12,12,14),Tx=Color3.fromRGB(230,230,235),El=Color3.fromRGB(28,28,32)}

local function theme(t)
	if type(t)=="string" and Themes[t] then return Themes[t] end
	if type(t)=="table" then return {Sc=t.SchemeColor or def.Sc,Bg=t.Background or def.Bg,Hd=t.Header or def.Hd,Tx=t.TextColor or def.Tx,El=t.ElementColor or def.El} end
	return def
end

local LID="Kavo_"..math.random(1e5,9e5)
function Kavo:ToggleUI() local g=game.CoreGui:FindFirstChild(LID); if g then g.Enabled=not g.Enabled end end
function Kavo:ChangeColor(prop,color)
	if Kavo._theme then
		local m={SchemeColor="Sc",Background="Bg",Header="Hd",TextColor="Tx",ElementColor="El"}
		if m[prop] then Kavo._theme[m[prop]]=color end
	end
end

function Kavo.CreateLib(title,themeIn)
	title=title or "Library"; local C=theme(themeIn); Kavo._theme=C
	for _,v in ipairs(game.CoreGui:GetChildren()) do if v.Name==LID then v:Destroy() end end

	local gui=mk("ScreenGui",{Name=LID,Parent=game.CoreGui,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,ResetOnSpawn=false})

	-- Main window
	local R=10
	local main=mk("Frame",{Name="Main",Parent=gui,BackgroundColor3=C.Bg,ClipsDescendants=true,Position=UDim2.new(0.5,-260,0.5,-170),Size=UDim2.fromOffset(520,340),BorderSizePixel=0})
	corner(main,R)

	-- Header
	local hdr=mk("Frame",{Parent=main,BackgroundColor3=C.Hd,Size=UDim2.new(1,0,0,32),BorderSizePixel=0})
	corner(hdr,R); mk("Frame",{Parent=hdr,BackgroundColor3=C.Hd,Position=UDim2.new(0,0,1,-R),Size=UDim2.new(1,0,0,R),BorderSizePixel=0})
	drag(hdr,main)
	mk("TextLabel",{Parent=hdr,BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-44,1,0),Font=Enum.Font.SourceSansBold,Text=title,RichText=true,TextColor3=C.Tx,TextSize=16,TextXAlignment=Enum.TextXAlignment.Left,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=0.5})
	local cls=mk("TextButton",{Parent=hdr,BackgroundTransparency=1,Position=UDim2.new(1,-32,0,0),Size=UDim2.fromOffset(32,32),Font=Enum.Font.SourceSansBold,Text="×",TextColor3=sh(C.Tx,-80),TextSize=20,AutoButtonColor=false})
	cls.MouseEnter:Connect(function() tw(cls,{TextColor3=Color3.fromRGB(220,50,50)}) end)
	cls.MouseLeave:Connect(function() tw(cls,{TextColor3=sh(C.Tx,-80)}) end)
	cls.MouseButton1Click:Connect(function() gui:Destroy() end)

	-- Sidebar
	local side=mk("Frame",{Parent=main,BackgroundColor3=C.Hd,Position=UDim2.fromOffset(0,32),Size=UDim2.new(0,130,1,-32),BorderSizePixel=0})
	corner(side,R); mk("Frame",{Parent=side,BackgroundColor3=C.Hd,Position=UDim2.new(1,-R,0,0),Size=UDim2.new(0,R,1,0),BorderSizePixel=0}); mk("Frame",{Parent=side,BackgroundColor3=C.Hd,Size=UDim2.new(1,0,0,R),BorderSizePixel=0})
	local tabs=mk("ScrollingFrame",{Parent=side,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ScrollBarThickness=0,BorderSizePixel=0,CanvasSize=UDim2.fromOffset(0,0)})
	local tabLay=list(tabs,2); pad(tabs,6,6,6,6); scrollFit(tabs,tabLay)

	-- Content area
	local content=mk("Frame",{Parent=main,BackgroundColor3=C.Bg,Position=UDim2.fromOffset(130,32),Size=UDim2.new(1,-130,1,-32),BorderSizePixel=0})
	corner(content,R); mk("Frame",{Parent=content,BackgroundColor3=C.Bg,Size=UDim2.new(1,0,0,R),BorderSizePixel=0}); mk("Frame",{Parent=content,BackgroundColor3=C.Bg,Size=UDim2.new(0,R,1,0),BorderSizePixel=0})

	-- Notification
	local nHolder=mk("Frame",{Parent=gui,BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-16,0,16),Size=UDim2.fromOffset(260,400)})
	local nLay=list(nHolder,6)

	function Kavo:Notify(cfg)
		cfg=cfg or {}
		local n=mk("Frame",{Parent=nHolder,BackgroundColor3=sh(C.Bg,10),Size=UDim2.new(1,0,0,50),BorderSizePixel=0})
		corner(n,10)
		mk("TextLabel",{Parent=n,BackgroundTransparency=1,Position=UDim2.fromOffset(10,6),Size=UDim2.new(1,-20,0,16),Font=Enum.Font.SourceSansBold,Text=cfg.Title or "Notice",TextColor3=C.Sc,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left})
		mk("TextLabel",{Parent=n,BackgroundTransparency=1,Position=UDim2.fromOffset(10,24),Size=UDim2.new(1,-20,0,20),Font=Enum.Font.SourceSans,Text=cfg.Text or "",TextColor3=sh(C.Tx,-20),TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true})
		task.delay(cfg.Duration or 4,function() tw(n,{BackgroundTransparency=1},0.2); for _,c in ipairs(n:GetChildren()) do pcall(function() tw(c,{TextTransparency=1},0.2) end) end; task.delay(0.25,n.Destroy,n) end)
	end

	local W={}; local first=true

	function W:NewTab(name)
		name=name or "Tab"
		local btn=mk("TextButton",{Parent=tabs,BackgroundColor3=C.Sc,BackgroundTransparency=1,Size=UDim2.new(1,0,0,28),AutoButtonColor=false,Font=Enum.Font.SourceSansBold,Text=name,TextColor3=sh(C.Tx,-50),TextSize=14,BorderSizePixel=0})
		corner(btn,10)

		local pg=mk("ScrollingFrame",{Parent=content,BackgroundColor3=C.Bg,BackgroundTransparency=0,Size=UDim2.new(1,0,1,0),ScrollBarThickness=2,ScrollBarImageColor3=sh(C.Sc,-30),BorderSizePixel=0,Visible=false,CanvasSize=UDim2.fromOffset(0,0)})
		local pgLay=list(pg,5); pad(pg,8,8,10,10); scrollFit(pg,pgLay)

		if first then first=false; pg.Visible=true; btn.BackgroundTransparency=0.15; btn.TextColor3=C.Tx end

		btn.MouseButton1Click:Connect(function()
			for _,p in ipairs(content:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible=false end end
			for _,b in ipairs(tabs:GetChildren()) do if b:IsA("TextButton") then tw(b,{BackgroundTransparency=1,TextColor3=sh(C.Tx,-50)}) end end
			pg.Visible=true; tw(btn,{BackgroundTransparency=0.15,TextColor3=C.Tx})
		end)

		local Tab={}

		function Tab:NewSection(secName)
			secName=secName or "Section"
			local hdr=mk("TextLabel",{Parent=pg,BackgroundTransparency=1,Size=UDim2.new(1,0,0,20),Font=Enum.Font.SourceSansBold,Text=string.upper(secName),RichText=true,TextColor3=sh(C.Tx,-70),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left})
			pad(hdr,0,0,4,0)

			local box=mk("Frame",{Parent=pg,BackgroundColor3=C.El,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BorderSizePixel=0})
			corner(box,10)
			local inner=mk("Frame",{Parent=box,BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y})
			local il=list(inner,2); pad(inner,4,4,4,4)

			local S={}
			function S:UpdateSection(t) hdr.Text=string.upper(t) end

			local function row()
				local f=mk("TextButton",{Parent=inner,BackgroundColor3=C.El,Size=UDim2.new(1,0,0,32),AutoButtonColor=false,Text="",BorderSizePixel=0})
				corner(f,8)
				f.MouseEnter:Connect(function() tw(f,{BackgroundColor3=sh(C.El,20)},0.1) end)
				f.MouseLeave:Connect(function() tw(f,{BackgroundColor3=C.El},0.1) end)
				return f
			end
			local function label(p,t) return mk("TextLabel",{Parent=p,BackgroundTransparency=1,Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-20,1,0),Font=Enum.Font.SourceSansBold,Text=t,RichText=true,TextColor3=C.Tx,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=0.5}) end

			function S:NewButton(n,tip,cb) n=n or "Button";cb=cb or function()end
				local f=row(); local l=label(f,n)
				f.MouseButton1Click:Connect(function() tw(f,{BackgroundColor3=sh(C.El,16)},0.05); task.delay(0.05,function() tw(f,{BackgroundColor3=C.El},0.15) end); cb() end)
				local Fn={}; function Fn:UpdateButton(t) l.Text=t end; return Fn
			end

			function S:NewToggle(n,tip,cb) n=n or "Toggle";cb=cb or function()end; local on=false
				local f=row(); label(f,n)
				local tr=mk("Frame",{Parent=f,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),Size=UDim2.fromOffset(32,16),BackgroundColor3=sh(C.El,12),BorderSizePixel=0}); corner(tr,8)
				local kb=mk("Frame",{Parent=tr,Position=UDim2.new(0,2,0.5,0),AnchorPoint=Vector2.new(0,0.5),Size=UDim2.fromOffset(12,12),BackgroundColor3=sh(C.Tx,-70),BorderSizePixel=0}); corner(kb,6)
				local function set(v) on=v; tw(tr,{BackgroundColor3=v and C.Sc or sh(C.El,12)}); tw(kb,{Position=v and UDim2.new(1,-14,0.5,0) or UDim2.new(0,2,0.5,0),BackgroundColor3=v and C.Tx or sh(C.Tx,-70)}) end
				f.MouseButton1Click:Connect(function() set(not on); pcall(cb,on) end)
				local Fn={}; function Fn:UpdateToggle(t,s) if t then for _,c in ipairs(f:GetChildren()) do if c:IsA("TextLabel") then c.Text=t end end end; if s~=nil then set(s);pcall(cb,s) end end; return Fn
			end

			function S:NewSlider(n,tip,maxV,minV,cb) n=n or "Slider";maxV=maxV or 100;minV=minV or 0;cb=cb or function()end
				local f=row(); f.Size=UDim2.new(1,0,0,40)
				local sl=label(f,n); sl.Size=UDim2.new(0.5,0,0,18); sl.Position=UDim2.fromOffset(10,2)
				local vl=mk("TextLabel",{Parent=f,BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-10,0,2),Size=UDim2.fromOffset(50,18),Font=Enum.Font.SourceSansBold,Text=tostring(minV),TextColor3=C.Sc,TextSize=13,TextXAlignment=Enum.TextXAlignment.Right})
				local bar=mk("Frame",{Parent=f,Position=UDim2.new(0,10,1,-12),Size=UDim2.new(1,-20,0,4),BackgroundColor3=sh(C.El,8),BorderSizePixel=0}); corner(bar,2)
				local fill=mk("Frame",{Parent=bar,Size=UDim2.new(0,0,1,0),BackgroundColor3=C.Sc,BorderSizePixel=0}); corner(fill,2)
				local s=false
				local function upd(i) local r=cl((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1); fill.Size=UDim2.new(r,0,1,0); local v=fl(minV+r*(maxV-minV)); vl.Text=tostring(v); pcall(cb,v) end
				bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then s=true;upd(i) end end)
				UIS.InputChanged:Connect(function(i) if s and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i) end end)
				UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then s=false end end)
			end

			function S:NewTextBox(n,tip,cb) n=n or "Input";cb=cb or function()end
				local f=row(); label(f,n).Size=UDim2.new(0.4,0,1,0)
				local bx=mk("TextBox",{Parent=f,BackgroundColor3=sh(C.Bg,4),Position=UDim2.new(0.5,4,0.5,0),AnchorPoint=Vector2.new(0,0.5),Size=UDim2.new(0.44,0,0,22),Font=Enum.Font.SourceSans,PlaceholderText="...",PlaceholderColor3=sh(C.Tx,-80),Text="",TextColor3=C.Tx,TextSize=13,ClearTextOnFocus=false,BorderSizePixel=0,ClipsDescendants=true})
				corner(bx,4); bx.FocusLost:Connect(function(e) if e then pcall(cb,bx.Text); bx.Text="" end end)
			end

			function S:NewKeybind(n,tip,dk,cb) n=n or "Keybind";cb=cb or function()end; local key=dk
				local f=row(); label(f,n)
				local kl=mk("TextLabel",{Parent=f,BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),Size=UDim2.fromOffset(60,20),Font=Enum.Font.SourceSansBold,Text=key and key.Name or "—",TextColor3=C.Sc,TextSize=13,TextXAlignment=Enum.TextXAlignment.Right})
				local listening=false
				f.MouseButton1Click:Connect(function() if listening then return end; listening=true;kl.Text="..."; local i=UIS.InputBegan:Wait(); if i.KeyCode~=Enum.KeyCode.Unknown then key=i.KeyCode;kl.Text=key.Name end; listening=false end)
				UIS.InputBegan:Connect(function(i,g) if not g and key and i.KeyCode==key then pcall(cb) end end)
			end

			function S:NewDropdown(n,tip,items,cb) n=n or "Select";items=items or {};cb=cb or function()end; local open=false
				local wrap=mk("Frame",{Parent=inner,BackgroundColor3=C.El,Size=UDim2.new(1,0,0,32),ClipsDescendants=true,BorderSizePixel=0}); corner(wrap,8)
				local head=mk("TextButton",{Parent=wrap,BackgroundTransparency=1,Size=UDim2.new(1,0,0,32),AutoButtonColor=false,Text="",BorderSizePixel=0})
				head.MouseEnter:Connect(function() tw(wrap,{BackgroundColor3=sh(C.El,20)},0.1) end)
				head.MouseLeave:Connect(function() tw(wrap,{BackgroundColor3=C.El},0.1) end)
				local hl=mk("TextLabel",{Parent=head,BackgroundTransparency=1,Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-30,1,0),Font=Enum.Font.SourceSansBold,Text=n,TextColor3=C.Tx,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,TextStrokeColor3=Color3.new(0,0,0),TextStrokeTransparency=0.5})
				local arr=mk("TextLabel",{Parent=head,BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),Size=UDim2.fromOffset(16,16),Font=Enum.Font.SourceSansBold,Text="v",TextColor3=sh(C.Tx,-60),TextSize=14})
				local opts=mk("Frame",{Parent=wrap,BackgroundTransparency=1,Position=UDim2.fromOffset(0,32),Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y})
				local ol=list(opts,1); pad(opts,2,4,4,4)
				local function build(lst)
					for _,c in ipairs(opts:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
					for _,v in ipairs(lst) do
						local o=mk("TextButton",{Parent=opts,BackgroundColor3=sh(C.El,4),Size=UDim2.new(1,0,0,26),AutoButtonColor=false,Font=Enum.Font.SourceSans,Text="  "..v,TextColor3=sh(C.Tx,-10),TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0}); corner(o,6)
						o.MouseEnter:Connect(function() tw(o,{BackgroundColor3=sh(C.El,24)},0.08) end)
						o.MouseLeave:Connect(function() tw(o,{BackgroundColor3=sh(C.El,4)},0.08) end)
						o.MouseButton1Click:Connect(function() hl.Text=v;pcall(cb,v);open=false;tw(wrap,{Size=UDim2.new(1,0,0,32)});arr.Text="v" end)
					end
				end; build(items)
				head.MouseButton1Click:Connect(function() open=not open
					if open then tw(wrap,{Size=UDim2.new(1,0,0,32+opts.AbsoluteSize.Y+8)});arr.Text="^"
					else tw(wrap,{Size=UDim2.new(1,0,0,32)});arr.Text="v" end
				end)
				local Fn={}; function Fn:Refresh(nl) build(nl); if open then tw(wrap,{Size=UDim2.new(1,0,0,32+opts.AbsoluteSize.Y+8)}) end end; return Fn
			end

			function S:NewColorPicker(n,tip,dc,cb) n=n or "Color";dc=dc or Color3.new(1,1,1);cb=cb or function()end
				local h,s,v=Color3.toHSV(dc); local cpO=false
				local wrap=mk("Frame",{Parent=inner,BackgroundColor3=C.El,Size=UDim2.new(1,0,0,32),ClipsDescendants=true,BorderSizePixel=0}); corner(wrap,8)
				local head=mk("TextButton",{Parent=wrap,BackgroundTransparency=1,Size=UDim2.new(1,0,0,32),AutoButtonColor=false,Text="",BorderSizePixel=0})
				mk("TextLabel",{Parent=head,BackgroundTransparency=1,Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-50,1,0),Font=Enum.Font.SourceSansBold,Text=n,TextColor3=C.Tx,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left})
				local pre=mk("Frame",{Parent=head,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),Size=UDim2.fromOffset(24,14),BackgroundColor3=dc,BorderSizePixel=0}); corner(pre,4)
				local hi=mk("ImageButton",{Parent=wrap,BackgroundTransparency=1,Position=UDim2.fromOffset(8,38),Size=UDim2.new(0.58,0,0,70),Image="rbxassetid://6523286724"}); corner(hi,4)
				local hc=mk("Frame",{Parent=hi,Size=UDim2.fromOffset(8,8),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5)}); corner(hc,4)
				local vi=mk("ImageButton",{Parent=wrap,BackgroundTransparency=1,Position=UDim2.new(0.62,4,0,38),Size=UDim2.fromOffset(12,70),Image="rbxassetid://6523291212"}); corner(vi,3)
				local vc=mk("Frame",{Parent=vi,Size=UDim2.fromOffset(12,4),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0)}); corner(vc,2)
				local pH,pV=false,false
				local function ref() local c=Color3.fromHSV(h,s,v); pre.BackgroundColor3=c; hc.Position=UDim2.new(h,0,1-s,0); vc.Position=UDim2.new(0.5,0,1-v,0); pcall(cb,c) end; ref()
				hi.MouseButton1Down:Connect(function() pH=true end); vi.MouseButton1Down:Connect(function() pV=true end)
				UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then pH=false;pV=false end end)
				Mouse.Move:Connect(function()
					if pH then h=cl((Mouse.X-hi.AbsolutePosition.X)/hi.AbsoluteSize.X,0,1);s=1-cl((Mouse.Y-hi.AbsolutePosition.Y)/hi.AbsoluteSize.Y,0,1);ref() end
					if pV then v=1-cl((Mouse.Y-vi.AbsolutePosition.Y)/vi.AbsoluteSize.Y,0,1);ref() end
				end)
				head.MouseButton1Click:Connect(function() cpO=not cpO; tw(wrap,{Size=UDim2.new(1,0,0,cpO and 116 or 32)}) end)
			end

			function S:NewLabel(txt)
				local l=mk("TextLabel",{Parent=inner,BackgroundTransparency=1,Size=UDim2.new(1,0,0,22),Font=Enum.Font.SourceSansBold,Text=txt or "",RichText=true,TextColor3=C.Sc,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0})
				pad(l,0,0,10,0)
				local Fn={}; function Fn:UpdateLabel(t) l.Text=t end; return Fn
			end

			return S
		end
		return Tab
	end
	return W
end

return Kavo
