rem ����I������Ɏ��s����B
rem scoreth095.dat �� ./rta-history/ �ɕۑ����A�o�b�N�A�b�v���Ă����� scoreth095.dat �� bestshot�f�B���N�g���̒��g�����X�g�A����B

rem ���[�J���ϐ����쐬
setlocal

rem �e�f�B���N�g����
set BASEDIR=rta-history
set _TIME=%TIME: =0%
rem �q�f�B���N�g����: YYYYMMDD-hh_mm_ss
set EXDIR=%DATE:~-10,4%%DATE:~-5,2%%DATE:~-2%-%_TIME:~0,2%_%_TIME:~3,2%_%_TIME:~6,2%
rem �쐬����f�B���N�g����
set DIR=.\%BASEDIR%\%EXDIR%

mkdir %DIR% > NUL 2>&1
rem scoreth095.dat�݈̂ړ�
move /Y .\scoreth095.dat %DIR%\
rem �o�b�N�A�b�v�t�@�C�������X�g�A
copy /Y .\backup\scoreth095.dat .\
mkdir .\bestshot > NUL 2>&1
copy /Y .\backup\bestshot\* .\bestshot\

endlocal
