package com.petadoption.controller;

import com.github.pagehelper.PageInfo;
import com.petadoption.entity.Pet;
import com.petadoption.entity.User;
import com.petadoption.service.PetService;
import com.petadoption.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 * 宠物控制器
 */
@Controller
@RequestMapping("/pet")
public class PetController {

    @Autowired
    private PetService petService;

    /**
     * 宠物列表页（公开）
     */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "9") int size,
            @RequestParam(required = false) String species,
            @RequestParam(required = false) String keyword,
            Model model) {
        // 只查询可领养状态的宠物
        List<Pet> pets = petService.getPetsByPage(species, Pet.STATUS_AVAILABLE, keyword, page, size);
        PageInfo<Pet> pageInfo = new PageInfo<>(pets);

        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("species", species);
        model.addAttribute("keyword", keyword);
        return "pet/list";
    }

    /**
     * 宠物详情页
     */
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        Pet pet = petService.getPetDetail(id);
        if (pet == null) {
            return "redirect:/pet/list";
        }
        model.addAttribute("pet", pet);
        return "pet/detail";
    }

    /**
     * 收容所管理宠物页面
     */
    @GetMapping("/manage")
    public String manage(@RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String keyword,
            HttpSession session,
            Model model) {
        User user = (User) session.getAttribute("loginUser");
        // 只有收容所管理员可以访问
        if (user == null || user.getRole() != User.ROLE_SHELTER) {
            return "redirect:/user/login";
        }

        List<Pet> pets = petService.getShelterPets(user.getId(), keyword, page, 10);
        PageInfo<Pet> pageInfo = new PageInfo<>(pets);

        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("keyword", keyword);
        return "pet/manage";
    }

    /**
     * 添加/编辑宠物页面
     */
    @GetMapping("/edit")
    public String editPage(@RequestParam(required = false) Integer id,
            HttpSession session,
            Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null || user.getRole() != User.ROLE_SHELTER) {
            return "redirect:/user/login";
        }

        if (id != null) {
            Pet pet = petService.getPetById(id);
            // 权限检查：只能编辑自己收容所的宠物
            if (pet != null && pet.getShelterId().equals(user.getId())) {
                model.addAttribute("pet", pet);
            }
        }
        return "pet/edit";
    }

    /**
     * 保存宠物信息
     */
    @PostMapping("/save")
    @ResponseBody
    public Result<Pet> save(Pet pet, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null || user.getRole() != User.ROLE_SHELTER) {
            return Result.error(Result.FORBIDDEN, "无权操作");
        }

        if (pet.getId() == null) {
            // 新增
            pet.setShelterId(user.getId());
            Pet newPet = petService.addPet(pet);
            return newPet != null ? Result.success(newPet) : Result.error("添加失败");
        } else {
            // 更新
            Pet existingPet = petService.getPetById(pet.getId());
            if (existingPet == null || !existingPet.getShelterId().equals(user.getId())) {
                return Result.error(Result.FORBIDDEN, "无权操作");
            }
            // 保持原始数据完整性
            pet.setShelterId(existingPet.getShelterId());
            boolean success = petService.updatePet(pet);
            return success ? Result.success(pet) : Result.error("更新失败");
        }
    }

    /**
     * 图片上传
     */
    @PostMapping("/upload")
    @ResponseBody
    public Result<String> upload(@RequestParam("file") MultipartFile file, HttpSession session) {
        if (file.isEmpty()) {
            return Result.error("文件为空");
        }

        try {
            // 获取上传目录
            String path = session.getServletContext().getRealPath("/static/upload/pet/");
            File dir = new File(path);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // 生成文件名
            String suffix = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
            String fileName = UUID.randomUUID().toString() + suffix;

            // 保存文件
            File targetFile = new File(dir, fileName);
            file.transferTo(targetFile);

            // 返回URL
            String url = "/static/upload/pet/" + fileName;
            return Result.success("上传成功", url);

        } catch (IOException e) {
            e.printStackTrace();
            return Result.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * 删除宠物
     */
    @PostMapping("/delete")
    @ResponseBody
    public Result<String> delete(@RequestParam Integer id, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null || user.getRole() != User.ROLE_SHELTER) {
            return Result.error(Result.FORBIDDEN, "无权操作");
        }

        Pet pet = petService.getPetById(id);
        if (pet == null || !pet.getShelterId().equals(user.getId())) {
            return Result.error(Result.FORBIDDEN, "无权操作");
        }

        boolean success = petService.deletePet(id);
        return success ? Result.success("删除成功", null) : Result.error("删除失败");
    }

    /**
     * 更新状态
     */
    @PostMapping("/status")
    @ResponseBody
    public Result<String> updateStatus(@RequestParam Integer id,
            @RequestParam Integer status,
            HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null || user.getRole() != User.ROLE_SHELTER) {
            return Result.error(Result.FORBIDDEN, "无权操作");
        }

        Pet pet = petService.getPetById(id);
        if (pet == null || !pet.getShelterId().equals(user.getId())) {
            return Result.error(Result.FORBIDDEN, "无权操作");
        }

        boolean success = petService.updateStatus(id, status);
        return success ? Result.success("状态更新成功", null) : Result.error("操作失败");
    }
}
