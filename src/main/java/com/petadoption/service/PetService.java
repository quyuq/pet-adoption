package com.petadoption.service;

import com.petadoption.entity.Pet;
import com.petadoption.util.Result;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 宠物业务接口
 */
public interface PetService {

    /**
     * 添加宠物
     */
    Pet addPet(Pet pet);

    /**
     * 更新宠物信息
     */
    boolean updatePet(Pet pet);

    /**
     * 获取宠物详情
     */
    Pet getPetById(Integer id);

    /**
     * 获取宠物详情（并增加浏览量）
     */
    Pet getPetDetail(Integer id);

    /**
     * 分页查询宠物列表
     */
    List<Pet> getPetsByPage(String species, Integer status, String keyword, int pageNum, int pageSize);

    /**
     * 查询收容所的宠物
     */
    List<Pet> getShelterPets(Integer shelterId, String keyword, int pageNum, int pageSize);

    /**
     * 更新状态
     */
    boolean updateStatus(Integer id, Integer status);

    /**
     * 删除宠物
     */
    boolean deletePet(Integer id);
}
