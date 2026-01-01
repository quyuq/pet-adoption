package com.petadoption.mapper;

import com.petadoption.entity.SysLog;
import java.util.List;

public interface SysLogMapper {
    int insert(SysLog log);

    List<SysLog> selectAll(String keyword);
}
