<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            <a class="${menuActivo eq 'planes' ? '' : 'activo'}" href="${pageContext.request.contextPath}/planes">SUSCRIPCION</a>
            <a class="${menuActivo eq 'planes' ? 'activo' : ''}" href="${pageContext.request.contextPath}/gestion-planes">GESTION DE PLANES
            </a>
            <%-- Enlaces para que el equipo descomente cuando termine su módulo:
            <a href="${pageContext.request.contextPath}/suscripciones">Suscripciones</a>
            <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
            <a href="${pageContext.request.contextPath}/subproductos">Subproductos</a>
            <a href="${pageContext.request.contextPath}/categorias">Categorías</a>
            <a href="${pageContext.request.contextPath}/acceso">Control de Acceso</a>
            <a href="${pageContext.request.contextPath}/cupones/nuevo">Cupones</a>
            --%>
        </nav>
        <div class="lateral-usuario">
            <a href="${pageContext.request.contextPath}/">Cerrar sesión</a>
        </div>
    </aside>
    <main class="contenido">
