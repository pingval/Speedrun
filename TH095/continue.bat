rem 走り終えた後、更に連続して走るときに実行する。
rem after.bat, restart.bat を連続して実行するのと同じ。

rem ローカル変数を作成
setlocal

rem 親ディレクトリ名
set BASEDIR=rta-history
set _TIME=%TIME: =0%
rem 子ディレクトリ名: YYYYMMDD-hh_mm_ss
set EXDIR=%DATE:~-10,4%%DATE:~-5,2%%DATE:~-2%-%_TIME:~0,2%_%_TIME:~3,2%_%_TIME:~6,2%
rem 作成するディレクトリ名
set DIR=.\%BASEDIR%\%EXDIR%

mkdir %DIR% > NUL 2>&1
rem scoreth095.datのみ移動
move /Y .\scoreth095.dat %DIR%\
rem bestshotディレクトリを削除
rmdir .\bestshot /S/Q

endlocal