package com.petadoption.service.impl;

import com.github.pagehelper.PageHelper;
import com.petadoption.entity.User;
import com.petadoption.mapper.UserMapper;
import com.petadoption.service.UserService;
import com.petadoption.util.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 用户业务实现类
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    @Transactional
    public User register(User user) {
        // 检查用户名是否已存在
        if (isUsernameExists(user.getUsername())) {
            return null;
        }
        // 密码MD5加密
        user.setPassword(MD5Util.encrypt(user.getPassword()));
        // 默认角色为普通用户
        if (user.getRole() == null) {
            user.setRole(User.ROLE_USER);
        }
        // 默认状态为正常
        user.setStatus(1);

        int result = userMapper.insert(user);
        return result > 0 ? user : null;
    }

    @Override
    public User login(String username, String password) {
        User user = userMapper.selectByUsername(username);
        if (user == null) {
            return null;
        }
        // 验证密码
        String encryptedPassword = MD5Util.encrypt(password);
        if (!encryptedPassword.equals(user.getPassword())) {
            return null;
        }
        // 检查用户状态
        if (user.getStatus() == 0) {
            return null;
        }
        return user;
    }

    @Override
    public User getById(Integer id) {
        return userMapper.selectById(id);
    }

    @Override
    public User getByUsername(String username) {
        return userMapper.selectByUsername(username);
    }

    @Override
    @Transactional
    public boolean updateProfile(User user) {
        return userMapper.update(user) > 0;
    }

    @Override
    @Transactional
    public boolean changePassword(Integer userId, String oldPassword, String newPassword) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            return false;
        }
        // 验证旧密码
        String encryptedOldPassword = MD5Util.encrypt(oldPassword);
        if (!encryptedOldPassword.equals(user.getPassword())) {
            return false;
        }
        // 更新新密码
        String encryptedNewPassword = MD5Util.encrypt(newPassword);
        return userMapper.updatePassword(userId, encryptedNewPassword) > 0;
    }

    @Override
    public List<User> getAllUsers() {
        return userMapper.selectAll();
    }

    @Override
    public List<User> getUsersByRole(Integer role) {
        return userMapper.selectByRole(role);
    }

    @Override
    public List<User> getUsersByPage(Integer role, String keyword, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        return userMapper.selectByPage(role, keyword);
    }

    @Override
    @Transactional
    public boolean updateStatus(Integer userId, Integer status) {
        return userMapper.updateStatus(userId, status) > 0;
    }

    @Override
    @Transactional
    public boolean deleteUser(Integer userId) {
        return userMapper.deleteById(userId) > 0;
    }

    @Override
    public boolean isUsernameExists(String username) {
        return userMapper.selectByUsername(username) != null;
    }
}
