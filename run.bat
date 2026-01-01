@echo off
echo [INFO] 清理并编译项目...
call mvn clean compile

echo [INFO] 正在启动服务器...
start "Pet Adoption System Server" mvn tomcat7:run

echo [INFO] 等待服务器启动 (10秒)...
timeout /t 10 /nobreak > nul

echo [INFO] 正在打开浏览器...
start http://localhost:8080/pet-adoption

echo [INFO] 启动完成！请在弹出的新窗口中查看服务器日志。
pause
