<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="zh-CN">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>宠物领养管理系统 - 给它一个温暖的家</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
                <style>
                    .hero {
                        position: relative;
                        background: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.3)),
                        url('${pageContext.request.contextPath}/static/images/hero-bg.png');
                        background-size: cover;
                        background-position: center;
                        color: white;
                        padding: 100px 20px;
                        border-radius: 16px;
                        margin-bottom: 40px;
                        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                    }

                    .hero h2 {
                        font-size: 3rem;
                        margin-bottom: 20px;
                        color: white;
                    }

                    .section-title {
                        text-align: center;
                        margin-bottom: 30px;
                        color: #1f2937;
                        font-size: 2rem;
                        position: relative;
                    }

                    .section-title::after {
                        content: '';
                        display: block;
                        width: 60px;
                        height: 4px;
                        background: var(--primary-color);
                        margin: 10px auto 0;
                        border-radius: 2px;
                    }

                    .pet-card {
                        background: white;
                        border-radius: 12px;
                        overflow: hidden;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                        transition: transform 0.3s ease, box-shadow 0.3s ease;
                        text-decoration: none;
                        color: inherit;
                        display: block;
                    }

                    .pet-card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
                    }

                    .pet-image {
                        width: 100%;
                        height: 250px;
                        object-fit: cover;
                        background: #f3f4f6;
                    }

                    .pet-info {
                        padding: 20px;
                    }

                    .pet-name {
                        font-size: 1.25rem;
                        font-weight: 700;
                        margin-bottom: 8px;
                        color: #1f2937;
                    }

                    .pet-details {
                        color: #6b7280;
                        font-size: 0.95rem;
                        display: flex;
                        gap: 10px;
                        align-items: center;
                    }

                    .gender-icon {
                        font-size: 1.1em;
                    }

                    .gender-male {
                        color: #3b82f6;
                    }

                    .gender-female {
                        color: #ec4899;
                    }

                    .empty-state {
                        text-align: center;
                        padding: 40px;
                        color: #9ca3af;
                        background: #f9fafb;
                        border-radius: 12px;
                        grid-column: 1 / -1;
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <!-- 导航栏 -->
                    <nav class="nav">
                        <div style="flex:1; display:flex; align-items:center; gap:10px;">
                            <span style="font-size:1.5rem;">🐾</span>
                            <span style="font-weight:700; font-size:1.2rem; color:#4b5563;">宠爱有家</span>
                        </div>
                        <a href="${pageContext.request.contextPath}/" class="nav-link"
                            style="color:var(--primary-color);">首页</a>
                        <a href="${pageContext.request.contextPath}/pet/list" class="nav-link">寻找宠物</a>
                        <a href="#" class="nav-link">关于我们</a>
                        <div style="width:1px; height:20px; background:#e5e7eb; margin:0 10px;"></div>
                        <c:if test="${empty loginUser}">
                            <a href="${pageContext.request.contextPath}/user/login" class="nav-link">登录</a>
                            <a href="${pageContext.request.contextPath}/user/register" class="btn btn-primary"
                                style="padding:8px 20px;">注册</a>
                        </c:if>
                        <c:if test="${not empty loginUser}">
                            <c:if test="${loginUser.role == 0 || loginUser.role == 1}">
                                <a href="${pageContext.request.contextPath}/admin/index" class="nav-link"
                                    style="color:var(--primary-color); font-weight:600;">⚙️ 管理后台</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/user/profile" class="nav-link">
                                <span style="display:flex; align-items:center; gap:5px;">
                                    <span>👤</span> ${loginUser.username}
                                </span>
                            </a>
                            <a href="${pageContext.request.contextPath}/user/logout" class="nav-link"
                                style="color:var(--danger-color);">退出</a>
                        </c:if>
                    </nav>

                    <!-- Hero区域 -->
                    <header class="hero">
                        <div style="max-width: 600px;">
                            <h2>遇见命中注定的 TA</h2>
                            <p style="font-size: 1.2rem; margin-bottom: 30px; opacity: 0.9; color:#e5e7eb;">
                                每一个生命都值得被温柔以待。在这里，成千上万的流浪精灵正在等待一个温暖的家。
                                加入我们，用领养代替购买。
                            </p>
                            <div style="display:flex; gap:15px;">
                                <a href="${pageContext.request.contextPath}/pet/list" class="btn btn-primary"
                                    style="font-size:1.1rem; padding:12px 35px;">
                                    🔍 立即寻宠
                                </a>
                                <c:if test="${empty loginUser}">
                                    <a href="${pageContext.request.contextPath}/user/register" class="btn"
                                        style="background:white; color:#374151; font-size:1.1rem; padding:12px 35px;">
                                        📝 注册领养
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </header>

                    <main class="main-content" style="background:none; padding:0; box-shadow:none;">
                        <!-- 推荐宠物 -->
                        <section style="margin-bottom: 50px;">
                            <h3 class="section-title">🌟 待领养的萌宠</h3>

                            <div class="features" style="grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));">
                                <c:forEach items="${featuredPets}" var="pet">
                                    <a href="${pageContext.request.contextPath}/pet/detail/${pet.id}" class="pet-card">
                                        <img src="${pageContext.request.contextPath}${pet.imageUrl}" alt="${pet.name}"
                                            class="pet-image"
                                            onerror="this.src='https://via.placeholder.com/300x250?text=No+Image'">
                                        <div class="pet-info">
                                            <div
                                                style="display:flex; justify-content:space-between; align-items:flex-start;">
                                                <h4 class="pet-name">${pet.name}</h4>
                                                <span class="badge badge-success">待领养</span>
                                            </div>
                                            <div class="pet-details">
                                                <span>${pet.species}</span>
                                                <span>•</span>
                                                <span>${pet.breed}</span>
                                                <span>•</span>
                                                <span>${pet.age}月</span>
                                                <c:if test="${pet.gender == 1}">
                                                    <span class="gender-icon gender-male">♂</span>
                                                </c:if>
                                                <c:if test="${pet.gender == 2}">
                                                    <span class="gender-icon gender-female">♀</span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                                <c:if test="${empty featuredPets}">
                                    <div class="empty-state">
                                        <p>暂无待领养的宠物，去看看其他的吧~</p>
                                    </div>
                                </c:if>
                            </div>

                            <div style="text-align:center; margin-top:30px;">
                                <a href="${pageContext.request.contextPath}/pet/list" class="btn btn-secondary">查看全部宠物
                                    →</a>
                            </div>
                        </section>

                        <!-- 特性介绍 -->
                        <section class="features">
                            <div class="feature-card">
                                <div class="feature-icon"
                                    style="background:#e0e7ff; color:#6366f1; width:80px; height:80px; line-height:80px; border-radius:50%; margin:0 auto 20px;">
                                    🐕</div>
                                <h3>海量萌宠</h3>
                                <p>汇集各地收容所信息，猫狗异宠应有尽有</p>
                            </div>
                            <div class="feature-card">
                                <div class="feature-icon"
                                    style="background:#dcfce7; color:#10b981; width:80px; height:80px; line-height:80px; border-radius:50%; margin:0 auto 20px;">
                                    🛡️</div>
                                <h3>严格审核</h3>
                                <p>双向身份认证与环境核查，保障领养安全</p>
                            </div>
                            <div class="feature-card">
                                <div class="feature-icon"
                                    style="background:#fef3c7; color:#f59e0b; width:80px; height:80px; line-height:80px; border-radius:50%; margin:0 auto 20px;">
                                    ❤️</div>
                                <h3>爱心社区</h3>
                                <p>分享养宠心得，记录毛孩子的幸福瞬间</p>
                            </div>
                        </section>
                    </main>

                    <footer class="footer">
                        <div style="border-top:1px solid rgba(255,255,255,0.2); padding-top:20px;">
                            <p>&copy; 2026 宠物领养管理系统 | 致力于打造最温暖的领养平台</p>
                        </div>
                    </footer>
                </div>
            </body>

            </html>