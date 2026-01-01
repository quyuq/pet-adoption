package com.petadoption.controller;

import com.github.pagehelper.PageInfo;
import com.petadoption.entity.SysLog;
import com.petadoption.service.SysLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/admin/log")
public class SysLogController {

    @Autowired
    private SysLogService sysLogService;

    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String keyword,
            Model model) {
        List<SysLog> list = sysLogService.getLogs(keyword, page, 20);
        PageInfo<SysLog> pageInfo = new PageInfo<>(list);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("keyword", keyword);
        return "admin/log";
    }
}
