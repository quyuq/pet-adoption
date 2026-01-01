package com.petadoption.mapper;

import com.petadoption.entity.Pet;
import com.petadoption.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 宠物数据访问接口
 */
public interface PetMapper {

    /**
     * 根据ID查询宠物
     */
    Pet selectById(Integer id);

    /**
     * 插入新宠物
     */
    int insert(Pet pet);

    /**
     * 更新宠物信息
     */
    int update(Pet pet);

    /**
     * 更新宠物状态
     */
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    /**
     * 删除宠物
     */
    int deleteById(Integer id);

    /**
     * 增加浏览次数
     */
    int incrementViewCount(Integer id);

    /**
     * 增加申请次数
     */
    int incrementApplyCount(Integer id);

    /**
     * 分页查询宠物列表
     */
    List<Pet> selectByPage(@Param("species") String species,
            @Param("status") Integer status,
            @Param("keyword") String keyword);

    /**
     * 查询收容所发布的宠物
     */
    List<Pet> selectByShelter(@Param("shelterId") Integer shelterId,
            @Param("keyword") String keyword);
}
