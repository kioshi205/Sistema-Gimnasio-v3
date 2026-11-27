<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Crear Cupón de Descuento"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/gimnasioJLHA.css">

<div class="titulo-pagina">
    <h1>Crear cupón de descuento</h1>
    <span class="codigo">F21</span>
</div>
<p class="sub">Registra un cupón promocional del ${porcentajeCupon}% para canjearlo en la confirmación de la suscripción.</p>

<c:if test="${not empty mensaje}">
    <div class="aviso-exito"><c:out value="${mensaje}"/></div>
</c:if>

<c:if test="${not empty errores}">
    <div class="error">
        <c:forEach var="e" items="${errores}">
            <p><c:out value="${e}"/></p>
        </c:forEach>
    </div>
</c:if>

<form class="panel formulario" method="post" action="${pageContext.request.contextPath}/cupones/nuevo">
    <div class="form-dos">
        <div>
            <label for="codigo">Código promocional *</label>
            <input type="text" id="codigo" name="codigo" maxlength="30" style="text-transform: uppercase"
                   value="<c:out value='${param.codigo}'/>" required>
        </div>
        <div>
            <label>Descuento (RN01)</label>
            <div class="descuento-fijo">${porcentajeCupon}% <span>fijo para cupones promocionales</span></div>
        </div>

        <div class="completo">
            <label for="descripcion">Descripción *</label>
            <input type="text" id="descripcion" name="descripcion" maxlength="150"
                   value="<c:out value='${param.descripcion}'/>" required>
        </div>

        <div>
            <label for="fechaInicio">Fecha de inicio *</label>
            <input type="date" id="fechaInicio" name="fechaInicio"
                   value="<c:out value='${param.fechaInicio}'/>" required>
        </div>
        <div>
            <label for="fechaFin">Fecha de fin *</label>
            <input type="date" id="fechaFin" name="fechaFin"
                   value="<c:out value='${param.fechaFin}'/>" required>
        </div>
    </div>

    <small>El código debe ser único. El cupón se guarda ACTIVO y solo puede canjearse una vez, dentro de sus fechas de vigencia.</small>

    <div class="acciones">
        <button class="btn" type="submit">Guardar cupón</button>
    </div>
</form>

<div class="panel">
    <h3>Cupones registrados</h3>
    <c:choose>
        <c:when test="${empty cupones}">
            <p class="sub">Todavía no hay cupones.</p>
        </c:when>
        <c:otherwise>
            <table class="tabla">
                <thead>
                <tr>
                    <th>Código</th><th>Descripción</th><th class="num">Desc.</th><th>Vigencia</th><th>Situación</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="c" items="${cupones}">
                    <tr>
                        <td><strong><c:out value="${c.codigo}"/></strong></td>
                        <td><c:out value="${c.descripcion}"/></td>
                        <td class="num">${c.porcentajeDescuento}%</td>
                        <td>${c.fechaInicio} &rarr; ${c.fechaFin}</td>
                        <td><span class="etiqueta ${c.situacion == 'DISPONIBLE' ? 'ok' : 'no'}">${c.situacion}</span></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
