<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <title>黑名单管理 - 宠物领养</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
            <style>
                .blacklist-table {
                    background: white;
                    border-radius: 8px;
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                }

                .add-box {
                    background: white;
                    padding: 20px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    display: none;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 系统管理后台</h1>
                </header>

                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/admin/index" class="nav-link">后台首页</a>
                    <a href="${pageContext.request.contextPath}/admin/blacklist/list" class="nav-link active"
                        style="background:var(--primary-color);color:white">黑名单管理</a>
                </nav>

                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px">
                    <h2>⛔ 失信黑名单管理</h2>
                    <button class="btn btn-danger" onclick="$('#addBox').slideToggle()">+ 添加黑名单</button>
                </div>

                <div id="addBox" class="add-box">
                    <h3>添加用户至黑名单</h3>
                    <form id="addForm" style="display:flex;gap:15px;align-items:flex-end">
                        <div style="flex:1">
                            <label>用户ID</label>
                            <input type="number" name="userId" class="form-control" required placeholder="请输入用户ID">
                        </div>
                        <div style="flex:3">
                            <label>拉黑原因</label>
                            <input type="text" name="reason" class="form-control" required placeholder="如：多次弃养、虐待动物等">
                        </div>
                        <button type="submit" class="btn btn-danger">确认拉黑</button>
                    </form>
                </div>

                <div style="margin-bottom:20px">
                    <form action="${pageContext.request.contextPath}/admin/blacklist/list" method="get"
                        style="display:flex;gap:10px">
                        <input type="text" name="keyword" value="${keyword}" class="select-input" placeholder="搜索用户名或姓名"
                            style="width:300px">
                        <button type="submit" class="btn btn-primary">搜索</button>
                    </form>
                </div>

                <table class="table blacklist-table">
                    <thead>
                        <tr>
                            <th>用户ID</th>
                            <th>用户名</th>
                            <th>真实姓名</th>
                            <th>联系电话</th>
                            <th>拉黑原因</th>
                            <th>拉黑时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${pageInfo.list}" var="item">
                            <tr>
                                <td>${item.user.id}</td>
                                <td>${item.user.username}</td>
                                <td>${item.user.realName}</td>
                                <td>${item.user.phone}</td>
                                <td style="color:#dc2626">${item.reason}</td>
                                <td>${item.createTime}</td>
                                <td>
                                    <button class="btn btn-success"
                                        onclick="removeFromBlacklist(${item.id})">解除拉黑</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty pageInfo.list}">
                    <div style="text-align:center;padding:40px;color:#9ca3af">暂无黑名单记录</div>
                </c:if>
            </div>

            <script>
                $('#addForm').submit(function (e) {
                    e.preventDefault();
                    $.post('${pageContext.request.contextPath}/admin/blacklist/add', $(this).serialize(), function (res) {
                        if (res.code === 200) {
                            alert('添加成功');
                            location.reload();
                        } else {
                            alert(res.message);
                        }
                    });
                });

                function removeFromBlacklist(id) {
                    if (confirm('确定要解除该用户的拉黑状态吗？')) {
                        $.post('${pageContext.request.contextPath}/admin/blacklist/remove', { id: id }, function (res) {
                            if (res.code === 200) {
                                alert('解除成功');
                                location.reload();
                            } else {
                                alert(res.message);
                            }
                        });
                    }
                }
            </script>
        </body>

        </html>