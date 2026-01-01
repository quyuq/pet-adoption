package com.petadoption.aspect;

import com.petadoption.entity.SysLog;
import com.petadoption.entity.User;
import com.petadoption.service.SysLogService;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Arrays;

@Aspect
@Component
public class LogAspect {

    @Autowired
    private SysLogService sysLogService;

    // 切点：拦截Service层的所有增删改方法
    @Pointcut("execution(* com.petadoption.service.impl.*.insert*(..)) || " +
            "execution(* com.petadoption.service.impl.*.update*(..)) || " +
            "execution(* com.petadoption.service.impl.*.delete*(..)) || " +
            "execution(* com.petadoption.service.impl.*.save*(..)) || " +
            "execution(* com.petadoption.service.impl.*.audit*(..)) || " +
            "execution(* com.petadoption.service.impl.*.publish*(..)) || " +
            "execution(* com.petadoption.service.impl.*.submit*(..))")
    public void servicePointcut() {
    }

    @AfterReturning(value = "servicePointcut()", returning = "result")
    public void afterReturning(JoinPoint joinPoint, Object result) {
        // 只有当操作成功（返回true或非空对象）时才记录
        if (result instanceof Boolean && !((Boolean) result)) {
            return;
        }

        try {
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder
                    .getRequestAttributes();
            if (attributes == null)
                return;

            HttpServletRequest request = attributes.getRequest();
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("loginUser");

            SysLog log = new SysLog();

            if (user != null) {
                log.setUserId(user.getId());
                log.setUsername(user.getUsername());
            } else {
                // 如果是登录，可能还没有session，从参数中尝试获取（这里简化，如果是注册/登录专门处理）
                log.setUsername("访客");
            }

            String className = joinPoint.getTarget().getClass().getSimpleName();
            String methodName = joinPoint.getSignature().getName();
            log.setMethod(className + "." + methodName);

            // 简化参数记录，只记录前100个字符避免过长
            String params = Arrays.toString(joinPoint.getArgs());
            if (params.length() > 200)
                params = params.substring(0, 200) + "...";
            log.setParams(params);

            log.setIp(request.getRemoteAddr());
            log.setOperation(getOperationName(methodName));

            sysLogService.saveLog(log);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 根据方法名猜测操作类型
    private String getOperationName(String methodName) {
        if (methodName.startsWith("insert") || methodName.startsWith("save") || methodName.startsWith("submit")
                || methodName.startsWith("publish"))
            return "新增/发布";
        if (methodName.startsWith("update") || methodName.startsWith("audit"))
            return "修改/审核";
        if (methodName.startsWith("delete"))
            return "删除";
        return "其他操作";
    }
}
