<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Registro de Cliente"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Registro de Cliente</h1>
    <span class="codigo">F02</span>
</div>
<p class="sub">Ingresa los datos del cliente.</p>

<c:if test="${not empty errores}">
    <div class="error">
        <c:forEach var="mensaje" items="${errores}">
            <p>${mensaje}</p>
        </c:forEach>
    </div>
</c:if>

<form class="panel formulario" method="post" action="${pageContext.request.contextPath}/clientes/registro">
    <c:if test="${not empty idPlan}">
        <input type="hidden" name="idPlan" value="${idPlan}">
    </c:if>
    <c:forEach var="id" items="${ids}">
        <input type="hidden" name="ids" value="${id}">
    </c:forEach>

    <label for="dni">DNI *</label>
    <input type="text" id="dni" name="dni" maxlength="8" value="<c:out value='${cliente.dni}'/>" required>

    <label for="nombre">Nombre *</label>
    <input type="text" id="nombre" name="nombre" maxlength="60" value="<c:out value='${cliente.nombre}'/>">

    <label for="apellido">Apellido *</label>
    <input type="text" id="apellido" name="apellido" maxlength="80" value="<c:out value='${cliente.apellido}'/>">

    <label for="telefono">Teléfono</label>
    <input type="text" id="telefono" name="telefono" maxlength="9" value="<c:out value='${cliente.telefono}'/>">

    <label for="email">Correo electrónico</label>
    <input type="email" id="email" name="email" maxlength="100" value="<c:out value='${cliente.email}'/>">

    <small>Si el DNI ya está registrado se usará el cliente existente.</small>

    <div class="acciones">
        <a class="btn sec" href="${pageContext.request.contextPath}/planes">Cancelar</a>
        <button class="btn" type="submit">Registrar y continuar</button>
    </div>
</form>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
