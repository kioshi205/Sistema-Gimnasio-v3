
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp"/>

<div class="titulo-pagina">
    <h1>Mejorar plan de suscripción</h1>
    <span class="codigo">PLANES</span>
</div>

<p class="sub">Selecciona un plan superior y agrega servicios adicionales.</p>

<c:if test="${not empty error}">
    <div class="error">
        <p><c:out value="${error}"/></p>
    </div>
</c:if>

<div class="panel">
    <h3>Información de la suscripción actual</h3>

    <div class="fila">
        <strong>Cliente</strong>
        <span><c:out value="${suscripcion['NOMBRE']}"/> <c:out value="${suscripcion['APELLIDO']}"/></span>
    </div>

    <div class="fila">
        <strong>DNI</strong>
        <span><c:out value="${suscripcion['DNI']}"/></span>
    </div>

    <div class="fila">
        <strong>Plan actual</strong>
        <span><c:out value="${suscripcion['NOMBRE_PLAN']}"/></span>
    </div>

    <div class="total">
        <span>Monto actual</span>
        <span>S/ <fmt:formatNumber value="${suscripcion['MONTO_TOTAL']}" minFractionDigits="2"/></span>
    </div>
</div>

<div class="panel">
    <h3>Servicios actuales</h3>

    <c:if test="${empty subproductosActuales}">
        <p class="descripcion">No se encontraron servicios actuales.</p>
    </c:if>

    <c:forEach var="actual" items="${subproductosActuales}">
        <div class="fila">
            <span><c:out value="${actual['NOMBRE_SUBPRODUCTO']}"/></span>
            <span>Incluido</span>
        </div>
    </c:forEach>
</div>

<div class="panel">
    <h3>Seleccionar nuevo plan</h3>

    <form method="post" action="${pageContext.request.contextPath}/seguimiento/mejorar/confirmar" class="formulario">

        <input type="hidden" name="idSuscripcion" value="${suscripcion['ID_SUSCRIPCION']}">

        <c:forEach var="p" items="${planes}">
            <label class="item" style="display:flex;align-items:center;justify-content:space-between;gap:12px;cursor:pointer;">
                <span style="display:flex;align-items:center;gap:10px;">
                    <input type="radio" name="idPlanNuevo" value="${p['ID_PLAN']}" required style="margin:0;">
                    <span style="font-size:13px;font-weight:600;">
                        <c:out value="${p['NOMBRE_PLAN']}"/>
                    </span>
                </span>

                <span class="precio" style="font-size:14px;white-space:nowrap;">
                    S/ <fmt:formatNumber value="${p['PRECIO_BASE']}" minFractionDigits="2"/>
                </span>
            </label>
        </c:forEach>

        <c:if test="${empty planes}">
            <p class="descripcion">No existen planes con un precio superior al actual.</p>
        </c:if>

        <h3>Servicios adicionales</h3>
        <p class="descripcion">Selecciona los servicios que deseas agregar a la suscripción.</p>

        <div style="display:flex;flex-direction:column;gap:12px;margin-top:15px;">

            <c:forEach var="sp" items="${subproductos}">
                <c:set var="incluido" value="false"/>

                <c:forEach var="actual" items="${subproductosActuales}">
                    <c:if test="${actual['ID_SUBPRODUCTO'] == sp['ID_SUBPRODUCTO']}">
                        <c:set var="incluido" value="true"/>
                    </c:if>
                </c:forEach>

                <c:if test="${not incluido}">
                    <label style="
                        display:flex;
                        align-items:center;
                        justify-content:space-between;
                        gap:15px;
                        padding:18px 20px;
                        border:1px solid #d4eef3;
                        border-radius:14px;
                        background:#ffffff;
                        cursor:pointer;
                        transition:all .2s ease;
                    ">

                        <span style="display:flex;align-items:center;gap:15px;flex:1;min-width:0;">

                            <input
                                type="checkbox"
                                name="adicionales"
                                value="${sp['ID_SUBPRODUCTO']}"
                                style="width:18px;height:18px;accent-color:#00b8d9;flex-shrink:0;">

                            <span style="display:flex;flex-direction:column;gap:5px;">
                                <strong style="font-size:14px;color:#0b2a33;">
                                    <c:out value="${sp['NOMBRE_SUBPRODUCTO']}"/>
                                </strong>

                                <span style="font-size:12px;color:#5b7c86;">
                                    <c:out value="${sp['NOMBRE_CATEGORIA']}"/>
                                </span>
                            </span>

                        </span>

                        <span style="
                            font-size:15px;
                            font-weight:700;
                            color:#0090ad;
                            white-space:nowrap;
                        ">
                            S/
                            <fmt:formatNumber
                                value="${sp['PRECIO_INDIVIDUAL']}"
                                minFractionDigits="2"/>
                        </span>

                    </label>
                </c:if>
            </c:forEach>

        </div>

        <div class="acciones">
            <button type="submit" class="btn" ${empty planes ? 'disabled' : ''}>Confirmar mejora</button>
            <a href="${pageContext.request.contextPath}/seguimiento/suscripciones" class="btn sec">Cancelar</a>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
