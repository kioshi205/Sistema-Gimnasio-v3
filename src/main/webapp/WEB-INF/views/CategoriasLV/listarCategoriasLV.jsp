<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Listado de Categorías"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Listado de Categorías</h1>
    <span class="codigo">F07</span>
</div>
<p class="sub">Administra las categorías de los subproductos.</p>

<div class="acciones">
    <a class="btn" href="${pageContext.request.contextPath}/categorias/registrar">Registrar categoría</a>
</div>

<div class="panel">
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Descripción</th>
            <th>Estado</th>
            <th>Acción</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="categoria" items="${categorias}">
            <tr>
                <td>${categoria.idCategoria}</td>
                <td><c:out value="${categoria.nombreCategoria}"/></td>
                <td><c:out value="${categoria.descripcion}"/></td>
                <td>
                    <c:if test="${categoria.estado == 'ACTIVO'}">
                        <span class="codigo">ACTIVO</span>
                    </c:if>
                    <c:if test="${categoria.estado == 'INACTIVO'}">
                        <span class="error">INACTIVO</span>
                    </c:if>
                </td>
                <td>
                    <a class="btn sec"
                       href="${pageContext.request.contextPath}/categorias/editar?id=${categoria.idCategoria}">Editar</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
