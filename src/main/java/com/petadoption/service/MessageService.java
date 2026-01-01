package com.petadoption.service;

import com.petadoption.entity.Message;
import java.util.List;

public interface MessageService {
    boolean sendMessage(Integer userId, String content);

    List<Message> getUserMessages(Integer userId);

    boolean markAsRead(Integer messageId);

    int getUnreadCount(Integer userId);
}
