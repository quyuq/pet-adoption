<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="zh-CN">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>申请领养 - ${pet.name}</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
            <style>
                .apply-container {
                    max-width: 800px;
                    margin: 40px auto;
                    background: white;
                    padding: 40px;
                    border-radius: 16px;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                }

                .pet-summary {
                    display: flex;
                    align-items: center;
                    background: #f9fafb;
                    padding: 20px;
                    border-radius: 12px;
                    margin-bottom: 30px;
                }

                .pet-summary img {
                    width: 80px;
                    height: 80px;
                    object-fit: cover;
                    border-radius: 8px;
                    margin-right: 20px;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <h1>🐾 宠物领养申请</h1>
                </header>

                <div class="apply-container">
                    <h2 style="margin-bottom:20px;color:#1f2937">填写领养申请表</h2>

                    <div class="pet-summary">
                        <img src="${pageContext.request.contextPath}${pet.imageUrl != null ? pet.imageUrl : '/static/images/default-pet.png'}"
                            alt="${pet.name}">
                        <div>
                            <h3 style="margin:0 0 5px 0">${pet.name}</h3>
                            <p style="margin:0;color:#6b7280">${pet.breed} | ${pet.age}个月 | ${pet.gender == 1 ? '公' :
                                '母'}</p>
                        </div>
                    </div>

                    <form id="applyForm">
                        <input type="hidden" name="petId" value="${pet.id}">

                        <div class="form-group">
                            <label>是否有养宠经验 *</label>
                            <select name="experience" class="form-control" required>
                                <option value="">请选择</option>
                                <option value="无经验">我是新手，无养宠经验</option>
                                <option value="有经验">有经验，目前没有宠物</option>
                                <option value="正在养">家里已有其他宠物</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>目前的住房情况 *</label>
                            <select name="housingCondition" class="form-control" required>
                                <option value="">请选择</option>
                                <option value="自有住房">自有住房</option>
                                <option value="整租">整租</option>
                                <option value="合租">合租（已征得室友同意）</option>
                                <option value="其他">其他</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>月收入范围 *</label>
                            <select name="income" class="form-control" required>
                                <option value="">请选择</option>
                                <option value="3000以下">3000以下</option>
                                <option value="3000-5000">3000-5000</option>
                                <option value="5000-10000">5000-10000</option>
                                <option value="10000以上">10000以上</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>是否已拥有其他宠物</label>
                            <div style="margin-top:10px">
                                <label style="display:inline-block;margin-right:20px;font-weight:normal">
                                    <input type="radio" name="hasPet" value="0" checked> 没有
                                </label>
                                <label style="display:inline-block;font-weight:normal">
                                    <input type="radio" name="hasPet" value="1"> 有
                                </label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>申请理由及想对我们说的话 *</label>
                            <textarea name="reason" class="form-control" rows="5"
                                placeholder="请详细描述您的领养动机、家庭成员态度以及对未来的规划..." required></textarea>
                        </div>

                        <div class="form-group" style="margin-top:20px">
                            <label>
                                <input type="checkbox" required> 我承诺：科学喂养，适龄绝育，有病就医，不离不弃。
                            </label>
                        </div>

                        <button type="submit" class="btn btn-primary"
                            style="width:100%;margin-top:20px;padding:15px">提交申请</button>
                    </form>
                </div>
            </div>

            <script>
                document.getElementById('applyForm').addEventListener('submit', function (e) {
                    e.preventDefault();

                    try {
                        var hasPetVal = this.querySelector('input[name="hasPet"]:checked').value;
                        var hasPetStr = hasPetVal === '1' ? '有' : '没有';

                        // Combine housing, income, and hasPet into livingCondition since DB has limited columns
                        var livingConditionDetails =
                            "住房：" + this.housingCondition.value + "；" +
                            "收入：" + this.income.value + "；" +
                            "是否有宠：" + hasPetStr;

                        var formData = {
                            petId: this.petId.value,
                            experience: this.experience.value,
                            livingCondition: livingConditionDetails,
                            applyReason: this.reason.value
                        };

                        console.log("Submitting application:", formData);

                        fetch('${pageContext.request.contextPath}/adoption/submit', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify(formData)
                        })
                            .then(res => {
                                if (!res.ok) {
                                    throw new Error('Network response was not ok: ' + res.statusText);
                                }
                                return res.json();
                            })
                            .then(data => {
                                if (data.code === 200) {
                                    alert('申请已提交！请耐心等待审核。');
                                    window.location.href = '${pageContext.request.contextPath}/adoption/my';
                                } else {
                                    alert('提交失败：' + data.message);
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('提交发生错误，请稍后重试或联系管理员。\n错误信息：' + error.message);
                            });
                    } catch (err) {
                        console.error('Form processing error:', err);
                        alert('表单处理出错：' + err.message);
                    }
                });
            </script>
        </body>

        </html>