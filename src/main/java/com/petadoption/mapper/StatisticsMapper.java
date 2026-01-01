package com.petadoption.mapper;

import com.petadoption.entity.StatsData;
import java.util.List;
import java.util.Map;

public interface StatisticsMapper {
    /** 统计各状态宠物数量 */
    List<StatsData> countPetByStatus();

    /** 统计各物种宠物数量 */
    List<StatsData> countPetBySpecies();

    /** 统计领养申请每日数量（最近7天） */
    List<StatsData> countApplyDaily();

    /** 统计浏览量最高的TOP5宠物 */
    List<StatsData> getTopViewedPets();

    /** 统计申请量最高的TOP5宠物 */
    List<StatsData> getTopAppliedPets();

    /** 统计核心数据总览 */
    Map<String, Object> getOverviewStats();
}
