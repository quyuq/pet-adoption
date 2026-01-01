<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <title>宠物社区 - 宠物领养</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
            <style>
                .post-card {
                    background: white;
                    border-radius: 12px;
                    margin-bottom: 25px;
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                    overflow: hidden;
                }

                .post-header {
                    padding: 20px;
                    display: flex;
                    align-items: center;
                }

                .user-avatar {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    background: #e0e7ff;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-right: 15px;
                    color: #4f46e5;
                    font-weight: bold;
                }

                .post-content {
                    padding: 0 20px 20px;
                    color: #374151;
                    line-height: 1.6;
                    font-size: 1.05rem;
                }

                .post-image img {
                    width: 100%;
                    max-height: 500px;
                    object-fit: cover;
                }

                .post-footer {
                    padding: 15px 20px;
                    border-top: 1px solid #f3f4f6;
                    color: #6b7280;
                    font-size: 0.9rem;
                    display: flex;
                    justify-content: space-between;
                }

                .fab {
                    position: fixed;
                    bottom: 40px;
                    right: 40px;
                    width: 60px;
                    height: 60px;
                    background: var(--primary-color);
                    color: white;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.8rem;
                    box-shadow: 0 10px 20px rgba(99, 102, 241, 0.4);
                    cursor: pointer;
                    transition: all 0.3s;
                    text-decoration: none;
                }

                .fab:hover {
                    transform: scale(1.1);
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 宠物秀社区</h1>
                </header>

                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/" class="nav-link">返回首页</a>
                    <a href="${pageContext.request.contextPath}/pet/list" class="nav-link">浏览宠物</a>
                    <a href="${pageContext.request.contextPath}/community/index" class="nav-link active">社区动态</a>
                </nav>

                <div style="max-width: 700px; margin: 0 auto;">
                    <c:forEach items="${pageInfo.list}" var="post">
                        <div class="post-card">
                            <div class="post-header">
                                <div class="user-avatar">
                                    ${post.user.username.substring(0, 1).toUpperCase()}
                                </div>
                                <div>
                                    <div style="font-weight:600">${post.user.realName != null ? post.user.realName :
                                        post.user.username}</div>
                                    <div style="font-size:0.85rem;color:#9ca3af">${post.createTime}</div>
                                </div>
                                <c:if
                                    test="${loginUser != null && (loginUser.id == post.userId || loginUser.role == 0)}">
                                    <button onclick="deletePost(${post.id})" class="btn btn-danger"
                                        style="margin-left:auto;padding:5px 10px;font-size:0.8rem">删除</button>
                                </c:if>
                            </div>

                            <div class="post-content">
                                ${post.content}
                            </div>

                            <c:if test="${not empty post.imageUrl}">
                                <div class="post-image">
                                    <img src="${pageContext.request.contextPath}${post.imageUrl}" alt="Post Image">
                                </div>
                            </c:if>

                            <div class="post-footer">
                                <span>👀 ${post.viewCount} 浏览</span>
                                <span>暂无评论</span>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty pageInfo.list}">
                        <div style="text-align:center;padding:50px;color:#9ca3af">
                            快来发布第一条动态吧！
                        </div>
                    </c:if>
                </div>

                <a href="${pageContext.request.contextPath}/community/publish" class="fab" title="发布动态">+</a>
            </div>

            <script>
                function deletePost(id) {
                    if (confirm('确定要删除这条动态吗？')) {
                        $.post('${pageContext.request.contextPath}/community/delete', { id: id }, function (res) {
                            if (res.code === 200) {
                                alert('删除成功');
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