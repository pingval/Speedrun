rem 走り終えた後に実行する。
rem scoreth095.dat を ./rta-history/ に保存し、バックアップしておいた scoreth095.dat と bestshotディレクトリの中身をリストアする。

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
rem バックアップファイルをリストア
copy /Y .\backup\scoreth095.dat .\
mkdir .\bestshot > NUL 2>&1
copy /Y .\backup\bestshot\* .\bestshot\

endlocal
