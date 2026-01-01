package com.petadoption.controller;

import com.petadoption.entity.User;
import com.petadoption.service.UserService;
import com.petadoption.util.Result;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;

    @GetMapping("/index")
    public String index(HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null || (user.getRole() != User.ROLE_ADMIN && user.getRole() != User.ROLE_SHELTER)) {
            return "redirect:/user/login";
        }
        return "admin/index";
    }

    /**
     * 用户列表
     */
    @GetMapping("/user/list")
    public String userList(@RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer role,
            HttpSession session,
            Model model) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() != User.ROLE_ADMIN) {
            return "redirect:/admin/index";
        }

        List<User> list = userService.getUsersByPage(role, keyword, page, 10);
        PageInfo<User> pageInfo = new PageInfo<>(list);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("keyword", keyword);
        model.addAttribute("role", role);
        return "admin/user_list";
    }

    /**
     * 更新用户角色
     */
    @PostMapping("/user/role")
    @ResponseBody
    public Result<String> updateRole(@RequestParam Integer userId, @RequestParam Integer role, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() != User.ROLE_ADMIN) {
            return Result.error("权限不足");
        }

        User user = userService.getById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }

        user.setRole(role);
        boolean success = userService.updateProfile(user);
        return success ? Result.success("角色更新成功") : Result.error("操作失败");
    }

    /**
     * 更新用户状态
     */
    @PostMapping("/user/status")
    @ResponseBody
    public Result<String> updateStatus(@RequestParam Integer userId, @RequestParam Integer status,
            HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null || loginUser.getRole() != User.ROLE_ADMIN) {
            return Result.error("权限不足");
        }

        boolean success = userService.updateStatus(userId, status);
        return success ? Result.success("状态更新成功") : Result.error("操作失败");
    }
}
