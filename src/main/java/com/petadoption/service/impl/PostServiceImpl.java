package com.petadoption.service.impl;

import com.github.pagehelper.PageHelper;
import com.petadoption.entity.Post;
import com.petadoption.mapper.PostMapper;
import com.petadoption.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PostServiceImpl implements PostService {

    @Autowired
    private PostMapper postMapper;

    @Override
    public boolean publish(Post post) {
        return postMapper.insert(post) > 0;
    }

    @Override
    public List<Post> getPosts(int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        return postMapper.selectAll();
    }

    @Override
    public List<Post> getUserPosts(Integer userId, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        return postMapper.selectByUserId(userId);
    }

    @Override
    public boolean deletePost(Integer id) {
        return postMapper.deleteById(id) > 0;
    }

    @Override
    public Post getPostDetail(Integer id) {
        postMapper.incrementViewCount(id);
        return postMapper.selectById(id);
    }
}
