package com.petadoption.mapper;

import com.petadoption.entity.Blacklist;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 黑名单数据访问接口
 */
public interface BlacklistMapper {

    /**
     * 添加黑名单记录
     */
    int insert(Blacklist blacklist);

    /**
     * 删除黑名单记录（解除拉黑）
     */
    int deleteById(Integer id);

    /**
     * 根据用户ID删除
     */
    int deleteByUserId(Integer userId);

    /**
     * 查询所有黑名单
     */
    List<Blacklist> selectAll(@Param("keyword") String keyword);

    /**
     * 检查用户是否在黑名单中
     */
    int checkUserInBlacklist(Integer userId);

    /**
     * 获取用户被拉黑详情
     */
    Blacklist selectByUserId(Integer userId);
}
