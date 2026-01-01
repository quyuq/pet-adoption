package com.petadoption.controller;

import com.github.pagehelper.PageInfo;
import com.petadoption.entity.Blacklist;
import com.petadoption.service.BlacklistService;
import com.petadoption.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/blacklist")
public class BlacklistController {

    @Autowired
    private BlacklistService blacklistService;

    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String keyword,
            Model model) {
        List<Blacklist> list = blacklistService.getBlacklist(keyword, page, 10);
        PageInfo<Blacklist> pageInfo = new PageInfo<>(list);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("keyword", keyword);
        return "admin/blacklist";
    }

    @PostMapping("/add")
    @ResponseBody
    public Result<String> add(@RequestParam Integer userId, @RequestParam String reason) {
        boolean success = blacklistService.addToBlacklist(userId, reason);
        return success ? Result.success("已加入黑名单") : Result.error("操作失败或用户已在黑名单");
    }

    @PostMapping("/remove")
    @ResponseBody
    public Result<String> remove(@RequestParam Integer id) {
        boolean success = blacklistService.removeFromBlacklist(id);
        return success ? Result.success("已移出黑名单") : Result.error("操作失败");
    }
}
