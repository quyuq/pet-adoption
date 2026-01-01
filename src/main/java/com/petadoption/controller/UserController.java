package com.petadoption.controller;

import com.petadoption.entity.User;
import com.petadoption.service.UserService;
import com.petadoption.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

/**
 * 用户控制器
 */
@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 登录页面
     */
    @GetMapping("/login")
    public String loginPage() {
        return "user/login";
    }

    /**
     * 登录处理
     */
    @PostMapping("/login")
    @ResponseBody
    public Result<User> login(@RequestParam String username,
            @RequestParam String password,
            HttpSession session) {
        User user = userService.login(username, password);
        if (user == null) {
            return Result.error("用户名或密码错误");
        }
        // 登录成功，保存用户信息到Session
        session.setAttribute("loginUser", user);
        return Result.success("登录成功", user);
    }

    /**
     * 注册页面
     */
    @GetMapping("/register")
    public String registerPage() {
        return "user/register";
    }

    /**
     * 注册处理
     */
    @PostMapping("/register")
    @ResponseBody
    public Result<User> register(@RequestBody User user) {
        // 检查用户名是否已存在
        if (userService.isUsernameExists(user.getUsername())) {
            return Result.error("用户名已存在");
        }
        User registeredUser = userService.register(user);
        if (registeredUser == null) {
            return Result.error("注册失败，请稍后重试");
        }
        return Result.success("注册成功", registeredUser);
    }

    /**
     * 退出登录
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("loginUser");
        session.invalidate();
        return "redirect:/";
    }

    /**
     * 个人中心页面
     */
    @GetMapping("/profile")
    public String profilePage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        model.addAttribute("user", user);
        return "user/profile";
    }

    /**
     * 更新个人信息
     */
    @PostMapping("/profile")
    @ResponseBody
    public Result<User> updateProfile(@RequestBody User user, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        user.setId(loginUser.getId());

        boolean success = userService.updateProfile(user);
        if (success) {
            // 更新Session中的用户信息
            User updatedUser = userService.getById(loginUser.getId());
            session.setAttribute("loginUser", updatedUser);
            return Result.success("更新成功", updatedUser);
        }
        return Result.error("更新失败");
    }

    /**
     * 修改密码
     */
    @PostMapping("/changePassword")
    @ResponseBody
    public Result<String> changePassword(@RequestParam String oldPassword,
            @RequestParam String newPassword,
            HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        boolean success = userService.changePassword(loginUser.getId(), oldPassword, newPassword);
        if (success) {
            return Result.success("密码修改成功");
        }
        return Result.error("原密码错误");
    }

    /**
     * 检查用户名是否可用
     */
    @GetMapping("/checkUsername")
    @ResponseBody
    public Result<Boolean> checkUsername(@RequestParam String username) {
        boolean exists = userService.isUsernameExists(username);
        if (exists) {
            return Result.error("用户名已被使用");
        }
        return Result.success("用户名可用", true);
    }
}
