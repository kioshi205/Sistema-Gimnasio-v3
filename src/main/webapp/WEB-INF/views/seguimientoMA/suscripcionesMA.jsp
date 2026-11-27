
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp"/>

<div class="titulo-pagina">
    <h1>Seguimiento de suscripciones</h1>
    <span class="codigo">F16</span>
</div>

<p class="sub">Consulta la vigencia y administra las suscripciones de los clientes.</p>

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
    <h3>Filtros de búsqueda</h3>

    <form method="get" action="${pageContext.request.contextPath}/seguimiento/suscripciones" class="formulario">

        <label>Buscar cliente o DNI</label>
        <input type="text" name="buscar" value="<c:out value='${buscar}'/>" placeholder="Ingrese DNI o nombre">

        <label>Estado de suscripción</label>
        <select name="estado">
            <option value="">Todos los estados</option>
            <option value="Vigente" ${estado == 'Vigente' ? 'selected' : ''}>Vigente</option>
            <option value="Por vencer" ${estado == 'Por vencer' ? 'selected' : ''}>Por vencer</option>
            <option value="Vencida" ${estado == 'Vencida' ? 'selected' : ''}>Vencida</option>
        </select>

        <div class="acciones">
            <button type="submit" class="btn">Filtrar</button>
            <a href="${pageContext.request.contextPath}/seguimiento/suscripciones" class="btn sec">Limpiar</a>
        </div>
    </form>
</div>

<div class="panel">
    <h3>Listado de suscripciones</h3>

    <div style="overflow-x:auto;">
        <table>
            <thead>
                <tr>
                    <th>Código</th>
                    <th>Cliente</th>
                    <th>DNI</th>
                    <th>Plan</th>
                    <th>Inicio</th>
                    <th>Vencimiento</th>
                    <th>Monto</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="s" items="${suscripciones}">
                    <tr>
                        <td><c:out value="${s['ID_SUSCRIPCION']}"/></td>
                        <td>
                            <c:out value="${s['NOMBRE']}"/>
                            <c:out value="${s['APELLIDO']}"/>
                        </td>
                        <td><c:out value="${s['DNI']}"/></td>
                        <td><c:out value="${s['NOMBRE_PLAN']}"/></td>
                        <td><c:out value="${s['FECHA_INICIO']}"/></td>
                        <td><c:out value="${s['FECHA_FIN']}"/></td>
                        <td>S/ <fmt:formatNumber value="${s['MONTO_TOTAL']}" minFractionDigits="2"/></td>

                        <td>
                            <c:choose>
                                <c:when test="${s['ESTADO_SUSCRIPCION'] == 'Vigente'}">
                                    <span style="display:inline-block;padding:7px 12px;border-radius:999px;background:#dcfce7;color:#167344;font-weight:700;">Vigente</span>
                                </c:when>

                                <c:when test="${s['ESTADO_SUSCRIPCION'] == 'Por vencer'}">
                                    <span style="display:inline-block;padding:7px 12px;border-radius:999px;background:#fef3c7;color:#946200;font-weight:700;">Por vencer</span>
                                </c:when>

                                <c:otherwise>
                                    <span style="display:inline-block;padding:7px 12px;border-radius:999px;background:#fff1f2;color:#b4233a;font-weight:700;">Vencida</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <a class="btn sec" href="${pageContext.request.contextPath}/seguimiento/historial/${s['ID_CLIENTE']}">Historial</a>

                            <c:if test="${s['ESTADO_SUSCRIPCION'] == 'Por vencer' || s['ESTADO_SUSCRIPCION'] == 'Vencida'}">
                                <a class="btn" href="${pageContext.request.contextPath}/seguimiento/renovar/${s['ID_SUSCRIPCION']}">
                                    Renovar
                                </a>
                            </c:if>

                            <c:if test="${s['ESTADO_SUSCRIPCION'] == 'Vigente'}">
                                <a class="btn" href="${pageContext.request.contextPath}/seguimiento/mejorar/${s['ID_SUSCRIPCION']}">
                                    Mejorar
                                </a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty suscripciones}">
                    <tr>
                        <td colspan="9">No se encontraron suscripciones.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
