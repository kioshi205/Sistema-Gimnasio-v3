
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Renovar suscripción"/>
</jsp:include>

<h2 class="titulo-pagina">RENOVAR SUSCRIPCIÓN</h2>
<p class="sub">Registrar un nuevo periodo de suscripción para el cliente.</p>

<div class="panel">
    <h3>Datos de la suscripción anterior</h3>

    <div class="grid">
        <div class="item">
            <strong>Cliente</strong>
            <p>${suscripcion.NOMBRE} ${suscripcion.APELLIDO}</p>
        </div>

        <div class="item">
            <strong>DNI</strong>
            <p>${suscripcion.DNI}</p>
        </div>

        <div class="item">
            <strong>Plan anterior</strong>
            <p>${suscripcion.NOMBRE_PLAN}</p>
        </div>

        <div class="item">
            <strong>Fecha de vencimiento</strong>
            <p>${suscripcion.FECHA_FIN}</p>
        </div>

        <div class="item">
            <strong>Monto anterior</strong>
            <p>
                S/ <fmt:formatNumber value="${suscripcion.MONTO_TOTAL}" minFractionDigits="2"/>
            </p>
        </div>

        <div class="item">
            <strong>Estado</strong>
            <p>${suscripcion.ESTADO_SUSCRIPCION}</p>
        </div>
    </div>
</div>

<div class="panel">
    <h3>Confirmar renovación</h3>

    <p class="descripcion">
        La renovación conservará el plan y los servicios registrados.
        Se creará una nueva suscripción por 30 días.
        La suscripción anterior permanecerá en el historial.
    </p>

    <form method="post" action="${pageContext.request.contextPath}/seguimiento/renovar/confirmar">
        <input type="hidden" name="idSuscripcion" value="${suscripcion.ID_SUSCRIPCION}">

        <div class="item">
            <strong>Duración</strong>
            <p>30 días</p>
        </div>

        <div class="item">
            <strong>Monto de renovación</strong>
            <p>
                S/ <fmt:formatNumber value="${suscripcion.MONTO_TOTAL}" minFractionDigits="2"/>
            </p>
        </div>

        <div class="acciones" style="margin-top:20px;">
            <button type="submit" class="btn">Confirmar renovación</button>

            <a class="btn sec" href="${pageContext.request.contextPath}/seguimiento/suscripciones">
                Cancelar
            </a>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
