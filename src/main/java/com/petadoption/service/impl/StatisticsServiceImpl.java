package com.petadoption.service.impl;

import com.petadoption.mapper.StatisticsMapper;
import com.petadoption.service.StatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class StatisticsServiceImpl implements StatisticsService {

    @Autowired
    private StatisticsMapper statisticsMapper;

    @Override
    public Map<String, Object> getDateboardData() {
        Map<String, Object> data = new HashMap<>();

        // 核心数据
        data.put("overview", statisticsMapper.getOverviewStats());

        // 图表数据
        data.put("petStatus", statisticsMapper.countPetByStatus());
        data.put("petSpecies", statisticsMapper.countPetBySpecies());
        data.put("applyTrend", statisticsMapper.countApplyDaily());
        data.put("topViewed", statisticsMapper.getTopViewedPets());
        data.put("topApplied", statisticsMapper.getTopAppliedPets());

        return data;
    }
}
