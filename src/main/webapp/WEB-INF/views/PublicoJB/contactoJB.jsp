<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerPublicoJB.jsp">
    <jsp:param name="titulo" value="Contacto"/>
</jsp:include>

<section class="pub-contacto-cabecera">
    <span class="pub-subtitulo-kicker">SEDE HUANCAYO</span>
    <h1>Visítanos o comunícate con recepción</h1>
    <p>Resolvemos tus dudas sobre planes predeterminados, planes personalizados, renovaciones y promociones vigentes.</p>
</section>

<section class="pub-contacto-split sin-mapa">
    <%-- PANEL DE DATOS DE CONTACTO --%>
    <div class="pub-contacto-info">
        <div class="pub-dato">
            <div class="pub-dato-icono" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 21s-6-5.686-6-10a6 6 0 1 1 12 0c0 4.314-6 10-6 10z"/>
                    <circle cx="12" cy="11" r="2.2"/>
                </svg>
            </div>
            <div>
                <span class="pub-dato-etiqueta">Dirección</span>
                <strong>Av. Real 123, Huancayo, Junín</strong>
                <small>Zona céntrica con estacionamiento para autos, motos y bicicletas.</small>
            </div>
        </div>

        <div class="pub-dato">
            <div class="pub-dato-icono" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6A19.79 19.79 0 0 1 2.12 4.18 2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.12.96.36 1.9.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.91.34 1.85.58 2.81.7A2 2 0 0 1 22 16.92z"/>
                </svg>
            </div>
            <div>
                <span class="pub-dato-etiqueta">Teléfonos</span>
                <strong>(064) 123 456 &nbsp;&middot;&nbsp; 999 888 777</strong>
                <small>Atención telefónica y consultas rápidas en horario de sede.</small>
            </div>
        </div>

        <div class="pub-dato">
            <div class="pub-dato-icono" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="5" width="18" height="14" rx="2"/>
                    <path d="m3 7 9 6 9-6"/>
                </svg>
            </div>
            <div>
                <span class="pub-dato-etiqueta">Correo electrónico</span>
                <strong>contacto@gimnasio.pe</strong>
                <small>Consultas sobre convenios, cupones y membresías.</small>
            </div>
        </div>

        <div class="pub-dato">
            <div class="pub-dato-icono" aria-hidden="true">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="9"/>
                    <path d="M12 7v5l3 2"/>
                </svg>
            </div>
            <div style="flex:1">
                <span class="pub-dato-etiqueta">Horario de atención</span>
                <div class="pub-horario-fila">
                    <span>Lunes a viernes</span>
                    <strong>5:00 a. m. – 10:00 p. m.</strong>
                </div>
                <div class="pub-horario-fila">
                    <span>Sábados</span>
                    <strong>6:00 a. m. – 8:00 p. m.</strong>
                </div>
            </div>
        </div>

        <div class="pub-contacto-acciones">
            <a class="btn" href="${pageContext.request.contextPath}/login">Acceso para recepción</a>
            <a class="pub-link-oscuro" href="mailto:contacto@gimnasio.pe">Enviar correo &rarr;</a>
        </div>
    </div>
</section>

<%-- BANDA VISUAL INFERIOR --%>
<section class="pub-contacto-franja">
    <div class="pub-contacto-franja-img">
        <img src="${pageContext.request.contextPath}/img/portada-gym.jpg" alt="Instalaciones del gimnasio" loading="lazy">
    </div>
    <div class="pub-contacto-franja-texto">
        <span class="pub-subtitulo-kicker">ATENCIÓN EN RECEPCIÓN</span>
        <h2>Inscríbete en minutos y empieza hoy mismo</h2>
        <p>Acércate con tu DNI para activar tu plan predeterminado o armar un plan personalizado al instante. Si vienes referido por un socio activo, solicita tu 50% de descuento en tu primera mensualidad.</p>
        <a class="btn" href="${pageContext.request.contextPath}/">Ver nuestros planes</a>
    </div>
</section>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerPublicoJB.jsp"/>
