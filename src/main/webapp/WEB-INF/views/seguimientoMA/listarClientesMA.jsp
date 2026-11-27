
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Listado de Clientes"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Listado de Clientes</h1>
    <span class="codigo">F14</span>
</div>

<p class="sub">Consulta y administra los clientes registrados en el gimnasio.</p>

<form class="panel formulario" method="get"
      action="${pageContext.request.contextPath}/seguimiento/clientes">

    <label for="buscar">Buscar cliente</label>
    <input type="text" id="buscar" name="buscar"
           value="<c:out value='${buscar}'/>"
           placeholder="Ingrese DNI, nombres o apellidos">

    <div class="acciones">
        <button class="btn" type="submit">Buscar</button>
        <a class="btn sec"
           href="${pageContext.request.contextPath}/seguimiento/clientes">
            Limpiar
        </a>
    </div>
</form>

<c:if test="${empty clientes}">
    <p class="sub">No hay clientes registrados para mostrar.</p>
</c:if>

<div class="panel">
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>DNI</th>
            <th>Nombres</th>
            <th>Apellidos</th>
            <th>Teléfono</th>
            <th>Correo electrónico</th>
            <th>Acción</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach var="cliente" items="${clientes}">
            <tr>
                <td><c:out value="${cliente['ID_CLIENTE']}"/></td>
                <td><c:out value="${cliente['DNI']}"/></td>
                <td><c:out value="${cliente['NOMBRE']}"/></td>
                <td><c:out value="${cliente['APELLIDO']}"/></td>
                <td><c:out value="${cliente['TELEFONO']}"/></td>
                <td><c:out value="${cliente['EMAIL']}"/></td>
                <td>
                    <a class="btn sec"
                       href="${pageContext.request.contextPath}/seguimiento/cliente/editar/${cliente['ID_CLIENTE']}">
                        Editar
                    </a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
