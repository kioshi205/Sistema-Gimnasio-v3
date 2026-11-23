<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerPublicoJB.jsp">
    <jsp:param name="titulo" value="Contacto"/>
</jsp:include>

<section class="bloque">
    <h1>Contacto</h1>
    <p class="sub">Estamos para ayudarte. Visítanos o escríbenos.</p>
    <div class="grid">
        <div class="card">
            <h3>Dirección</h3>
            <p class="descripcion">Av. Real 123, Huancayo, Junín</p>
        </div>
        <div class="card">
            <h3>Teléfono</h3>
            <p class="descripcion">(064) 123 456</p>
            <p class="descripcion">999 888 777</p>
        </div>
        <div class="card">
            <h3>Correo</h3>
            <p class="descripcion">contacto@gimnasio.pe</p>
        </div>
        <div class="card">
            <h3>Horario de atención</h3>
            <p class="descripcion">Lunes a viernes: 5:00 a. m. a 10:00 p. m.</p>
            <p class="descripcion">Sábados: 6:00 a. m. a 8:00 p. m.</p>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerPublicoJB.jsp"/>
