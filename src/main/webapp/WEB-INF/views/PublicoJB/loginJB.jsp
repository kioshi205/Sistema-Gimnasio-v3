<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerPublicoJB.jsp">
    <jsp:param name="titulo" value="Iniciar sesión"/>
</jsp:include>

<section class="login">
    <h1>Iniciar sesión</h1>
    <p class="sub">Ingresa tus credenciales para acceder al sistema.</p>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <form class="panel formulario" method="post" action="${pageContext.request.contextPath}/login">
        <label for="usuario">Usuario</label>
        <input type="text" id="usuario" name="usuario" required>

        <label for="clave">Contraseña</label>
        <input type="password" id="clave" name="clave" required>

        <div class="acciones">
            <button class="btn" type="submit">Ingresar</button>
        </div>
    </form>
</section>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerPublicoJB.jsp"/>
