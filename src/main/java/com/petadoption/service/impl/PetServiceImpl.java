package com.petadoption.service.impl;

import com.github.pagehelper.PageHelper;
import com.petadoption.entity.Pet;
import com.petadoption.mapper.PetMapper;
import com.petadoption.service.PetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 宠物业务实现类
 */
@Service
public class PetServiceImpl implements PetService {

    @Autowired
    private PetMapper petMapper;

    @Override
    @Transactional
    public Pet addPet(Pet pet) {
        // 默认状态为可领养
        if (pet.getStatus() == null) {
            pet.setStatus(Pet.STATUS_AVAILABLE);
        }
        pet.setViewCount(0);
        pet.setApplyCount(0);

        int result = petMapper.insert(pet);
        return result > 0 ? pet : null;
    }

    @Override
    @Transactional
    public boolean updatePet(Pet pet) {
        return petMapper.update(pet) > 0;
    }

    @Override
    public Pet getPetById(Integer id) {
        return petMapper.selectById(id);
    }

    @Override
    @Transactional
    public Pet getPetDetail(Integer id) {
        // 增加浏览量
        petMapper.incrementViewCount(id);
        return petMapper.selectById(id);
    }

    @Override
    public List<Pet> getPetsByPage(String species, Integer status, String keyword, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        return petMapper.selectByPage(species, status, keyword);
    }

    @Override
    public List<Pet> getShelterPets(Integer shelterId, String keyword, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        return petMapper.selectByShelter(shelterId, keyword);
    }

    @Override
    @Transactional
    public boolean updateStatus(Integer id, Integer status) {
        return petMapper.updateStatus(id, status) > 0;
    }

    @Override
    @Transactional
    public boolean deletePet(Integer id) {
        return petMapper.deleteById(id) > 0;
    }
}
