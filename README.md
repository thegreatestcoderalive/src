# Kavo Library

### Kavo UI Library by xHeptc u fucktards (EDITED BY imonfent on discord)

Documentation

### Update: <a href="#update" id="update"></a>

All of the latest updates can be found in here.

Added: Section Update Functions&#x20;

New Themes: Serpent, Aurora, Cyberpunk, Sunset, Forest, Candy, Royal, Neon, Desert, Ice, Matrix, Halloween, Pastel, Space.

New Component: Label

Rich Text Support For: UI Title, Sections, And Other Elements (exc tabs)

### Getting Updated Loadstring <a href="#getting-loadstring" id="getting-loadstring"></a>

```
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/undetected-ddl-service/Kavo-UI-Library-UPDATED-WITH-MORE-FUNCTIONS-/refs/heads/main/source.lua"))()
```

### Creating UI Library Window <a href="#creating-ui-library-window" id="creating-ui-library-window"></a>

```
local Window = Library.CreateLib("TITLE", "DarkTheme")
```

Themes: LightTheme, DarkTheme, GrapeTheme, BloodTheme, Ocean, Midnight, Sentinel, Synapse, Serpent, Aurora, Cyberpunk, Sunset, Forest, Candy, Royal, Neon, Desert, Ice, Matrix, Halloween, Pastel, Space.

### Creating Tabs <a href="#creating-tabs" id="creating-tabs"></a>

```
local Tab = Window:NewTab("TabName")
```

### Creating Section <a href="#creating-section" id="creating-section"></a>

```
local Section = Tab:NewSection("Section Name")
```

### Update Section <a href="#update-section" id="update-section"></a>

```
Section:UpdateSection("Section New Title")
```

### Creating Labels <a href="#creating-labels" id="creating-labels"></a>

```
Section:NewLabel("LabelText")
```

### Update Label <a href="#update-label" id="update-label"></a>

```
label:UpdateLabel("New Text")
```

### Creating Buttons <a href="#creating-buttons" id="creating-buttons"></a>

```
Section:NewButton("ButtonText", "ButtonInfo", function()
    print("Clicked")
end)
```

### Update Button <a href="#update-button" id="update-button"></a>

Make sure your button is local when updating it.

```
button:UpdateButton("New Text")
```

### Creating Toggles <a href="#creating-toggles" id="creating-toggles"></a>

```
Section:NewToggle("ToggleText", "ToggleInfo", function(state)
    if state then
        print("Toggle On")
    else
        print("Toggle Off")
    end
end)
```

### Updating Toggles <a href="#updating-toggles" id="updating-toggles"></a>

```
getgenv().Toggled = false

local toggle = Section:NewToggle("Toggle", "Info", function(state)
    getgenv().Toggled = state
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if getgenv().Toggled then
		toggle:UpdateToggle("Toggle On")
	else
		toggle:UpdateToggle("Toggle Off")
	end
end)
```

### Creating Sliders <a href="#creating-sliders" id="creating-sliders"></a>

```
Section:NewSlider("SliderText", "SliderInfo", 500, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)
```

### Creating Textboxes <a href="#creating-textboxes" id="creating-textboxes"></a>

```
Section:NewTextBox("TextboxText", "TextboxInfo", function(txt)
	print(txt)
end)
```

### Creating Keybinds <a href="#creating-keybinds" id="creating-keybinds"></a>

```
Section:NewKeybind("KeybindText", "KeybindInfo", Enum.KeyCode.F, function()
	print("You just clicked the bind")
end)
```

### Toggling UI with Keybinds <a href="#toggling-ui-with-keybinds" id="toggling-ui-with-keybinds"></a>

```
Section:NewKeybind("KeybindText", "KeybindInfo", Enum.KeyCode.F, function()
	Library:ToggleUI()
end)
```

### Creating Dropdowns <a href="#creating-dropdowns" id="creating-dropdowns"></a>

```
Section:NewDropdown("DropdownText", "DropdownInf", {"Option 1", "Option 2", "Option 3"}, function(currentOption)
    print(currentOption)
end)
```

### Dropdown Refresh <a href="#dropdown-refresh" id="dropdown-refresh"></a>

```
local oldList = {
  "2019",
  "2020"
}
local newList = {
  "2021",
  "2022"
}
local dropdown = Section:NewDropdown("Dropdown","Info", oldList, function()

end)
Section:NewButton("Update Dropdown", "Refreshes Dropdown", function()
  dropdown:Refresh(newList)
end)
```

### Creating Color Pickers <a href="#creating-color-pickers" id="creating-color-pickers"></a>

```
Section:NewColorPicker("Color Text", "Color Info", Color3.fromRGB(0,0,0), function(color)
    print(color)
    -- Second argument is the default color
end)
```

Make new table, here you are going to put your colors, as shown below.

### Applying Custom Themes / Colors <a href="#creating-color-pickers" id="creating-color-pickers"></a>

```
local colors = {
    SchemeColor = Color3.fromRGB(0,255,255),
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255,255,255),
    ElementColor = Color3.fromRGB(20, 20, 20)
}
```

Applying it: Change your window code little bit.

```
local Window = Library.CreateLib("TITLE", colors)
```

### Want to add fully customizable UI? <a href="#want-to-add-fully-customizable-ui" id="want-to-add-fully-customizable-ui"></a>

Add this code in your section. This will create color pickers.

Make sure you have added table with all the values of UI. then apply it to window. Like shown above.

```
for theme, color in pairs(themes) do
    Section:NewColorPicker(theme, "Change your "..theme, color, function(color3)
        Library:ChangeColor(theme, color3)
    end)
end
```

Last updated: (9:42 PM) (7/2/2025)
