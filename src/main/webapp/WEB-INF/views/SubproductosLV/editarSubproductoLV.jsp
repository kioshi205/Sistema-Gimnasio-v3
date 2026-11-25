<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Editar Subproducto"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Editar Subproducto</h1>
    <span class="codigo">F10</span>
</div>
<p class="sub">Actualiza los datos del subproducto N.º ${subproducto.idSubproducto}.</p>

<c:if test="${not empty errores}">
    <div class="error">
        <c:forEach var="mensaje" items="${errores}">
            <p>${mensaje}</p>
        </c:forEach>
    </div>
</c:if>

<c:if test="${not empty planesBloqueados}">
    <div class="error">
        <p><strong>RN02:</strong> Los planes que incluyen este subproducto no se pueden vender mientras esté inactivo:</p>
        <c:forEach var="plan" items="${planesBloqueados}">
            <p>${plan}</p>
        </c:forEach>
    </div>
</c:if>

<form class="panel formulario" method="post" action="${pageContext.request.contextPath}/subproductos/editar">
    <input type="hidden" name="idSubproducto" value="${subproducto.idSubproducto}">

    <label for="idCategoria">Categoría *</label>
    <select id="idCategoria" name="idCategoria" required>
        <c:forEach var="categoria" items="${categorias}">
            <option value="${categoria.idCategoria}"
                    <c:if test="${subproducto.idCategoria == categoria.idCategoria}">selected</c:if>>
                <c:out value="${categoria.nombreCategoria}"/>
            </option>
        </c:forEach>
    </select>

    <label for="nombreSubproducto">Nombre del subproducto *</label>
    <input type="text" id="nombreSubproducto" name="nombreSubproducto" maxlength="100"
           value="<c:out value='${subproducto.nombreSubproducto}'/>" required>

    <label for="precioIndividual">Precio individual (S/) *</label>
    <input type="number" id="precioIndividual" name="precioIndividual" min="0" step="0.01"
           value="<c:out value='${precioTexto}'/>" required>

    <label for="estado">Estado</label>
    <select id="estado" name="estado">
        <option value="ACTIVO" <c:if test="${subproducto.estado == 'ACTIVO'}">selected</c:if>>ACTIVO</option>
        <option value="INACTIVO" <c:if test="${subproducto.estado == 'INACTIVO'}">selected</c:if>>INACTIVO</option>
    </select>

    <small>El precio debe ser mayor o igual a 0.00. El cambio de estado es lógico (no se elimina el registro); al desactivar, los planes que incluyen este servicio dejan de venderse (RN02).</small>

    <div class="acciones">
        <a class="btn sec" href="${pageContext.request.contextPath}/subproductos">Cancelar</a>
        <button class="btn" type="submit">Guardar cambios</button>
    </div>
</form>

<c:choose>
    <c:when test="${subproducto.estado == 'ACTIVO'}">
        <form method="post" action="${pageContext.request.contextPath}/subproductos/desactivar">
            <input type="hidden" name="idSubproducto" value="${subproducto.idSubproducto}">
            <div class="acciones">
                <button class="btn sec" type="submit">Desactivar subproducto</button>
            </div>
        </form>
    </c:when>
    <c:otherwise>
        <form method="post" action="${pageContext.request.contextPath}/subproductos/activar">
            <input type="hidden" name="idSubproducto" value="${subproducto.idSubproducto}">
            <div class="acciones">
                <button class="btn sec" type="submit">Activar subproducto</button>
            </div>
        </form>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
