
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Mejorar plan"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Mejorar plan de suscripción</h1>
    <span class="codigo">INT19 - F19</span>
</div>

<p class="sub">
    Actualiza el plan del cliente y agrega servicios adicionales a su suscripción vigente.
</p>

<c:if test="${not empty error}">
    <div class="panel" style="border-left:5px solid #c03939;">
        <strong><c:out value="${error}"/></strong>
    </div>
</c:if>

<div class="grid" style="margin-bottom:22px;">
    <div class="card">
        <small>Código de suscripción</small>
        <div class="precio">
            #<c:out value="${suscripcion.ID_SUSCRIPCION}"/>
        </div>
        <p class="descripcion">Registro seleccionado para actualizar.</p>
    </div>

    <div class="card destacada">
        <small>Estado actual</small>
        <h2 style="margin-top:12px;color:#16834b;">Vigente</h2>
        <p class="descripcion">Esta suscripción permite realizar mejoras.</p>
    </div>
</div>

<div class="panel">
    <h3>Información del cliente</h3>

    <div class="grid">
        <div>
            <label>DNI</label>
            <p><strong><c:out value="${suscripcion.DNI}"/></strong></p>
        </div>

        <div>
            <label>Cliente</label>
            <p>
                <strong>
                    <c:out value="${suscripcion.NOMBRE}"/>
                    <c:out value="${suscripcion.APELLIDO}"/>
                </strong>
            </p>
        </div>

        <div>
            <label>Teléfono</label>
            <p><c:out value="${suscripcion.TELEFONO}"/></p>
        </div>

        <div>
            <label>Correo electrónico</label>
            <p><c:out value="${suscripcion.EMAIL}"/></p>
        </div>
    </div>
</div>

<div class="panel">
    <h3>Suscripción actual</h3>

    <div class="grid">
        <div>
            <label>Plan actual</label>
            <p><strong><c:out value="${suscripcion.NOMBRE_PLAN}"/></strong></p>
        </div>

        <div>
            <label>Precio del plan</label>
            <p>
                <strong>
                    S/
                    <fmt:formatNumber value="${suscripcion.PRECIO_PLAN}"
                                      minFractionDigits="2"/>
                </strong>
            </p>
        </div>

        <div>
            <label>Monto registrado</label>
            <p>
                <strong>
                    S/
                    <fmt:formatNumber value="${suscripcion.MONTO_TOTAL}"
                                      minFractionDigits="2"/>
                </strong>
            </p>
        </div>

        <div>
            <label>Fecha de finalización</label>
            <p>
                <strong>
                    <fmt:formatDate value="${suscripcion.FECHA_FIN}"
                                    pattern="dd/MM/yyyy"/>
                </strong>
            </p>
        </div>
    </div>

    <div style="margin-top:15px;">
        <label>Servicios actuales</label>
        <p>
            <c:out value="${suscripcion.DETALLE}"/>
        </p>
    </div>
</div>

<form method="post"
      action="${pageContext.request.contextPath}/seguimiento/mejorar/confirmar">

    <input type="hidden"
           name="idSuscripcion"
           value="${suscripcion.ID_SUSCRIPCION}"/>

    <div class="panel">
        <h3>Seleccionar nuevo plan</h3>

        <p class="sub">
            Selecciona un plan cuyo precio sea superior al precio del plan actual.
        </p>

        <c:choose>
            <c:when test="${not empty planes}">
                <div class="grid">
                    <c:forEach var="p" items="${planes}">
                        <label class="card" style="cursor:pointer;">
                            <div style="display:flex;align-items:center;gap:10px;">
                                <input type="radio"
                                       name="idPlanNuevo"
                                       value="${p.ID_PLAN}"
                                       required>

                                <strong>
                                    <c:out value="${p.NOMBRE_PLAN}"/>
                                </strong>
                            </div>

                            <div class="precio" style="font-size:1.6rem;">
                                S/
                                <fmt:formatNumber value="${p.PRECIO_BASE}"
                                                  minFractionDigits="2"/>
                            </div>

                            <p class="descripcion">
                                Duración:
                                <c:out value="${p.DURACION_DIAS}"/> días
                            </p>
                        </label>
                    </c:forEach>
                </div>
            </c:when>

            <c:otherwise>
                <p style="color:#a66b00;">
                    No existen planes con un precio superior al plan actual.
                </p>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="panel">
        <h3>Servicios adicionales</h3>

        <p class="sub">
            Selecciona los servicios que deseas agregar al nuevo plan.
            Los servicios que ya están incluidos en el plan seleccionado no se cobran nuevamente.
        </p>

        <c:choose>
            <c:when test="${not empty subproductos}">
                <div class="grid">
                    <c:forEach var="sub" items="${subproductos}">
                        <label class="card" style="cursor:pointer;">
                            <div style="display:flex;align-items:center;gap:10px;">
                                <input type="checkbox"
                                       name="adicionales"
                                       value="${sub.ID_SUBPRODUCTO}">

                                <strong>
                                    <c:out value="${sub.NOMBRE_SUBPRODUCTO}"/>
                                </strong>
                            </div>

                            <div class="precio" style="font-size:1.4rem;">
                                S/
                                <fmt:formatNumber value="${sub.PRECIO_INDIVIDUAL}"
                                                  minFractionDigits="2"/>
                            </div>

                            <p class="descripcion">Servicio adicional</p>
                        </label>
                    </c:forEach>
                </div>
            </c:when>

            <c:otherwise>
                <p>No hay servicios adicionales disponibles.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="panel">
        <h3>Confirmar mejora</h3>

        <p class="sub">
            Verifica el nuevo plan y los servicios adicionales antes de guardar los cambios.
        </p>

        <div class="acciones">
            <button type="submit"
                    class="btn"
                    <c:if test="${empty planes}">disabled</c:if>>
                Confirmar mejora
            </button>

            <a href="${pageContext.request.contextPath}/seguimiento/suscripciones"
               class="btn sec">
                Cancelar
            </a>
        </div>
    </div>
</form>

<div class="acciones">
    <a href="${pageContext.request.contextPath}/seguimiento/suscripciones"
       class="btn sec">
        Volver a suscripciones
    </a>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
