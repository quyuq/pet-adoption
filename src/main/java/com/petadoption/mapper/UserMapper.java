package com.petadoption.mapper;

import com.petadoption.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户数据访问接口
 */
public interface UserMapper {

    /**
     * 根据ID查询用户
     */
    User selectById(Integer id);

    /**
     * 根据用户名查询用户
     */
    User selectByUsername(String username);

    /**
     * 插入新用户
     */
    int insert(User user);

    /**
     * 更新用户信息
     */
    int update(User user);

    /**
     * 更新密码
     */
    int updatePassword(@Param("id") Integer id, @Param("password") String password);

    /**
     * 删除用户
     */
    int deleteById(Integer id);

    /**
     * 查询所有用户
     */
    List<User> selectAll();

    /**
     * 根据角色查询用户
     */
    List<User> selectByRole(Integer role);

    /**
     * 分页查询用户
     */
    List<User> selectByPage(@Param("role") Integer role, @Param("keyword") String keyword);

    /**
     * 更新用户状态
     */
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);
}
