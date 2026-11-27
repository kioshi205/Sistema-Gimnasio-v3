
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp"/>

<div class="titulo-pagina">
    <h1>Historial del cliente</h1>
    <span class="codigo">HISTORIAL</span>
</div>

<p class="sub">Consulta los registros de suscripción del cliente.</p>

<div class="panel">
    <h3>Información del cliente</h3>

    <div class="fila">
        <strong>Nombre completo</strong>
        <span><c:out value="${cliente['NOMBRE']}"/> <c:out value="${cliente['APELLIDO']}"/></span>
    </div>

    <div class="fila">
        <strong>DNI</strong>
        <span><c:out value="${cliente['DNI']}"/></span>
    </div>
</div>

<div class="panel">
    <h3>Historial de suscripciones</h3>

    <div style="overflow-x:auto;">
        <table>
            <thead>
                <tr>
                    <th>Código</th>
                    <th>Plan</th>
                    <th>Detalle</th>
                    <th>Inicio</th>
                    <th>Vencimiento</th>
                    <th>Monto</th>
                    <th>Estado</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="h" items="${historial}">
                    <tr>
                        <td><c:out value="${h['ID_SUSCRIPCION']}"/></td>
                        <td><c:out value="${h['NOMBRE_PLAN']}"/></td>
                        <td><c:out value="${h['DETALLE']}"/></td>
                        <td><c:out value="${h['FECHA_INICIO']}"/></td>
                        <td><c:out value="${h['FECHA_FIN']}"/></td>
                        <td>S/ <fmt:formatNumber value="${h['MONTO_TOTAL']}" minFractionDigits="2"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${h['ESTADO_SUSCRIPCION'] == 'Vigente'}">
                                    <span style="display:inline-block;padding:7px 12px;border-radius:999px;background:#dcfce7;color:#167344;font-weight:700;">Vigente</span>
                                </c:when>
                                <c:when test="${h['ESTADO_SUSCRIPCION'] == 'Por vencer'}">
                                    <span style="display:inline-block;padding:7px 12px;border-radius:999px;background:#fef3c7;color:#946200;font-weight:700;">Por vencer</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="display:inline-block;padding:7px 12px;border-radius:999px;background:#fff1f2;color:#b4233a;font-weight:700;">Vencida</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty historial}">
                    <tr>
                        <td colspan="7">No existen registros de suscripción.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <div class="acciones">
        <a href="${pageContext.request.contextPath}/seguimiento/clientes" class="btn sec">Volver a clientes</a>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
