package com.petadoption.service.impl;

import com.petadoption.entity.Message;
import com.petadoption.mapper.MessageMapper;
import com.petadoption.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MessageServiceImpl implements MessageService {

    @Autowired
    private MessageMapper messageMapper;

    @Override
    public boolean sendMessage(Integer userId, String content) {
        Message message = new Message();
        message.setUserId(userId);
        message.setContent(content);
        return messageMapper.insert(message) > 0;
    }

    @Override
    public List<Message> getUserMessages(Integer userId) {
        return messageMapper.selectByUserId(userId);
    }

    @Override
    public boolean markAsRead(Integer messageId) {
        return messageMapper.updateReadStatus(messageId) > 0;
    }

    @Override
    public int getUnreadCount(Integer userId) {
        return messageMapper.selectUnreadCount(userId);
    }
}
