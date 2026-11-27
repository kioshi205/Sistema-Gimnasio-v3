
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp"/>

<div class="titulo-pagina">
    <h1>Renovar suscripción</h1>
    <span class="codigo">F18</span>
</div>

<p class="sub">Renueva la vigencia de la suscripción seleccionada.</p>

<c:if test="${not empty error}">
    <div class="error">
        <p><c:out value="${error}"/></p>
    </div>
</c:if>

<div class="panel">
    <h3>Información de la suscripción</h3>

    <div class="fila">
        <strong>Código</strong>
        <span><c:out value="${suscripcion['ID_SUSCRIPCION']}"/></span>
    </div>

    <div class="fila">
        <strong>Cliente</strong>
        <span><c:out value="${suscripcion['NOMBRE']}"/> <c:out value="${suscripcion['APELLIDO']}"/></span>
    </div>

    <div class="fila">
        <strong>DNI</strong>
        <span><c:out value="${suscripcion['DNI']}"/></span>
    </div>

    <div class="fila">
        <strong>Plan</strong>
        <span><c:out value="${suscripcion['NOMBRE_PLAN']}"/></span>
    </div>

    <div class="fila">
        <strong>Fecha de vencimiento</strong>
        <span><c:out value="${suscripcion['FECHA_FIN']}"/></span>
    </div>

    <div class="fila">
        <strong>Duración</strong>
        <span><c:out value="${suscripcion['DURACION_DIAS']}"/> días</span>
    </div>

    <div class="fila">
        <strong>Monto</strong>
        <span>S/ <fmt:formatNumber value="${suscripcion['MONTO_TOTAL']}" minFractionDigits="2"/></span>
    </div>

    <div class="fila">
        <strong>Estado</strong>
        <span style="display:inline-block;padding:7px 12px;border-radius:999px;background:#fff1f2;color:#b4233a;font-weight:700;">Vencida</span>
    </div>
</div>

<div class="panel">
    <h3>Confirmar renovación</h3>

    <p class="descripcion">
        Al confirmar, se actualizarán las fechas de inicio y vencimiento de esta misma suscripción.
    </p>

    <div class="mensaje-info">
        No se creará una nueva suscripción. Se conservarán los datos del cliente, el plan y el monto.
    </div>

    <form method="post" action="${pageContext.request.contextPath}/seguimiento/renovar/confirmar">
        <input type="hidden" name="idSuscripcion" value="${suscripcion['ID_SUSCRIPCION']}">

        <div class="acciones">
            <button type="submit" class="btn">Confirmar renovación</button>
            <a href="${pageContext.request.contextPath}/seguimiento/suscripciones" class="btn sec">Cancelar</a>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
