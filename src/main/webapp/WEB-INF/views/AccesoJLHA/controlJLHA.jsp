<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Control de Acceso"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/gimnasioJLHA.css">

<div class="titulo-pagina">
    <h1>Control y registro de acceso</h1>
    <span class="codigo">F20</span>
</div>
<p class="sub">Ingresa el DNI del cliente y presiona verificar.</p>

<form class="panel formulario" method="post" action="${pageContext.request.contextPath}/acceso/verificar">
    <label for="dni">DNI del cliente</label>
    <div class="acceso-barra">
        <input type="text" id="dni" name="dni" maxlength="8" inputmode="numeric"
               pattern="\d{8}" title="8 dígitos" autocomplete="off" autofocus required>
        <button class="btn" type="submit">Verificar</button>
    </div>
</form>

<c:if test="${not empty resultado}">
    <c:choose>

        <%-- Suscripción vigente: luz verde --%>
        <c:when test="${resultado.estado == 'PERMITIDO'}">
            <div class="semaforo verde">
                <div class="luz">&#10004;</div>
                <div class="semaforo-cuerpo">
                    <h2>ACCESO PERMITIDO</h2>
                    <p class="socio"><c:out value="${resultado.nombreCompleto}"/></p>
                    <p>
                        <c:choose>
                            <c:when test="${resultado.diasRestantes == 0}">Su suscripción vence <strong>hoy</strong>.</c:when>
                            <c:when test="${resultado.diasRestantes == 1}">Le queda <strong>1 día</strong> (vence el ${resultado.fechaFin}).</c:when>
                            <c:otherwise>Le quedan <strong>${resultado.diasRestantes} días</strong> (vence el ${resultado.fechaFin}).</c:otherwise>
                        </c:choose>
                    </p>
                    <c:if test="${not empty resultado.servicios}">
                        <p class="servicios-titulo">Servicios a los que tiene acceso:</p>
                        <ul class="servicios">
                            <c:forEach var="s" items="${resultado.servicios}">
                                <li><c:out value="${s}"/></li>
                            </c:forEach>
                        </ul>
                    </c:if>
                </div>
            </div>
        </c:when>

        <%-- Vencida o sin suscripción: alerta roja con accesos rápidos --%>
        <c:when test="${resultado.estado == 'DENEGADO'}">
            <div class="semaforo rojo">
                <div class="luz">&#10006;</div>
                <div class="semaforo-cuerpo">
                    <h2>ACCESO DENEGADO</h2>
                    <p class="socio"><c:out value="${resultado.nombreCompleto}"/></p>
                    <p>La suscripción está vencida o el cliente no tiene una vigente.</p>
                    <div class="acciones izq">
                        <a class="btn" href="${pageContext.request.contextPath}${rutaRenovar}">Renovar suscripción</a>
                        <a class="btn sec" href="${pageContext.request.contextPath}${rutaPlanes}">Elegir un plan</a>
                    </div>
                </div>
            </div>
        </c:when>

        <%-- DNI inexistente: solo mensaje, no se registra nada --%>
        <c:when test="${resultado.estado == 'NO_REGISTRADO'}">
            <div class="semaforo gris">
                <div class="luz">?</div>
                <div class="semaforo-cuerpo">
                    <h2>CLIENTE NO REGISTRADO</h2>
                    <p>El cliente con DNI <strong><c:out value="${resultado.dni}"/></strong> no está registrado.</p>
                </div>
            </div>
        </c:when>

        <%-- Formato inválido --%>
        <c:otherwise>
            <div class="error"><p><c:out value="${resultado.mensaje}"/></p></div>
        </c:otherwise>
    </c:choose>
</c:if>

<div class="panel">
    <h3>Últimas marcaciones</h3>
    <c:choose>
        <c:when test="${empty ultimas}">
            <p class="sub">Aún no hay marcaciones registradas.</p>
        </c:when>
        <c:otherwise>
            <table class="tabla">
                <thead>
                <tr><th>Fecha</th><th>Hora</th><th>DNI</th><th>Socio</th><th>Resultado</th></tr>
                </thead>
                <tbody>
                <c:forEach var="m" items="${ultimas}">
                    <tr>
                        <td>${m.fechaAcceso}</td>
                        <td>${m.horaAcceso}</td>
                        <td>${m.dni}</td>
                        <td><c:out value="${m.nombreCompleto}"/></td>
                        <td>
                            <span class="etiqueta ${m.resultado == 'PERMITIDO' ? 'ok' : 'no'}">${m.resultado}</span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
