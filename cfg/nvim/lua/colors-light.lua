local Color, colors, Group, groups, styles = require('colorbuddy').setup()

vim.api.nvim_command("hi! clear")

local background =         '#e8e8e8'
local darkbackground =     '#d8d8d8'
local verydarkbackground = '#c8c8c8'
local highlightbackground ='#bcc1d1'

local foreground =   '#2a2a2a'
local black =        '#111111'
local grey =         '#606060'
local lightgrey =    '#808080'
local verylightgrey ='#a0a0a0'
local white =        '#e8e8e8'

local darkred =      '#660000'
local red =          '#cd3131'
local orange =       '#c76040'
local verylightblue ='#a3c0cc'
local lightblue =    '#4a67c5'
local blue =         '#1e7094'
local darkblue =     '#2e5e73'
local paledarkblue = '#62737a'
local pink =         '#b3247e'
local darkpink =     '#941e69'
local purple =       '#7a409c'
local lightpurple =  '#9248bd'
local yellow =       '#786a00'
local lightgreen =   '#38cf27'
local green =        '#26701e'

local function rgbFromString(str)
    local r = tonumber(string.sub(str, 2, 3), 16) / 255
    local g = tonumber(string.sub(str, 4, 5), 16) / 255
    local b = tonumber(string.sub(str, 6, 7), 16) / 255
    return r, g, b
end

local function rgbToString(r, g, b)
    return string.format(
        "#%02X%02X%02X",
        math.floor(r * 255 + 0.5),
        math.floor(g * 255 + 0.5),
        math.floor(b * 255 + 0.5)
    )
end

-- Adapted from https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
function rgbToHsl(r, g, b)
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, l

  l = (max + min) / 2

  if max == min then
    h, s = 0, 0 -- achromatic
  else
    local d = max - min
    if l > 0.5 then s = d / (2 - max - min) else s = d / (max + min) end
    if max == r then
      h = (g - b) / d
      if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, l
end

-- Adapted from https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
function hslToRgb(h, s, l)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    function hue2rgb(p, q, t)
      if t < 0   then t = t + 1 end
      if t > 1   then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end

    local q
    if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end

  return r, g, b
end

local function invert(str)
    local r, g, b = rgbFromString(str)
    local h, s, l = rgbToHsl(r, g, b)
    r, g, b = hslToRgb(h, s, 1.0 - l)
    return rgbToString(r, g, b)
end

if vim.o.background == "dark" then
    Color.new('background',          invert(background))
    Color.new('darkbackground',      invert(darkbackground))
    Color.new('verydarkbackground',  invert(verydarkbackground))
    Color.new('highlightbackground', invert(highlightbackground))

    Color.new('foreground',    invert(foreground))
    Color.new('black',         invert(black))
    Color.new('grey',          invert(grey))
    Color.new('lightgrey',     invert(lightgrey))
    Color.new('verylightgrey', invert(verylightgrey))
    Color.new('white',         invert(white))

    Color.new('darkred',       invert(darkred))
    Color.new('red',           invert(red))
    Color.new('orange',        invert(orange))
    Color.new('verylightblue', invert(verylightblue))
    Color.new('lightblue',     invert(lightblue))
    Color.new('blue',          invert(blue))
    Color.new('darkblue',      invert(darkblue))
    Color.new('paledarkblue',  invert(paledarkblue))
    Color.new('pink',          invert(pink))
    Color.new('darkpink',      invert(darkpink))
    Color.new('purple',        invert(purple))
    Color.new('lightpurple',   invert(lightpurple))
    Color.new('yellow',        invert(yellow))
    Color.new('lightgreen',    invert(lightgreen))
    Color.new('green',         invert(green))
else
    Color.new('background',          background)
    Color.new('darkbackground',      darkbackground)
    Color.new('verydarkbackground',  verydarkbackground)
    Color.new('highlightbackground', highlightbackground)

    Color.new('foreground',    foreground)
    Color.new('black',         black)
    Color.new('grey',          grey)
    Color.new('lightgrey',     lightgrey)
    Color.new('verylightgrey', verylightgrey)
    Color.new('white',         white)

    Color.new('darkred',       darkred)
    Color.new('red',           red)
    Color.new('orange',        orange)
    Color.new('verylightblue', verylightblue)
    Color.new('lightblue',     lightblue)
    Color.new('blue',          blue)
    Color.new('darkblue',      darkblue)
    Color.new('paledarkblue',  paledarkblue)
    Color.new('pink',          pink)
    Color.new('darkpink',      darkpink)
    Color.new('purple',        purple)
    Color.new('lightpurple',   lightpurple)
    Color.new('yellow',        yellow)
    Color.new('lightgreen',    lightgreen)
    Color.new('green',         green)
end

Group.new('Normal',      colors.foreground, colors.background)
Group.new('Comment',     colors.lightgrey)
Group.new('Operator',    colors.grey)
Group.new('Delimiter',   colors.grey)
Group.new('MatchParen',  nil, colors.highlightbackground)
Group.new('Keyword',     colors.lightpurple)
Group.new('Conditional', colors.purple, nil, styles.bold)
Group.new('Repeat',      groups.Conditional)
Group.new('Statement',   groups.Conditional)
Group.new('Variable',    groups.Normal)
Group.new('Function',    colors.lightblue, nil, nil)
Group.new('Type',        colors.pink, nil, styles.bold)
Group.new('Define',      groups.Type)
Group.new('Include',     colors.darkpink, nil, nil)
Group.new('Identifier',  colors.darkblue)
Group.new('Label',       groups.Identifier)
Group.new('Constant',    colors.blue)
Group.new('Number',      colors.orange)
Group.new('Float',       groups.Number)
Group.new('String',      groups.Constant)
Group.new('Character',   groups.Constant)
Group.new('Boolean',     groups.Conditional)
Group.new('Exception',   colors.darkred, nil, styles.bold)

Group.new('Special',   colors.yellow)
Group.new('PreProc',   colors.yellow)

Group.new('Error',     colors.red, nil, styles.bold)
Group.new('ErrorMsg',  groups.Error)
Group.new('Warning',   colors.orange, nil, styles.bold)
Group.new('WarningMsg', groups.Warning)

-- Vim coloring:
Group.new('Cursor',  colors.background, colors.darkblue)
Group.new('iCursor',                    groups.Cursor, groups.Cursor)
Group.new('vCursor',                    groups.Cursor, groups.Cursor)
Group.new('cCursor',                    groups.Cursor, groups.Cursor)
Group.new('iCursor',                    groups.Cursor, groups.Cursor)
Group.new('TermCursor',                 groups.Cursor, groups.Cursor)
Group.new('VitalOverCommandLineCursor', groups.Cursor, groups.Cursor)

Group.new('Visual',  colors.background, colors.darkblue)

Group.new('SpecialKey', colors.lightblue, nil, styles.italic)

Group.new('CursorColumn', colors.none, colors.highlightbackground)
Group.new('CursorLine',  groups.CursorColumn)
Group.new('Warnings', colors.orange, nil, styles.bold)

Group.new('SignColumn',   colors.lightgrey,  colors.darkbackground)
Group.new('LineNr',       groups.SignColumn, groups.SignColumn)
Group.new('CursorLineNr', colors.blue,       colors.background, styles.bold)

Group.new('FoldColumn',   colors.foreground, groups.SignColumn)

Group.new('Folded', colors.foreground, colors.verydarkbackground)

Group.new('StatusLine',   colors.background,          colors.darkblue)
Group.new('StatusLineNC', colors.highlightbackground, colors.paledarkblue)

Group.new('VertSplit', colors.highlightbackground, colors.background)

Group.new('Search',     colors.black, colors.verylightblue, styles.bold)
Group.new('Substitute', colors.black, colors.blue,          styles.bold)

Group.new('Directory', groups.Include)

Group.new('Title', colors.purple)
Group.new('Question', colors.green)
Group.new('MoreMsg', groups.Question)

Group.new('Pmenu', colors.foreground, colors.verydarkbackground)
Group.new('NormalFloat', colors.foreground, colors.verydarkbackground)

-- Some plugin coloring:
Group.new('TSVariableBuiltin', groups.Constant)

Group.new("LSPDiagnosticsDefaultHint", groups.Comment)
Group.new("LSPDiagnosticsDefaultInformation", groups.Normal)
Group.new("LSPDiagnosticsDefaultWarning", groups.Warning)
Group.new("LSPDiagnosticsDefaultError", groups.Error)

Group.new("EasyMotionTarget", colors.red, nil, styles.bold)
Group.new("EasyMotionIncSearch", colors.blue, nil, styles.bold)
Group.new("EasyMotionShade", colors.verylightgrey)

Group.new("MinimapBase",      colors.verylightgrey)
Group.new("Minimap", colors.foreground)

-- Group.new('Tag',            colors.nord_4,       colors.none,    styles.NONE)
-- Group.new('Todo',           colors.nord_13,      colors.none,    styles.NONE)
