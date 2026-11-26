<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Editar datos del cliente"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Editar datos del cliente</h1>
    <span class="codigo">INT15 - F15</span>
</div>

<p class="sub">Actualiza la información personal del cliente registrado.</p>

<c:if test="${not empty error}">
    <div class="error">
        <p><c:out value="${error}"/></p>
    </div>
</c:if>

<div class="panel">
    <h3>Información del cliente</h3>

    <form action="${pageContext.request.contextPath}/seguimiento/cliente/guardar"
          method="post" class="formulario">

        <input type="hidden" name="idCliente" value="${cliente.ID_CLIENTE}">

        <label for="dni">DNI</label>
        <input type="text" id="dni" value="${cliente.DNI}" readonly
               style="background:#f0f7f8;color:#5b7c86;">

        <label for="nombre">Nombre</label>
        <input type="text" id="nombre" name="nombre"
               value="<c:out value='${cliente.NOMBRE}'/>"
               maxlength="60" required>

        <label for="apellido">Apellido</label>
        <input type="text" id="apellido" name="apellido"
               value="<c:out value='${cliente.APELLIDO}'/>"
               maxlength="80" required>

        <label for="telefono">Teléfono</label>
        <input type="text" id="telefono" name="telefono"
               value="<c:out value='${cliente.TELEFONO}'/>"
               maxlength="9" pattern="[0-9]{9}"
               title="Debe contener exactamente 9 dígitos">

        <label for="email">Correo electrónico</label>
        <input type="email" id="email" name="email"
               value="<c:out value='${cliente.EMAIL}'/>"
               maxlength="100">

        <small>El DNI no puede modificarse. El teléfono debe contener 9 dígitos y el correo no debe estar registrado por otro cliente.</small>

        <div class="acciones">
            <a href="${pageContext.request.contextPath}/seguimiento/clientes"
               class="btn sec">Cancelar</a>
            <button type="submit" class="btn">Guardar cambios</button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>