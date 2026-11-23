<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Vista Previa"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Vista Previa de Plan Personalizado</h1>
    <span class="codigo">F05</span>
</div>
<p class="sub">Revisa los subproductos elegidos.</p>

<div class="panel">
    <c:forEach var="subproducto" items="${subproductos}">
        <div class="fila">
            <span>${subproducto.nombreSubproducto} <small>(${subproducto.nombreCategoria})</small></span>
            <span>S/ <fmt:formatNumber value="${subproducto.precioIndividual}" minFractionDigits="2" maxFractionDigits="2"/></span>
        </div>
    </c:forEach>
    <div class="total">
        <span>Total</span>
        <span>S/ <fmt:formatNumber value="${total}" minFractionDigits="2" maxFractionDigits="2"/></span>
    </div>
</div>

<form method="get" action="${pageContext.request.contextPath}/clientes/registro">
    <c:forEach var="id" items="${ids}">
        <input type="hidden" name="ids" value="${id}">
    </c:forEach>
    <div class="acciones">
        <a class="btn sec" href="${pageContext.request.contextPath}/planes/personalizado">Modificar</a>
        <button class="btn" type="submit">Continuar</button>
    </div>
</form>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
