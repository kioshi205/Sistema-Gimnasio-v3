<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Catálogo de Planes"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Catálogo de Planes</h1>
    <span class="codigo">F01</span>
</div>
<p class="sub">Elige un plan o arma el tuyo.</p>

<div class="grid">
    <c:forEach var="plan" items="${planes}">
        <div class="card <c:if test='${!plan.disponible}'>bloqueada</c:if>">
            <h2>${plan.nombrePlan}</h2>
            <div class="precio">S/ <fmt:formatNumber value="${plan.precioBase}" minFractionDigits="2" maxFractionDigits="2"/></div>
            <small>${plan.duracionDias} días</small>
            <ul>
                <c:forEach var="servicio" items="${plan.incluye}">
                    <li>${servicio}</li>
                </c:forEach>
            </ul>

            <c:choose>
                <c:when test="${plan.disponible}">
                    <a class="btn" href="${pageContext.request.contextPath}/clientes/registro?idPlan=${plan.idPlan}">Elegir plan</a>
                </c:when>
                <c:otherwise>
                    <div class="error">
                        <p><strong>No disponible temporalmente</strong></p>
                        <p>Servicio desactivado:
                            <c:forEach var="inactivo" items="${plan.serviciosInactivos}" varStatus="estado">
                                ${inactivo}<c:if test="${!estado.last}">, </c:if>
                            </c:forEach>
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </c:forEach>

    <div class="card destacada">
        <h2>Plan personalizado</h2>
        <div class="precio">A tu medida</div>
        <ul>
            <li>Elige solo los subproductos que necesitas</li>
            <li>Pagas la suma de sus precios individuales</li>
        </ul>
        <a class="btn sec" href="${pageContext.request.contextPath}/planes/personalizado">Crear plan personalizado</a>
    </div>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
