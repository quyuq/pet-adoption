<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>用户注册 - 宠物领养管理系统</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <style>
                .register-container {
                    max-width: 500px;
                    margin: 40px auto;
                }

                .register-card {
                    background: rgba(255, 255, 255, 0.98);
                    border-radius: 16px;
                    padding: 40px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
                }

                .register-header {
                    text-align: center;
                    margin-bottom: 30px;
                }

                .register-header h2 {
                    color: #1f2937;
                    font-size: 1.8rem;
                    margin-bottom: 8px;
                }

                .register-header p {
                    color: #6b7280;
                }

                .register-icon {
                    font-size: 4rem;
                    margin-bottom: 15px;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 500;
                    color: #374151;
                }

                .form-group label .required {
                    color: #ef4444;
                }

                .form-control {
                    width: 100%;
                    padding: 12px 16px;
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

                .form-control.error {
                    border-color: #ef4444;
                }

                .form-control.success {
                    border-color: #10b981;
                }

                .form-hint {
                    font-size: 0.85rem;
                    color: #6b7280;
                    margin-top: 5px;
                }

                .form-hint.error {
                    color: #ef4444;
                }

                .btn-register {
                    width: 100%;
                    padding: 14px;
                    background: linear-gradient(135deg, #10b981, #059669);
                    color: white;
                    border: none;
                    border-radius: 10px;
                    font-size: 1.1rem;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    margin-top: 10px;
                }

                .btn-register:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(16, 185, 129, 0.4);
                }

                .btn-register:disabled {
                    background: #9ca3af;
                    cursor: not-allowed;
                    transform: none;
                    box-shadow: none;
                }

                .register-footer {
                    text-align: center;
                    margin-top: 25px;
                    color: #6b7280;
                }

                .register-footer a {
                    color: #6366f1;
                    text-decoration: none;
                    font-weight: 500;
                }

                .error-message,
                .success-message {
                    padding: 12px 16px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    display: none;
                }

                .error-message {
                    background: rgba(239, 68, 68, 0.1);
                    color: #dc2626;
                }

                .success-message {
                    background: rgba(16, 185, 129, 0.1);
                    color: #059669;
                }

                .form-row {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 15px;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 宠物领养管理系统</h1>
                </header>

                <div class="register-container">
                    <div class="register-card">
                        <div class="register-header">
                            <div class="register-icon">📝</div>
                            <h2>用户注册</h2>
                            <p>加入我们，为流浪动物找一个家</p>
                        </div>

                        <div id="errorMsg" class="error-message"></div>
                        <div id="successMsg" class="success-message"></div>

                        <form id="registerForm">
                            <div class="form-group">
                                <label for="username">用户名 <span class="required">*</span></label>
                                <input type="text" id="username" name="username" class="form-control"
                                    placeholder="请输入用户名（4-20位字母数字）" required>
                                <div id="usernameHint" class="form-hint"></div>
                            </div>

                            <div class="form-group">
                                <label for="password">密码 <span class="required">*</span></label>
                                <input type="password" id="password" name="password" class="form-control"
                                    placeholder="请输入密码（至少6位）" required>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword">确认密码 <span class="required">*</span></label>
                                <input type="password" id="confirmPassword" class="form-control" placeholder="请再次输入密码"
                                    required>
                                <div id="passwordHint" class="form-hint"></div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="realName">真实姓名</label>
                                    <input type="text" id="realName" name="realName" class="form-control"
                                        placeholder="请输入真实姓名">
                                </div>

                                <div class="form-group">
                                    <label for="phone">联系电话</label>
                                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="请输入手机号">
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="email">邮箱</label>
                                <input type="email" id="email" name="email" class="form-control" placeholder="请输入邮箱地址">
                            </div>

                            <div class="form-group">
                                <label for="address">地址</label>
                                <input type="text" id="address" name="address" class="form-control"
                                    placeholder="请输入您的居住地址">
                            </div>

                            <button type="submit" id="submitBtn" class="btn-register">立 即 注 册</button>
                        </form>

                        <div class="register-footer">
                            已有账号？<a href="${pageContext.request.contextPath}/user/login">立即登录</a>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                var usernameValid = false;
                var passwordMatch = false;

                // 用户名验证
                document.getElementById('username').addEventListener('blur', function () {
                    var username = this.value;
                    var hint = document.getElementById('usernameHint');

                    if (username.length < 4 || username.length > 20) {
                        hint.textContent = '用户名长度需在4-20位之间';
                        hint.className = 'form-hint error';
                        this.className = 'form-control error';
                        usernameValid = false;
                        return;
                    }

                    // 检查用户名是否可用
                    fetch('${pageContext.request.contextPath}/user/checkUsername?username=' + encodeURIComponent(username))
                        .then(response => response.json())
                        .then(data => {
                            if (data.code === 200) {
                                hint.textContent = '✓ 用户名可用';
                                hint.className = 'form-hint';
                                hint.style.color = '#10b981';
                                document.getElementById('username').className = 'form-control success';
                                usernameValid = true;
                            } else {
                                hint.textContent = data.message;
                                hint.className = 'form-hint error';
                                document.getElementById('username').className = 'form-control error';
                                usernameValid = false;
                            }
                        });
                });

                // 密码确认验证
                document.getElementById('confirmPassword').addEventListener('input', function () {
                    var password = document.getElementById('password').value;
                    var confirmPassword = this.value;
                    var hint = document.getElementById('passwordHint');

                    if (password !== confirmPassword) {
                        hint.textContent = '两次输入的密码不一致';
                        hint.className = 'form-hint error';
                        this.className = 'form-control error';
                        passwordMatch = false;
                    } else {
                        hint.textContent = '✓ 密码一致';
                        hint.className = 'form-hint';
                        hint.style.color = '#10b981';
                        this.className = 'form-control success';
                        passwordMatch = true;
                    }
                });

                // 表单提交
                document.getElementById('registerForm').addEventListener('submit', function (e) {
                    e.preventDefault();

                    var errorMsg = document.getElementById('errorMsg');
                    var successMsg = document.getElementById('successMsg');
                    var username = document.getElementById('username').value;
                    var password = document.getElementById('password').value;
                    var confirmPassword = document.getElementById('confirmPassword').value;

                    // 验证
                    if (username.length < 4 || username.length > 20) {
                        errorMsg.textContent = '用户名长度需在4-20位之间';
                        errorMsg.style.display = 'block';
                        return;
                    }

                    if (password.length < 6) {
                        errorMsg.textContent = '密码长度至少为6位';
                        errorMsg.style.display = 'block';
                        return;
                    }

                    if (password !== confirmPassword) {
                        errorMsg.textContent = '两次输入的密码不一致';
                        errorMsg.style.display = 'block';
                        return;
                    }

                    // 收集表单数据
                    var formData = {
                        username: document.getElementById('username').value,
                        password: password,
                        realName: document.getElementById('realName').value,
                        phone: document.getElementById('phone').value,
                        email: document.getElementById('email').value,
                        address: document.getElementById('address').value
                    };

                    // 发送注册请求
                    fetch('${pageContext.request.contextPath}/user/register', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify(formData)
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.code === 200) {
                                errorMsg.style.display = 'none';
                                successMsg.textContent = '注册成功！3秒后跳转到登录页面...';
                                successMsg.style.display = 'block';
                                document.getElementById('submitBtn').disabled = true;

                                setTimeout(function () {
                                    window.location.href = '${pageContext.request.contextPath}/user/login';
                                }, 3000);
                            } else {
                                successMsg.style.display = 'none';
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