rem ����O�Ɏ��s����
rem scoreth095.dat �� bestshot�f�B���N�g���̒��g�� backup�f�B���N�g���̒��Ƀo�b�N�A�b�v����B

mkdir .\backup\bestshot > NUL 2>&1
move /Y .\scoreth095.dat .\backup\
move /Y .\bestshot\* .\backup\bestshot
rem bestshot�f�B���N�g�����폜
rmdir .\bestshot /S/Q
