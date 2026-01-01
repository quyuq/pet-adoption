package com.petadoption.controller;

import com.github.pagehelper.PageInfo;
import com.petadoption.entity.AdoptionApply;
import com.petadoption.entity.Pet;
import com.petadoption.entity.User;
import com.petadoption.service.AdoptionApplyService;
import com.petadoption.service.PetService;
import com.petadoption.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 领养申请控制器
 */
@Controller
@RequestMapping("/adoption")
public class AdoptionApplyController {

    @Autowired
    private AdoptionApplyService applyService;

    @Autowired
    private PetService petService;

    /**
     * 申请页面
     */
    @GetMapping("/apply/{petId}")
    public String applyPage(@PathVariable Integer petId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/user/login";
        }

        // 检查是否已申请过
        if (applyService.hasPendingApply(user.getId(), petId)) {
            model.addAttribute("error", "您已经申请过这只宠物了，请等待审核");
            return "redirect:/pet/detail/" + petId;
        }

        Pet pet = petService.getPetById(petId);
        if (pet == null || pet.getStatus() != Pet.STATUS_AVAILABLE) {
            return "redirect:/pet/list";
        }

        model.addAttribute("pet", pet);
        return "adoption/apply";
    }

    /**
     * 提交申请
     */
    @PostMapping("/submit")
    @ResponseBody
    public Result<String> submitApply(@RequestBody AdoptionApply apply, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return Result.error(Result.UNAUTHORIZED, "请先登录");
        }

        if (apply == null) {
            return Result.error("提交数据为空");
        }

        apply.setUserId(user.getId());
        boolean success = applyService.submitApply(apply);

        return success ? Result.success("申请提交成功，请耐心等待审核", null)
                : Result.error("申请提交失败，可能是您已被加入黑名单或由于该宠物不可领养");
    }

    /**
     * 用户查看自己的申请
     */
    @GetMapping("/my")
    public String myApplies(@RequestParam(defaultValue = "1") int page, HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/user/login";
        }

        List<AdoptionApply> applies = applyService.getUserApplies(user.getId(), page, 10);
        PageInfo<AdoptionApply> pageInfo = new PageInfo<>(applies);

        model.addAttribute("pageInfo", pageInfo);
        return "adoption/my";
    }

    /**
     * 收容所管理申请
     */
    @GetMapping("/manage")
    public String manageApplies(@RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) Integer status,
            HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null || user.getRole() != User.ROLE_SHELTER) {
            return "redirect:/user/login";
        }

        List<AdoptionApply> applies = applyService.getShelterApplies(user.getId(), status, page, 10);
        PageInfo<AdoptionApply> pageInfo = new PageInfo<>(applies);

        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("status", status); // 回显筛选状态
        return "adoption/manage";
    }

    /**
     * 审核操作
     */
    @PostMapping("/audit")
    @ResponseBody
    public Result<String> audit(@RequestParam Integer id, @RequestParam Integer status,
            @RequestParam(required = false) String reason, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null || user.getRole() != User.ROLE_SHELTER) {
            return Result.error(Result.FORBIDDEN, "无权操作");
        }

        // 验证该申请是否属于该收容所的宠物
        AdoptionApply apply = applyService.getApplyById(id);
        if (apply == null || !apply.getPet().getShelterId().equals(user.getId())) {
            return Result.error(Result.FORBIDDEN, "无权操作");
        }

        boolean success = applyService.auditApply(id, status, reason);
        return success ? Result.success("操作成功", null) : Result.error("操作失败");
    }
}
