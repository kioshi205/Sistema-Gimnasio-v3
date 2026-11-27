
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Editar cliente"/>
</jsp:include>

<h2 class="titulo-pagina">EDITAR DATOS DEL CLIENTE</h2>
<p class="sub">Actualización de la información personal del cliente.</p>

<c:if test="${not empty error}">
    <div class="error">${error}</div>
</c:if>

<div class="panel">
    <form method="post" action="${pageContext.request.contextPath}/seguimiento/cliente/guardar">

        <input type="hidden" name="idCliente" value="${cliente.ID_CLIENTE}">

        <div class="formulario">
            <label>DNI</label>
            <input type="text" value="${cliente.DNI}" readonly>
            <small>El DNI no se puede modificar.</small>

            <label>Nombre</label>
            <input type="text" name="nombre" value="${cliente.NOMBRE}" required maxlength="100">

            <label>Apellido</label>
            <input type="text" name="apellido" value="${cliente.APELLIDO}" required maxlength="100">

            <label>Teléfono</label>
            <input type="text" name="telefono" value="${cliente.TELEFONO}"
                   pattern="[0-9]{9}" maxlength="9" required>

            <label>Correo electrónico</label>
            <input type="email" name="email" value="${cliente.EMAIL}" required maxlength="150">
        </div>

        <div class="acciones" style="margin-top:20px;">
            <button type="submit" class="btn">Guardar cambios</button>
            <a class="btn sec" href="${pageContext.request.contextPath}/seguimiento/clientes">
                Cancelar
            </a>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
