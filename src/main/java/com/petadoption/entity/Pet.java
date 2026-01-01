package com.petadoption.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 宠物实体类
 */
public class Pet implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;
    private String name;
    /** 物种（猫/狗等） */
    private String species;
    /** 品种 */
    private String breed;
    private Integer age;
    /** 性别：0-未知，1-公，2-母 */
    private Integer gender;
    private BigDecimal weight;
    /** 毛色 */
    private String color;
    /** 性格描述 */
    private String personality;
    /** 是否绝育：0-否，1-是 */
    private Integer isSterilized;
    /** 状态：0-可领养，1-审核中，2-已领养，3-医疗中 */
    private Integer status;
    /** 所属收容所ID */
    private Integer shelterId;
    /** 宠物照片URL */
    private String imageUrl;
    /** 浏览次数 */
    private Integer viewCount;
    /** 申请次数 */
    private Integer applyCount;
    private Date createTime;

    // 状态常量
    public static final int STATUS_AVAILABLE = 0;
    public static final int STATUS_REVIEWING = 1;
    public static final int STATUS_ADOPTED = 2;
    public static final int STATUS_MEDICAL = 3;

    public Pet() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSpecies() {
        return species;
    }

    public void setSpecies(String species) {
        this.species = species;
    }

    public String getBreed() {
        return breed;
    }

    public void setBreed(String breed) {
        this.breed = breed;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public Integer getGender() {
        return gender;
    }

    public void setGender(Integer gender) {
        this.gender = gender;
    }

    public BigDecimal getWeight() {
        return weight;
    }

    public void setWeight(BigDecimal weight) {
        this.weight = weight;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getPersonality() {
        return personality;
    }

    public void setPersonality(String personality) {
        this.personality = personality;
    }

    public Integer getIsSterilized() {
        return isSterilized;
    }

    public void setIsSterilized(Integer isSterilized) {
        this.isSterilized = isSterilized;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getShelterId() {
        return shelterId;
    }

    public void setShelterId(Integer shelterId) {
        this.shelterId = shelterId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    public Integer getApplyCount() {
        return applyCount;
    }

    public void setApplyCount(Integer applyCount) {
        this.applyCount = applyCount;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "Pet{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", species='" + species + '\'' +
                ", breed='" + breed + '\'' +
                ", status=" + status +
                '}';
    }
}
