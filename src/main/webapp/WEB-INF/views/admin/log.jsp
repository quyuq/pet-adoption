<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <title>系统日志 - 宠物领养</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 系统管理后台</h1>
                </header>

                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/admin/index" class="nav-link">后台首页</a>
                    <a href="${pageContext.request.contextPath}/admin/log/list" class="nav-link active"
                        style="background:var(--primary-color);color:white">操作日志</a>
                </nav>

                <div style="margin-bottom:20px">
                    <form action="${pageContext.request.contextPath}/admin/log/list" method="get"
                        style="display:flex;gap:10px">
                        <input type="text" name="keyword" value="${keyword}" class="select-input" placeholder="搜索用户名或操作"
                            style="width:300px">
                        <button type="submit" class="btn btn-primary">搜索</button>
                    </form>
                </div>

                <table class="table" style="background:white;border-radius:8px">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>操作人</th>
                            <th>操作类型</th>
                            <th>调用方法</th>
                            <th>参数摘要</th>
                            <th>IP地址</th>
                            <th>操作时间</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${pageInfo.list}" var="log">
                            <tr>
                                <td>${log.id}</td>
                                <td>${log.username}</td>
                                <td>${log.operation}</td>
                                <td style="font-size:0.85rem;color:#6b7280">${log.method}</td>
                                <td title="${log.params}">
                                    <div
                                        style="width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-size:0.85rem;color:#6b7280">
                                        ${log.params}
                                    </div>
                                </td>
                                <td>${log.ip}</td>
                                <td>${log.createTime}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- 分页 -->
                <div style="margin-top:20px;text-align:center">
                    <c:if test="${pageInfo.hasPreviousPage}">
                        <a href="?page=${pageInfo.prePage}&keyword=${keyword}" class="btn">上一页</a>
                    </c:if>
                    <span style="margin:0 10px">第 ${pageInfo.pageNum} / ${pageInfo.pages} 页</span>
                    <c:if test="${pageInfo.hasNextPage}">
                        <a href="?page=${pageInfo.nextPage}&keyword=${keyword}" class="btn">下一页</a>
                    </c:if>
                </div>
            </div>
        </body>

        </html>