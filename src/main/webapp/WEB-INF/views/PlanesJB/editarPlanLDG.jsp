<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Editar plan"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Editar plan</h1>
    <span class="codigo">F13</span>
</div>
<p class="sub">Plan <strong><c:out value="${plan.nombrePlan}"/></strong>. Marca los subproductos que incluye.</p>

<c:if test="${not empty error}">
    <div class="error"><c:out value="${error}"/></div>
</c:if>

<form method="post" action="${pageContext.request.contextPath}/gestion-planes/actualizar/${plan.idPlan}"
      onsubmit="return validarZonaEntrenamiento()">
    <div class="panel">
        <h3>Subproductos disponibles</h3>
        <p class="descripcion">Debes seleccionar al menos un subproducto de la categoría Zonas de Entrenamiento.</p>

        <c:forEach var="subproducto" items="${subproductos}">
            <label class="item">
                <span>
                    <input type="checkbox" name="ids" value="${subproducto.idSubproducto}"
                           data-precio="${subproducto.precioIndividual}"
                           data-categoria="${subproducto.nombreCategoria}"
                           onchange="calcularPrecio()"
                           ${idsSeleccionados.contains(subproducto.idSubproducto) ? 'checked' : ''}>
                    <c:out value="${subproducto.nombreSubproducto}"/>
                    <small>(<c:out value="${subproducto.nombreCategoria}"/>)</small>
                </span>
                <span>S/ <fmt:formatNumber value="${subproducto.precioIndividual}" minFractionDigits="2" maxFractionDigits="2"/></span>
            </label>
        </c:forEach>

        <c:if test="${empty subproductos}">
            <p class="descripcion">No hay subproductos registrados.</p>
        </c:if>
    </div>

    <div class="panel">
        <div class="total">
            <span>Precio base total</span>
            <span>S/ <span id="precioBase"><fmt:formatNumber value="${precioCalculado}" minFractionDigits="2" maxFractionDigits="2"/></span></span>
        </div>
        <p class="descripcion">El precio base se calcula automáticamente sumando los precios individuales de los subproductos seleccionados.</p>
    </div>

    <div class="acciones">
        <a class="btn sec" href="${pageContext.request.contextPath}/gestion-planes">Cancelar</a>
        <button class="btn" type="submit">Guardar cambios</button>
    </div>
</form>

<script>
    function calcularPrecio() {
        var casillas = document.getElementsByName("ids");
        var total = 0;

        for (var i = 0; i < casillas.length; i++) {
            if (casillas[i].checked) {
                total = total + parseFloat(casillas[i].getAttribute("data-precio"));
            }
        }

        document.getElementById("precioBase").innerHTML = total.toFixed(2);
    }

    function validarZonaEntrenamiento() {
        var casillas = document.getElementsByName("ids");
        var hayZona = false;

        for (var i = 0; i < casillas.length; i++) {
            if (casillas[i].checked && casillas[i].getAttribute("data-categoria") === "Zonas de Entrenamiento") {
                hayZona = true;
            }
        }

        if (!hayZona) {
            alert("Debes seleccionar al menos un subproducto de la categoría Zonas de Entrenamiento.");
            return false;
        }

        return true;
    }

    window.onload = function () {
        calcularPrecio();
    };
</script>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
