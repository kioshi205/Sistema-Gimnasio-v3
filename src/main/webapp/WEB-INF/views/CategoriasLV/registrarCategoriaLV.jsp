<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Registrar Categoría"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Registrar Categoría</h1>
    <span class="codigo">F06</span>
</div>
<p class="sub">Ingresa los datos de la nueva categoría.</p>

<c:if test="${not empty errores}">
    <div class="error">
        <c:forEach var="mensaje" items="${errores}">
            <p>${mensaje}</p>
        </c:forEach>
    </div>
</c:if>

<form class="panel formulario" method="post" action="${pageContext.request.contextPath}/categorias/registrar">
    <label for="nombreCategoria">Nombre de la categoría *</label>
    <input type="text" id="nombreCategoria" name="nombreCategoria" maxlength="60"
           value="<c:out value='${categoria.nombreCategoria}'/>" required>

    <label for="descripcion">Descripción</label>
    <input type="text" id="descripcion" name="descripcion" maxlength="200"
           value="<c:out value='${categoria.descripcion}'/>">

    <small>La categoría se registrará con estado ACTIVO.</small>

    <div class="acciones">
        <a class="btn sec" href="${pageContext.request.contextPath}/categorias">Cancelar</a>
        <button class="btn" type="submit">Registrar categoría</button>
    </div>
</form>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
