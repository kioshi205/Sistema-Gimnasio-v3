<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerPublicoJB.jsp">
    <jsp:param name="titulo" value="Inicio"/>
</jsp:include>

<section class="portada">
    <h1>Entrena a tu manera</h1>
    <p>Elige el plan que se adapta a ti o arma uno a tu medida, solo con los servicios que necesitas.</p>
    <a class="btn" href="${pageContext.request.contextPath}/login">Ingresar al sistema</a>
</section>

<section class="bloque">
    <h2>Nuestros planes</h2>
    <div class="grid">
        <div class="card">
            <h3>Básico</h3>
            <div class="precio">S/ 90.00</div>
            <small>30 días</small>
            <ul>
                <li>Sala de máquinas y pesas</li>
                <li>Wifi gratis</li>
                <li>Uso de casilleros</li>
            </ul>
        </div>
        <div class="card">
            <h3>Medio</h3>
            <div class="precio">S/ 195.00</div>
            <small>30 días</small>
            <ul>
                <li>Zona de cardio</li>
                <li>Ingreso a las duchas</li>
                <li>Zona de descanso y lounge</li>
            </ul>
        </div>
        <div class="card">
            <h3>Pro</h3>
            <div class="precio">S/ 410.00</div>
            <small>30 días</small>
            <ul>
                <li>Sauna</li>
                <li>Parking de auto</li>
                <li>Reloj cardiomedidor</li>
            </ul>
        </div>
    </div>
</section>

<section class="bloque">
    <h2>Por qué elegirnos</h2>
    <div class="grid">
        <div class="card">
            <h3>Planes flexibles</h3>
            <p class="descripcion">Planes predeterminados o personalizados, siempre mensuales.</p>
        </div>
        <div class="card">
            <h3>Equipos modernos</h3>
            <p class="descripcion">Zonas de máquinas, cardio y entrenamiento funcional.</p>
        </div>
        <div class="card">
            <h3>Comodidad total</h3>
            <p class="descripcion">Duchas, casilleros, zona de descanso y estacionamiento.</p>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerPublicoJB.jsp"/>
