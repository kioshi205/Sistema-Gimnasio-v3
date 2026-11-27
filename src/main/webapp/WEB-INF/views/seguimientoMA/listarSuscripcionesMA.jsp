
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Seguimiento de suscripciones"/>
</jsp:include>

<h2 class="titulo-pagina">SEGUIMIENTO DE SUSCRIPCIONES</h2>
<p class="sub">Consulta las suscripciones y controla sus fechas de vigencia.</p>

<c:if test="${param.renovada != null}">
    <div class="exito">La renovación se registró correctamente.</div>
</c:if>

<c:if test="${param.mejorada != null}">
    <div class="exito">El plan se actualizó correctamente.</div>
</c:if>

<c:if test="${param.error != null}">
    <div class="error">No se pudo realizar la operación. Verifica el estado de la suscripción.</div>
</c:if>

<div class="grid">
    <div class="card">
        <h3>Clientes</h3>
        <p class="descripcion">Consultar y editar información de clientes.</p>
        <a class="btn" href="${pageContext.request.contextPath}/seguimiento/clientes">
            Consultar clientes
        </a>
    </div>
</div>

<div class="panel">
    <h3>Listado de suscripciones</h3>

    <div style="overflow-x:auto;">
        <table style="width:100%;border-collapse:collapse;">
            <thead>
            <tr>
                <th style="padding:12px;text-align:left;">Cliente</th>
                <th style="padding:12px;text-align:left;">DNI</th>
                <th style="padding:12px;text-align:left;">Plan</th>
                <th style="padding:12px;text-align:left;">Inicio</th>
                <th style="padding:12px;text-align:left;">Vencimiento</th>
                <th style="padding:12px;text-align:left;">Monto</th>
                <th style="padding:12px;text-align:left;">Estado</th>
                <th style="padding:12px;text-align:center;">Acciones</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="s" items="${suscripciones}">
                <tr>
                    <td style="padding:12px;">${s.NOMBRE} ${s.APELLIDO}</td>
                    <td style="padding:12px;">${s.DNI}</td>
                    <td style="padding:12px;">${s.NOMBRE_PLAN}</td>
                    <td style="padding:12px;">${s.FECHA_INICIO}</td>
                    <td style="padding:12px;">${s.FECHA_FIN}</td>
                    <td style="padding:12px;">
                        S/ <fmt:formatNumber value="${s.MONTO_TOTAL}" minFractionDigits="2"/>
                    </td>
                    <td style="padding:12px;">
                        <c:choose>
                            <c:when test="${s.ESTADO_SUSCRIPCION == 'Vigente'}">
                                <span class="badge">Vigente</span>
                            </c:when>
                            <c:when test="${s.ESTADO_SUSCRIPCION == 'Por vencer'}">
                                <span class="codigo">Por vencer</span>
                            </c:when>
                            <c:otherwise>
                                <span class="error">Vencida</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="padding:12px;">
                        <div class="acciones">
                            <a class="btn sec"
                               href="${pageContext.request.contextPath}/seguimiento/historial/${s.ID_CLIENTE}">
                                Historial
                            </a>

                            <c:if test="${s.ESTADO_SUSCRIPCION == 'Por vencer' || s.ESTADO_SUSCRIPCION == 'Vencida'}">
                                <a class="btn"
                                   href="${pageContext.request.contextPath}/seguimiento/renovar/${s.ID_SUSCRIPCION}">
                                    Renovar
                                </a>
                            </c:if>

                            <c:if test="${s.ESTADO_SUSCRIPCION == 'Vigente'}">
                                <a class="btn"
                                   href="${pageContext.request.contextPath}/seguimiento/mejorar/${s.ID_SUSCRIPCION}">
                                    Mejorar plan
                                </a>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty suscripciones}">
                <tr>
                    <td colspan="8" style="padding:20px;text-align:center;">
                        No existen suscripciones registradas.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
