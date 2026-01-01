package com.petadoption.util;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

/**
 * 极简静态资源 Servlet - 彻底解决 Tomcat 7 与 Spring 5 资源处理器的兼容性问题
 */
public class SimpleStaticServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 获取请求路径（相对于上下文路径）
        String requestURI = req.getRequestURI();
        String contextPath = req.getContextPath();
        String pathInContext = requestURI.substring(contextPath.length());

        // 获取物理路径
        String realPath = getServletContext().getRealPath(pathInContext);
        if (realPath == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        File file = new File(realPath);
        if (!file.exists() || file.isDirectory()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 设置内容类型
        String mimeType = getServletContext().getMimeType(realPath);
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        resp.setContentType(mimeType);

        // 设置内容长度 (使用 int 兼容 Servlet 3.0)
        long length = file.length();
        if (length <= Integer.MAX_VALUE) {
            resp.setContentLength((int) length);
        } else {
            resp.setHeader("Content-Length", String.valueOf(length));
        }

        // 写入响应流
        try (FileInputStream in = new FileInputStream(file);
                OutputStream out = resp.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
