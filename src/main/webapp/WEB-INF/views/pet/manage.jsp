<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>宠物管理 - 收容所后台</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <style>
                .admin-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 30px;
                }

                .action-bar {
                    background: white;
                    padding: 15px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    display: flex;
                    justify-content: space-between;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 宠物领养管理系统 - 收容所后台</h1>
                </header>

                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/" class="nav-link">返回首页</a>
                    <a href="${pageContext.request.contextPath}/pet/manage" class="nav-link active"
                        style="background:var(--primary-color);color:white">宠物管理</a>
                    <a href="${pageContext.request.contextPath}/adoption/manage" class="nav-link">领养审核</a>
                    <a href="${pageContext.request.contextPath}/user/profile" class="nav-link">个人中心</a>
                </nav>

                <div class="admin-header">
                    <h2>我的宠物列表</h2>
                    <a href="${pageContext.request.contextPath}/pet/edit" class="btn btn-success">
                        + 发布新宠物
                    </a>
                </div>

                <div class="action-bar">
                    <form action="${pageContext.request.contextPath}/pet/manage" method="get"
                        style="display:flex;gap:10px">
                        <input type="text" name="keyword" value="${keyword}" placeholder="搜索宠物名称" class="select-input"
                            style="width:250px">
                        <button type="submit" class="btn btn-primary">搜索</button>
                    </form>
                </div>

                <table class="table" style="background:white;border-radius:8px;overflow:hidden">
                    <thead>
                        <tr>
                            <th>图片</th>
                            <th>名称</th>
                            <th>品种</th>
                            <th>状态</th>
                            <th>浏览/申请</th>
                            <th>发布时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${pageInfo.list}" var="pet">
                            <tr>
                                <td>
                                    <img src="${pageContext.request.contextPath}${pet.imageUrl != null ? pet.imageUrl : '/static/images/default-pet.png'}"
                                        style="width:50px;height:50px;object-fit:cover;border-radius:4px"
                                        onerror="this.src='https://placehold.co/50?text=Pet'">
                                </td>
                                <td>${pet.name}</td>
                                <td>${pet.breed}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${pet.status == 0}"><span class="badge badge-success">可领养</span>
                                        </c:when>
                                        <c:when test="${pet.status == 1}"><span class="badge badge-warning">审核中</span>
                                        </c:when>
                                        <c:when test="${pet.status == 2}"><span class="badge badge-info">已领养</span>
                                        </c:when>
                                        <c:when test="${pet.status == 3}"><span class="badge badge-danger">医疗中</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>${pet.viewCount} / ${pet.applyCount}</td>
                                <td>${pet.createTime}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/pet/edit?id=${pet.id}"
                                        class="btn btn-secondary" style="padding:5px 10px;font-size:0.85rem">编辑</a>
                                    <button onclick="updateStatus(${pet.id}, ${pet.status})" class="btn btn-warning"
                                        style="padding:5px 10px;font-size:0.85rem">状态</button>
                                    <button onclick="deletePet(${pet.id})" class="btn btn-danger"
                                        style="padding:5px 10px;font-size:0.85rem">删除</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty pageInfo.list}">
                    <div style="text-align:center;padding:30px;color:#6b7280">暂无数据，快去添加吧</div>
                </c:if>

                <!-- 分页 -->
                <c:if test="${pageInfo.pages > 1}">
                    <div class="pagination">
                        <c:if test="${!pageInfo.isFirstPage}">
                            <a href="?page=${pageInfo.prePage}&keyword=${keyword}">上一页</a>
                        </c:if>
                        <c:forEach begin="1" end="${pageInfo.pages}" var="p">
                            <a href="?page=${p}&keyword=${keyword}"
                                class="${p == pageInfo.pageNum ? 'active' : ''}">${p}</a>
                        </c:forEach>
                        <c:if test="${!pageInfo.isLastPage}">
                            <a href="?page=${pageInfo.nextPage}&keyword=${keyword}">下一页</a>
                        </c:if>
                    </div>
                </c:if>
            </div>

            <script>
                function deletePet(id) {
                    if (confirm('确定要删除这只宠物吗？此操作无法撤销。')) {
                        fetch('${pageContext.request.contextPath}/pet/delete', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'id=' + id
                        })
                            .then(res => res.json())
                            .then(data => {
                                if (data.code === 200) {
                                    alert('删除成功');
                                    location.reload();
                                } else {
                                    alert(data.message);
                                }
                            });
                    }
                }

                function updateStatus(id, currentStatus) {
                    var status = prompt("请输入新状态码 (0-可领养, 2-已领养, 3-医疗中):", currentStatus);
                    if (status !== null) {
                        fetch('${pageContext.request.contextPath}/pet/status', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'id=' + id + '&status=' + status
                        })
                            .then(res => res.json())
                            .then(data => {
                                if (data.code === 200) {
                                    alert('状态更新成功');
                                    location.reload();
                                } else {
                                    alert(data.message);
                                }
                            });
                    }
                }
            </script>
        </body>

        </html>