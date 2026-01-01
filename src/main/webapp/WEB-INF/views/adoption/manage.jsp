<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>领养审核 - 收容所后台</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
            <style>
                .audit-actions button {
                    margin-right: 5px;
                    padding: 5px 12px;
                    font-size: 0.9rem;
                }

                .detail-row {
                    display: none;
                    background: #f9fafb;
                }

                .detail-content {
                    padding: 20px;
                    display: grid;
                    grid-template-columns: 1fr 2fr;
                    gap: 20px;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 领养审核管理</h1>
                </header>

                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/pet/manage" class="nav-link">宠物管理</a>
                    <a href="${pageContext.request.contextPath}/adoption/manage" class="nav-link active"
                        style="background:var(--primary-color);color:white">领养审核</a>
                </nav>

                <div style="margin-bottom:20px;background:white;padding:15px;border-radius:8px">
                    <a href="?status=0" class="btn ${status == 0 ? 'btn-primary' : 'btn-secondary'}">待审核</a>
                    <a href="?status=1" class="btn ${status == 1 ? 'btn-primary' : 'btn-secondary'}">已通过</a>
                    <a href="?status=2" class="btn ${status == 2 ? 'btn-primary' : 'btn-secondary'}">已拒绝</a>
                </div>

                <table class="table" style="background:white;border-radius:8px">
                    <thead>
                        <tr>
                            <th>申请人</th>
                            <th>申请宠物</th>
                            <th>生活情况</th>
                            <th>养宠经验</th>
                            <th>申请时间</th>
                            <th>状态</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${pageInfo.list}" var="apply">
                            <tr>
                                <td>${apply.user.realName} <br><span
                                        style="font-size:0.8rem;color:#9ca3af">${apply.user.phone}</span></td>
                                <td>${apply.pet.name}</td>
                                <td>${apply.livingCondition}</td>
                                <td>${apply.experience}</td>
                                <td>${apply.createTime}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${apply.status == 0}"><span class="badge badge-warning">⏳
                                                待审核</span></c:when>
                                        <c:when test="${apply.status == 1}"><span class="badge badge-primary">✅
                                                初审通过</span></c:when>
                                        <c:when test="${apply.status == 2}"><span class="badge badge-info">🏠 家访中</span>
                                        </c:when>
                                        <c:when test="${apply.status == 3}"><span class="badge badge-success">✨
                                                审核通过</span></c:when>
                                        <c:when test="${apply.status == 4}"><span class="badge badge-danger">❌
                                                已拒绝</span></c:when>
                                    </c:choose>
                                </td>
                                <td class="audit-actions">
                                    <button class="btn btn-info" onclick="$('#detail-${apply.id}').toggle()">详情</button>
                                    <c:choose>
                                        <c:when test="${apply.status == 0}">
                                            <button class="btn btn-success"
                                                onclick="audit(${apply.id}, 1)">初审通过</button>
                                            <button class="btn btn-danger" onclick="audit(${apply.id}, 4)">拒绝</button>
                                        </c:when>
                                        <c:when test="${apply.status == 1}">
                                            <button class="btn btn-primary"
                                                onclick="audit(${apply.id}, 2)">开始家访</button>
                                            <button class="btn btn-danger" onclick="audit(${apply.id}, 4)">拒绝</button>
                                        </c:when>
                                        <c:when test="${apply.status == 2}">
                                            <button class="btn btn-success"
                                                onclick="audit(${apply.id}, 3)">终审通过</button>
                                            <button class="btn btn-danger" onclick="audit(${apply.id}, 4)">拒绝</button>
                                        </c:when>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr id="detail-${apply.id}" class="detail-row">
                                <td colspan="7">
                                    <div class="detail-content">
                                        <div>
                                            <h4>申请理由：</h4>
                                            <p>${apply.applyReason}</p>
                                        </div>
                                        <div style="border-left:1px solid #e5e7eb;padding-left:20px">
                                            <h4>申请人信息补充：</h4>
                                            <p>现居地：${apply.user.address}</p>
                                            <p>其他补充：${apply.experience}</p>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <script>
                function audit(id, status) {
                    var action = '';
                    var reason = '';
                    switch (status) {
                        case 1: action = '初审通过'; break;
                        case 2: action = '开始家访'; break;
                        case 3: action = '终审通过'; break;
                        case 4: action = '拒绝'; break;
                    }

                    if (status == 4) {
                        reason = prompt('请输入拒绝原因（选填）：');
                        if (reason === null) return; // 取消操作
                    }

                    if (confirm('确定要[' + action + ']这条申请吗？')) {
                        $.post('${pageContext.request.contextPath}/adoption/audit', {
                            id: id,
                            status: status,
                            reason: reason
                        }, function (res) {
                            if (res.code === 200) {
                                alert('操作成功');
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