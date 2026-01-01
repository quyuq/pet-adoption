package com.petadoption.service.impl;

import com.github.pagehelper.PageHelper;
import com.petadoption.entity.Blacklist;
import com.petadoption.mapper.BlacklistMapper;
import com.petadoption.service.BlacklistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BlacklistServiceImpl implements BlacklistService {

    @Autowired
    private BlacklistMapper blacklistMapper;

    @Override
    public boolean addToBlacklist(Integer userId, String reason) {
        if (isBlacklisted(userId)) {
            return false;
        }
        Blacklist blacklist = new Blacklist();
        blacklist.setUserId(userId);
        blacklist.setReason(reason);
        return blacklistMapper.insert(blacklist) > 0;
    }

    @Override
    public boolean removeFromBlacklist(Integer id) {
        return blacklistMapper.deleteById(id) > 0;
    }

    @Override
    public List<Blacklist> getBlacklist(String keyword, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        return blacklistMapper.selectAll(keyword);
    }

    @Override
    public boolean isBlacklisted(Integer userId) {
        return blacklistMapper.checkUserInBlacklist(userId) > 0;
    }
}
