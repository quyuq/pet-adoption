<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>宠物列表 - 宠物领养管理系统</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <style>
                .filter-bar {
                    background: white;
                    padding: 20px;
                    border-radius: 12px;
                    margin-bottom: 30px;
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                    display: flex;
                    gap: 20px;
                    align-items: center;
                    flex-wrap: wrap;
                }

                .filter-group {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .search-input {
                    padding: 10px 15px;
                    border: 1px solid #e5e7eb;
                    border-radius: 8px;
                    width: 250px;
                }

                .select-input {
                    padding: 10px 15px;
                    border: 1px solid #e5e7eb;
                    border-radius: 8px;
                    background: white;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 宠物领养管理系统</h1>
                </header>

                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/" class="nav-link">首页</a>
                    <a href="${pageContext.request.contextPath}/pet/list" class="nav-link"
                        style="background:var(--primary-color);color:white">浏览宠物</a>
                    <c:if test="${empty loginUser}">
                        <a href="${pageContext.request.contextPath}/user/login" class="nav-link">登录</a>
                        <a href="${pageContext.request.contextPath}/user/register" class="nav-link">注册</a>
                    </c:if>
                    <c:if test="${not empty loginUser}">
                        <c:if test="${loginUser.role == 0 || loginUser.role == 1}">
                            <a href="${pageContext.request.contextPath}/admin/index" class="nav-link">管理后台</a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/user/profile" class="nav-link">个人中心</a>
                        <a href="${pageContext.request.contextPath}/user/logout" class="nav-link">退出</a>
                    </c:if>
                </nav>

                <form action="${pageContext.request.contextPath}/pet/list" method="get" class="filter-bar">
                    <div class="filter-group">
                        <label>物种：</label>
                        <select name="species" class="select-input">
                            <option value="">全部</option>
                            <option value="猫" ${species=='猫' ? 'selected' : '' }>猫</option>
                            <option value="狗" ${species=='狗' ? 'selected' : '' }>狗</option>
                            <option value="其他" ${species=='其他' ? 'selected' : '' }>其他</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <input type="text" name="keyword" class="search-input" value="${keyword}"
                            placeholder="搜索宠物名称或品种">
                        <button type="submit" class="btn btn-primary">搜索</button>
                    </div>
                </form>

                <div class="pet-grid">
                    <c:forEach items="${pageInfo.list}" var="pet">
                        <div class="card">
                            <img src="${pageContext.request.contextPath}${pet.imageUrl != null ? pet.imageUrl : '/static/images/default-pet.png'}"
                                alt="${pet.name}" class="card-img"
                                onerror="this.src='https://placehold.co/400x300?text=No+Image'">
                            <div class="card-body">
                                <h3 class="card-title">${pet.name} <span class="badge badge-info">${pet.breed}</span>
                                </h3>
                                <p class="card-text">
                                    ${pet.gender == 1 ? '♂ 公' : (pet.gender == 2 ? '♀ 母' : '未知性别')} |
                                    ${pet.age}个月 |
                                    ${pet.color}
                                </p>
                                <p class="card-text" style="color:#6b7280;font-size:0.9rem;height:45px;overflow:hidden">
                                    ${pet.personality}</p>
                                <div
                                    style="display:flex;justify-content:space-between;align-items:center;margin-top:15px">
                                    <span style="font-size:0.85rem;color:#9ca3af">👀 ${pet.viewCount}人浏览</span>
                                    <a href="${pageContext.request.contextPath}/pet/detail/${pet.id}"
                                        class="btn btn-primary" style="padding:8px 20px">查看详情</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${empty pageInfo.list}">
                    <div style="text-align:center;padding:50px;color:#6b7280">
                        <h3>🐶 暂无相关宠物信息</h3>
                        <p>换个筛选条件试试看吧</p>
                    </div>
                </c:if>

                <!-- 分页 -->
                <c:if test="${pageInfo.pages > 1}">
                    <div class="pagination">
                        <c:if test="${!pageInfo.isFirstPage}">
                            <a href="?page=${pageInfo.prePage}&species=${species}&keyword=${keyword}">上一页</a>
                        </c:if>
                        <c:forEach begin="1" end="${pageInfo.pages}" var="p">
                            <a href="?page=${p}&species=${species}&keyword=${keyword}"
                                class="${p == pageInfo.pageNum ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        <c:if test="${!pageInfo.isLastPage}">
                            <a href="?page=${pageInfo.nextPage}&species=${species}&keyword=${keyword}">下一页</a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </body>

        </html>