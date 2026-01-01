package com.petadoption.service;

import com.petadoption.entity.Blacklist;
import java.util.List;

public interface BlacklistService {

    /**
     * 将用户加入黑名单
     */
    boolean addToBlacklist(Integer userId, String reason);

    /**
     * 将用户移出黑名单
     */
    boolean removeFromBlacklist(Integer id);

    /**
     * 获取黑名单列表
     */
    List<Blacklist> getBlacklist(String keyword, int pageNum, int pageSize);

    /**
     * 检查用户是否被拉黑
     */
    boolean isBlacklisted(Integer userId);
}
