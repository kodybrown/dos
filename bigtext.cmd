@setlocal
@echo off

if [%1] NEQ [] goto s_start

:: Originally from http://ss64.com/nt/bigtext.cmd.txt
:: Updated by @wasatchwizard (Sep 2013)

echo   Syntax
echo       BIGTEXT string
echo           Where string is the text or numbers to be displayed
echo.
goto :eof

:s_start
    set _length=0
    set _sentence=%*

    rem Get the length of the sentence
    set _substring=%_sentence%

    :s_loop
        if not defined _substring goto :s_result
        rem remove the first char from _substring (until it is null)
        set _substring=%_substring:~1%
        set /a _length+=1
        goto s_loop

:s_result
    set /A _length-=1

    rem Truncate text to fit the window size
    rem assuming average char is 6 digits wide
    for /f "tokens=2" %%G in ('mode ^|find "Columns"') do set /a _window=%%G/6
    if %_length% GTR %_window% set _length=%_window%

    rem Step through each digit of the sentence and store in a set of variables
    for /L %%G in (0,1,%_length%) do call :s_build %%G

    rem Now Echo all the variables
    echo.%_1%
    echo.%_2%
    echo.%_3%
    echo.%_4%
    echo.%_5%
    echo.%_6%
    echo.%_7%
    echo.%_8%
    goto :eof

:s_build
    rem Get the next character
    call set _digit=%%_sentence:~%1,1%%%

    rem Add the graphics for this digit to the variables
    if "%_digit%"==" " (
        call :s_space
    ) else if "%_digit%"=="," (
        call :s_comma
    ) else if "%_digit%"=="a" ( call :s_al
    ) else if "%_digit%"=="b" ( call :s_bl
    ) else if "%_digit%"=="c" ( call :s_cl
    ) else if "%_digit%"=="d" ( call :s_dl
    ) else if "%_digit%"=="e" ( call :s_el
    ) else if "%_digit%"=="f" ( call :s_fl
    ) else if "%_digit%"=="g" ( call :s_gl
    ) else if "%_digit%"=="h" ( call :s_hl
    ) else if "%_digit%"=="i" ( call :s_il
    ) else if "%_digit%"=="j" ( call :s_jl
    ) else if "%_digit%"=="k" ( call :s_kl
    ) else if "%_digit%"=="l" ( call :s_ll
    ) else if "%_digit%"=="m" ( call :s_ml
    ) else if "%_digit%"=="n" ( call :s_nl
    ) else if "%_digit%"=="o" ( call :s_ol
    ) else if "%_digit%"=="p" ( call :s_pl
    ) else if "%_digit%"=="q" ( call :s_ql
    ) else if "%_digit%"=="r" ( call :s_rl
    ) else if "%_digit%"=="s" ( call :s_sl
    ) else if "%_digit%"=="t" ( call :s_tl
    ) else if "%_digit%"=="u" ( call :s_ul
    ) else if "%_digit%"=="v" ( call :s_vl
    ) else if "%_digit%"=="w" ( call :s_wl
    ) else if "%_digit%"=="x" ( call :s_xl
    ) else if "%_digit%"=="y" ( call :s_yl
    ) else if "%_digit%"=="z" ( call :s_zl
    ) else (
        call :s_%_digit%
    )
    goto :eof

:s_0
    (set _1=%_1%  ## )
    (set _2=%_2% #  #)
    (set _3=%_3% #  #)
    (set _4=%_4% #  #)
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7%  ## )
    (set _8=%_8%     )
    goto :eof

:s_1
    (set _1=%_1%  ## )
    (set _2=%_2%   # )
    (set _3=%_3%   # )
    (set _4=%_4%   # )
    (set _5=%_5%   # )
    (set _6=%_6%   # )
    (set _7=%_7% ####)
    (set _8=%_8%     )
    goto :eof

:s_2
    (set _1=%_1%  ## )
    (set _2=%_2% #  #)
    (set _3=%_3%    #)
    (set _4=%_4%   # )
    (set _5=%_5%  #  )
    (set _6=%_6% #  #)
    (set _7=%_7% ####)
    (set _8=%_8%     )
    goto :eof

:s_3
    (set _1=%_1% ####)
    (set _2=%_2%   # )
    (set _3=%_3%  ## )
    (set _4=%_4%    #)
    (set _5=%_5%    #)
    (set _6=%_6%    #)
    (set _7=%_7% ### )
    (set _8=%_8%     )
    goto :eof

:s_4
    (set _1=%_1% #   )
    (set _2=%_2% # # )
    (set _3=%_3% # # )
    (set _4=%_4% ####)
    (set _5=%_5%   # )
    (set _6=%_6%   # )
    (set _7=%_7%   # )
    (set _8=%_8%     )
    goto :eof

:s_5
    (set _1=%_1% ####)
    (set _2=%_2% #   )
    (set _3=%_3% ### )
    (set _4=%_4%    #)
    (set _5=%_5%    #)
    (set _6=%_6% #  #)
    (set _7=%_7%  ## )
    (set _8=%_8%     )
    goto :eof

:s_6
    (set _1=%_1%  ## )
    (set _2=%_2% #   )
    (set _3=%_3% #   )
    (set _4=%_4% ### )
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7%  ## )
    (set _8=%_8%     )
    goto :eof

:s_7
    (set _1=%_1% ####)
    (set _2=%_2% #  #)
    (set _3=%_3%    #)
    (set _4=%_4%   # )
    (set _5=%_5%  #  )
    (set _6=%_6%  #  )
    (set _7=%_7%  #  )
    (set _8=%_8%     )
    goto :eof

:s_8
    (set _1=%_1%  ## )
    (set _2=%_2% #  #)
    (set _3=%_3% #  #)
    (set _4=%_4%  ## )
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7%  ## )
    (set _8=%_8%     )
    goto :eof

:s_9
    (set _1=%_1%  ## )
    (set _2=%_2% #  #)
    (set _3=%_3% #  #)
    (set _4=%_4%  ###)
    (set _5=%_5%    #)
    (set _6=%_6%    #)
    (set _7=%_7%  ## )
    (set _8=%_8%     )
    goto :eof

:s_-
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4% ####)
    (set _5=%_5%     )
    (set _6=%_6%     )
    (set _7=%_7%     )
    (set _8=%_8%     )
    goto :eof

:s_al
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4%  ###)
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7%  ###)
    (set _8=%_8%     )
    goto :eof

:s_a
    (set _1=%_1%  ## )
    (set _2=%_2% #  #)
    (set _3=%_3% #  #)
    (set _4=%_4% ####)
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7% #  #)
    (set _8=%_8%     )
    goto :eof

:s_bl
    (set _1=%_1% #   )
    (set _2=%_2% #   )
    (set _3=%_3% #   )
    (set _4=%_4% ### )
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7% ### )
    (set _8=%_8%     )
    goto :eof

:s_b
    (set _1=%_1% ### )
    (set _2=%_2% #  #)
    (set _3=%_3% #  #)
    (set _4=%_4% ####)
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7% ### )
    (set _8=%_8%     )
    goto :eof

:s_cl
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4%  ###)
    (set _5=%_5% #   )
    (set _6=%_6% #   )
    (set _7=%_7%  ###)
    (set _8=%_8%     )
    goto :eof

:s_c
    (set _1=%_1%  ## )
    (set _2=%_2% #  #)
    (set _3=%_3% #   )
    (set _4=%_4% #   )
    (set _5=%_5% #   )
    (set _6=%_6% #  #)
    (set _7=%_7%  ## )
    (set _8=%_8%     )
    goto :eof

:s_dl
    (set _1=%_1%    #)
    (set _2=%_2%    #)
    (set _3=%_3%    #)
    (set _4=%_4%  ###)
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7%  ###)
    (set _8=%_8%     )
    goto :eof

:s_d
    (set _1=%_1% ### )
    (set _2=%_2% #  #)
    (set _3=%_3% #  #)
    (set _4=%_4% #  #)
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7% ### )
    (set _8=%_8%     )
    goto :eof

:s_el
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4%  ## )
    (set _5=%_5% ####)
    (set _6=%_6% #   )
    (set _7=%_7%  ## )
    (set _8=%_8%     )
    goto :eof

:s_e
    (set _1=%_1% ####)
    (set _2=%_2% #   )
    (set _3=%_3% #   )
    (set _4=%_4% ### )
    (set _5=%_5% #   )
    (set _6=%_6% #   )
    (set _7=%_7% ####)
    (set _8=%_8%     )
    goto :eof

:s_fl
    (set _1=%_1%   ##)
    (set _2=%_2%  #  )
    (set _3=%_3%  #  )
    (set _4=%_4% ### )
    (set _5=%_5%  #  )
    (set _6=%_6%  #  )
    (set _7=%_7%  #  )
    (set _8=%_8%     )
    goto :eof

:s_f
    (set _1=%_1% ####)
    (set _2=%_2% #   )
    (set _3=%_3% #   )
    (set _4=%_4% ### )
    (set _5=%_5% #   )
    (set _6=%_6% #   )
    (set _7=%_7% #   )
    (set _8=%_8%     )
    goto :eof

:s_gl
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4%  ## )
    (set _5=%_5% #  #)
    (set _6=%_6%  ###)
    (set _7=%_7%    #)
    (set _8=%_8%#### )
    goto :eof

:s_g
    (set _1=%_1%  ## )
    (set _2=%_2% #  #)
    (set _3=%_3% #   )
    (set _4=%_4% #   )
    (set _5=%_5% # ##)
    (set _6=%_6% #  #)
    (set _7=%_7%  ## )
    (set _8=%_8%     )
    goto :eof

:s_hl
    (set _1=%_1% #   )
    (set _2=%_2% #   )
    (set _3=%_3% #   )
    (set _4=%_4% ### )
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7% #  #)
    (set _8=%_8%     )
    goto :eof

:s_h
    (set _1=%_1% #  #)
    (set _2=%_2% #  #)
    (set _3=%_3% #  #)
    (set _4=%_4% ####)
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7% #  #)
    (set _8=%_8%     )
    goto :eof

:s_il
    (set _1=%_1%  )
    (set _2=%_2% #)
    (set _3=%_3%  )
    (set _4=%_4% #)
    (set _5=%_5% #)
    (set _6=%_6% #)
    (set _7=%_7% #)
    (set _8=%_8%  )
    goto :eof

:s_i
    (set _1=%_1% ###)
    (set _2=%_2%  # )
    (set _3=%_3%  # )
    (set _4=%_4%  # )
    (set _5=%_5%  # )
    (set _6=%_6%  # )
    (set _7=%_7% ###)
    (set _8=%_8%    )
    goto :eof

:s_jl
    (set _1=%_1%  )
    (set _2=%_2% #)
    (set _3=%_3%  )
    (set _4=%_4% #)
    (set _5=%_5% #)
    (set _6=%_6% #)
    (set _7=%_7% #)
    (set _8=%_8%# )
    goto :eof

:s_j
    (set _1=%_1% ####)
    (set _2=%_2%   # )
    (set _3=%_3%   # )
    (set _4=%_4%   # )
    (set _5=%_5%   # )
    (set _6=%_6%   # )
    (set _7=%_7% ##  )
    (set _8=%_8%     )
    goto :eof

:s_kl
    (set _1=%_1% #   )
    (set _2=%_2% #   )
    (set _3=%_3% #   )
    (set _4=%_4% # # )
    (set _5=%_5% ##  )
    (set _6=%_6% # # )
    (set _7=%_7% #  #)
    (set _8=%_8%     )
    goto :eof

:s_k
    (set _1=%_1% #   )
    (set _2=%_2% #  #)
    (set _3=%_3% # # )
    (set _4=%_4% ##  )
    (set _5=%_5% ##  )
    (set _6=%_6% # # )
    (set _7=%_7% #  #)
    (set _8=%_8%     )
    goto :eof

:s_ll

    (set _1=%_1% # )
    (set _2=%_2% # )
    (set _3=%_3% # )
    (set _4=%_4% # )
    (set _5=%_5% # )
    (set _6=%_6% # )
    (set _7=%_7% ##)
    (set _8=%_8%   )
    goto :eof

:s_l

    (set _1=%_1% #   )
    (set _2=%_2% #   )
    (set _3=%_3% #   )
    (set _4=%_4% #   )
    (set _5=%_5% #   )
    (set _6=%_6% #   )
    (set _7=%_7% ####)
    (set _8=%_8%     )
    goto :eof

:s_ml
    (set _1=%_1%        )
    (set _2=%_2%        )
    (set _3=%_3%        )
    (set _4=%_4% ### ## )
    (set _5=%_5% #  #  #)
    (set _6=%_6% #  #  #)
    (set _7=%_7% #  #  #)
    (set _8=%_8%        )
    goto :eof

:s_m
    (set _1=%_1% #   #)
    (set _2=%_2% ## ##)
    (set _3=%_3% # # #)
    (set _4=%_4% # # #)
    (set _5=%_5% #   #)
    (set _6=%_6% #   #)
    (set _7=%_7% #   #)
    (set _8=%_8%      )
    goto :eof

:s_nl
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4% ### )
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7% #  #)
    (set _8=%_8%     )
    goto :eof

:s_n
    (set _1=%_1% #   #)
    (set _2=%_2% ##  #)
    (set _3=%_3% ##  #)
    (set _4=%_4% # # #)
    (set _5=%_5% #  ##)
    (set _6=%_6% #  ##)
    (set _7=%_7% #   #)
    (set _8=%_8%      )
    goto :eof

:s_ol
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4%  ## )
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7%  ## )
    (set _8=%_8%     )
    goto :eof

:s_o
    (set _1=%_1%  ## )
    (set _2=%_2% #  #)
    (set _3=%_3% #  #)
    (set _4=%_4% #  #)
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7%  ## )
    (set _8=%_8%     )
    goto :eof

:s_pl
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4% ### )
    (set _5=%_5% #  #)
    (set _6=%_6% ### )
    (set _7=%_7% #   )
    (set _8=%_8% #   )
    goto :eof

:s_p
    (set _1=%_1% ### )
    (set _2=%_2% #  #)
    (set _3=%_3% #  #)
    (set _4=%_4% ### )
    (set _5=%_5% #   )
    (set _6=%_6% #   )
    (set _7=%_7% #   )
    (set _8=%_8%     )
    goto :eof

:s_ql
    (set _1=%_1%      )
    (set _2=%_2%      )
    (set _3=%_3%      )
    (set _4=%_4%  ### )
    (set _5=%_5% #  # )
    (set _6=%_6%  ### )
    (set _7=%_7%    # )
    (set _8=%_8%    ##)
    goto :eof

:s_q
    (set _1=%_1%  ## )
    (set _2=%_2% #  #)
    (set _3=%_3% #  #)
    (set _4=%_4% #  #)
    (set _5=%_5% #  #)
    (set _6=%_6% # ##)
    (set _7=%_7%  # #)
    (set _8=%_8%     )
    goto :eof

:s_rl
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4% ### )
    (set _5=%_5% #  #)
    (set _6=%_6% #   )
    (set _7=%_7% #   )
    (set _8=%_8%     )
    goto :eof

:s_r
    (set _1=%_1% ### )
    (set _2=%_2% #  #)
    (set _3=%_3% #  #)
    (set _4=%_4% ### )
    (set _5=%_5% # # )
    (set _6=%_6% #  #)
    (set _7=%_7% #  #)
    (set _8=%_8%     )
    goto :eof

:s_sl
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4%  ###)
    (set _5=%_5%  #  )
    (set _6=%_6%   # )
    (set _7=%_7% ### )
    (set _8=%_8%     )
    goto :eof

:s_s
    (set _1=%_1%  ###)
    (set _2=%_2% #   )
    (set _3=%_3% #   )
    (set _4=%_4%  ## )
    (set _5=%_5%    #)
    (set _6=%_6%    #)
    (set _7=%_7% ### )
    (set _8=%_8%     )
    goto :eof

:s_tl
    (set _1=%_1%    )
    (set _2=%_2%  # )
    (set _3=%_3%  # )
    (set _4=%_4% ###)
    (set _5=%_5%  # )
    (set _6=%_6%  # )
    (set _7=%_7%  # )
    (set _8=%_8%    )
    goto :eof

:s_t
    (set _1=%_1% #####)
    (set _2=%_2%   #  )
    (set _3=%_3%   #  )
    (set _4=%_4%   #  )
    (set _5=%_5%   #  )
    (set _6=%_6%   #  )
    (set _7=%_7%   #  )
    (set _8=%_8%      )
    goto :eof

:s_ul
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4% #  #)
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7%  ###)
    (set _8=%_8%     )
    goto :eof

:s_u
    (set _1=%_1% #  #)
    (set _2=%_2% #  #)
    (set _3=%_3% #  #)
    (set _4=%_4% #  #)
    (set _5=%_5% #  #)
    (set _6=%_6% #  #)
    (set _7=%_7%  ## )
    (set _8=%_8%     )
    goto :eof

:s_vl2
    (set _1=%_1%      )
    (set _2=%_2%      )
    (set _3=%_3%      )
    (set _4=%_4% #  # )
    (set _5=%_5% #  # )
    (set _6=%_6%  # # )
    (set _7=%_7%   ## )
    (set _8=%_8%      )
    goto :eof

:s_vl
    (set _1=%_1%      )
    (set _2=%_2%      )
    (set _3=%_3%      )
    (set _4=%_4% #   #)
    (set _5=%_5% #   #)
    (set _6=%_6%  # # )
    (set _7=%_7%   #  )
    (set _8=%_8%      )
    goto :eof

:s_v
    (set _1=%_1% #   #)
    (set _2=%_2% #   #)
    (set _3=%_3% #   #)
    (set _4=%_4% #   #)
    (set _5=%_5% #   #)
    (set _6=%_6%  # # )
    (set _7=%_7%   #  )
    (set _8=%_8%      )
    goto :eof

:s_wl
    (set _1=%_1%        )
    (set _2=%_2%        )
    (set _3=%_3%        )
    (set _4=%_4% #  #  #)
    (set _5=%_5% #  #  #)
    (set _6=%_6% #  #  #)
    (set _7=%_7%  ## ## )
    (set _8=%_8%        )
    goto :eof

:s_w
    (set _1=%_1% #  #  #)
    (set _2=%_2% #  #  #)
    (set _3=%_3% #  #  #)
    (set _4=%_4% #  #  #)
    (set _5=%_5% #  #  #)
    (set _6=%_6% #  #  #)
    (set _7=%_7%  ## ## )
    (set _8=%_8%        )
    goto :eof

:s_xl
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4% #  #)
    (set _5=%_5%  ## )
    (set _6=%_6%  ## )
    (set _7=%_7% #  #)
    (set _8=%_8%     )
    goto :eof

:s_x
    (set _1=%_1%      )
    (set _2=%_2% #   #)
    (set _3=%_3%  # # )
    (set _4=%_4%   #  )
    (set _5=%_5%   #  )
    (set _6=%_6%  # # )
    (set _7=%_7% #   #)
    (set _8=%_8%      )
    goto :eof

:s_yl
    (set _1=%_1%      )
    (set _2=%_2%      )
    (set _3=%_3%      )
    (set _4=%_4% #  # )
    (set _5=%_5% #  # )
    (set _6=%_6%  ### )
    (set _7=%_7%    # )
    (set _8=%_8%####  )
    goto :eof

:s_y
    (set _1=%_1% #   #)
    (set _2=%_2%  # # )
    (set _3=%_3%   #  )
    (set _4=%_4%   #  )
    (set _5=%_5%   #  )
    (set _6=%_6%   #  )
    (set _7=%_7%   #  )
    (set _8=%_8%      )
    goto :eof

:s_zl
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4% ####)
    (set _5=%_5%   # )
    (set _6=%_6%  #  )
    (set _7=%_7% ####)
    (set _8=%_8%     )
    goto :eof

:s_z
    (set _1=%_1% #####)
    (set _2=%_2%     #)
    (set _3=%_3%    # )
    (set _4=%_4%   #  )
    (set _5=%_5%  #   )
    (set _6=%_6% #    )
    (set _7=%_7% #####)
    (set _8=%_8%      )
    goto :eof

:s_space
    (set _1=%_1%     )
    (set _2=%_2%     )
    (set _3=%_3%     )
    (set _4=%_4%     )
    (set _5=%_5%     )
    (set _6=%_6%     )
    (set _7=%_7%     )
    (set _8=%_8%     )
    goto :eof

:s_!
    (set _1=%_1%  # )
    (set _2=%_2%  # )
    (set _3=%_3%  # )
    (set _4=%_4%  # )
    (set _5=%_5%  # )
    (set _6=%_6%    )
    (set _7=%_7%  # )
    (set _8=%_8%    )
    goto :eof

:s_?
    (set _1=%_1% #### )
    (set _2=%_2% #  # )
    (set _3=%_3%    # )
    (set _4=%_4%  ### )
    (set _5=%_5%  #   )
    (set _6=%_6%      )
    (set _7=%_7%  #   )
    (set _8=%_8%      )
    goto :eof

:s_.
    (set _1=%_1%   )
    (set _2=%_2%   )
    (set _3=%_3%   )
    (set _4=%_4%   )
    (set _5=%_5%   )
    (set _6=%_6%   )
    (set _7=%_7% # )
    (set _8=%_8%   )
    goto :eof

:s_comma
    (set _1=%_1%    )
    (set _2=%_2%    )
    (set _3=%_3%    )
    (set _4=%_4%    )
    (set _5=%_5%    )
    (set _6=%_6%    )
    (set _7=%_7%  # )
    (set _8=%_8% #  )
    goto :eof
