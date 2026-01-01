<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <title>发布动态 - 宠物社区</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
        <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <style>
            .publish-container {
                max-width: 600px;
                margin: 40px auto;
                background: white;
                padding: 40px;
                border-radius: 16px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            }

            .upload-box {
                border: 2px dashed #e5e7eb;
                border-radius: 12px;
                padding: 30px;
                text-align: center;
                cursor: pointer;
                margin-bottom: 20px;
                transition: all 0.3s;
            }

            .upload-box:hover {
                border-color: var(--primary-color);
                background: #fdfdfd;
            }

            .preview-img {
                max-height: 200px;
                border-radius: 8px;
                display: none;
                margin-top: 15px;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <header class="header">
                <h1>🐾 发布动态</h1>
            </header>

            <div class="publish-container">
                <form id="publishForm">
                    <input type="hidden" name="imageUrl" id="imageUrl">

                    <div class="form-group">
                        <label>分享你的宠物故事</label>
                        <textarea name="content" class="form-control" rows="6" placeholder="今天发生了什么有趣的事情..."
                            required></textarea>
                    </div>

                    <div class="form-group">
                        <label>配图（可选）</label>
                        <div class="upload-box" onclick="$('#fileInput').click()">
                            <div style="font-size:2rem;margin-bottom:10px">📷</div>
                            <p>点击上传图片</p>
                            <input type="file" id="fileInput" style="display:none" accept="image/*"
                                onchange="uploadImage(this)">
                            <img id="preview" class="preview-img">
                        </div>
                    </div>

                    <div style="display:flex;gap:15px">
                        <a href="${pageContext.request.contextPath}/community/index" class="btn btn-secondary"
                            style="flex:1;text-align:center">取消</a>
                        <button type="submit" class="btn btn-primary" style="flex:2">发布</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function uploadImage(input) {
                if (input.files && input.files[0]) {
                    var formData = new FormData();
                    formData.append('file', input.files[0]);

                    $.ajax({
                        url: '${pageContext.request.contextPath}/community/upload',
                        type: 'POST',
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function (res) {
                            if (res.code === 200) {
                                $('#imageUrl').val(res.data);
                                $('#preview').attr('src', '${pageContext.request.contextPath}' + res.data).show();
                            } else {
                                alert(res.message);
                            }
                        }
                    });
                }
            }

            $('#publishForm').submit(function (e) {
                e.preventDefault();
                $.post('${pageContext.request.contextPath}/community/publish', $(this).serialize(), function (res) {
                    if (res.code === 200) {
                        alert('发布成功！');
                        window.location.href = '${pageContext.request.contextPath}/community/index';
                    } else {
                        alert(res.message);
                    }
                });
            });
        </script>
    </body>

    </html>