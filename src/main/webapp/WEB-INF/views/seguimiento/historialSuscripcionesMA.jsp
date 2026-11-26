<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Historial de suscripciones"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Historial de suscripciones</h1>
    <span class="codigo">INT17 - F17</span>
</div>

<p class="sub">Consulta cronológicamente las suscripciones anteriores y actuales del cliente.</p>

<div class="panel">
    <h3>Datos del cliente</h3>

    <div class="fila">
        <strong>DNI</strong>
        <span><c:out value="${cliente.DNI}"/></span>
    </div>

    <div class="fila">
        <strong>Cliente</strong>
        <span><c:out value="${cliente.NOMBRE}"/> <c:out value="${cliente.APELLIDO}"/></span>
    </div>

    <div class="fila">
        <strong>Teléfono</strong>
        <span><c:out value="${cliente.TELEFONO}"/></span>
    </div>

    <div class="fila">
        <strong>Correo</strong>
        <span><c:out value="${cliente.EMAIL}"/></span>
    </div>
</div>

<div class="panel">
    <h3>Historial de suscripciones</h3>

    <c:if test="${empty historial}">
        <p class="sub">Este cliente todavía no cuenta con suscripciones registradas.</p>
    </c:if>

    <c:forEach var="h" items="${historial}">
        <div class="card" style="margin-bottom:18px;">
            <div class="titulo-pagina">
                <h2>Suscripción #${h.ID_SUSCRIPCION}</h2>

                <c:choose>
                    <c:when test="${h.ESTADO == 'Vigente'}">
                        <span style="background:#e5f8ee;color:#16834b;padding:6px 12px;border-radius:20px;font-weight:700;">Vigente</span>
                    </c:when>
                    <c:when test="${h.ESTADO == 'Por vencer'}">
                        <span style="background:#fff6df;color:#a66b00;padding:6px 12px;border-radius:20px;font-weight:700;">Por vencer</span>
                    </c:when>
                    <c:otherwise>
                        <span style="background:#fff0f0;color:#c03939;padding:6px 12px;border-radius:20px;font-weight:700;">Vencida</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <p class="descripcion">Plan adquirido: <strong><c:out value="${h.PLAN}"/></strong></p>

            <div class="grid">
                <div>
                    <small>Fecha de inicio</small>
                    <p><strong><fmt:formatDate value="${h.FECHA_INICIO}" pattern="dd/MM/yyyy"/></strong></p>
                </div>

                <div>
                    <small>Fecha de finalización</small>
                    <p><strong><fmt:formatDate value="${h.FECHA_FIN}" pattern="dd/MM/yyyy"/></strong></p>
                </div>

                <div>
                    <small>Monto pagado</small>
                    <p class="precio" style="font-size:1.5rem;">
                        S/ <fmt:formatNumber value="${h.MONTO_TOTAL}" minFractionDigits="2"/>
                    </p>
                </div>
            </div>

            <h3 style="margin-top:16px;">Servicios incluidos</h3>
            <ul style="list-style:none;padding:0;">
                <c:forTokens var="servicio" items="${h.DETALLE}" delims=";">
                    <li style="padding:8px 4px;border-bottom:1px dashed #d4eef3;">
                        <span style="color:#0090ad;font-weight:700;">✓</span>
                        <c:out value="${servicio}"/>
                    </li>
                </c:forTokens>
            </ul>
        </div>
    </c:forEach>
</div>

<div class="acciones">
    <a href="${pageContext.request.contextPath}/seguimiento/clientes"
       class="btn sec">Volver a clientes</a>

    <a href="${pageContext.request.contextPath}/seguimiento/suscripciones"
       class="btn">Ver suscripciones</a>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>