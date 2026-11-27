
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp"/>

<div class="titulo-pagina">
    <h1>Seguimiento de clientes</h1>
    <span class="codigo">SOPORTE 02</span>
</div>

<p class="sub">Consulta y administra la información de los clientes registrados.</p>

<c:if test="${not empty mensaje}">
    <div class="panel">
        <div class="exito">
            <p><c:out value="${mensaje}"/></p>
        </div>
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="error">
        <p><c:out value="${error}"/></p>
    </div>
</c:if>

<div class="panel">
    <h3>Buscar clientes</h3>

    <form method="get" action="${pageContext.request.contextPath}/seguimiento/clientes" class="formulario">
        <label>Buscar por DNI o nombre</label>
        <input type="text" name="buscar" value="<c:out value='${buscar}'/>" placeholder="Ingrese DNI o nombre">

        <div class="acciones">
            <button type="submit" class="btn">Buscar</button>
            <a href="${pageContext.request.contextPath}/seguimiento/clientes" class="btn sec">Limpiar</a>
        </div>
    </form>
</div>

<div class="panel">
    <h3>Clientes registrados</h3>

    <div style="overflow-x:auto;">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>DNI</th>
                    <th>Nombre</th>
                    <th>Apellido</th>
                    <th>Teléfono</th>
                    <th>Correo</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="c" items="${clientes}">
                    <tr>
                        <td><c:out value="${c['ID_CLIENTE']}"/></td>
                        <td><c:out value="${c['DNI']}"/></td>
                        <td><c:out value="${c['NOMBRE']}"/></td>
                        <td><c:out value="${c['APELLIDO']}"/></td>
                        <td><c:out value="${c['TELEFONO']}"/></td>
                        <td><c:out value="${c['EMAIL']}"/></td>
                        <td>
                            <a class="btn" href="${pageContext.request.contextPath}/seguimiento/cliente/editar/${c['ID_CLIENTE']}">Editar</a>
                            <a class="btn sec" href="${pageContext.request.contextPath}/seguimiento/historial/${c['ID_CLIENTE']}">Historial</a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty clientes}">
                    <tr>
                        <td colspan="7">No se encontraron clientes registrados.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
