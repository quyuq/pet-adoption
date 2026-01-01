package com.petadoption.mapper;

import com.petadoption.entity.Message;
import java.util.List;

public interface MessageMapper {
    int insert(Message message);

    int updateReadStatus(Integer id);

    List<Message> selectByUserId(Integer userId);

    int selectUnreadCount(Integer userId);
}
