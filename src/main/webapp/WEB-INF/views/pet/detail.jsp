<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${pet.name}的详情 - 宠物领养</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <style>
                .detail-container {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 40px;
                    background: white;
                    padding: 40px;
                    border-radius: 16px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                }

                .pet-gallery img {
                    width: 100%;
                    height: 400px;
                    object-fit: cover;
                    border-radius: 12px;
                }

                .pet-info h2 {
                    font-size: 2.5rem;
                    margin-bottom: 20px;
                    color: #1f2937;
                }

                .tag-list {
                    display: flex;
                    gap: 10px;
                    margin-bottom: 25px;
                }

                .info-grid {
                    display: grid;
                    grid-template-columns: repeat(2, 1fr);
                    gap: 20px;
                    margin-bottom: 30px;
                    background: #f9fafb;
                    padding: 20px;
                    border-radius: 12px;
                }

                .info-item label {
                    display: block;
                    color: #6b7280;
                    font-size: 0.9rem;
                    margin-bottom: 5px;
                }

                .info-item span {
                    font-weight: 600;
                    color: #1f2937;
                    font-size: 1.1rem;
                }

                .section-title {
                    font-size: 1.3rem;
                    color: #374151;
                    margin-bottom: 15px;
                    padding-bottom: 10px;
                    border-bottom: 2px solid #e5e7eb;
                }

                .action-box {
                    margin-top: 40px;
                    padding: 20px;
                    background: #f3f4f6;
                    border-radius: 12px;
                    text-align: center;
                }

                .health-badge {
                    display: inline-flex;
                    align-items: center;
                    padding: 6px 12px;
                    border-radius: 20px;
                    background: #ecfdf5;
                    color: #059669;
                    font-size: 0.9rem;
                    margin-right: 10px;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 宠物领养管理系统</h1>
                </header>

                <a href="${pageContext.request.contextPath}/pet/list" class="btn"
                    style="margin-bottom:20px;display:inline-block">← 返回列表</a>

                <div class="detail-container">
                    <div class="pet-gallery">
                        <img src="${pageContext.request.contextPath}${pet.imageUrl != null ? pet.imageUrl : '/static/images/default-pet.png'}"
                            alt="${pet.name}" onerror="this.src='https://placehold.co/600x400?text=No+Image'">
                    </div>

                    <div class="pet-info">
                        <h2>${pet.name}</h2>
                        <div class="tag-list">
                            <span class="badge badge-info">${pet.species}</span>
                            <span class="badge badge-warning">${pet.breed}</span>
                            <c:if test="${pet.isSterilized == 1}">
                                <span class="health-badge">✓ 已绝育</span>
                            </c:if>
                        </div>

                        <div class="info-grid">
                            <div class="info-item">
                                <label>性别</label>
                                <span>${pet.gender == 1 ? '♂ 公' : (pet.gender == 2 ? '♀ 母' : '未知')}</span>
                            </div>
                            <div class="info-item">
                                <label>年龄</label>
                                <span>${pet.age} 个月</span>
                            </div>
                            <div class="info-item">
                                <label>体重</label>
                                <span>${pet.weight} KG</span>
                            </div>
                            <div class="info-item">
                                <label>毛色</label>
                                <span>${pet.color}</span>
                            </div>
                        </div>

                        <div style="margin-bottom:30px">
                            <h3 class="section-title">性格特点</h3>
                            <p style="color:#4b5563;line-height:1.7">${pet.personality}</p>
                        </div>

                        <div class="action-box">
                            <c:choose>
                                <c:when test="${not empty loginUser}">
                                    <c:if test="${loginUser.role == 2}"> <!-- 领养用户 -->
                                        <a href="${pageContext.request.contextPath}/adoption/apply/${pet.id}"
                                            class="btn btn-primary btn-lg"
                                            style="display:block;width:100%;padding:15px;font-size:1.2rem;text-align:center">
                                            ❤️ 申请领养 ${pet.name}
                                        </a>
                                        <p style="margin-top:10px;font-size:0.9rem;color:#6b7280">已有 ${pet.applyCount}
                                            人申请</p>
                                    </c:if>
                                    <c:if test="${loginUser.role != 2}">
                                        <p>管理员无法申请领养</p>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/user/login" class="btn btn-primary"
                                        style="width:100%">登录后申请领养</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </body>

        </html>