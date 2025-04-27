Config { font = "Terminus"
        , fgColor  = "#a59c63"
        , position = TopW L 100
        , commands = [ Run Com "uname" ["-s","-r"] "" 36000
                     , Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
                     , Run Com "sh" ["-c", "hostname"] "host" 36000
                     , Run XMonadLog
                     ]
        , sepChar = "%"
        , alignSep = "}{"
        , template = "<fc=#a59c63>%XMonadLog%</fc>}{<fc=#8da563>%host%</fc> | <fc=#63a5a2>%uname%</fc> | <fc=#a59c63>%date%</fc>"
        }
