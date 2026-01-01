package com.petadoption.util;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import java.io.IOException;

/**
 * 兼容性过滤器 - 解决 Tomcat 7 (Servlet 3.0) 缺少 setContentLengthLong 方法的问题
 * 该方法在 Servlet 3.1 中引入，Spring 5.x 会调用它
 */
public class Tomcat7CompatibilityFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (response instanceof HttpServletResponse) {
            chain.doFilter(request, new Tomcat7ResponseWrapper((HttpServletResponse) response));
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
    }

    private static class Tomcat7ResponseWrapper extends HttpServletResponseWrapper {
        public Tomcat7ResponseWrapper(HttpServletResponse response) {
            super(response);
        }

        // 核心修复：手动实现的 Servlet 3.1 方法
        public void setContentLengthLong(long len) {
            if (len <= Integer.MAX_VALUE) {
                setContentLength((int) len);
            } else {
                setHeader("Content-Length", String.valueOf(len));
            }
        }
    }
}
