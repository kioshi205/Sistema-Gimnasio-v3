<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Editar Categoría"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Editar Categoría</h1>
    <span class="codigo">F08</span>
</div>
<p class="sub">Actualiza los datos de la categoría N.º ${categoria.idCategoria}.</p>

<c:if test="${not empty errores}">
    <div class="error">
        <c:forEach var="mensaje" items="${errores}">
            <p>${mensaje}</p>
        </c:forEach>
    </div>
</c:if>

<c:if test="${not empty planesBloqueados}">
    <div class="error">
        <p><strong>RN02:</strong> Los planes que incluyen sus subproductos no se pueden vender mientras la categoría esté inactiva:</p>
        <c:forEach var="plan" items="${planesBloqueados}">
            <p>${plan}</p>
        </c:forEach>
    </div>
</c:if>

<form class="panel formulario" method="post" action="${pageContext.request.contextPath}/categorias/editar">
    <input type="hidden" name="idCategoria" value="${categoria.idCategoria}">

    <label for="nombreCategoria">Nombre de la categoría *</label>
    <input type="text" id="nombreCategoria" name="nombreCategoria" maxlength="60"
           value="<c:out value='${categoria.nombreCategoria}'/>" required>

    <label for="descripcion">Descripción</label>
    <input type="text" id="descripcion" name="descripcion" maxlength="200"
           value="<c:out value='${categoria.descripcion}'/>">

    <label for="estado">Estado</label>
    <select id="estado" name="estado">
        <option value="ACTIVO" <c:if test="${categoria.estado == 'ACTIVO'}">selected</c:if>>ACTIVO</option>
        <option value="INACTIVO" <c:if test="${categoria.estado == 'INACTIVO'}">selected</c:if>>INACTIVO</option>
    </select>

    <small>El cambio de estado es lógico (no se elimina el registro). Al desactivar, sus subproductos dejan de estar disponibles y los planes que los incluyen dejan de venderse (RN02).</small>

    <div class="acciones">
        <a class="btn sec" href="${pageContext.request.contextPath}/categorias">Cancelar</a>
        <button class="btn" type="submit">Guardar cambios</button>
    </div>
</form>

<c:choose>
    <c:when test="${categoria.estado == 'ACTIVO'}">
        <form method="post" action="${pageContext.request.contextPath}/categorias/desactivar">
            <input type="hidden" name="idCategoria" value="${categoria.idCategoria}">
            <div class="acciones">
                <button class="btn sec" type="submit">Desactivar categoría</button>
            </div>
        </form>
    </c:when>
    <c:otherwise>
        <form method="post" action="${pageContext.request.contextPath}/categorias/activar">
            <input type="hidden" name="idCategoria" value="${categoria.idCategoria}">
            <div class="acciones">
                <button class="btn sec" type="submit">Activar categoría</button>
            </div>
        </form>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
