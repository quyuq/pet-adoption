package com.petadoption.service;

import com.petadoption.entity.AdoptionApply;
import java.util.List;

/**
 * 领养申请业务接口
 */
public interface AdoptionApplyService {

    /**
     * 提交领养申请
     */
    boolean submitApply(AdoptionApply apply);

    /**
     * 获取申请详情
     */
    AdoptionApply getApplyById(Integer id);

    /**
     * 获取用户的申请列表
     */
    List<AdoptionApply> getUserApplies(Integer userId, int pageNum, int pageSize);

    /**
     * 获取收容所的待处理申请
     */
    List<AdoptionApply> getShelterApplies(Integer shelterId, Integer status, int pageNum, int pageSize);

    /**
     * 审核申请（通过/拒绝）
     */
    boolean auditApply(Integer applyId, Integer status, String reason);

    /**
     * 检查是否已申请过
     */
    boolean hasPendingApply(Integer userId, Integer petId);
}
