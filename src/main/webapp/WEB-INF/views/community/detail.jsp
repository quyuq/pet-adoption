<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>帖子详情 - 宠物社区</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <style>
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
            color: #222;
            background: linear-gradient(135deg,#667eea 0%,#764ba2 100%);
            -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale;
            margin:0; padding:40px 20px;
        }
        .wrap { max-width:920px; margin:0 auto; }
        .card { background:#fff; border-radius:12px; padding:28px; box-shadow:0 12px 30px rgba(16,24,40,0.25); }
        a.back-in-card { color:#6b7280; display:inline-block; margin-bottom:12px; text-decoration:none; font-size:13px }
        h1.title { margin:0 0 8px; font-size:22px; color:#111; font-weight:700; }
        .meta { color:#6b7280; font-size:13px; margin-bottom:18px; }
        .content { font-size:16px; line-height:1.9; color:#333; margin-bottom:18px; white-space:pre-wrap; }
        .post-image img { width:100%; border-radius:8px; max-height:520px; object-fit:cover; display:block; margin-bottom:18px; }
        .actions { display:flex; align-items:center; gap:12px; margin-bottom:16px; }
        .btn-like { background:#fff; border:1px solid #e6e6e6; padding:10px 14px; border-radius:8px; cursor:pointer; font-weight:600; }
        .btn-like:hover { box-shadow:0 6px 18px rgba(99,102,241,0.18); }
        .like-count { font-weight:700; color:#111; margin-right:6px; }
        .divider { height:1px; background:linear-gradient(90deg,transparent,#e5e7eb,transparent); margin:22px 0; }
        .comments { color:#4b5563; font-size:14px; }
        @media (max-width:640px){ .card{padding:18px} h1.title{font-size:18px} }
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <a class="back-in-card" href="${pageContext.request.contextPath}/community/index">← 返回社区</a>
        <h1 class="title">帖子详情</h1>
        <div class="meta">由
            <c:choose>
                <c:when test="${not empty post.user.realName}">${post.user.realName}</c:when>
                <c:otherwise>${post.user.username}</c:otherwise>
            </c:choose>
            发布于 ${post.createTime}
        </div>

        <div class="content">${post.content}</div>

        <c:if test="${not empty post.imageUrl}">
            <div class="post-image"><img src="${pageContext.request.contextPath}${post.imageUrl}" alt="帖子图片"></div>
        </c:if>

        <div class="actions">
            <div><span class="like-count" id="like-count">${post.viewCount}</span> 赞</div>
            <button id="like-btn" class="btn-like">点赞</button>
        </div>

        <div class="divider"></div>

        <div class="comments">
            <h3 style="margin-top:0;margin-bottom:10px;">评论区</h3>
            <p>暂无评论功能，敬请期待。</p>
        </div>
    </div>
</div>

<script>
    $(function(){
        $('#like-btn').click(function(){
            $.post('${pageContext.request.contextPath}/community/like', {id: ${post.id}}, function(res){
                if(res.code === 200){
                    var cnt = parseInt($('#like-count').text()) || 0;
                    $('#like-count').text(cnt + 1);
                } else {
                    alert(res.message || '操作失败');
                }
            }).fail(function(){ alert('网络或服务器错误，点赞失败。'); });
        });
    });
</script>
</body>
</html>