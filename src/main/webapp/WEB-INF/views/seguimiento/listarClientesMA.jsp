<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Buscar y listar clientes"/>
</jsp:include>

<div class="titulo-pagina">
    <h1>Clientes registrados</h1>
    <span class="codigo">INT14 - F14</span>
</div>

<p class="sub">Busca clientes registrados y accede a sus datos personales o historial de suscripciones.</p>

<div class="panel">
    <h3>Buscar cliente</h3>

    <form action="${pageContext.request.contextPath}/seguimiento/clientes"
          method="get" class="formulario">

        <label for="buscar">DNI, nombre o apellido</label>
        <input type="text" id="buscar" name="buscar"
               value="<c:out value='${buscar}'/>"
               placeholder="Ingrese DNI, nombre o apellido">

        <div class="acciones">
            <a href="${pageContext.request.contextPath}/seguimiento/clientes"
               class="btn sec">Limpiar</a>
            <button type="submit" class="btn">Buscar</button>
        </div>
    </form>
</div>

<div class="panel">
    <h3>Listado de clientes</h3>

    <p class="sub">Clientes encontrados: ${clientes.size()}</p>

    <div style="overflow-x:auto;">
        <table style="width:100%;border-collapse:collapse;text-align:left;">
            <thead>
            <tr style="background:#e6fafd;color:#0090ad;">
                <th style="padding:13px;">DNI</th>
                <th style="padding:13px;">Nombre completo</th>
                <th style="padding:13px;">Teléfono</th>
                <th style="padding:13px;">Correo electrónico</th>
                <th style="padding:13px;">Acciones</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="c" items="${clientes}">
                <tr style="border-bottom:1px solid #d4eef3;">
                    <td style="padding:13px;"><c:out value="${c.DNI}"/></td>
                    <td style="padding:13px;">
                        <c:out value="${c.NOMBRE}"/> <c:out value="${c.APELLIDO}"/>
                    </td>
                    <td style="padding:13px;"><c:out value="${c.TELEFONO}"/></td>
                    <td style="padding:13px;"><c:out value="${c.EMAIL}"/></td>
                    <td style="padding:13px;">
                        <div style="display:flex;gap:8px;flex-wrap:wrap;">
                            <a class="btn"
                               style="padding:8px 14px;font-size:.85rem;"
                               href="${pageContext.request.contextPath}/seguimiento/cliente/editar/${c.ID_CLIENTE}">
                                Editar
                            </a>

                            <a class="btn sec"
                               style="padding:8px 14px;font-size:.85rem;"
                               href="${pageContext.request.contextPath}/seguimiento/historial/${c.ID_CLIENTE}">
                                Historial
                            </a>
                        </div>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty clientes}">
                <tr>
                    <td colspan="5" style="padding:24px;text-align:center;color:#5b7c86;">
                        No se encontraron clientes registrados.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<div class="acciones">
    <a href="${pageContext.request.contextPath}/" class="btn sec">Volver al inicio</a>
</div>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>