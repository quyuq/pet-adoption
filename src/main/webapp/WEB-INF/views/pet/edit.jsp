<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${empty pet ? '发布新宠物' : '编辑宠物'} - 宠物管理</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <style>
                .edit-container {
                    max-width: 800px;
                    margin: 40px auto;
                    background: white;
                    padding: 40px;
                    border-radius: 16px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                }

                .form-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 20px;
                }

                .upload-area {
                    border: 2px dashed #d1d5db;
                    border-radius: 8px;
                    padding: 20px;
                    text-align: center;
                    cursor: pointer;
                    transition: all 0.3s;
                    margin-bottom: 20px;
                }

                .upload-area:hover {
                    border-color: var(--primary-color);
                    background: #fdfdfd;
                }

                .preview-img {
                    max-height: 200px;
                    border-radius: 8px;
                    margin-top: 10px;
                    display: none;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 宠物管理系统</h1>
                </header>

                <div class="edit-container">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:30px">
                        <h2>${empty pet ? '📸 发布新宠物' : '📝 编辑宠物信息'}</h2>
                        <a href="${pageContext.request.contextPath}/pet/manage" class="btn btn-secondary">取消返回</a>
                    </div>

                    <form id="petForm">
                        <input type="hidden" name="id" value="${pet.id}">
                        <input type="hidden" id="imageUrl" name="imageUrl" value="${pet.imageUrl}">

                        <div class="form-group">
                            <label>宠物照片</label>
                            <div class="upload-area" onclick="document.getElementById('fileInput').click()">
                                <p>点击此处上传照片</p>
                                <input type="file" id="fileInput" style="display:none" accept="image/*"
                                    onchange="uploadImage(this)">
                                <img id="preview" src="${pageContext.request.contextPath}${pet.imageUrl}"
                                    class="preview-img" style="${not empty pet.imageUrl ? 'display:block' : ''}">
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label>宠物昵称 *</label>
                                <input type="text" name="name" class="form-control" value="${pet.name}" required>
                            </div>
                            <div class="form-group">
                                <label>所属物种 *</label>
                                <select name="species" class="form-control" required>
                                    <option value="猫" ${pet.species=='猫' ? 'selected' : '' }>猫</option>
                                    <option value="狗" ${pet.species=='狗' ? 'selected' : '' }>狗</option>
                                    <option value="其他" ${pet.species=='其他' ? 'selected' : '' }>其他</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>品种</label>
                                <input type="text" name="breed" class="form-control" value="${pet.breed}">
                            </div>
                            <div class="form-group">
                                <label>年龄 (月)</label>
                                <input type="number" name="age" class="form-control" value="${pet.age}">
                            </div>
                            <div class="form-group">
                                <label>性别</label>
                                <select name="gender" class="form-control">
                                    <option value="0" ${pet.gender==0 ? 'selected' : '' }>未知</option>
                                    <option value="1" ${pet.gender==1 ? 'selected' : '' }>公</option>
                                    <option value="2" ${pet.gender==2 ? 'selected' : '' }>母</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>体重 (kg)</label>
                                <input type="number" step="0.1" name="weight" class="form-control"
                                    value="${pet.weight}">
                            </div>
                            <div class="form-group">
                                <label>毛色</label>
                                <input type="text" name="color" class="form-control" value="${pet.color}">
                            </div>
                            <div class="form-group">
                                <label>绝育情况</label>
                                <select name="isSterilized" class="form-control">
                                    <option value="0" ${pet.isSterilized==0 ? 'selected' : '' }>未绝育</option>
                                    <option value="1" ${pet.isSterilized==1 ? 'selected' : '' }>已绝育</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>当前状态 *</label>
                                <select name="status" class="form-control" required>
                                    <option value="0" ${pet.status==0 ? 'selected' : '' }>可领养</option>
                                    <option value="2" ${pet.status==2 ? 'selected' : '' }>已领养</option>
                                    <option value="3" ${pet.status==3 ? 'selected' : '' }>医疗中</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>性格特点及详细描述 *</label>
                            <textarea name="personality" class="form-control" rows="5"
                                required>${pet.personality}</textarea>
                        </div>

                        <div style="margin-top:30px">
                            <button type="submit" class="btn btn-primary" style="width:100%;padding:15px">保存发布</button>
                        </div>
                    </form>
                </div>
            </div>

            <script>
                function uploadImage(input) {
                    if (input.files && input.files[0]) {
                        var formData = new FormData();
                        formData.append('file', input.files[0]);

                        fetch('${pageContext.request.contextPath}/pet/upload', {
                            method: 'POST',
                            body: formData
                        })
                            .then(res => res.json())
                            .then(data => {
                                if (data.code === 200) {
                                    document.getElementById('imageUrl').value = data.data;
                                    var preview = document.getElementById('preview');
                                    preview.src = '${pageContext.request.contextPath}' + data.data;
                                    preview.style.display = 'block';
                                } else {
                                    alert('上传失败: ' + data.message);
                                }
                            });
                    }
                }

                document.getElementById('petForm').addEventListener('submit', function (e) {
                    e.preventDefault();
                    var formData = new FormData(this);

                    fetch('${pageContext.request.contextPath}/pet/save', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: new URLSearchParams(formData).toString()
                    })
                        .then(res => res.json())
                        .then(data => {
                            if (data.code === 200) {
                                alert('保存成功！');
                                window.location.href = '${pageContext.request.contextPath}/pet/manage';
                            } else {
                                alert('保存失败: ' + data.message);
                            }
                        });
                });
            </script>
        </body>

        </html>