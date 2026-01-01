package com.petadoption.mapper;

import com.petadoption.entity.Post;
import java.util.List;

public interface PostMapper {
    int insert(Post post);

    int deleteById(Integer id);

    List<Post> selectAll();

    Post selectById(Integer id);

    List<Post> selectByUserId(Integer userId);

    int incrementViewCount(Integer id);
}
