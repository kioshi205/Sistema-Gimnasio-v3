
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Historial del cliente"/>
</jsp:include>

<h2 class="titulo-pagina">HISTORIAL DE SUSCRIPCIONES</h2>
<p class="sub">Consulta las suscripciones anteriores y actuales del cliente.</p>

<div class="panel">
    <h3>Información del cliente</h3>

    <div class="grid">
        <div class="item">
            <strong>DNI</strong>
            <p>${cliente.DNI}</p>
        </div>
        <div class="item">
            <strong>Nombre completo</strong>
            <p>${cliente.NOMBRE} ${cliente.APELLIDO}</p>
        </div>
        <div class="item">
            <strong>Teléfono</strong>
            <p>${cliente.TELEFONO}</p>
        </div>
        <div class="item">
            <strong>Correo</strong>
            <p>${cliente.EMAIL}</p>
        </div>
    </div>
</div>

<div class="panel">
    <h3>Historial registrado</h3>

    <c:forEach var="h" items="${historial}">
        <div class="card" style="margin-bottom:15px;">
            <div class="fila">
                <h3>Suscripción #${h.ID_SUSCRIPCION}</h3>
                <strong>${h.ESTADO_SUSCRIPCION}</strong>
            </div>

            <div class="grid">
                <div class="item">
                    <strong>Plan</strong>
                    <p>${h.NOMBRE_PLAN}</p>
                </div>

                <div class="item">
                    <strong>Fecha de inicio</strong>
                    <p>${h.FECHA_INICIO}</p>
                </div>

                <div class="item">
                    <strong>Fecha de vencimiento</strong>
                    <p>${h.FECHA_FIN}</p>
                </div>

                <div class="item">
                    <strong>Monto registrado</strong>
                    <p>
                        S/ <fmt:formatNumber value="${h.MONTO_TOTAL}" minFractionDigits="2"/>
                    </p>
                </div>
            </div>

            <h4>Servicios incluidos</h4>

            <c:choose>
                <c:when test="${not empty h.DETALLE}">
                    <ul>
                        <c:forTokens items="${h.DETALLE}" delims=";" var="servicio">
                            <li>${servicio}</li>
                        </c:forTokens>
                    </ul>
                </c:when>
                <c:otherwise>
                    <p class="descripcion">No se registraron servicios adicionales.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </c:forEach>

    <c:if test="${empty historial}">
        <p class="descripcion">Este cliente todavía no tiene suscripciones registradas.</p>
    </c:if>
</div>

<div class="acciones">
    <a class="btn sec" href="${pageContext.request.contextPath}/seguimiento/clientes">
        Volver a clientes
    </a>
    <a class="btn" href="${pageContext.request.contextPath}/seguimiento/suscripciones">
        Ver suscripciones
    </a>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
