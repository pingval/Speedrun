rem 走る前に実行する
rem scoreth095.dat と bestshotディレクトリの中身を backupディレクトリの中にバックアップする。

mkdir .\backup\bestshot > NUL 2>&1
move /Y .\scoreth095.dat .\backup\
move /Y .\bestshot\* .\backup\bestshot
rem bestshotディレクトリを削除
rmdir .\bestshot /S/Q
