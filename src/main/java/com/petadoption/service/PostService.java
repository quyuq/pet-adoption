package com.petadoption.service;

import com.petadoption.entity.Post;
import java.util.List;

public interface PostService {
    boolean publish(Post post);

    List<Post> getPosts(int pageNum, int pageSize);

    List<Post> getUserPosts(Integer userId, int pageNum, int pageSize);

    boolean deletePost(Integer id);

    Post getPostDetail(Integer id);
}
