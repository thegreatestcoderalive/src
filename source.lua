--// Kavo UI Library — Windows 98 Edition
--// ponytail: ultra — faithful 98.css in Roblox
local Kavo = {}
local UIS = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local function mk(c,p) local o=Instance.new(c); for k,v in pairs(p) do o[k]=v end; return o end
local function list(p,s,d) return mk("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,s or 0),FillDirection=d or Enum.FillDirection.Vertical,Parent=p}) end
local function pad(p,t,b,l,r) return mk("UIPadding",{PaddingTop=UDim.new(0,t),PaddingBottom=UDim.new(0,b),PaddingLeft=UDim.new(0,l),PaddingRight=UDim.new(0,r),Parent=p}) end
local fl,cl = math.floor, math.clamp

local function scrollFit(s,l)
	local function u() s.CanvasSize=UDim2.fromOffset(0,l.AbsoluteContentSize.Y+8) end
	l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(u); u()
end

local function drag(h,t)
	local d,ds,fs
	h.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then d=true;ds=i.Position;fs=t.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end) end end)
	UIS.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then local dt=i.Position-ds;t.Position=UDim2.new(fs.X.Scale,fs.X.Offset+dt.X,fs.Y.Scale,fs.Y.Offset+dt.Y) end end)
end

-- 98.css palette
local W = {
	Face   = Color3.fromRGB(192,192,192), -- --surface #c0c0c0
	BtnF   = Color3.fromRGB(223,223,223), -- --button-face #dfdfdf
	Hi     = Color3.fromRGB(255,255,255), -- --button-highlight
	Sha    = Color3.fromRGB(128,128,128), -- --button-shadow
	Dk     = Color3.fromRGB(10,10,10),    -- --window-frame #0a0a0a
	Win    = Color3.fromRGB(255,255,255),
	Title  = Color3.fromRGB(0,0,128),     -- --dialog-blue
	TitTx  = Color3.fromRGB(255,255,255),
	Tx     = Color3.fromRGB(34,34,34),    -- --text-color #222
	Sel    = Color3.fromRGB(0,0,128),
	SelTx  = Color3.fromRGB(255,255,255),
}

-- ponytail: raised/sunken match 98.css 4-layer box-shadow exactly
local function raised(p,z)
	z=z or p.ZIndex+1
	mk("Frame",{Parent=p,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.BtnF,BorderSizePixel=0,Size=UDim2.new(1,-2,0,1),Position=UDim2.fromOffset(1,1),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.BtnF,BorderSizePixel=0,Size=UDim2.new(0,1,1,-2),Position=UDim2.fromOffset(1,1),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(1,-2,0,1),Position=UDim2.new(0,1,1,-2),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(0,1,1,-2),Position=UDim2.new(1,-2,0,1),ZIndex=z})
end

local function sunken(p,z)
	z=z or p.ZIndex+1
	mk("Frame",{Parent=p,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(1,-2,0,1),Position=UDim2.fromOffset(1,1),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(0,1,1,-2),Position=UDim2.fromOffset(1,1),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.BtnF,BorderSizePixel=0,Size=UDim2.new(1,-2,0,1),Position=UDim2.new(0,1,1,-2),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.BtnF,BorderSizePixel=0,Size=UDim2.new(0,1,1,-2),Position=UDim2.new(1,-2,0,1),ZIndex=z})
end

-- ponytail: field border (checkbox, input) — 98.css flips window-frame and button-shadow
local function fieldBorder(p,z)
	z=z or p.ZIndex+1
	mk("Frame",{Parent=p,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.new(1,-2,0,1),Position=UDim2.fromOffset(1,1),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.new(0,1,1,-2),Position=UDim2.fromOffset(1,1),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.BtnF,BorderSizePixel=0,Size=UDim2.new(1,-2,0,1),Position=UDim2.new(0,1,1,-2),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.BtnF,BorderSizePixel=0,Size=UDim2.new(0,1,1,-2),Position=UDim2.new(1,-2,0,1),ZIndex=z})
end

local function clearBorders(p)
	for _,c in ipairs(p:GetChildren()) do if c:IsA("Frame") and (c.Size.Y.Scale <= 0.01 or c.Size.X.Scale <= 0.01) then c:Destroy() end end
end
local function pressBorder(p) clearBorders(p); sunken(p) end
local function releaseBorder(p) clearBorders(p); raised(p) end

-- Etched groove for fieldset/GroupBox
local function etched(p,z)
	z=z or p.ZIndex+1
	mk("Frame",{Parent=p,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(1,-4,0,1),Position=UDim2.fromOffset(2,0),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(1,-4,0,1),Position=UDim2.fromOffset(2,1),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(0,1,1,-4),Position=UDim2.fromOffset(0,2),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(0,1,1,-4),Position=UDim2.fromOffset(1,2),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(1,-4,0,1),Position=UDim2.new(0,2,1,-2),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(1,-4,0,1),Position=UDim2.new(0,2,1,-1),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(0,1,1,-4),Position=UDim2.new(1,-2,0,2),ZIndex=z})
	mk("Frame",{Parent=p,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(0,1,1,-4),Position=UDim2.new(1,-1,0,2),ZIndex=z})
end

-- Title bar button — draw icon with frames instead of unreliable unicode glyphs
local function titleBtn(parent, icon, onClick, z)
	z = z or 10
	local b = mk("TextButton",{Parent=parent,BackgroundColor3=W.Face,Size=UDim2.fromOffset(16,14),AutoButtonColor=false,Font=Enum.Font.SourceSans,Text="",TextSize=1,BorderSizePixel=0,ZIndex=z})
	raised(b,z+1)
	-- draw icon with pixel frames
	if icon == "min" then
		mk("Frame",{Parent=b,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.fromOffset(6,2),Position=UDim2.fromOffset(4,10),ZIndex=z+2})
	elseif icon == "max" then
		mk("Frame",{Parent=b,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.fromOffset(9,1),Position=UDim2.fromOffset(3,2),ZIndex=z+2})
		mk("Frame",{Parent=b,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.fromOffset(9,1),Position=UDim2.fromOffset(3,3),ZIndex=z+2})
		mk("Frame",{Parent=b,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.fromOffset(1,7),Position=UDim2.fromOffset(3,4),ZIndex=z+2})
		mk("Frame",{Parent=b,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.fromOffset(1,7),Position=UDim2.fromOffset(11,4),ZIndex=z+2})
		mk("Frame",{Parent=b,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.fromOffset(9,1),Position=UDim2.fromOffset(3,10),ZIndex=z+2})
	elseif icon == "close" then
		-- X shape
		for i=0,6 do
			mk("Frame",{Parent=b,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.fromOffset(2,1),Position=UDim2.fromOffset(3+i,3+i),ZIndex=z+2})
			mk("Frame",{Parent=b,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.fromOffset(2,1),Position=UDim2.fromOffset(11-i,3+i),ZIndex=z+2})
		end
	end
	b.MouseButton1Down:Connect(function() pressBorder(b) end)
	b.MouseButton1Up:Connect(function() releaseBorder(b) end)
	if onClick then b.MouseButton1Click:Connect(onClick) end
	return b
end

local LID="Kavo_"..math.random(1e5,9e5)
function Kavo:ToggleUI() local g=game.CoreGui:FindFirstChild(LID); if g then g.Enabled=not g.Enabled end end
function Kavo:ChangeColor() end -- ponytail: no-op

function Kavo.CreateLib(title, _themeIn)
	title = title or "Library"
	Kavo._theme = {}
	for _,v in ipairs(game.CoreGui:GetChildren()) do if v.Name==LID then v:Destroy() end end

	local gui = mk("ScreenGui",{Name=LID,Parent=game.CoreGui,ZIndexBehavior=Enum.ZIndexBehavior.Global,ResetOnSpawn=false})
	local popupLayer = mk("Frame",{Name="Popups",Parent=gui,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=100})

	-- Main window — 98.css .window borders
	local main = mk("Frame",{Name="Main",Parent=gui,BackgroundColor3=W.Face,ClipsDescendants=false,Position=UDim2.new(0.5,-260,0.5,-190),Size=UDim2.fromOffset(520,380),BorderSizePixel=0,ZIndex=1})
	do -- window border: outer BtnF/Dk, inner Hi/Sha
		local z=2
		mk("Frame",{Parent=main,BackgroundColor3=W.BtnF,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(),ZIndex=z})
		mk("Frame",{Parent=main,BackgroundColor3=W.BtnF,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(),ZIndex=z})
		mk("Frame",{Parent=main,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),ZIndex=z})
		mk("Frame",{Parent=main,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),ZIndex=z})
		mk("Frame",{Parent=main,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(1,-2,0,1),Position=UDim2.fromOffset(1,1),ZIndex=z})
		mk("Frame",{Parent=main,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(0,1,1,-2),Position=UDim2.fromOffset(1,1),ZIndex=z})
		mk("Frame",{Parent=main,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(1,-2,0,1),Position=UDim2.new(0,1,1,-2),ZIndex=z})
		mk("Frame",{Parent=main,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(0,1,1,-2),Position=UDim2.new(1,-2,0,1),ZIndex=z})
	end

	-- Title bar — 98.css: 18px, padding 3px 2px 3px 3px
	local hdr = mk("Frame",{Parent=main,BackgroundColor3=W.Title,Size=UDim2.new(1,-6,0,18),Position=UDim2.fromOffset(3,3),BorderSizePixel=0,ZIndex=3})
	drag(hdr,main)
	mk("TextLabel",{Parent=hdr,BackgroundTransparency=1,Position=UDim2.fromOffset(3,0),Size=UDim2.new(1,-60,1,0),Font=Enum.Font.SourceSansBold,Text=title,RichText=true,TextColor3=W.TitTx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=4})

	-- Title buttons — frame-drawn pixel icons, high ZIndex
	local btnBar = mk("Frame",{Parent=hdr,BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-2,0.5,0),Size=UDim2.fromOffset(54,14),ZIndex=10})
	list(btnBar,2,Enum.FillDirection.Horizontal)
	titleBtn(btnBar,"min",function() main.Visible=not main.Visible end,10)
	titleBtn(btnBar,"max",nil,10)
	titleBtn(btnBar,"close",function() gui:Destroy() end,10)

	-- Tab row — sits directly above content, tabs overlap 2px into content border
	-- 98.css: tablist margin:0 0 -2px, padding-left:3px
	local tabRow = mk("Frame",{Parent=main,BackgroundTransparency=1,Position=UDim2.fromOffset(3,23),Size=UDim2.new(1,-6,0,24),BorderSizePixel=0,ZIndex=3})
	list(tabRow,0,Enum.FillDirection.Horizontal)
	pad(tabRow,0,0,3,0)

	-- Content well — Y = tabRow.Y + tabRow.Height - 2 (tabs overlap 2px)
	-- tabRow at Y=23, height=24, so content at Y=45
	local content = mk("Frame",{Parent=main,BackgroundColor3=W.Face,Position=UDim2.fromOffset(3,45),Size=UDim2.new(1,-6,1,-66),BorderSizePixel=0,ZIndex=3})
	sunken(content,4)

	-- Status bar — 98.css: .status-bar-field { inset -1px -1px BtnF, inset 1px 1px Sha }
	local sbar = mk("Frame",{Parent=main,BackgroundColor3=W.Face,Position=UDim2.new(0,4,1,-19),Size=UDim2.new(1,-8,0,16),BorderSizePixel=0,ZIndex=3})
	do
		local z=4
		mk("Frame",{Parent=sbar,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(),ZIndex=z})
		mk("Frame",{Parent=sbar,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(),ZIndex=z})
		mk("Frame",{Parent=sbar,BackgroundColor3=W.BtnF,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),ZIndex=z})
		mk("Frame",{Parent=sbar,BackgroundColor3=W.BtnF,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),ZIndex=z})
	end
	mk("TextLabel",{Parent=sbar,BackgroundTransparency=1,Position=UDim2.fromOffset(3,1),Size=UDim2.new(1,-6,1,-1),Font=Enum.Font.SourceSans,Text="Ready",TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5})

	-- Notifications
	local nHolder = mk("Frame",{Parent=gui,BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-12,0,12),Size=UDim2.fromOffset(260,500),ZIndex=90})
	list(nHolder,4)

	function Kavo:Notify(cfg)
		cfg = cfg or {}
		local n = mk("Frame",{Parent=nHolder,BackgroundColor3=W.Face,Size=UDim2.new(1,0,0,68),BorderSizePixel=0,ZIndex=91})
		raised(n,92)
		local nh = mk("Frame",{Parent=n,BackgroundColor3=W.Title,Size=UDim2.new(1,-6,0,18),Position=UDim2.fromOffset(3,3),BorderSizePixel=0,ZIndex=93})
		mk("TextLabel",{Parent=nh,BackgroundTransparency=1,Position=UDim2.fromOffset(3,0),Size=UDim2.new(1,-6,1,0),Font=Enum.Font.SourceSansBold,Text=cfg.Title or "Notice",TextColor3=W.TitTx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=94})
		mk("TextLabel",{Parent=n,BackgroundTransparency=1,Position=UDim2.fromOffset(8,26),Size=UDim2.new(1,-16,0,36),Font=Enum.Font.SourceSans,Text=cfg.Text or "",TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,ZIndex=93})
		task.delay(cfg.Duration or 4, function() n:Destroy() end)
	end

	local activePopup = nil
	local function closePopup() if activePopup then activePopup:Destroy(); activePopup=nil end end

	local Lib = {}; local first = true

	function Lib:NewTab(name)
		name = name or "Tab"

		-- Tab button — 98.css --border-tab, no bottom border
		local btn = mk("TextButton",{Parent=tabRow,BackgroundColor3=W.Face,Size=UDim2.new(0,0,0,24),AutomaticSize=Enum.AutomaticSize.X,AutoButtonColor=false,Font=Enum.Font.SourceSans,Text=name,TextColor3=W.Tx,TextSize=13,BorderSizePixel=0,ZIndex=5,ClipsDescendants=false})
		pad(btn,4,4,8,8)

		-- Tab borders: left Hi+BtnF, top Hi+BtnF, right Dk+Sha — NO bottom
		mk("Frame",{Name="B",Parent=btn,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(),ZIndex=6})
		mk("Frame",{Name="B",Parent=btn,BackgroundColor3=W.BtnF,BorderSizePixel=0,Size=UDim2.new(0,1,1,-1),Position=UDim2.fromOffset(1,1),ZIndex=6})
		mk("Frame",{Name="B",Parent=btn,BackgroundColor3=W.Hi,BorderSizePixel=0,Size=UDim2.new(1,-2,0,1),Position=UDim2.fromOffset(1,0),ZIndex=6})
		mk("Frame",{Name="B",Parent=btn,BackgroundColor3=W.BtnF,BorderSizePixel=0,Size=UDim2.new(1,-4,0,1),Position=UDim2.fromOffset(2,1),ZIndex=6})
		mk("Frame",{Name="B",Parent=btn,BackgroundColor3=W.Dk,BorderSizePixel=0,Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),ZIndex=6})
		mk("Frame",{Name="B",Parent=btn,BackgroundColor3=W.Sha,BorderSizePixel=0,Size=UDim2.new(0,1,1,-1),Position=UDim2.new(1,-2,0,1),ZIndex=6})
		-- Bottom cover — masks content top border when active. Extends 4px below tab.
		local btm = mk("Frame",{Name="TabBottom",Parent=btn,BackgroundColor3=W.Face,BorderSizePixel=0,Size=UDim2.new(1,-2,0,4),Position=UDim2.new(0,1,1,-2),ZIndex=9})

		-- Page
		local pg = mk("ScrollingFrame",{Parent=content,BackgroundColor3=W.Face,BackgroundTransparency=0,Size=UDim2.new(1,-4,1,-4),Position=UDim2.fromOffset(2,2),ScrollBarThickness=16,ScrollBarImageColor3=W.BtnF,BorderSizePixel=0,Visible=false,CanvasSize=UDim2.fromOffset(0,0),ZIndex=5})
		local pgLay = list(pg,6); pad(pg,8,8,10,10); scrollFit(pg,pgLay)

		local function activate()
			closePopup()
			for _,b in ipairs(tabRow:GetChildren()) do
				if b:IsA("TextButton") then
					b.Font = Enum.Font.SourceSans
					b.Size = UDim2.new(0,0,0,22)
					b.Position = UDim2.fromOffset(0,2)
					b.ZIndex = 5
					local bb = b:FindFirstChild("TabBottom")
					if bb then bb.Visible = false end
				end
			end
			for _,p in ipairs(content:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible=false end end

			btn.Font = Enum.Font.SourceSans
			btn.Size = UDim2.new(0,0,0,26)
			btn.Position = UDim2.fromOffset(0,-2)
			btn.ZIndex = 8
			btm.Visible = true
			pg.Visible = true
		end

		if first then first=false; activate() else btm.Visible=false; btn.Size=UDim2.new(0,0,0,22); btn.Position=UDim2.fromOffset(0,2) end
		btn.MouseButton1Click:Connect(activate)

		local Tab = {}

		function Tab:NewSection(secName)
			secName = secName or "Section"

			local box = mk("Frame",{Parent=pg,BackgroundColor3=W.Face,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BorderSizePixel=0,ZIndex=5})
			pad(box,14,8,2,2)
			etched(box,6)

			local legend = mk("TextLabel",{Parent=box,BackgroundColor3=W.Face,Position=UDim2.fromOffset(10,-7),Size=UDim2.new(0,0,0,14),AutomaticSize=Enum.AutomaticSize.X,Font=Enum.Font.SourceSans,Text=" "..secName.." ",RichText=true,TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,ZIndex=7})

			local inner = mk("Frame",{Parent=box,BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,ZIndex=5})
			list(inner,6); pad(inner,4,4,8,8)

			local S = {}
			function S:UpdateSection(t) legend.Text=" "..t.." " end

			local function row(h)
				return mk("Frame",{Parent=inner,BackgroundTransparency=1,Size=UDim2.new(1,0,0,h or 22),BorderSizePixel=0,ZIndex=5})
			end

			function S:NewButton(n,tip,cb) n=n or "Button";cb=cb or function()end
				local f = row(26)
				local b = mk("TextButton",{Parent=f,BackgroundColor3=W.Face,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(1,0,0,23),AutoButtonColor=false,Font=Enum.Font.SourceSans,Text=n,TextColor3=W.Tx,TextSize=13,BorderSizePixel=0,ZIndex=6})
				raised(b,7)
				b.MouseButton1Down:Connect(function() pressBorder(b) end)
				b.MouseButton1Up:Connect(function() releaseBorder(b) end)
				b.MouseButton1Click:Connect(cb)
				local Fn={}; function Fn:UpdateButton(t) b.Text=t end; return Fn
			end

			function S:NewToggle(n,tip,cb) n=n or "Toggle";cb=cb or function()end; local on=false
				local f = row(20)
				-- 98.css checkbox: 13x13 sunken white box, label 6px to the right
				local chk = mk("Frame",{Parent=f,BackgroundColor3=W.Win,Position=UDim2.fromOffset(0,3),Size=UDim2.fromOffset(13,13),BorderSizePixel=0,ZIndex=6})
				fieldBorder(chk,7)
				local mark = mk("TextLabel",{Parent=chk,BackgroundTransparency=1,Position=UDim2.fromOffset(2,0),Size=UDim2.new(1,-4,1,0),Font=Enum.Font.SourceSansBold,Text="",TextColor3=W.Dk,TextSize=14,ZIndex=8})
				local lbl = mk("TextLabel",{Parent=f,BackgroundTransparency=1,Position=UDim2.fromOffset(19,0),Size=UDim2.new(1,-19,1,0),Font=Enum.Font.SourceSans,Text=n,RichText=true,TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6})
				local hit = mk("TextButton",{Parent=f,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text="",BorderSizePixel=0,ZIndex=9})
				local function set(v) on=v; mark.Text=v and "✓" or "" end
				hit.MouseButton1Click:Connect(function() set(not on); pcall(cb,on) end)
				local Fn={}; function Fn:UpdateToggle(t,s) if t then lbl.Text=t end; if s~=nil then set(s);pcall(cb,s) end end; return Fn
			end

			function S:NewSlider(n,tip,maxV,minV,cb) n=n or "Slider";maxV=maxV or 100;minV=minV or 0;cb=cb or function()end
				local f = mk("Frame",{Parent=inner,BackgroundTransparency=1,Size=UDim2.new(1,0,0,36),BorderSizePixel=0,ZIndex=5})
				mk("TextLabel",{Parent=f,BackgroundTransparency=1,Size=UDim2.new(0.6,0,0,14),Font=Enum.Font.SourceSans,Text=n,TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6})
				local vl = mk("TextLabel",{Parent=f,BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,0,0,0),Size=UDim2.fromOffset(50,14),Font=Enum.Font.SourceSans,Text=tostring(minV),TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=6})
				-- Track: 98.css range track is 2px black with 1px inset shadows
				local track = mk("Frame",{Parent=f,BackgroundColor3=W.Dk,Position=UDim2.new(0,0,0,22),Size=UDim2.new(1,0,0,2),BorderSizePixel=0,ZIndex=6})
				-- Thumb: 98.css is 11x21 raised
				local thumb = mk("Frame",{Parent=f,BackgroundColor3=W.Face,Position=UDim2.new(0,0,0,15),Size=UDim2.fromOffset(11,16),BorderSizePixel=0,ZIndex=8})
				raised(thumb,9)
				local dragging = false
				local function upd(x)
					local r = cl((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
					thumb.Position = UDim2.new(0, fl(r * (track.AbsoluteSize.X - 11)), 0, 15)
					local v = fl(minV + r * (maxV - minV))
					vl.Text = tostring(v); pcall(cb, v)
				end
				track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;upd(i.Position.X) end end)
				thumb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
				UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i.Position.X) end end)
				UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
			end

			function S:NewTextBox(n,tip,cb) n=n or "Input";cb=cb or function()end
				local f = row(24)
				mk("TextLabel",{Parent=f,BackgroundTransparency=1,Size=UDim2.new(0.3,0,1,0),Font=Enum.Font.SourceSans,Text=n,TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6})
				local bx = mk("TextBox",{Parent=f,BackgroundColor3=W.Win,Position=UDim2.new(0.32,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),Size=UDim2.new(0.68,0,0,21),Font=Enum.Font.SourceSans,PlaceholderText="",PlaceholderColor3=W.Sha,Text="",TextColor3=W.Tx,TextSize=13,ClearTextOnFocus=false,BorderSizePixel=0,ClipsDescendants=true,ZIndex=6})
				fieldBorder(bx,7)
				bx.FocusLost:Connect(function(e) if e then pcall(cb,bx.Text); bx.Text="" end end)
			end

			function S:NewKeybind(n,tip,dk,cb) n=n or "Keybind";cb=cb or function()end; local key=dk
				local f = row(24)
				mk("TextLabel",{Parent=f,BackgroundTransparency=1,Size=UDim2.new(1,-64,1,0),Font=Enum.Font.SourceSans,Text=n,TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6})
				local kd = mk("Frame",{Parent=f,BackgroundColor3=W.Win,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.fromOffset(58,21),BorderSizePixel=0,ZIndex=6})
				fieldBorder(kd,7)
				local kl = mk("TextLabel",{Parent=kd,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Font=Enum.Font.SourceSans,Text=key and key.Name or "None",TextColor3=W.Tx,TextSize=13,ZIndex=8})
				local listening = false
				local hit = mk("TextButton",{Parent=f,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text="",BorderSizePixel=0,ZIndex=9})
				hit.MouseButton1Click:Connect(function()
					if listening then return end; listening=true; kl.Text="..."
					local i=UIS.InputBegan:Wait()
					if i.KeyCode~=Enum.KeyCode.Unknown then key=i.KeyCode;kl.Text=key.Name end
					listening=false
				end)
				UIS.InputBegan:Connect(function(i,g) if not g and key and i.KeyCode==key then pcall(cb) end end)
			end

			function S:NewDropdown(n,tip,items,cb) n=n or "Select";items=items or {};cb=cb or function()end
				local f = row(24)
				mk("TextLabel",{Parent=f,BackgroundTransparency=1,Size=UDim2.new(0.3,0,1,0),Font=Enum.Font.SourceSans,Text=n,TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6})

				local disp = mk("Frame",{Parent=f,BackgroundColor3=W.Win,Position=UDim2.new(0.32,0,0.5,0),AnchorPoint=Vector2.new(0,0.5),Size=UDim2.new(0.68,-18,0,21),BorderSizePixel=0,ZIndex=6})
				fieldBorder(disp,7)
				local dispTx = mk("TextLabel",{Parent=disp,BackgroundTransparency=1,Position=UDim2.fromOffset(4,0),Size=UDim2.new(1,-8,1,0),Font=Enum.Font.SourceSans,Text="",TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ClipsDescendants=true,ZIndex=8})

				local arr = mk("TextButton",{Parent=f,BackgroundColor3=W.Face,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.fromOffset(16,21),AutoButtonColor=false,Font=Enum.Font.SourceSans,Text="▼",TextColor3=W.Tx,TextSize=10,BorderSizePixel=0,ZIndex=6})
				raised(arr,7)

				local function buildPopup(lst)
					closePopup()
					local itemH = 18; local popH = #lst * itemH + 4
					local absPos = disp.AbsolutePosition
					local absW = disp.AbsoluteSize.X + 16
					local popup = mk("Frame",{Parent=popupLayer,BackgroundColor3=W.Win,Position=UDim2.fromOffset(absPos.X, absPos.Y + 21),Size=UDim2.fromOffset(absW, popH),BorderSizePixel=0,ZIndex=101})
					fieldBorder(popup,102)
					activePopup = popup
					for idx,v in ipairs(lst) do
						local o = mk("TextButton",{Parent=popup,BackgroundColor3=W.Win,Size=UDim2.new(1,-4,0,itemH),Position=UDim2.fromOffset(2, (idx-1)*itemH + 2),AutoButtonColor=false,Font=Enum.Font.SourceSans,Text=" "..v,TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,ZIndex=103})
						o.MouseEnter:Connect(function() o.BackgroundColor3=W.Sel; o.TextColor3=W.SelTx end)
						o.MouseLeave:Connect(function() o.BackgroundColor3=W.Win; o.TextColor3=W.Tx end)
						o.MouseButton1Click:Connect(function() dispTx.Text=v; pcall(cb,v); closePopup() end)
					end
				end

				local open = false
				local function toggle()
					if open then closePopup(); open=false; return end
					open = true; buildPopup(items)
				end

				local hit = mk("TextButton",{Parent=f,BackgroundTransparency=1,Position=UDim2.new(0.32,0,0,0),Size=UDim2.new(0.68,0,1,0),Text="",BorderSizePixel=0,ZIndex=10})
				hit.MouseButton1Click:Connect(toggle)

				local Fn = {}
				function Fn:Refresh(nl)
					items = nl
					if open then closePopup(); open=false; buildPopup(nl); open=true end
				end
				return Fn
			end

			function S:NewColorPicker(n,tip,dc,cb) n=n or "Color";dc=dc or Color3.new(1,1,1);cb=cb or function()end
				local h,s,v = Color3.toHSV(dc); local cpO = false
				local wrap = mk("Frame",{Parent=inner,BackgroundTransparency=1,Size=UDim2.new(1,0,0,22),ClipsDescendants=true,BorderSizePixel=0,ZIndex=5})

				local head = mk("Frame",{Parent=wrap,BackgroundTransparency=1,Size=UDim2.new(1,0,0,22),BorderSizePixel=0,ZIndex=5})
				mk("TextLabel",{Parent=head,BackgroundTransparency=1,Size=UDim2.new(1,-30,1,0),Font=Enum.Font.SourceSans,Text=n,TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6})
				local pre = mk("Frame",{Parent=head,BackgroundColor3=dc,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Size=UDim2.fromOffset(24,14),BorderSizePixel=0,ZIndex=6})
				fieldBorder(pre,7)

				local hi = mk("ImageButton",{Parent=wrap,BackgroundTransparency=1,Position=UDim2.fromOffset(4,26),Size=UDim2.new(0.55,0,0,70),Image="rbxassetid://6523286724",ZIndex=6})
				local hc = mk("Frame",{Parent=hi,Size=UDim2.fromOffset(8,8),BackgroundColor3=W.Dk,BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0.5),ZIndex=7})
				local vi = mk("ImageButton",{Parent=wrap,BackgroundTransparency=1,Position=UDim2.new(0.58,4,0,26),Size=UDim2.fromOffset(14,70),Image="rbxassetid://6523291212",ZIndex=6})
				local vc = mk("Frame",{Parent=vi,Size=UDim2.fromOffset(14,4),BackgroundColor3=W.Dk,BorderSizePixel=0,AnchorPoint=Vector2.new(0.5,0),ZIndex=7})

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

				local headHit = mk("TextButton",{Parent=head,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Text="",BorderSizePixel=0,ZIndex=9})
				headHit.MouseButton1Click:Connect(function()
					cpO = not cpO
					wrap.Size = UDim2.new(1,0,0, cpO and 100 or 22)
				end)
			end

			function S:NewLabel(txt)
				local l = mk("TextLabel",{Parent=inner,BackgroundTransparency=1,Size=UDim2.new(1,0,0,16),Font=Enum.Font.SourceSans,Text=txt or "",RichText=true,TextColor3=W.Tx,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,ZIndex=6})
				local Fn={}; function Fn:UpdateLabel(t) l.Text=t end; return Fn
			end

			return S
		end
		return Tab
	end
	return Lib
end

return Kavo
