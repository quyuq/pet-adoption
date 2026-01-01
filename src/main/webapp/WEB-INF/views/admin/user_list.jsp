<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <title>用户管理 - 宠物领养</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 系统管理后台</h1>
                </header>

                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/admin/index" class="nav-link">后台首页</a>
                    <a href="${pageContext.request.contextPath}/admin/user/list" class="nav-link active"
                        style="background:var(--primary-color);color:white">用户管理</a>
                </nav>

                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px">
                    <h2>👥 注册用户管理</h2>
                </div>

                <div style="margin-bottom:20px">
                    <form action="${pageContext.request.contextPath}/admin/user/list" method="get"
                        style="display:flex;gap:10px">
                        <select name="role" class="select-input" style="width:150px">
                            <option value="">全部角色</option>
                            <option value="0" ${role==0 ? 'selected' : '' }>系统管理员</option>
                            <option value="1" ${role==1 ? 'selected' : '' }>收容所</option>
                            <option value="2" ${role==2 ? 'selected' : '' }>领养用户</option>
                        </select>
                        <input type="text" name="keyword" value="${keyword}" class="select-input" placeholder="搜索用户名或姓名"
                            style="width:300px">
                        <button type="submit" class="btn btn-primary">搜索</button>
                    </form>
                </div>

                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>用户名</th>
                            <th>真实姓名</th>
                            <th>联系电话</th>
                            <th>当前角色</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${pageInfo.list}" var="user">
                            <tr>
                                <td>${user.id}</td>
                                <td>${user.username}</td>
                                <td>${user.realName}</td>
                                <td>${user.phone}</td>
                                <td>
                                    <select onchange="updateRole(${user.id}, this.value)" class="form-control"
                                        style="width:auto;display:inline-block">
                                        <option value="0" ${user.role==0 ? 'selected' : '' }>系统管理员</option>
                                        <option value="1" ${user.role==1 ? 'selected' : '' }>收容所</option>
                                        <option value="2" ${user.role==2 ? 'selected' : '' }>领养用户</option>
                                    </select>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.status == 1}"><span class="badge badge-success">正常</span>
                                        </c:when>
                                        <c:otherwise><span class="badge badge-danger">已禁用</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.status == 1}">
                                            <button class="btn btn-danger"
                                                onclick="blacklistUser('${user.id}')">拉黑/禁用</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-success"
                                                onclick="updateStatus('${user.id}', 1)">启用</button>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty pageInfo.list}">
                    <div style="text-align:center;padding:40px;color:#9ca3af">暂无用户记录</div>
                </c:if>

                <!-- 分页 -->
                <div class="pagination">
                    <c:if test="${pageInfo.hasPreviousPage}">
                        <a href="${pageContext.request.contextPath}/admin/user/list?page=${pageInfo.prePage}&keyword=${keyword}&role=${role}"
                            class="page-link">上一页</a>
                    </c:if>
                    <c:forEach items="${pageInfo.navigatepageNums}" var="pageNum">
                        <a href="${pageContext.request.contextPath}/admin/user/list?page=${pageNum}&keyword=${keyword}&role=${role}"
                            class="page-link ${pageNum == pageInfo.pageNum ? 'active' : ''}">${pageNum}</a>
                    </c:forEach>
                    <c:if test="${pageInfo.hasNextPage}">
                        <a href="${pageContext.request.contextPath}/admin/user/list?page=${pageInfo.nextPage}&keyword=${keyword}&role=${role}"
                            class="page-link">下一页</a>
                    </c:if>
                </div>
            </div>

            <script>
                function updateRole(userId, role) {
                    if (confirm('确定要修改该用户的权限角色吗？')) {
                        $.post('${pageContext.request.contextPath}/admin/user/role', { userId: userId, role: role }, function (res) {
                            if (res.code === 200) {
                                alert('修改成功');
                                location.reload();
                            } else {
                                alert(res.message);
                            }
                        });
                    } else {
                        location.reload();
                    }
                }

                function updateStatus(userId, status) {
                    var action = status === 1 ? '启用' : '禁用';
                    if (confirm('确定要' + action + '该用户吗？')) {
                        $.post('${pageContext.request.contextPath}/admin/user/status', { userId: userId, status: status }, function (res) {
                            if (res.code === 200) {
                                alert(action + '成功');
                                location.reload();
                            } else {
                                alert(res.message);
                            }
                        });
                    }
                }

                function blacklistUser(userId) {
                    var reason = prompt("请输入禁用/拉黑原因:", "违规操作");
                    if (reason !== null) {
                        // 1. 先修改状态
                        $.post('${pageContext.request.contextPath}/admin/user/status', { userId: userId, status: 0 }, function (res) {
                            if (res.code === 200) {
                                // 2. 同步写入黑名单表
                                $.post('${pageContext.request.contextPath}/admin/blacklist/add', { userId: userId, reason: reason }, function (res2) {
                                    alert('用户已禁用并加入黑名单');
                                    location.reload();
                                });
                            } else {
                                alert(res.message);
                            }
                        });
                    }
                }
            </script>
        </body>

        </html>