-- ========================================
-- 宠物领养管理系统 - 数据库初始化脚本
-- ========================================

-- 设置客户端编码（解决中文乱码问题）
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- 创建数据库
DROP DATABASE IF EXISTS pet_adoption;
CREATE DATABASE pet_adoption DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE pet_adoption;

-- ----------------------------------------
-- 用户表
-- ----------------------------------------
DROP TABLE IF EXISTS t_user;
CREATE TABLE t_user (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码（MD5加密）',
    real_name VARCHAR(50) COMMENT '真实姓名',
    phone VARCHAR(20) COMMENT '联系电话',
    email VARCHAR(100) COMMENT '邮箱',
    address TEXT COMMENT '地址',
    role INT NOT NULL DEFAULT 2 COMMENT '角色：0-系统管理员，1-收容所管理员，2-领养用户',
    status INT DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ----------------------------------------
-- 宠物信息表
-- ----------------------------------------
DROP TABLE IF EXISTS t_pet;
CREATE TABLE t_pet (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '宠物ID',
    name VARCHAR(50) NOT NULL COMMENT '宠物名称',
    species VARCHAR(50) COMMENT '物种（猫/狗等）',
    breed VARCHAR(50) COMMENT '品种',
    age INT COMMENT '年龄（月份）',
    gender INT COMMENT '性别：0-未知，1-公，2-母',
    weight DECIMAL(5,2) COMMENT '体重（kg）',
    color VARCHAR(50) COMMENT '毛色',
    personality TEXT COMMENT '性格描述',
    is_sterilized INT DEFAULT 0 COMMENT '是否绝育：0-否，1-是',
    status INT DEFAULT 0 COMMENT '状态：0-可领养，1-审核中，2-已领养，3-医疗中',
    shelter_id INT COMMENT '所属收容所管理员ID',
    image_url VARCHAR(255) COMMENT '宠物照片URL',
    view_count INT DEFAULT 0 COMMENT '浏览次数',
    apply_count INT DEFAULT 0 COMMENT '申请次数',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_status (status),
    INDEX idx_species (species),
    INDEX idx_shelter (shelter_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宠物信息表';

-- ----------------------------------------
-- 健康记录表
-- ----------------------------------------
DROP TABLE IF EXISTS t_health_record;
CREATE TABLE t_health_record (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    pet_id INT NOT NULL COMMENT '宠物ID',
    record_type INT COMMENT '记录类型：1-疫苗，2-体检，3-用药，4-疾病',
    description TEXT COMMENT '记录描述',
    record_date DATE COMMENT '记录日期',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_pet (pet_id),
    FOREIGN KEY (pet_id) REFERENCES t_pet(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='健康记录表';

-- ----------------------------------------
-- 领养申请表
-- ----------------------------------------
DROP TABLE IF EXISTS t_adoption_apply;
CREATE TABLE t_adoption_apply (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '申请ID',
    user_id INT NOT NULL COMMENT '申请用户ID',
    pet_id INT NOT NULL COMMENT '申请宠物ID',
    apply_reason TEXT COMMENT '申请理由',
    living_condition TEXT COMMENT '居住条件',
    experience TEXT COMMENT '养宠经验',
    status INT DEFAULT 0 COMMENT '状态：0-待审核，1-初审通过，2-家访中，3-审核通过，4-已拒绝',
    reject_reason VARCHAR(255) COMMENT '拒绝原因',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
    update_time DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user (user_id),
    INDEX idx_pet (pet_id),
    INDEX idx_status (status),
    FOREIGN KEY (user_id) REFERENCES t_user(id),
    FOREIGN KEY (pet_id) REFERENCES t_pet(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='领养申请表';

-- ----------------------------------------
-- 失信黑名单表
-- ----------------------------------------
DROP TABLE IF EXISTS t_blacklist;
CREATE TABLE t_blacklist (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    user_id INT NOT NULL COMMENT '用户ID',
    reason TEXT COMMENT '拉黑原因',
    evidence TEXT COMMENT '证据描述',
    status INT DEFAULT 1 COMMENT '状态：0-已移除，1-生效中',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_user (user_id),
    INDEX idx_status (status),
    FOREIGN KEY (user_id) REFERENCES t_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='失信黑名单表';

-- ----------------------------------------
-- 消息通知表
-- ----------------------------------------
DROP TABLE IF EXISTS t_message;
CREATE TABLE t_message (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '消息ID',
    user_id INT NOT NULL COMMENT '用户ID',
    title VARCHAR(100) COMMENT '消息标题',
    content TEXT COMMENT '消息内容',
    is_read INT DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_user (user_id),
    INDEX idx_read (is_read),
    FOREIGN KEY (user_id) REFERENCES t_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息通知表';

-- ----------------------------------------
-- 宠物秀帖子表
-- ----------------------------------------
DROP TABLE IF EXISTS t_post;
CREATE TABLE t_post (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '帖子ID',
    user_id INT NOT NULL COMMENT '发帖用户ID',
    pet_id INT COMMENT '关联宠物ID',
    title VARCHAR(100) COMMENT '帖子标题',
    content TEXT COMMENT '帖子内容',
    images TEXT COMMENT '图片URL（逗号分隔）',
    post_type INT COMMENT '帖子类型：1-成功故事，2-经验分享，3-成长记录',
    like_count INT DEFAULT 0 COMMENT '点赞数',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_user (user_id),
    INDEX idx_type (post_type),
    FOREIGN KEY (user_id) REFERENCES t_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='宠物秀帖子表';

-- ----------------------------------------
-- 系统日志表
-- ----------------------------------------
DROP TABLE IF EXISTS t_sys_log;
CREATE TABLE t_sys_log (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    user_id INT COMMENT '操作用户ID',
    operation VARCHAR(100) COMMENT '操作描述',
    method VARCHAR(200) COMMENT '请求方法',
    params TEXT COMMENT '请求参数',
    ip VARCHAR(50) COMMENT 'IP地址',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_user (user_id),
    INDEX idx_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统日志表';

-- ----------------------------------------
-- 初始化数据
-- ----------------------------------------

-- 插入系统管理员（密码：admin123，MD5加密后）
INSERT INTO t_user (username, password, real_name, role, status) VALUES 
('admin', '0192023a7bbd73250516f069df18b500', '系统管理员', 0, 1);

-- 插入测试收容所管理员（密码：shelter123）
INSERT INTO t_user (username, password, real_name, phone, role, status) VALUES 
('shelter01', '7208930a7892295ec1e520224681af20', '阳光宠物收容所', '13800138001', 1, 1);

-- 插入测试领养用户（密码：user123）
INSERT INTO t_user (username, password, real_name, phone, email, role, status) VALUES 
('user01', '6ad14ba9986e3615423dfca256d04e3f', '张三', '13900139001', 'zhangsan@example.com', 2, 1);

-- 插入测试宠物数据
INSERT INTO t_pet (name, species, breed, age, gender, weight, color, personality, is_sterilized, status, shelter_id, view_count, apply_count) VALUES 
('小橘', '猫', '中华田园猫', 12, 1, 4.50, '橘色', '性格温顺，亲人，喜欢被抚摸', 1, 0, 2, 100, 5),
('豆豆', '狗', '柴犬', 24, 1, 8.00, '棕色', '活泼好动，忠诚，爱玩耍', 1, 0, 2, 150, 8),
('雪球', '猫', '布偶猫', 18, 2, 3.80, '白色', '安静优雅，喜欢独处，偶尔撒娇', 0, 0, 2, 200, 12);

SELECT '数据库初始化完成！' AS message;
