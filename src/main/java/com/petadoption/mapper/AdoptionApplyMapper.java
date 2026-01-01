package com.petadoption.mapper;

import com.petadoption.entity.AdoptionApply;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 领养申请数据访问接口
 */
public interface AdoptionApplyMapper {

    /**
     * 根据ID查询
     */
    AdoptionApply selectById(Integer id);

    /**
     * 插入申请
     */
    int insert(AdoptionApply apply);

    /**
     * 更新申请状态
     */
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status,
            @Param("rejectReason") String rejectReason);

    /**
     * 根据用户ID查询申请列表
     */
    List<AdoptionApply> selectByUserId(Integer userId);

    /**
     * 根据收容所ID查询申请列表（针对该收容所宠物的申请）
     */
    List<AdoptionApply> selectByShelterId(@Param("shelterId") Integer shelterId, @Param("status") Integer status);

    /**
     * 查询某用户对某宠物是否已有未处理完的申请
     */
    int checkExistApply(@Param("userId") Integer userId, @Param("petId") Integer petId);

    /**
     * 自动拒绝该宠物的所有其他待审核申请
     */
    int rejectOtherApplies(@Param("petId") Integer petId, @Param("approvedApplyId") Integer approvedApplyId);
}
