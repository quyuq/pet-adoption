package com.petadoption.controller;

import com.petadoption.entity.Message;
import com.petadoption.entity.User;
import com.petadoption.service.MessageService;
import com.petadoption.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/message")
public class MessageController {

    @Autowired
    private MessageService messageService;

    @GetMapping("/list")
    public String list(HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null)
            return "redirect:/user/login";

        List<Message> messages = messageService.getUserMessages(user.getId());
        model.addAttribute("messages", messages);
        return "user/message";
    }

    @PostMapping("/read")
    @ResponseBody
    public Result<String> markRead(@RequestParam Integer id) {
        messageService.markAsRead(id);
        return Result.success("已读");
    }
}
