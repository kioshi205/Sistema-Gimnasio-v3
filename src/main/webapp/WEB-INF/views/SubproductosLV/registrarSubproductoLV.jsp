<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Registrar Subproducto"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Registrar Subproducto</h1>
    <span class="codigo">F09</span>
</div>
<p class="sub">Registra un nuevo servicio individual.</p>

<c:if test="${not empty errores}">
    <div class="error">
        <c:forEach var="mensaje" items="${errores}">
            <p>${mensaje}</p>
        </c:forEach>
    </div>
</c:if>

<form class="panel formulario" method="post" action="${pageContext.request.contextPath}/subproductos/registrar">
    <label for="idCategoria">Categoría *</label>
    <select id="idCategoria" name="idCategoria" required>
        <option value="">Seleccione una categoría</option>
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

    <small>Solo se pueden registrar subproductos en categorías activas. El estado inicial será ACTIVO.</small>

    <div class="acciones">
        <a class="btn sec" href="${pageContext.request.contextPath}/subproductos">Cancelar</a>
        <button class="btn" type="submit">Registrar subproducto</button>
    </div>
</form>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
