package com.petadoption.service;

import com.petadoption.entity.User;

import java.util.List;

/**
 * 用户业务接口
 */
public interface UserService {

    /**
     * 用户注册
     * 
     * @param user 用户信息
     * @return 注册成功返回用户对象，失败返回null
     */
    User register(User user);

    /**
     * 用户登录
     * 
     * @param username 用户名
     * @param password 密码（明文）
     * @return 登录成功返回用户对象，失败返回null
     */
    User login(String username, String password);

    /**
     * 根据ID获取用户
     */
    User getById(Integer id);

    /**
     * 根据用户名获取用户
     */
    User getByUsername(String username);

    /**
     * 更新用户信息
     */
    boolean updateProfile(User user);

    /**
     * 修改密码
     */
    boolean changePassword(Integer userId, String oldPassword, String newPassword);

    /**
     * 获取所有用户
     */
    List<User> getAllUsers();

    /**
     * 根据角色获取用户列表
     */
    List<User> getUsersByRole(Integer role);

    /**
     * 分页查询用户
     */
    List<User> getUsersByPage(Integer role, String keyword, int pageNum, int pageSize);

    /**
     * 启用/禁用用户
     */
    boolean updateStatus(Integer userId, Integer status);

    /**
     * 删除用户
     */
    boolean deleteUser(Integer userId);

    /**
     * 检查用户名是否存在
     */
    boolean isUsernameExists(String username);
}
