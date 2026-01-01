package com.petadoption.controller;

import com.github.pagehelper.PageInfo;
import com.petadoption.entity.Post;
import com.petadoption.entity.User;
import com.petadoption.service.PostService;
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

@Controller
@RequestMapping("/community")
public class PostController {

    @Autowired
    private PostService postService;

    @GetMapping("/index")
    public String index(@RequestParam(defaultValue = "1") int page, Model model) {
        List<Post> posts = postService.getPosts(page, 10);
        PageInfo<Post> pageInfo = new PageInfo<>(posts);
        model.addAttribute("pageInfo", pageInfo);
        return "community/index";
    }

    @GetMapping("/publish")
    public String publishPage(HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/user/login";
        }
        return "community/publish";
    }

    @PostMapping("/publish")
    @ResponseBody
    public Result<String> publish(Post post, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return Result.error(Result.UNAUTHORIZED, "请先登录");
        }
        post.setUserId(user.getId());
        boolean success = postService.publish(post);
        return success ? Result.success("发布成功", null) : Result.error("发布失败");
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result<String> delete(@RequestParam Integer id, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return Result.error(Result.UNAUTHORIZED, "请先登录");
        }

        Post post = postService.getPostDetail(id);
        // 只有发布者或管理员能删除
        if (post != null && (post.getUserId().equals(user.getId()) || user.getRole() == User.ROLE_ADMIN)) {
            postService.deletePost(id);
            return Result.success("删除成功", null);
        }
        return Result.error(Result.FORBIDDEN, "无权操作");
    }

    @PostMapping("/upload")
    @ResponseBody
    public Result<String> upload(@RequestParam("file") MultipartFile file, HttpSession session) {
        if (file.isEmpty()) {
            return Result.error("文件为空");
        }
        try {
            String path = session.getServletContext().getRealPath("/static/upload/community/");
            File dir = new File(path);
            if (!dir.exists())
                dir.mkdirs();

            String suffix = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
            String fileName = UUID.randomUUID().toString() + suffix;

            file.transferTo(new File(dir, fileName));

            return Result.success("上传成功", "/static/upload/community/" + fileName);
        } catch (IOException e) {
            e.printStackTrace();
            return Result.error("上传失败");
        }
    }
}
