package com.petadoption.service.impl;

import com.github.pagehelper.PageHelper;
import com.petadoption.entity.AdoptionApply;
import com.petadoption.entity.Pet;
import com.petadoption.mapper.AdoptionApplyMapper;
import com.petadoption.mapper.PetMapper;
import com.petadoption.service.AdoptionApplyService;
import com.petadoption.service.MessageService;
import com.petadoption.service.BlacklistService;
import com.petadoption.service.PetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 领养申请业务实现类
 */
@Service
public class AdoptionApplyServiceImpl implements AdoptionApplyService {

    @Autowired
    private AdoptionApplyMapper applyMapper;

    @Autowired
    private PetMapper petMapper;

    @Autowired
    private BlacklistService blacklistService;

    @Override
    @Transactional
    public boolean submitApply(AdoptionApply apply) {
        // 0. 检查是否在黑名单中
        if (blacklistService.isBlacklisted(apply.getUserId())) {
            return false;
        }

        // 1. 检查宠物是否存在且可领养
        Pet pet = petMapper.selectById(apply.getPetId());
        if (pet == null || pet.getStatus() != Pet.STATUS_AVAILABLE) {
            return false;
        }

        // 2. 检查是否重复申请
        if (applyMapper.checkExistApply(apply.getUserId(), apply.getPetId()) > 0) {
            return false;
        }

        // 3. 初始状态为审核中
        apply.setStatus(AdoptionApply.STATUS_PENDING);

        // 4. 宠物申请计数+1
        petMapper.incrementApplyCount(apply.getPetId());

        return applyMapper.insert(apply) > 0;
    }

    @Override
    public AdoptionApply getApplyById(Integer id) {
        return applyMapper.selectById(id);
    }

    @Override
    public List<AdoptionApply> getUserApplies(Integer userId, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        return applyMapper.selectByUserId(userId);
    }

    @Override
    public List<AdoptionApply> getShelterApplies(Integer shelterId, Integer status, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        return applyMapper.selectByShelterId(shelterId, status);
    }

    @Autowired
    private MessageService messageService;

    @Override
    @Transactional
    public boolean auditApply(Integer applyId, Integer status, String reason) {
        AdoptionApply apply = applyMapper.selectById(applyId);
        if (apply == null)
            return false;

        // 更新申请状态及审核理由
        int rows = applyMapper.updateStatus(applyId, status, reason);
        if (rows > 0) {
            String messageContent = "";
            if (status == AdoptionApply.STATUS_APPROVED) {
                // 如果审核通过
                // 1. 将宠物状态改为已领养
                petMapper.updateStatus(apply.getPetId(), Pet.STATUS_ADOPTED);
                // 2. 自动拒绝该宠物的其他申请
                applyMapper.rejectOtherApplies(apply.getPetId(), applyId);

                messageContent = "恭喜！您申请领养的宠物【" + apply.getPet().getName() + "】已通过最终审核。工作人员将尽快联系您办理后续领养手续。";
            } else if (status == AdoptionApply.STATUS_REJECTED) {
                messageContent = "很遗憾，您申请领养的宠物【" + apply.getPet().getName() + "】未能通过审核。";
                if (reason != null && !reason.trim().isEmpty()) {
                    messageContent += "原因：" + reason;
                } else {
                    messageContent += "原因：由于不符合领养条件或该宠物已被领养。";
                }
            } else if (status == AdoptionApply.STATUS_FIRST_PASS) {
                messageContent = "好消息！您申请领养的宠物【" + apply.getPet().getName() + "】已通过初步筛选。后续我们将安排家访或进一步沟通，请保持联系。";
            }

            // 发送站内信
            if (!messageContent.isEmpty()) {
                messageService.sendMessage(apply.getUserId(), messageContent);
            }

            return true;
        }
        return false;
    }

    @Override
    public boolean hasPendingApply(Integer userId, Integer petId) {
        return applyMapper.checkExistApply(userId, petId) > 0;
    }
}
