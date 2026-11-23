<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Diseñador de Plan"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Diseñador de Plan Personalizado</h1>
    <span class="codigo">F04</span>
</div>
<p class="sub">Marca los subproductos que quieres incluir.</p>

<c:if test="${not empty error}">
    <div class="error">${error}</div>
</c:if>

<form method="get" action="${pageContext.request.contextPath}/planes/personalizado/vista-previa">
    <div class="panel">
        <c:forEach var="subproducto" items="${subproductos}">
            <label class="item">
                <span>
                    <input type="checkbox" name="ids" value="${subproducto.idSubproducto}" data-precio="${subproducto.precioIndividual}">
                    ${subproducto.nombreSubproducto}
                    <small>(${subproducto.nombreCategoria})</small>
                </span>
                <span>S/ <fmt:formatNumber value="${subproducto.precioIndividual}" minFractionDigits="2" maxFractionDigits="2"/></span>
            </label>
        </c:forEach>
    </div>

    <div class="panel">
        <div class="total">
            <span>Seleccionados: <span id="cantidad">0</span></span>
            <span>Total: S/ <span id="total">0.00</span></span>
        </div>
    </div>

    <div class="acciones">
        <a class="btn sec" href="${pageContext.request.contextPath}/planes">Volver</a>
        <button class="btn" type="submit">Ver vista previa</button>
    </div>
</form>

<script>
    const casillas = document.querySelectorAll('input[name=ids]');

    function calcular() {
        let total = 0;
        let cantidad = 0;
        casillas.forEach(function (casilla) {
            if (casilla.checked) {
                total += parseFloat(casilla.dataset.precio);
                cantidad++;
            }
        });
        document.getElementById('total').textContent = total.toFixed(2);
        document.getElementById('cantidad').textContent = cantidad;
    }

    casillas.forEach(function (casilla) {
        casilla.addEventListener('change', calcular);
    });
</script>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
