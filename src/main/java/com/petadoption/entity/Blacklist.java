package com.petadoption.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 失信黑名单实体类
 */
public class Blacklist implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer userId;
    /** 拉黑原因 */
    private String reason;
    /** 证据描述 */
    private String evidence;
    /** 状态：0-已移除，1-生效中 */
    private Integer status;
    private Date createTime;

    // 关联对象
    private User user;

    public Blacklist() {
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

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getEvidence() {
        return evidence;
    }

    public void setEvidence(String evidence) {
        this.evidence = evidence;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
