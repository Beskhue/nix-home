local Color, colors, Group, groups, styles = require('colorbuddy').setup()

vim.api.nvim_command("hi! clear")

Color.new('background',          '#e8e8e8')
Color.new('darkbackground',      '#d8d8d8')
Color.new('verydarkbackground',  '#c8c8c8')
Color.new('highlightbackground', '#bcc1d1')

Color.new('foreground',    '#2a2a2a')
Color.new('black',         '#111111')
Color.new('grey',          '#606060')
Color.new('lightgrey',     '#808080')
Color.new('verylightgrey', '#a0a0a0')
Color.new('white',         '#e8e8e8')

Color.new('darkred',       '#660000')
Color.new('red',           '#cd3131')
Color.new('orange',        '#c76040')
Color.new('verylightblue', '#a3c0cc')
Color.new('lightblue',     '#4a67c5')
Color.new('blue',          '#1e7094')
Color.new('darkblue',      '#2e5e73')
Color.new('paledarkblue',  '#62737a')
Color.new('pink',          '#b3247e')
Color.new('darkpink',      '#941e69')
Color.new('purple',        '#7a409c')
Color.new('lightpurple',   '#9248bd')
Color.new('yellow',        '#786a00')
Color.new('lightgreen',    '#38cf27')
Color.new('green',         '#26701e')

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
