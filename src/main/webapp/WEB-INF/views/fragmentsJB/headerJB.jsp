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

            <c:set var="esCore"
                   value="${rutaActual == '/planes'
                           or fn:startsWith(rutaActual, '/planes/personalizado')
                           or rutaActual == '/clientes/registro'
                           or fn:startsWith(rutaActual, '/suscripciones/')}"/>

            <a class="${esCore ? 'activo' : ''}"
               href="${pageContext.request.contextPath}/planes">Suscripción</a>

            <a class="${fn:startsWith(rutaActual, '/gestion-planes') ? 'activo' : ''}"
               href="${pageContext.request.contextPath}/gestion-planes">Gestión de Planes</a>

            <a class="${fn:startsWith(rutaActual, '/categorias') ? 'activo' : ''}"
               href="${pageContext.request.contextPath}/categorias">Categorías</a>

            <a class="${fn:startsWith(rutaActual, '/subproductos') ? 'activo' : ''}"
               href="${pageContext.request.contextPath}/subproductos">Subproductos</a>

            <a class="${rutaActual == '/seguimiento/clientes' or fn:startsWith(rutaActual, '/seguimiento/cliente/') ? 'activo' : ''}"
               href="${pageContext.request.contextPath}/seguimiento/clientes">Clientes</a>

            <a class="${rutaActual == '/seguimiento/suscripciones'
                        or fn:startsWith(rutaActual, '/seguimiento/historial')
                        or fn:startsWith(rutaActual, '/seguimiento/renovar')
                        or fn:startsWith(rutaActual, '/seguimiento/mejorar') ? 'activo' : ''}"
               href="${pageContext.request.contextPath}/seguimiento/suscripciones">Suscripciones</a>

            <a class="${fn:startsWith(rutaActual, '/acceso') ? 'activo' : ''}"
               href="${pageContext.request.contextPath}/acceso">Control de Acceso</a>

            <a class="${fn:startsWith(rutaActual, '/cupones') ? 'activo' : ''}"
               href="${pageContext.request.contextPath}/cupones/nuevo">Cupones</a>

            <a class="${fn:startsWith(rutaActual, '/metricas') ? 'activo' : ''}"
               href="${pageContext.request.contextPath}/metricas">Métricas</a>

        </nav>

        <div class="lateral-usuario">
            <a href="${pageContext.request.contextPath}/">Cerrar sesión</a>
        </div>

    </aside>

    <main class="contenido">