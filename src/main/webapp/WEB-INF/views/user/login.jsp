<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>用户登录 - 宠物领养管理系统</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <style>
                .login-container {
                    max-width: 450px;
                    margin: 60px auto;
                }

                .login-card {
                    background: rgba(255, 255, 255, 0.98);
                    border-radius: 16px;
                    padding: 40px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
                }

                .login-header {
                    text-align: center;
                    margin-bottom: 30px;
                }

                .login-header h2 {
                    color: #1f2937;
                    font-size: 1.8rem;
                    margin-bottom: 8px;
                }

                .login-header p {
                    color: #6b7280;
                }

                .login-icon {
                    font-size: 4rem;
                    margin-bottom: 15px;
                }

                .form-group {
                    margin-bottom: 24px;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 500;
                    color: #374151;
                }

                .form-control {
                    width: 100%;
                    padding: 14px 16px;
                    border: 2px solid #e5e7eb;
                    border-radius: 10px;
                    font-size: 1rem;
                    transition: all 0.3s ease;
                }

                .form-control:focus {
                    outline: none;
                    border-color: #6366f1;
                    box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
                }

                .btn-login {
                    width: 100%;
                    padding: 14px;
                    background: linear-gradient(135deg, #6366f1, #4f46e5);
                    color: white;
                    border: none;
                    border-radius: 10px;
                    font-size: 1.1rem;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .btn-login:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
                }

                .login-footer {
                    text-align: center;
                    margin-top: 25px;
                    color: #6b7280;
                }

                .login-footer a {
                    color: #6366f1;
                    text-decoration: none;
                    font-weight: 500;
                }

                .login-footer a:hover {
                    text-decoration: underline;
                }

                .error-message {
                    background: rgba(239, 68, 68, 0.1);
                    color: #dc2626;
                    padding: 12px 16px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    display: none;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 宠物领养管理系统</h1>
                </header>

                <div class="login-container">
                    <div class="login-card">
                        <div class="login-header">
                            <div class="login-icon">🔐</div>
                            <h2>用户登录</h2>
                            <p>欢迎回来，请登录您的账号</p>
                        </div>

                        <div id="errorMsg" class="error-message"></div>

                        <form id="loginForm">
                            <div class="form-group">
                                <label for="username">用户名</label>
                                <input type="text" id="username" name="username" class="form-control"
                                    placeholder="请输入用户名" required>
                            </div>

                            <div class="form-group">
                                <label for="password">密码</label>
                                <input type="password" id="password" name="password" class="form-control"
                                    placeholder="请输入密码" required>
                            </div>

                            <button type="submit" class="btn-login">登 录</button>
                        </form>

                        <div class="login-footer">
                            还没有账号？<a href="${pageContext.request.contextPath}/user/register">立即注册</a>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                document.getElementById('loginForm').addEventListener('submit', function (e) {
                    e.preventDefault();

                    var username = document.getElementById('username').value;
                    var password = document.getElementById('password').value;
                    var errorMsg = document.getElementById('errorMsg');

                    // 发送登录请求
                    fetch('${pageContext.request.contextPath}/user/login', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password)
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.code === 200) {
                                // 登录成功，根据角色跳转
                                var role = data.data.role;
                                if (role === 0 || role === 1) {
                                    window.location.href = '${pageContext.request.contextPath}/admin/index';
                                } else {
                                    window.location.href = '${pageContext.request.contextPath}/';
                                }
                            } else {
                                errorMsg.textContent = data.message;
                                errorMsg.style.display = 'block';
                            }
                        })
                        .catch(error => {
                            errorMsg.textContent = '网络错误，请稍后重试';
                            errorMsg.style.display = 'block';
                        });
                });
            </script>
        </body>

        </html>