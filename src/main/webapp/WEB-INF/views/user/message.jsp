<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <title>我的消息 - 宠物领养</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
            <style>
                .message-list {
                    background: white;
                    border-radius: 12px;
                    overflow: hidden;
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
                }

                .message-item {
                    padding: 20px;
                    border-bottom: 1px solid #f3f4f6;
                    transition: background 0.2s;
                    position: relative;
                }

                .message-item:hover {
                    background: #f9fafb;
                }

                .message-item.unread::before {
                    content: '';
                    position: absolute;
                    left: 0;
                    top: 0;
                    bottom: 0;
                    width: 4px;
                    background: var(--primary-color);
                }

                .message-time {
                    font-size: 0.85rem;
                    color: #9ca3af;
                    margin-bottom: 5px;
                }

                .message-content {
                    color: #374151;
                    line-height: 1.6;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 消息中心</h1>
                </header>

                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/" class="nav-link">返回首页</a>
                    <a href="${pageContext.request.contextPath}/user/profile" class="nav-link">个人中心</a>
                </nav>

                <div class="message-list">
                    <c:if test="${empty messages}">
                        <div style="text-align:center;padding:50px;color:#9ca3af">无消息记录</div>
                    </c:if>
                    <c:forEach items="${messages}" var="msg">
                        <div class="message-item ${msg.isRead == 0 ? 'unread' : ''}"
                            onclick="markRead(${msg.id}, this)">
                            <div class="message-time">${msg.createTime} <c:if test="${msg.isRead == 0}"><span
                                        class="badge badge-error">NEW</span></c:if>
                            </div>
                            <div class="message-content">${msg.content}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <script>
                function markRead(id, element) {
                    if ($(element).hasClass('unread')) {
                        $.post('${pageContext.request.contextPath}/message/read', { id: id }, function () {
                            $(element).removeClass('unread');
                            $(element).find('.badge').remove();
                        });
                    }
                }
            </script>
        </body>

        </html>