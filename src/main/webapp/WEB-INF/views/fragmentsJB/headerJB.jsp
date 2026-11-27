
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${param.titulo} | Gimnasio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/gimnasioJB.css">
</head>
<body>
<div class="app">
    <aside class="lateral">
        <div class="marca">GIMNASIO</div>

        <nav class="lateral-menu">

            <c:set var="rutaActual"
                   value="${requestScope['jakarta.servlet.forward.servlet_path']}"/>

            <%-- SUSCRIPCIÓN --%>
            <c:choose>
                <c:when test="${rutaActual == '/planes' or rutaActual == '/planes/personalizado' or rutaActual == '/planes/personalizado/vista-previa' or rutaActual == '/clientes/registro' or rutaActual == '/suscripciones/resumen' or rutaActual == '/suscripciones/exito'}">
                    <a class="activo" href="${pageContext.request.contextPath}/planes">SUSCRIPCION</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/planes">SUSCRIPCION</a>
                </c:otherwise>
            </c:choose>

            <%-- GESTIÓN DE PLANES --%>
            <c:choose>
                <c:when test="${fn:startsWith(rutaActual, '/gestion-planes')}">
                    <a class="activo" href="${pageContext.request.contextPath}/gestion-planes">GESTION DE PLANES</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/gestion-planes">GESTION DE PLANES</a>
                </c:otherwise>
            </c:choose>

            <%-- CATEGORÍAS --%>
            <c:choose>
                <c:when test="${rutaActual == '/categorias' or rutaActual == '/categorias/registrar' or rutaActual == '/categorias/editar'}">
                    <a class="activo" href="${pageContext.request.contextPath}/categorias">CATEGORÍAS</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/categorias">CATEGORÍAS</a>
                </c:otherwise>
            </c:choose>

            <%-- SUBPRODUCTOS --%>
            <c:choose>
                <c:when test="${rutaActual == '/subproductos' or rutaActual == '/subproductos/registrar' or rutaActual == '/subproductos/editar'}">
                    <a class="activo" href="${pageContext.request.contextPath}/subproductos">SUBPRODUCTOS</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/subproductos">SUBPRODUCTOS</a>
                </c:otherwise>
            </c:choose>

            <%-- SEGUIMIENTO DE CLIENTES --%>
            <c:choose>
                <c:when test="${fn:startsWith(rutaActual, '/seguimiento/cliente') or rutaActual == '/seguimiento/clientes'}">
                    <a class="activo" href="${pageContext.request.contextPath}/seguimiento/clientes">
                        SEGUIMIENTO DE CLIENTES
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/seguimiento/clientes">
                        SEGUIMIENTO DE CLIENTES
                    </a>
                </c:otherwise>
            </c:choose>

            <%-- SEGUIMIENTO DE SUSCRIPCIONES --%>
            <c:choose>
                <c:when test="${fn:startsWith(rutaActual, '/seguimiento/suscripciones') or fn:startsWith(rutaActual, '/seguimiento/historial') or fn:startsWith(rutaActual, '/seguimiento/renovar') or fn:startsWith(rutaActual, '/seguimiento/mejorar')}">
                    <a class="activo" href="${pageContext.request.contextPath}/seguimiento/suscripciones">
                        SEGUIMIENTO DE SUSCRIPCIONES
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/seguimiento/suscripciones">
                        SEGUIMIENTO DE SUSCRIPCIONES
                    </a>
                </c:otherwise>
            </c:choose>

        </nav>

        <div class="lateral-usuario">
            <a href="${pageContext.request.contextPath}/">Cerrar sesión</a>
        </div>
    </aside>

    <main class="contenido">
