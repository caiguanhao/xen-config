@echo off
 echo Copyright (c) 2014 Cai Guanhao (Choi Goon-ho)
 echo Licensed under the terms of the MIT license.
 echo Report bugs on https://github.com/caiguanhao/xen-config/issues
 echo --------------------------------------------------------------

for /f "tokens=1,3" %%a in ('query user ^| more +1 ^| findstr /r "^[^>]"') do (
  logoff %%b
  if ERRORLEVEL 1 (
    echo Error logging off %%a [id=%%b].
  ) else (
    echo %%a [id=%%b] has been logged off.
  )
)

timeout /t 4
