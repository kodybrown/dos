
:settimevars
    :: Sets global variables to the current time (hh, nn, ss, ii)
    set "hh=" && set "nn=" && set "ss=" && set "ii="
    for /f "tokens=1-4 delims=:. " %%A in ("%time: =0%") do (
        set "hh=%%A" && set "nn=%%B" && set "ss=%%C" && set "ii=%%D"
        goto :eof
    )
    goto :eof
