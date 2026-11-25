<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Confirmación de Suscripción"/>
</jsp:include>

<c:choose>
    <c:when test="${not empty idSuscripcion}">
        <div class="panel exito">
            <div class="check">&#10004;</div>
            <h1>¡Suscripción registrada con éxito!</h1>
            <p class="sub">N.º de suscripción: <strong>${idSuscripcion}</strong></p>
            <a class="btn" href="${pageContext.request.contextPath}/planes">Hecho</a>
        </div>
    </c:when>

    <c:when test="${not empty resumen.fechaFinVigente}">
        <div class="titulo-pagina">
            <h1>Confirmación de Suscripción</h1>
            <span class="codigo">Finish</span>
        </div>
        <div class="error">
            Este usuario ya tiene una suscripción vigente hasta el ${resumen.fechaFinVigente}.
        </div>
        <div class="acciones">
            <a class="btn" href="${pageContext.request.contextPath}/planes">Volver al catálogo</a>
        </div>
    </c:when>

    <c:otherwise>
        <div class="titulo-pagina">
            <h1>Resumen de la Suscripción</h1>
            <span class="codigo">F03</span>
        </div>
        <p class="sub">Verifica los datos y aplica un beneficio promocional si corresponde.</p>

        <c:if test="${not empty resumen.mensajePromocion}">
            <div class="error">${resumen.mensajePromocion}</div>
        </c:if>

        <div class="panel">
            <h3>Cliente</h3>
            <div class="fila"><span>DNI</span><span>${resumen.cliente.dni}</span></div>
            <div class="fila"><span>Nombre</span><span><c:out value="${resumen.cliente.nombre} ${resumen.cliente.apellido}"/></span></div>
        </div>

        <form class="panel formulario" method="get" action="${pageContext.request.contextPath}/suscripciones/resumen">
            <h3>Beneficio Promocional (Opcional - Solo uno)</h3>
            <input type="hidden" name="idCliente" value="${idCliente}">
            <c:if test="${not empty idPlan}">
                <input type="hidden" name="idPlan" value="${idPlan}">
            </c:if>
            <c:forEach var="id" items="${ids}">
                <input type="hidden" name="ids" value="${id}">
            </c:forEach>

            <label for="codigoCupon">Código de cupón (25% de descuento)</label>
            <input type="text" id="codigoCupon" name="codigoCupon" maxlength="30"
                   placeholder="Ej. CAMPAÑA25" value="<c:out value='${codigoCupon}'/>">

            <label for="dniReferente">DNI de socio referente vigente (50% de descuento para clientes nuevos)</label>
            <input type="text" id="dniReferente" name="dniReferente" maxlength="8"
                   placeholder="Ej. 70990011" value="<c:out value='${dniReferente}'/>">

            <small>Puedes usar un cupón o un DNI de socio referente, pero no ambos a la vez.</small>

            <div class="acciones">
                <button class="btn sec" type="submit">Verificar beneficio</button>
            </div>
        </form>

        <div class="panel">
            <h3>Plan: ${resumen.nombrePlan}</h3>
            <c:forEach var="servicio" items="${resumen.incluye}">
                <div class="fila"><span>${servicio}</span></div>
            </c:forEach>
            <div class="fila"><span>Vigencia</span><span>${resumen.fechaInicio} - ${resumen.fechaFin}</span></div>
            <div class="fila">
                <span>Subtotal</span>
                <span>S/ <fmt:formatNumber value="${resumen.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
            </div>

            <c:if test="${resumen.descuentoPersonalizado > 0}">
                <div class="fila">
                    <span>Descuento 15% (5 o más subproductos)</span>
                    <span>- S/ <fmt:formatNumber value="${resumen.descuentoPersonalizado}" minFractionDigits="2" maxFractionDigits="2"/></span>
                </div>
            </c:if>

            <c:if test="${resumen.descuentoPromocion > 0}">
                <div class="fila">
                    <span>${resumen.nombrePromocion}</span>
                    <span>- S/ <fmt:formatNumber value="${resumen.descuentoPromocion}" minFractionDigits="2" maxFractionDigits="2"/></span>
                </div>
            </c:if>

            <div class="total">
                <span>Monto total</span>
                <span>S/ <fmt:formatNumber value="${resumen.montoTotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
            </div>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/suscripciones/confirmar">
            <input type="hidden" name="idCliente" value="${idCliente}">
            <c:if test="${not empty idPlan}">
                <input type="hidden" name="idPlan" value="${idPlan}">
            </c:if>
            <c:forEach var="id" items="${ids}">
                <input type="hidden" name="ids" value="${id}">
            </c:forEach>
            <input type="hidden" name="codigoCupon" value="<c:out value='${codigoCupon}'/>">
            <input type="hidden" name="dniReferente" value="<c:out value='${dniReferente}'/>">

            <div class="acciones">
                <a class="btn sec" href="${pageContext.request.contextPath}/planes">Cancelar</a>
                <button class="btn" type="submit">Confirmar suscripción</button>
            </div>
        </form>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
