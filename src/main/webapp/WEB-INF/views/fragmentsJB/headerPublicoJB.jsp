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
<header class="publico-barra">
    <a class="publico-marca" href="${pageContext.request.contextPath}/">GIMNASIO</a>
    <nav class="publico-menu">
        <a href="${pageContext.request.contextPath}/">Inicio</a>
        <a href="${pageContext.request.contextPath}/contacto">Contacto</a>
        <a class="publico-boton" href="${pageContext.request.contextPath}/login">Iniciar sesión</a>
    </nav>
</header>
<main class="publico-contenido">
