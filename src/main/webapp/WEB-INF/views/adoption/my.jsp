<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>我的领养申请 - 宠物领养</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <style>
                .status-badge {
                    padding: 4px 10px;
                    border-radius: 12px;
                    font-size: 0.85rem;
                }

                .status-0 {
                    background: #fef3c7;
                    color: #d97706;
                }

                /* 审核中 */
                .status-1 {
                    background: #d1fae5;
                    color: #059669;
                }

                /* 通过 */
                .status-2 {
                    background: #fee2e2;
                    color: #dc2626;
                }

                /* 拒绝 */

                .timeline {
                    position: relative;
                    padding-left: 20px;
                    border-left: 2px solid #e5e7eb;
                    margin-top: 10px;
                }

                .timeline-item {
                    position: relative;
                    margin-bottom: 20px;
                }

                .timeline-item::before {
                    content: '';
                    position: absolute;
                    left: -26px;
                    top: 5px;
                    width: 10px;
                    height: 10px;
                    border-radius: 50%;
                    background: var(--primary-color);
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 宠物领养管理系统</h1>
                </header>

                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/" class="nav-link">返回首页</a>
                    <a href="${pageContext.request.contextPath}/pet/list" class="nav-link">浏览宠物</a>
                    <a href="${pageContext.request.contextPath}/user/profile" class="nav-link active">个人中心</a>
                </nav>

                <div style="background:white;padding:30px;border-radius:12px;box-shadow:0 4px 10px rgba(0,0,0,0.05)">
                    <h2 style="margin-bottom:20px">我的领养申请记录</h2>

                    <c:if test="${empty pageInfo.list}">
                        <div style="text-align:center;padding:40px;color:#6b7280">
                            <p>您还没有提交过领养申请哦</p>
                            <a href="${pageContext.request.contextPath}/pet/list" class="btn btn-primary">去看看可爱的宠物</a>
                        </div>
                    </c:if>

                    <div class="card-grid" style="grid-template-columns:1fr">
                        <c:forEach items="${pageInfo.list}" var="apply">
                            <div class="card" style="display:flex;padding:20px;gap:20px;align-items:flex-start">
                                <img src="${pageContext.request.contextPath}${apply.pet.imageUrl}"
                                    style="width:120px;height:120px;object-fit:cover;border-radius:8px">

                                <div style="flex:1">
                                    <div
                                        style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px">
                                        <h3 style="margin:0">申请领养：${apply.pet.name}</h3>
                                        <span class="status-badge status-${apply.status}">
                                            <c:choose>
                                                <c:when test="${apply.status == 0}">⏳ 审核中</c:when>
                                                <c:when test="${apply.status == 1}">✅ 初审通过</c:when>
                                                <c:when test="${apply.status == 2}">🏠 家访中</c:when>
                                                <c:when test="${apply.status == 3}">✨ 审核通过</c:when>
                                                <c:when test="${apply.status == 4}">❌ 已拒绝</c:when>
                                            </c:choose>
                                        </span>
                                    </div>

                                    <p style="color:#6b7280;font-size:0.9rem">申请时间：${apply.createTime}</p>
                                    <div
                                        style="margin-top:10px;background:#f9fafb;padding:12px;border-radius:8px;border-left:4px solid #e5e7eb">
                                        <p style="margin:0;font-size:0.95rem"><strong>申请理由：</strong>${apply.applyReason}
                                        </p>
                                        <p style="margin:5px 0 0;font-size:0.9rem;color:#6b7280">
                                            <strong>居住条件：</strong>${apply.livingCondition} |
                                            <strong>养宠经验：</strong>${apply.experience}
                                        </p>
                                    </div>

                                    <c:if test="${not empty apply.rejectReason}">
                                        <div
                                            style="margin-top:15px;padding:12px;background:#fff1f2;color:#e11d48;border-radius:8px;border:1px solid #ffe4e6">
                                            <strong>📋 审核意见：</strong>${apply.rejectReason}
                                        </div>
                                    </c:if>

                                    <c:if test="${apply.status == 1}">
                                        <div
                                            style="margin-top:15px;padding:12px;background:#ecfdf5;color:#047857;border-radius:8px">
                                            🎉 恭喜！您的申请已通过初审。工作人员将安排家访（${loginUser.phone}），请保持电话畅通。
                                        </div>
                                    </c:if>
                                    <c:if test="${apply.status == 2}">
                                        <div
                                            style="margin-top:15px;padding:12px;background:#eff6ff;color:#1d4ed8;border-radius:8px">
                                            🏠 正在家访中，请配合工作人员进行实地考察，谢谢您的耐心等待。
                                        </div>
                                    </c:if>
                                    <c:if test="${apply.status == 3}">
                                        <div
                                            style="margin-top:15px;padding:12px;background:#f0fdf4;color:#16a34a;border-radius:8px;font-weight:600">
                                            🎊 审核已全部通过！恭喜您成为领养人，请前往收容所办理领养手续并接回您的新伙伴。
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- 分页代码略 -->
                </div>
            </div>
        </body>

        </html>