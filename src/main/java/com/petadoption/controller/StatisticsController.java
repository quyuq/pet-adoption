package com.petadoption.controller;

import com.petadoption.service.StatisticsService;
import com.petadoption.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

@Controller
@RequestMapping("/admin/stats")
public class StatisticsController {

    @Autowired
    private StatisticsService statisticsService;

    @GetMapping("/dashboard")
    public String dashboard() {
        return "admin/statistics";
    }

    @GetMapping("/data")
    @ResponseBody
    public Result<Map<String, Object>> getData() {
        Map<String, Object> data = statisticsService.getDateboardData();
        return Result.success(data);
    }
}
