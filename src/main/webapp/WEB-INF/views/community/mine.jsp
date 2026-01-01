<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <title>我的发布 - 宠物社区</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <style>
        .post-card { background: white; border-radius: 12px; margin-bottom: 25px; box-shadow: 0 4px 6px -1px rgba(0,0,0,.1); overflow: hidden; }
        .post-header { padding: 20px; display:flex; align-items:center }
        .user-avatar { width:40px; height:40px; border-radius:50%; background:#e0e7ff; display:flex; align-items:center; justify-content:center; margin-right:15px; color:#4f46e5; font-weight:bold }
        .post-content { padding: 0 20px 20px; color:#374151; line-height:1.6; font-size:1.05rem }
        .post-image img { width:100%; max-height:500px; object-fit:cover }
        .post-footer { padding:15px 20px; border-top:1px solid #f3f4f6; color:#6b7280; font-size:0.9rem; display:flex; justify-content:space-between }
    </style>
</head>

<body>
    <div class="container">
        <header class="header">
            <h1>🐾 我的发布</h1>
        </header>

        <nav class="nav">
            <a href="${pageContext.request.contextPath}/" class="nav-link">返回首页</a>
            <a href="${pageContext.request.contextPath}/community/index" class="nav-link">社区动态</a>
            <a href="${pageContext.request.contextPath}/community/publish" class="nav-link">发布动态</a>
        </nav>

        <div style="max-width:700px;margin:0 auto;">
            <c:forEach items="${pageInfo.list}" var="post">
                <div class="post-card">
                    <div class="post-header">
                        <div class="user-avatar">${post.user.username.substring(0,1).toUpperCase()}</div>
                        <div>
                            <div style="font-weight:600">${post.user.realName != null ? post.user.realName : post.user.username}</div>
                            <div style="font-size:0.85rem;color:#9ca3af">${post.createTime}</div>
                        </div>
                        <button onclick="deletePost(${post.id})" class="btn btn-danger" style="margin-left:auto;padding:5px 10px;font-size:0.8rem">删除</button>
                    </div>

                    <div class="post-content">
                        <a href="${pageContext.request.contextPath}/community/detail/${post.id}" style="color:inherit;text-decoration:none">${post.content}</a>
                    </div>

                    <c:if test="${not empty post.imageUrl}">
                        <div class="post-image"><img src="${pageContext.request.contextPath}${post.imageUrl}" alt="Post Image"></div>
                    </c:if>

                    <div class="post-footer">
                        <span>👍 <span id="like-count-${post.id}">${post.viewCount}</span> 赞</span>
                        <span>暂无评论</span>
                        <button id="like-btn-${post.id}" class="btn" style="margin-left:8px;padding:4px 8px">点赞</button>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty pageInfo.list}">
                <div style="text-align:center;padding:50px;color:#9ca3af">你还没有发布任何动态，快去发布吧！</div>
            </c:if>
        </div>
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
        $(function(){
            $('[id^="like-btn-"]').click(function(){
                var id = this.id.replace('like-btn-','');
                $.post('${pageContext.request.contextPath}/community/like', {id: id}, function(res){
                    if(res.code === 200){
                        var cntEl = $('#like-count-' + id);
                        var cnt = parseInt(cntEl.text()) || 0;
                        cntEl.text(cnt + 1);
                    } else {
                        alert(res.message);
                    }
                });
            });
        });
    </script>
</body>

</html>