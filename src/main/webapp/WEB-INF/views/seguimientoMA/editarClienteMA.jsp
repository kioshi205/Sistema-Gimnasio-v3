
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp"/>

<div class="titulo-pagina">
    <h1>Actualizar cliente</h1>
    <span class="codigo">F15</span>
</div>

<p class="sub">Modifica la información personal del cliente.</p>

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
    <h3>Datos del cliente</h3>

    <form method="post" action="${pageContext.request.contextPath}/seguimiento/cliente/guardar" class="formulario">

        <input type="hidden" name="idCliente" value="${cliente['ID_CLIENTE']}">

        <label>DNI</label>
        <input type="text" name="dni" maxlength="8" required value="${cliente['DNI']}">

        <label>Nombre</label>
        <input type="text" name="nombre" required value="${cliente['NOMBRE']}">

        <label>Apellido</label>
        <input type="text" name="apellido" required value="${cliente['APELLIDO']}">

        <label>Teléfono</label>
        <input type="text" name="telefono" maxlength="9" value="${cliente['TELEFONO']}">

        <label>Correo electrónico</label>
        <input type="email" name="email" value="${cliente['EMAIL']}">

        <div class="acciones">
            <button type="submit" class="btn">Guardar cambios</button>
            <a href="${pageContext.request.contextPath}/seguimiento/clientes" class="btn sec">Volver</a>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
