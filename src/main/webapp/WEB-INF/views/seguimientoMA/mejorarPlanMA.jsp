
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Mejorar Plan"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Mejorar Plan de Suscripción</h1>
    <span class="codigo">F19</span>
</div>

<p class="sub">Selecciona un nuevo plan y los servicios adicionales para mejorar la suscripción.</p>

<div class="panel">
    <h3>Información de la suscripción</h3>

    <div class="grid">
        <div class="card">
            <p class="sub">Cliente</p>
            <strong>
                <c:out value="${suscripcion['NOMBRE']}"/>
                <c:out value="${suscripcion['APELLIDO']}"/>
            </strong>
        </div>

        <div class="card">
            <p class="sub">DNI</p>
            <strong><c:out value="${suscripcion['DNI']}"/></strong>
        </div>

        <div class="card">
            <p class="sub">Plan actual</p>
            <strong><c:out value="${suscripcion['NOMBRE_PLAN']}"/></strong>
        </div>

        <div class="card">
            <p class="sub">Monto actual</p>
            <strong>
                S/ <fmt:formatNumber value="${suscripcion['MONTO_TOTAL']}"
                                     minFractionDigits="2"
                                     maxFractionDigits="2"/>
            </strong>
        </div>
    </div>
</div>

<form class="panel formulario" method="post"
      action="${pageContext.request.contextPath}/seguimiento/mejorar/confirmar">

    <input type="hidden" name="idSuscripcion"
           value="${suscripcion['ID_SUSCRIPCION']}"/>

    <h3>1. Seleccionar nuevo plan</h3>
    <p class="sub">Selecciona el plan al que deseas cambiar.</p>

    <label for="idPlanNuevo">Nuevo plan</label>

    <select id="idPlanNuevo" name="idPlanNuevo" required>
        <option value="">Seleccione un plan</option>

        <c:forEach var="plan" items="${planes}">
            <option value="${plan['ID_PLAN']}">
                <c:out value="${plan['NOMBRE_PLAN']}"/>
                -
                S/ <fmt:formatNumber value="${plan['PRECIO_BASE']}"
                                     minFractionDigits="2"
                                     maxFractionDigits="2"/>
            </option>
        </c:forEach>
    </select>

    <div class="panel">
        <h3>2. Subproductos adicionales</h3>
        <p class="sub">
            Selecciona los servicios que deseas agregar.
        </p>

        <c:if test="${empty subproductos}">
            <p class="sub">No hay subproductos disponibles.</p>
        </c:if>

        <div class="grid">
            <c:forEach var="subproducto" items="${subproductos}">
                <div class="card">
                    <label>
                        <input type="checkbox"
                               name="adicionales"
                               value="${subproducto['ID_SUBPRODUCTO']}"/>

                        <strong>
                            <c:out value="${subproducto['NOMBRE_SUBPRODUCTO']}"/>
                        </strong>
                    </label>

                    <p class="sub">
                        Precio individual:
                        S/ <fmt:formatNumber
                                value="${subproducto['PRECIO_INDIVIDUAL']}"
                                minFractionDigits="2"
                                maxFractionDigits="2"/>
                    </p>
                </div>
            </c:forEach>
        </div>
    </div>

    <div class="acciones">
        <button class="btn" type="submit">
            Confirmar mejora de plan
        </button>

        <a class="btn sec"
           href="${pageContext.request.contextPath}/seguimiento/suscripciones">
            Cancelar
        </a>
    </div>
</form>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
