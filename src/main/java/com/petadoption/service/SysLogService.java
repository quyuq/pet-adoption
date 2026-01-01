package com.petadoption.service;

import com.github.pagehelper.PageHelper;
import com.petadoption.entity.SysLog;
import com.petadoption.mapper.SysLogMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SysLogService {

    @Autowired
    private SysLogMapper sysLogMapper;

    public void saveLog(SysLog log) {
        sysLogMapper.insert(log);
    }

    public List<SysLog> getLogs(String keyword, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        return sysLogMapper.selectAll(keyword);
    }
}
