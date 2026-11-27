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
            <c:set var="rutaActual" value="${requestScope['jakarta.servlet.forward.servlet_path']}"/>

            <c:choose>
                <c:when test="${rutaActual == '/planes' or rutaActual == '/planes/personalizado' or rutaActual == '/planes/personalizado/vista-previa' or rutaActual == '/clientes/registro' or rutaActual == '/suscripciones/resumen' or rutaActual == '/suscripciones/exito'}">
                    <a class="activo" href="${pageContext.request.contextPath}/planes">SUSCRIPCION</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/planes">SUSCRIPCION</a>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${fn:startsWith(rutaActual, '/gestion-planes')}">
                    <a class="activo" href="${pageContext.request.contextPath}/gestion-planes">GESTION DE PLANES</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/gestion-planes">GESTION DE PLANES</a>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${rutaActual == '/categorias' or rutaActual == '/categorias/registrar' or rutaActual == '/categorias/editar'}">
                    <a class="activo" href="${pageContext.request.contextPath}/categorias">CATEGORÍAS</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/categorias">CATEGORÍAS</a>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${rutaActual == '/subproductos' or rutaActual == '/subproductos/registrar' or rutaActual == '/subproductos/editar'}">
                    <a class="activo" href="${pageContext.request.contextPath}/subproductos">SUBPRODUCTOS</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/subproductos">SUBPRODUCTOS</a>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${rutaActual == '/acceso' or rutaActual == '/acceso/verificar'}">
                    <a class="activo" href="${pageContext.request.contextPath}/acceso">CONTROL DE ACCESO</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/acceso">CONTROL DE ACCESO</a>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${rutaActual == '/cupones/nuevo'}">
                    <a class="activo" href="${pageContext.request.contextPath}/cupones/nuevo">CUPONES</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/cupones/nuevo">CUPONES</a>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${rutaActual == '/metricas'}">
                    <a class="activo" href="${pageContext.request.contextPath}/metricas">MÉTRICAS</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/metricas">MÉTRICAS</a>
                </c:otherwise>
            </c:choose>

            <%-- Enlaces para que el equipo descomente cuando termine su módulo:
            <a href="${pageContext.request.contextPath}/suscripciones">Suscripciones</a>
            <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
            <a href="${pageContext.request.contextPath}/subproductos">Subproductos</a>
            <a href="${pageContext.request.contextPath}/categorias">Categorías</a>
            --%>
        </nav>
        <div class="lateral-usuario">
            <a href="${pageContext.request.contextPath}/">Cerrar sesión</a>
        </div>
    </aside>
    <main class="contenido">
