<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <title>管理后台 - 宠物领养系统</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <style>
                .admin-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                    gap: 25px;
                    margin-top: 30px;
                }

                .admin-card {
                    background: white;
                    padding: 30px;
                    border-radius: 12px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                    text-align: center;
                    transition: all 0.3s;
                    cursor: pointer;
                    text-decoration: none;
                    color: #374151;
                    display: block;
                }

                .admin-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
                    color: var(--primary-color);
                }

                .card-icon {
                    font-size: 3rem;
                    margin-bottom: 15px;
                }

                .card-title {
                    font-size: 1.25rem;
                    font-weight: 600;
                }

                .card-desc {
                    margin-top: 10px;
                    font-size: 0.9rem;
                    color: #9ca3af;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>⚙️ 管理后台</h1>
                    <div class="user-info">
                        <span>欢迎, ${loginUser.realName} (${loginUser.role == 0 ? '系统管理员' : '收容所管理员'})</span>
                        <a href="${pageContext.request.contextPath}/user/logout" class="btn btn-secondary"
                            style="padding:5px 10px;margin-left:10px">退出</a>
                    </div>
                </header>

                <div class="admin-grid">
                    <c:if test="${loginUser.role == 1}">
                        <a href="${pageContext.request.contextPath}/pet/manage" class="admin-card">
                            <div class="card-icon">🐶</div>
                            <div class="card-title">宠物管理</div>
                            <div class="card-desc">发布、编辑、下架宠物信息</div>
                        </a>

                        <a href="${pageContext.request.contextPath}/adoption/manage" class="admin-card">
                            <div class="card-icon">📝</div>
                            <div class="card-title">领养审核</div>
                            <div class="card-desc">处理用户的领养申请</div>
                        </a>
                    </c:if>

                    <c:if test="${loginUser.role == 0}">
                        <a href="${pageContext.request.contextPath}/admin/stats/dashboard" class="admin-card">
                            <div class="card-icon">📊</div>
                            <div class="card-title">数据统计</div>
                            <div class="card-desc">查看系统运营数据图表</div>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/blacklist/list" class="admin-card">
                            <div class="card-icon">⛔</div>
                            <div class="card-title">黑名单管理</div>
                            <div class="card-desc">管理失信用户记录</div>
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/log/list" class="admin-card">
                            <div class="card-icon">📋</div>
                            <div class="card-title">系统日志</div>
                            <div class="card-desc">查看系统关键操作日志</div>
                        </a>

                        <!-- 预留用户管理 -->
                        <a href="${pageContext.request.contextPath}/admin/user/list" class="admin-card">
                            <div class="card-icon">👥</div>
                            <div class="card-title">用户管理</div>
                            <div class="card-desc">管理用户角色与禁用状态</div>
                        </a>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/" class="admin-card">
                        <div class="card-icon">🏠</div>
                        <div class="card-title">返回前台</div>
                        <div class="card-desc">浏览网站首页</div>
                    </a>
                </div>
            </div>
        </body>

        </html>