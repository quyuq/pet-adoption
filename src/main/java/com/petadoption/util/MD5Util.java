package com.petadoption.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * MD5加密工具类
 */
public class MD5Util {

    /**
     * 对字符串进行MD5加密
     * 
     * @param input 原始字符串
     * @return 加密后的字符串
     */
    public static String encrypt(String input) {
        if (input == null || input.isEmpty()) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] digest = md.digest(input.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5加密失败", e);
        }
    }

    /**
     * 加盐MD5加密
     * 
     * @param input 原始字符串
     * @param salt  盐值
     * @return 加密后的字符串
     */
    public static String encryptWithSalt(String input, String salt) {
        return encrypt(input + salt);
    }
}
