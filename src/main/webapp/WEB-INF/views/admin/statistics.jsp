<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <title>数据统计 - 宠物领养</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
        <script src="https://cdn.bootcdn.net/ajax/libs/echarts/5.3.2/echarts.min.js"></script>
        <script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <style>
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
                margin-bottom: 30px;
            }

            .stats-card {
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                text-align: center;
            }

            .stats-value {
                font-size: 2.5rem;
                font-weight: bold;
                color: var(--primary-color);
                margin: 10px 0;
            }

            .stats-label {
                color: #6b7280;
                font-size: 0.9rem;
            }

            .chart-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 20px;
            }

            .chart-card {
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
                height: 400px;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <header class="header">
                <h1>🐾 数据统计看板</h1>
            </header>

            <nav class="nav">
                <a href="${pageContext.request.contextPath}/admin/index" class="nav-link">后台首页</a>
                <a href="${pageContext.request.contextPath}/admin/stats/dashboard" class="nav-link active">数据统计</a>
            </nav>

            <div class="stats-grid">
                <div class="stats-card">
                    <div class="stats-label">总用户数</div>
                    <div class="stats-value" id="userCount">-</div>
                </div>
                <div class="stats-card">
                    <div class="stats-label">宠物总数</div>
                    <div class="stats-value" id="petCount">-</div>
                </div>
                <div class="stats-card">
                    <div class="stats-label">已领养数</div>
                    <div class="stats-value" id="adoptedCount">-</div>
                </div>
                <div class="stats-card">
                    <div class="stats-label">申请总次</div>
                    <div class="stats-value" id="applyCount">-</div>
                </div>
            </div>

            <div class="chart-row">
                <div class="chart-card" id="statusChart"></div>
                <div class="chart-card" id="speciesChart"></div>
            </div>

            <div class="chart-row">
                <div class="chart-card" id="trendChart"></div>
                <div class="chart-card" id="topChart"></div>
            </div>
        </div>

        <script>
            // 初始化图表
            var statusChart = echarts.init(document.getElementById('statusChart'));
            var speciesChart = echarts.init(document.getElementById('speciesChart'));
            var trendChart = echarts.init(document.getElementById('trendChart'));
            var topChart = echarts.init(document.getElementById('topChart'));

            // 加载数据
            $.get('${pageContext.request.contextPath}/admin/stats/data', function (res) {
                if (res.code === 200) {
                    var data = res.data;
                    var overview = data.overview;

                    // 填充概览数据
                    $('#userCount').text(overview.userCount);
                    $('#petCount').text(overview.petCount);
                    $('#adoptedCount').text(overview.adoptedCount);
                    $('#applyCount').text(overview.applyCount);

                    // 1. 宠物状态分布
                    statusChart.setOption({
                        title: { text: '宠物状态分布', left: 'center' },
                        tooltip: { trigger: 'item' },
                        legend: { bottom: '5%' },
                        series: [{
                            type: 'pie',
                            radius: ['40%', '70%'],
                            data: data.petStatus
                        }]
                    });

                    // 2. 宠物物种分布
                    speciesChart.setOption({
                        title: { text: '物种分布', left: 'center' },
                        tooltip: { trigger: 'item' },
                        series: [{
                            type: 'pie',
                            radius: '50%',
                            data: data.petSpecies
                        }]
                    });

                    // 3. 申请趋势（最近7天）
                    trendChart.setOption({
                        title: { text: '最近7天申请趋势', left: 'center' },
                        tooltip: { trigger: 'axis' },
                        xAxis: {
                            type: 'category',
                            data: data.applyTrend.map(i => i.name)
                        },
                        yAxis: { type: 'value' },
                        series: [{
                            data: data.applyTrend.map(i => i.value),
                            type: 'line',
                            smooth: true,
                            areaStyle: {}
                        }]
                    });

                    // 4. TOP5 热门宠物（浏览量）
                    topChart.setOption({
                        title: { text: '热门宠物TOP5 (浏览量)', left: 'center' },
                        tooltip: { trigger: 'axis' },
                        xAxis: { type: 'value' },
                        yAxis: {
                            type: 'category',
                            data: data.topViewed.map(i => i.name).reverse()
                        },
                        series: [{
                            type: 'bar',
                            data: data.topViewed.map(i => i.value).reverse(),
                            itemStyle: { color: '#6366f1' }
                        }]
                    });
                }
            });

            // 窗口大小改变时重绘
            window.onresize = function () {
                statusChart.resize();
                speciesChart.resize();
                trendChart.resize();
                topChart.resize();
            };
        </script>
    </body>

    </html>