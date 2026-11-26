<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Renovar suscripción"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Renovar suscripción</h1>
    <span class="codigo">INT18 - F18</span>
</div>

<p class="sub">Registra un nuevo periodo de 30 días utilizando la información de la suscripción anterior.</p>

<c:if test="${not empty error}">
    <div class="error">
        <p><c:out value="${error}"/></p>
    </div>
</c:if>

<div class="panel">
    <h3>Información de la suscripción actual</h3>

    <div class="fila">
        <strong>Código de suscripción</strong>
        <span>#${suscripcion.ID_SUSCRIPCION}</span>
    </div>

    <div class="fila">
        <strong>Cliente</strong>
        <span><c:out value="${suscripcion.NOMBRE}"/> <c:out value="${suscripcion.APELLIDO}"/></span>
    </div>

    <div class="fila">
        <strong>DNI</strong>
        <span><c:out value="${suscripcion.DNI}"/></span>
    </div>

    <div class="fila">
        <strong>Plan actual</strong>
        <span><c:out value="${suscripcion.PLAN}"/></span>
    </div>

    <div class="fila">
        <strong>Fecha de inicio anterior</strong>
        <span><fmt:formatDate value="${suscripcion.FECHA_INICIO}" pattern="dd/MM/yyyy"/></span>
    </div>

    <div class="fila">
        <strong>Fecha de finalización anterior</strong>
        <span><fmt:formatDate value="${suscripcion.FECHA_FIN}" pattern="dd/MM/yyyy"/></span>
    </div>

    <div class="fila">
        <strong>Monto anterior</strong>
        <span>S/ <fmt:formatNumber value="${suscripcion.MONTO_TOTAL}" minFractionDigits="2"/></span>
    </div>
</div>

<div class="panel">
    <h3>Condiciones de renovación</h3>

    <div class="fila">
        <span>Duración de la nueva suscripción</span>
        <strong>30 días</strong>
    </div>

    <div class="fila">
        <span>Datos del cliente</span>
        <strong>Se conservan</strong>
    </div>

    <div class="fila">
        <span>Plan y servicios</span>
        <strong>Se conservan</strong>
    </div>

    <div class="fila">
        <span>Registro</span>
        <strong>Nueva fila en SUSCRIPCION</strong>
    </div>

    <p class="sub" style="margin-top:16px;">
        Si la suscripción está por vencer, el nuevo periodo comenzará al finalizar la fecha de vigencia anterior.
        Si ya venció, comenzará desde la fecha actual.
    </p>
</div>

<div class="panel">
    <h3>Confirmar renovación</h3>

    <form action="${pageContext.request.contextPath}/seguimiento/renovar/confirmar"
          method="post">

        <input type="hidden" name="idSuscripcion"
               value="${suscripcion.ID_SUSCRIPCION}">

        <p>¿Desea registrar una nueva suscripción para este cliente?</p>

        <div class="acciones">
            <a href="${pageContext.request.contextPath}/seguimiento/suscripciones"
               class="btn sec">Cancelar</a>

            <button type="submit" class="btn"
                    onclick="return confirm('¿Confirma la renovación de esta suscripción?')">
                Confirmar renovación
            </button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>