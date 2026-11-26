<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Listado de Subproductos"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Listado de Subproductos</h1>
    <span class="codigo">F11</span>
</div>
<p class="sub">Filtra por categoría o administra los servicios individuales.</p>

<form class="panel formulario" method="get" action="${pageContext.request.contextPath}/subproductos">
    <label for="idCategoria">Filtrar por categoría</label>
    <select id="idCategoria" name="idCategoria">
        <option value="">Todas las categorías</option>
        <c:forEach var="categoria" items="${categorias}">
            <option value="${categoria.idCategoria}"
                    <c:if test="${idCategoria == categoria.idCategoria}">selected</c:if>>
                <c:out value="${categoria.nombreCategoria}"/>
            </option>
        </c:forEach>
    </select>
    <div class="acciones">
        <button class="btn" type="submit">Filtrar</button>
        <a class="btn sec" href="${pageContext.request.contextPath}/subproductos">Limpiar</a>
    </div>
</form>

<div class="acciones">
    <a class="btn" href="${pageContext.request.contextPath}/subproductos/registrar">Registrar subproducto</a>
</div>

<c:if test="${empty subproductos}">
    <p class="sub">No hay subproductos para mostrar.</p>
</c:if>

<div class="panel">
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Categoría</th>
            <th>Nombre del subproducto</th>
            <th>Precio</th>
            <th>Estado</th>
            <th>Acción</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="subproducto" items="${subproductos}">
            <tr>
                <td>${subproducto.idSubproducto}</td>
                <td><c:out value="${subproducto.nombreCategoria}"/></td>
                <td><c:out value="${subproducto.nombreSubproducto}"/></td>
                <td>S/ <fmt:formatNumber value="${subproducto.precioIndividual}" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td>
                    <c:if test="${subproducto.estado == 'ACTIVO'}">
                        <span class="codigo">ACTIVO</span>
                    </c:if>
                    <c:if test="${subproducto.estado == 'INACTIVO'}">
                        <span class="error">INACTIVO</span>
                    </c:if>
                </td>
                <td>
                    <a class="btn sec"
                       href="${pageContext.request.contextPath}/subproductos/editar?id=${subproducto.idSubproducto}">Editar</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
