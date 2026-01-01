package com.petadoption.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 领养申请实体类
 */
public class AdoptionApply implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer userId;
    private Integer petId;
    /** 申请理由 */
    private String applyReason;
    /** 居住条件 */
    private String livingCondition;
    /** 养宠经验 */
    private String experience;
    /** 状态：0-待审核，1-初审通过，2-家访中，3-审核通过，4-已拒绝 */
    private Integer status;
    /** 拒绝原因 */
    private String rejectReason;
    private Date createTime;
    private Date updateTime;

    // 关联对象
    private User user;
    private Pet pet;

    // 状态常量
    public static final int STATUS_PENDING = 0;
    public static final int STATUS_FIRST_PASS = 1;
    public static final int STATUS_HOME_VISIT = 2;
    public static final int STATUS_APPROVED = 3;
    public static final int STATUS_REJECTED = 4;

    public AdoptionApply() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getPetId() {
        return petId;
    }

    public void setPetId(Integer petId) {
        this.petId = petId;
    }

    public String getApplyReason() {
        return applyReason;
    }

    public void setApplyReason(String applyReason) {
        this.applyReason = applyReason;
    }

    public String getLivingCondition() {
        return livingCondition;
    }

    public void setLivingCondition(String livingCondition) {
        this.livingCondition = livingCondition;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Pet getPet() {
        return pet;
    }

    public void setPet(Pet pet) {
        this.pet = pet;
    }
}
