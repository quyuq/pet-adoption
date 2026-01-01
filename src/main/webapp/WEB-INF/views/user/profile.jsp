<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>个人中心 - 宠物领养管理系统</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <style>
                .profile-container {
                    max-width: 800px;
                    margin: 40px auto;
                }

                .profile-card {
                    background: rgba(255, 255, 255, 0.98);
                    border-radius: 16px;
                    padding: 40px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
                    position: relative;
                    /* Relative positioning for absolute child */
                }

                .profile-header {
                    display: flex;
                    align-items: center;
                    margin-bottom: 30px;
                    padding-bottom: 20px;
                    border-bottom: 1px solid #e5e7eb;
                }

                .profile-avatar {
                    width: 100px;
                    height: 100px;
                    background: linear-gradient(135deg, #6366f1, #4f46e5);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 2.5rem;
                    color: white;
                    margin-right: 25px;
                }

                .profile-info h2 {
                    color: #1f2937;
                    margin-bottom: 5px;
                }

                .profile-info p {
                    color: #6b7280;
                }

                .role-badge {
                    display: inline-block;
                    padding: 4px 12px;
                    border-radius: 20px;
                    font-size: 0.85rem;
                    margin-top: 8px;
                }

                .role-admin {
                    background: rgba(239, 68, 68, 0.1);
                    color: #dc2626;
                }

                .role-shelter {
                    background: rgba(245, 158, 11, 0.1);
                    color: #d97706;
                }

                .role-user {
                    background: rgba(16, 185, 129, 0.1);
                    color: #059669;
                }

                .tab-container {
                    margin-top: 20px;
                }

                .tab-nav {
                    display: flex;
                    border-bottom: 2px solid #e5e7eb;
                    margin-bottom: 25px;
                }

                .tab-btn {
                    padding: 12px 25px;
                    background: none;
                    border: none;
                    cursor: pointer;
                    font-size: 1rem;
                    color: #6b7280;
                    border-bottom: 2px solid transparent;
                    margin-bottom: -2px;
                    transition: all 0.3s ease;
                }

                .tab-btn.active {
                    color: #6366f1;
                    border-bottom-color: #6366f1;
                }

                .tab-content {
                    display: none;
                }

                .tab-content.active {
                    display: block;
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

                .form-control:disabled {
                    background: #f3f4f6;
                    color: #9ca3af;
                }

                .form-row {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 20px;
                }

                .btn-save {
                    padding: 12px 30px;
                    background: linear-gradient(135deg, #6366f1, #4f46e5);
                    color: white;
                    border: none;
                    border-radius: 10px;
                    font-size: 1rem;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .btn-save:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
                }

                .message {
                    padding: 12px 16px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    display: none;
                }

                .message.success {
                    background: rgba(16, 185, 129, 0.1);
                    color: #059669;
                }

                .message.error {
                    background: rgba(239, 68, 68, 0.1);
                    color: #dc2626;
                }

                /* Absolute positioned home button group styles */
                .btn-group-top-right {
                    position: absolute;
                    top: 20px;
                    right: 20px;
                    display: flex;
                    gap: 12px;
                }

                .btn-nav-top {
                    text-decoration: none;
                    padding: 8px 16px;
                    font-size: 0.9rem;
                    border-radius: 8px;
                    transition: all 0.3s ease;
                    display: flex;
                    align-items: center;
                    gap: 6px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                }

                .btn-nav-white {
                    background: #ffffff;
                    color: #4b5563;
                    border: 1px solid #e5e7eb;
                }

                .btn-nav-white:hover {
                    background: #f9fafb;
                    border-color: #d1d5db;
                }

                .btn-nav-primary {
                    background: rgba(99, 102, 241, 0.1);
                    color: #6366f1;
                    border: 1px solid rgba(99, 102, 241, 0.2);
                    font-weight: 600;
                }

                .btn-nav-primary:hover {
                    background: #6366f1;
                    color: white;
                }

                .btn-home-absolute:hover {
                    background: #6366f1;
                    color: white;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 宠物领养管理系统</h1>
                </header>

                <div class="profile-container">
                    <div class="profile-card">
                        <!-- Header Navigation Buttons -->
                        <div class="btn-group-top-right">
                            <a href="${pageContext.request.contextPath}/" class="btn-nav-top btn-nav-white">
                                🏠 返回首页
                            </a>
                            <c:if test="${user.role == 0 || user.role == 1}">
                                <a href="${pageContext.request.contextPath}/admin/index"
                                    class="btn-nav-top btn-nav-primary">
                                    ⚙️ 管理后台
                                </a>
                            </c:if>
                        </div>

                        <div class="profile-header">
                            <div class="profile-avatar">
                                ${not empty user.realName ? user.realName.substring(0, 1) : user.username.substring(0,
                                1)}
                            </div>
                            <div class="profile-info">
                                <h2>${user.realName != null && user.realName != '' ? user.realName : user.username}</h2>
                                <p>@${user.username}</p>
                                <c:choose>
                                    <c:when test="${user.role == 0}">
                                        <span class="role-badge role-admin">系统管理员</span>
                                    </c:when>
                                    <c:when test="${user.role == 1}">
                                        <span class="role-badge role-shelter">收容所管理员</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="role-badge role-user">领养用户</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="tab-container">
                            <div class="tab-nav">
                                <button class="tab-btn active" data-tab="info">个人信息</button>
                                <button class="tab-btn" data-tab="password">修改密码</button>
                                <a href="${pageContext.request.contextPath}/message/list" class="tab-btn"
                                    style="text-decoration:none;">我的消息</a>
                                <c:if test="${user.role == 2}">
                                    <a href="${pageContext.request.contextPath}/adoption/my" class="tab-btn"
                                        style="text-decoration:none;">我的领养申请</a>
                                </c:if>
                            </div>

                            <!-- 个人信息 -->
                            <div id="info" class="tab-content active">
                                <div id="infoMessage" class="message"></div>
                                <form id="profileForm">
                                    <div class="form-group">
                                        <label>用户名</label>
                                        <input type="text" class="form-control" value="${user.username}" disabled>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="realName">真实姓名</label>
                                            <input type="text" id="realName" class="form-control"
                                                value="${user.realName}" placeholder="请输入真实姓名">
                                        </div>

                                        <div class="form-group">
                                            <label for="phone">联系电话</label>
                                            <input type="tel" id="phone" class="form-control" value="${user.phone}"
                                                placeholder="请输入联系电话">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="email">邮箱地址</label>
                                        <input type="email" id="email" class="form-control" value="${user.email}"
                                            placeholder="请输入邮箱地址">
                                    </div>

                                    <div class="form-group">
                                        <label for="address">居住地址</label>
                                        <input type="text" id="address" class="form-control" value="${user.address}"
                                            placeholder="请输入居住地址">
                                    </div>

                                    <button type="submit" class="btn-save">保存修改</button>
                                </form>
                            </div>

                            <!-- 修改密码 -->
                            <div id="password" class="tab-content">
                                <div id="passwordMessage" class="message"></div>
                                <form id="passwordForm">
                                    <div class="form-group">
                                        <label for="oldPassword">原密码</label>
                                        <input type="password" id="oldPassword" class="form-control"
                                            placeholder="请输入原密码" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="newPassword">新密码</label>
                                        <input type="password" id="newPassword" class="form-control"
                                            placeholder="请输入新密码（至少6位）" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="confirmNewPassword">确认新密码</label>
                                        <input type="password" id="confirmNewPassword" class="form-control"
                                            placeholder="请再次输入新密码" required>
                                    </div>

                                    <button type="submit" class="btn-save">修改密码</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                // Tab切换
                document.querySelectorAll('.tab-btn').forEach(function (btn) {
                    btn.addEventListener('click', function () {
                        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                        document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));

                        this.classList.add('active');
                        document.getElementById(this.dataset.tab).classList.add('active');
                    });
                });

                // 更新个人信息
                document.getElementById('profileForm').addEventListener('submit', function (e) {
                    e.preventDefault();
                    var messageEl = document.getElementById('infoMessage');

                    var formData = {
                        realName: document.getElementById('realName').value,
                        phone: document.getElementById('phone').value,
                        email: document.getElementById('email').value,
                        address: document.getElementById('address').value
                    };

                    fetch('${pageContext.request.contextPath}/user/profile', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify(formData)
                    })
                        .then(response => response.json())
                        .then(data => {
                            messageEl.style.display = 'block';
                            if (data.code === 200) {
                                messageEl.className = 'message success';
                                messageEl.textContent = '个人信息更新成功';
                            } else {
                                messageEl.className = 'message error';
                                messageEl.textContent = data.message;
                            }
                        });
                });

                // 修改密码
                document.getElementById('passwordForm').addEventListener('submit', function (e) {
                    e.preventDefault();
                    var messageEl = document.getElementById('passwordMessage');

                    var newPassword = document.getElementById('newPassword').value;
                    var confirmNewPassword = document.getElementById('confirmNewPassword').value;

                    if (newPassword.length < 6) {
                        messageEl.className = 'message error';
                        messageEl.textContent = '新密码长度至少为6位';
                        messageEl.style.display = 'block';
                        return;
                    }

                    if (newPassword !== confirmNewPassword) {
                        messageEl.className = 'message error';
                        messageEl.textContent = '两次输入的新密码不一致';
                        messageEl.style.display = 'block';
                        return;
                    }

                    var params = 'oldPassword=' + encodeURIComponent(document.getElementById('oldPassword').value) +
                        '&newPassword=' + encodeURIComponent(newPassword);

                    fetch('${pageContext.request.contextPath}/user/changePassword', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: params
                    })
                        .then(response => response.json())
                        .then(data => {
                            messageEl.style.display = 'block';
                            if (data.code === 200) {
                                messageEl.className = 'message success';
                                messageEl.textContent = '密码修改成功';
                                document.getElementById('passwordForm').reset();
                            } else {
                                messageEl.className = 'message error';
                                messageEl.textContent = data.message;
                            }
                        });
                });
            </script>
        </body>

        </html>