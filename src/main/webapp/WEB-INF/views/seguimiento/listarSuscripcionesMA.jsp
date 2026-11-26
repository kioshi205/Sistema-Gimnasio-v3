
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Listado de suscripciones"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Listado de suscripciones</h1>
    <span class="codigo">INT16 - F16</span>
</div>

<p class="sub">
    Consulta las suscripciones registradas, su vigencia y las opciones disponibles.
</p>

<!-- Mensajes del sistema -->

<c:if test="${param.renovada != null}">
    <div class="panel" style="border-left:5px solid #16a36a;">
        <strong>La renovación se registró correctamente.</strong>
    </div>
</c:if>

<c:if test="${param.mejorada != null}">
    <div class="panel" style="border-left:5px solid #16a36a;">
        <strong>La suscripción fue actualizada correctamente.</strong>
    </div>
</c:if>

<c:if test="${param.error != null}">
    <div class="panel" style="border-left:5px solid #c03939;">
        <strong>No se pudo realizar la operación solicitada.</strong>
        <p>Verifica el estado de la suscripción e inténtalo nuevamente.</p>
    </div>
</c:if>

<!-- Indicadores -->

<div class="grid" style="margin-bottom:22px;">

    <div class="card">
        <small>Suscripciones encontradas</small>
        <div class="precio">${suscripciones.size()}</div>
        <p class="descripcion">
            Total de registros según los filtros aplicados.
        </p>
    </div>

    <div class="card destacada">
        <small>Estados disponibles</small>
        <h2 style="margin-top:12px;">
            Vigente / Por vencer / Vencida
        </h2>
        <p class="descripcion">
            El estado se determina según la fecha de finalización.
        </p>
    </div>

</div>

<!-- Buscar suscripciones -->

<div class="panel">

    <h3>Buscar suscripción</h3>

    <form action="${pageContext.request.contextPath}/seguimiento/suscripciones"
          method="get"
          class="formulario">

        <label for="buscar">DNI, nombre o apellido</label>

        <input type="text"
               id="buscar"
               name="buscar"
               value="<c:out value='${buscar}'/>"
               placeholder="Ingrese DNI, nombre o apellido">

        <!-- Filtro por estado -->

        <label style="margin-top:15px;display:block;">
            Filtrar por estado de suscripción
        </label>

        <div class="grid" style="margin-top:10px;">

            <!-- Todos -->

            <label class="card" style="cursor:pointer;">

                <input type="radio"
                       name="estado"
                       value=""
                       ${empty estadoSeleccionado ? 'checked' : ''}
                       style="margin-right:8px;">

                <strong>Todos los estados</strong>

                <p class="descripcion">
                    Mostrar todas las suscripciones
                </p>

            </label>

            <!-- Vigente -->

            <label class="card" style="cursor:pointer;">

                <input type="radio"
                       name="estado"
                       value="Vigente"
                       ${estadoSeleccionado == 'Vigente' ? 'checked' : ''}
                       style="margin-right:8px;">

                <strong>Vigente</strong>

                <p class="descripcion">
                    Suscripciones activas
                </p>

            </label>

            <!-- Por vencer -->

            <label class="card" style="cursor:pointer;">

                <input type="radio"
                       name="estado"
                       value="Por vencer"
                       ${estadoSeleccionado == 'Por vencer' ? 'checked' : ''}
                       style="margin-right:8px;">

                <strong>Por vencer</strong>

                <p class="descripcion">
                    Próximas a finalizar
                </p>

            </label>

            <!-- Vencida -->

            <label class="card" style="cursor:pointer;">

                <input type="radio"
                       name="estado"
                       value="Vencida"
                       ${estadoSeleccionado == 'Vencida' ? 'checked' : ''}
                       style="margin-right:8px;">

                <strong>Vencida</strong>

                <p class="descripcion">
                    Suscripciones finalizadas
                </p>

            </label>

        </div>

        <!-- Botones -->

        <div class="acciones">

            <a href="${pageContext.request.contextPath}/seguimiento/suscripciones"
               class="btn sec">
                Limpiar
            </a>

            <button type="submit" class="btn">
                Buscar
            </button>

        </div>

    </form>

</div>

<!-- Listado de suscripciones -->

<div class="panel">

    <h3>Suscripciones registradas</h3>

    <p class="sub">
        Suscripciones encontradas: ${suscripciones.size()}
    </p>

    <div style="overflow-x:auto;">

        <table style="width:100%;border-collapse:collapse;text-align:left;">

            <thead>

                <tr style="background:#e6fafd;color:#0090ad;">

                    <th style="padding:12px;">Código</th>
                    <th style="padding:12px;">Cliente</th>
                    <th style="padding:12px;">Plan</th>
                    <th style="padding:12px;">Inicio</th>
                    <th style="padding:12px;">Fin</th>
                    <th style="padding:12px;">Monto</th>
                    <th style="padding:12px;">Estado</th>
                    <th style="padding:12px;">Acciones</th>

                </tr>

            </thead>

            <tbody>

                <c:forEach var="s" items="${suscripciones}">

                    <tr style="border-bottom:1px solid #d4eef3;">

                        <!-- Código -->

                        <td style="padding:12px;">
                            #<c:out value="${s.ID_SUSCRIPCION}"/>
                        </td>

                        <!-- Cliente -->

                        <td style="padding:12px;">

                            <c:out value="${s.NOMBRE}"/>
                            <c:out value="${s.APELLIDO}"/>

                            <br>

                            <small>
                                DNI: <c:out value="${s.DNI}"/>
                            </small>

                        </td>

                        <!-- Plan -->

                        <td style="padding:12px;">
                            <c:out value="${s.NOMBRE_PLAN}"/>
                        </td>

                        <!-- Fecha de inicio -->

                        <td style="padding:12px;">

                            <fmt:formatDate
                                value="${s.FECHA_INICIO}"
                                pattern="dd/MM/yyyy"/>

                        </td>

                        <!-- Fecha de fin -->

                        <td style="padding:12px;">

                            <fmt:formatDate
                                value="${s.FECHA_FIN}"
                                pattern="dd/MM/yyyy"/>

                        </td>

                        <!-- Monto -->

                        <td style="padding:12px;">

                            S/

                            <fmt:formatNumber
                                value="${s.MONTO_TOTAL}"
                                minFractionDigits="2"/>

                        </td>

                        <!-- Estado -->

                        <td style="padding:12px;">

                            <c:choose>

                                <c:when test="${s.ESTADO_SUSCRIPCION == 'Vigente'}">

                                    <span style="background:#e5f8ee;
                                                 color:#16834b;
                                                 padding:6px 10px;
                                                 border-radius:20px;
                                                 font-weight:700;">
                                        Vigente
                                    </span>

                                </c:when>

                                <c:when test="${s.ESTADO_SUSCRIPCION == 'Por vencer'}">

                                    <span style="background:#fff6df;
                                                 color:#a66b00;
                                                 padding:6px 10px;
                                                 border-radius:20px;
                                                 font-weight:700;">
                                        Por vencer
                                    </span>

                                </c:when>

                                <c:otherwise>

                                    <span style="background:#fff0f0;
                                                 color:#c03939;
                                                 padding:6px 10px;
                                                 border-radius:20px;
                                                 font-weight:700;">
                                        Vencida
                                    </span>

                                </c:otherwise>

                            </c:choose>

                        </td>

                        <!-- Acciones -->

                        <td style="padding:12px;">

                            <div style="display:flex;gap:7px;flex-wrap:wrap;">

                                <!-- Historial -->

                                <a class="btn sec"
                                   style="padding:8px 12px;font-size:.82rem;"
                                   href="${pageContext.request.contextPath}/seguimiento/historial/${s.ID_CLIENTE}">

                                    Historial

                                </a>

                                <!-- Renovar -->

                                <c:if test="${s.ESTADO_SUSCRIPCION == 'Por vencer' || s.ESTADO_SUSCRIPCION == 'Vencida'}">

                                    <a class="btn"
                                       style="padding:8px 12px;font-size:.82rem;"
                                       href="${pageContext.request.contextPath}/seguimiento/renovar/${s.ID_SUSCRIPCION}">

                                        Renovar

                                    </a>

                                </c:if>

                                <!-- Mejorar plan -->

                                <c:if test="${s.ESTADO_SUSCRIPCION == 'Vigente'}">

                                    <a class="btn"
                                       style="padding:8px 12px;font-size:.82rem;"
                                       href="${pageContext.request.contextPath}/seguimiento/mejorar/${s.ID_SUSCRIPCION}">

                                        Mejorar plan

                                    </a>

                                </c:if>

                            </div>

                        </td>

                    </tr>

                </c:forEach>

                <!-- Sin resultados -->

                <c:if test="${empty suscripciones}">

                    <tr>

                        <td colspan="8"
                            style="padding:24px;
                                   text-align:center;
                                   color:#5b7c86;">

                            No existen suscripciones con los filtros seleccionados.

                        </td>

                    </tr>

                </c:if>

            </tbody>

        </table>

    </div>

</div>

<!-- Volver -->

<div class="acciones">

    <a href="${pageContext.request.contextPath}/"
       class="btn sec">

        Volver al inicio

    </a>

</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
