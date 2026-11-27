<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Gestión de Planes"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Gestión de Planes</h1>
    <span class="codigo">INT12</span>
</div>
<p class="sub">Consulta y actualiza los subproductos incluidos en los planes predeterminados del gimnasio.</p>

<c:if test="${not empty mensajeExito}">
    <div class="panel" style="border-left: 5px solid var(--cian); color: var(--cian-oscuro); font-weight: 700;">
        &#10004; <c:out value="${mensajeExito}"/>
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="error"><c:out value="${error}"/></div>
</c:if>

<div class="grid">
    <c:forEach var="plan" items="${planes}">
        <div class="card">
            <h2><c:out value="${plan.nombrePlan}"/></h2>
            <div class="precio">S/ <fmt:formatNumber value="${plan.precioBase}" minFractionDigits="2" maxFractionDigits="2"/></div>
            <small>${plan.duracionDias} días</small>

            <c:choose>
                <c:when test="${empty plan.incluye}">
                    <p class="descripcion">Sin subproductos incluidos.</p>
                </c:when>
                <c:otherwise>
                    <ul>
                        <c:forEach var="servicio" items="${plan.incluye}">
                            <li><c:out value="${servicio}"/></li>
                        </c:forEach>
                    </ul>
                </c:otherwise>
            </c:choose>

            <a class="btn" href="${pageContext.request.contextPath}/gestion-planes/editar/${plan.idPlan}">Editar plan</a>
        </div>
    </c:forEach>
</div>

<c:if test="${empty planes}">
    <div class="error">No se encontraron los planes predeterminados.</div>
</c:if>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
