package com.petadoption.controller;

import com.github.pagehelper.PageInfo;
import com.petadoption.entity.Post;
import com.petadoption.entity.User;
import com.petadoption.service.PostService;
import com.petadoption.util.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

    private static final Logger logger = LoggerFactory.getLogger(PostController.class);

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
        // 仅允许个人用户（ROLE_USER）发布社区动态
        if (user.getRole() != null && user.getRole() == User.ROLE_USER) {
            return "community/publish";
        }
        return "redirect:/community/index";
    }

    @PostMapping("/publish")
    @ResponseBody
    public Result<String> publish(Post post, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return Result.error(Result.UNAUTHORIZED, "请先登录");
        }
        // 仅允许个人用户发布
        if (user.getRole() == null || user.getRole() != User.ROLE_USER) {
            return Result.error(Result.FORBIDDEN, "仅个人用户可发布社区动态");
        }
        post.setUserId(user.getId());
        try {
            logger.info("用户 {} 提交社区动态，内容长度={}，imageUrl={}", user.getId(), post.getContent() == null ? 0 : post.getContent().length(), post.getImageUrl());
            boolean success = postService.publish(post);
            if (success) {
                logger.info("用户 {} 发布成功，postId 将由数据库生成", user.getId());
                return Result.success("发布成功", null);
            } else {
                logger.warn("用户 {} 发布失败，postService.publish 返回 false", user.getId());
                return Result.error("发布失败");
            }
        } catch (Exception e) {
            logger.error("发布异常，userId={}", user.getId(), e);
            return Result.error("发布失败: " + e.getMessage());
        }
    }

    @GetMapping("/mine")
    public String myPosts(@RequestParam(defaultValue = "1") int page, HttpSession session, Model model) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/user/login";
        }
        // 仅个人用户可以查看自己的发布
        if (user.getRole() == null || user.getRole() != User.ROLE_USER) {
            return "redirect:/community/index";
        }

        List<Post> posts = postService.getUserPosts(user.getId(), page, 10);
        com.github.pagehelper.PageInfo<Post> pageInfo = new com.github.pagehelper.PageInfo<>(posts);
        model.addAttribute("pageInfo", pageInfo);
        return "community/mine";
    }

    @PostMapping("/delete")
    @ResponseBody
    public Result<String> delete(@RequestParam Integer id, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return Result.error(Result.UNAUTHORIZED, "请先登录");
        }

        Post post = postService.getPostDetail(id);
        if (post == null) {
            return Result.error(404, "帖子不存在");
        }

        boolean isOwner = false;
        if (post.getUserId() != null && user.getId() != null) {
            isOwner = post.getUserId().intValue() == user.getId().intValue();
        }

        // 只有发布者或管理员能删除
        if (isOwner || (user.getRole() != null && user.getRole() == User.ROLE_ADMIN)) {
            try {
                boolean ok = postService.deletePost(id);
                if (ok) {
                    return Result.success("删除成功", null);
                }
                return Result.error("删除失败");
            } catch (Exception e) {
                logger.error("删除帖子异常，postId={}, userId={}", id, user.getId(), e);
                return Result.error("删除失败: " + e.getMessage());
            }
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

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        Post post = postService.getPostDetail(id);
        if (post == null) {
            return "redirect:/community/index";
        }
        model.addAttribute("post", post);
        return "community/detail";
    }

    @PostMapping("/like")
    @ResponseBody
    public Result<String> like(@RequestParam Integer id, HttpSession session) {
        User user = (User) session.getAttribute("loginUser");
        if (user == null) {
            return Result.error(Result.UNAUTHORIZED, "请先登录");
        }
        try {
            boolean ok = postService.likePost(id);
            if (ok) return Result.success("点赞成功", null);
            return Result.error("点赞失败");
        } catch (Exception e) {
            logger.error("点赞异常，postId={}", id, e);
            return Result.error("点赞失败: " + e.getMessage());
        }
    }
}
