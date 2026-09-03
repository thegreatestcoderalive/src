# Flux UI Library

Modern, performant Roblox UI library — monochromatic themes, event-driven, zero polling.

## Quick Start

```lua
local Flux = loadstring(game:HttpGet("YOUR_RAW_URL"))()

local lib = Flux.new({ Title = "My Hub", Theme = "Obsidian", ToggleKey = Enum.KeyCode.RightShift })
local tab = lib:Tab("Main")
local section = tab:Section("Tools")

section:Button({ Name = "Click Me", Callback = function() print("clicked") end })
section:Toggle({ Name = "ESP", Callback = function(v) print(v) end })
section:Slider({ Name = "Speed", Min = 16, Max = 100, Default = 16, Callback = function(v) end })
section:Dropdown({ Name = "Team", Items = {"Red","Blue"}, Callback = function(v) end })
```

## Themes

Obsidian · Carbon · Slate · Graphite · Ash · Silver · Ivory · Onyx

## Elements

Button · Toggle · Slider · TextBox · Dropdown · Keybind · ColorPicker · Label · Separator · Paragraph
