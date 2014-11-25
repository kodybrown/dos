
:setdatevars
    :: Sets global variables to the current date (mm, dd, yy) -- `yy` actually outputs `yyyy`
    set "mm=" && set "dd=" && set "yy="
    for /f "tokens=1-3 delims=/.- " %%A in ("%date:* =%") do (
        set "mm=%%A" && set "dd=%%B" && set "yy=%%C"
        goto :eof
    )
    goto :eof
