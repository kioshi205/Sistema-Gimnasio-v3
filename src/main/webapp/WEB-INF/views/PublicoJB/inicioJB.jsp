<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerPublicoJB.jsp">
    <jsp:param name="titulo" value="Inicio"/>
</jsp:include>

<%-- HERO ASIMÉTRICO CON MÉTRICAS INTEGRADAS --%>
<section class="pub-hero"
         style="background-image: linear-gradient(105deg, rgba(15, 23, 42, 0.92) 0%, rgba(11, 58, 74, 0.74) 52%, rgba(15, 23, 42, 0.25) 100%), url('${pageContext.request.contextPath}/img/portada-gym.jpg');">
    <div class="pub-hero-contenido">
        <span class="pub-kicker">GIMNASIO HUANCAYO</span>
        <h1>Entrena a tu manera, paga solo por lo que usas</h1>
        <p>Elige entre nuestros planes mensuales predeterminados o diseña un plan a tu medida combinando los servicios que realmente necesitas.</p>
        <div class="pub-hero-acciones">
            <a class="btn" href="${pageContext.request.contextPath}/login">Ingresar al sistema</a>
            <a class="pub-link-claro" href="${pageContext.request.contextPath}/contacto">Conocer la sede &rarr;</a>
        </div>
    </div>

    <div class="pub-hero-stats">
        <div class="pub-stat">
            <strong>20</strong>
            <span>Subproductos configurables</span>
        </div>
        <div class="pub-stat">
            <strong>6</strong>
            <span>Categorías especializadas</span>
        </div>
        <div class="pub-stat">
            <strong>30 días</strong>
            <span>Membresías flexibles</span>
        </div>
        <div class="pub-stat">
            <strong>Hasta 50%</strong>
            <span>Beneficios y promociones</span>
        </div>
    </div>
</section>

<%-- PLANES EN BLOQUE COMPARATIVO UNIFICADO --%>
<section class="pub-seccion">
    <div class="pub-encabezado">
        <div>
            <span class="pub-subtitulo-kicker">MEMBRESÍAS MENSUALES</span>
            <h2>Planes claros, sin letras pequeñas</h2>
        </div>
        <p>Todos los planes tienen una vigencia de 30 días y se gestionan directamente en recepción.</p>
    </div>

    <div class="pub-planes-tabla">
        <div class="pub-plan-col">
            <div class="pub-plan-top">
                <span class="pub-plan-nivel">Esencial</span>
                <h3>Básico</h3>
                <div class="pub-plan-precio"><span>S/</span> 90.00</div>
                <small>por 30 días</small>
            </div>
            <ul class="pub-plan-lista">
                <li>Sala de máquinas y pesas</li>
                <li>Wifi gratis</li>
                <li>Dispensador de agua purificada</li>
                <li>Uso de casilleros</li>
            </ul>
        </div>

        <div class="pub-plan-col destacado">
            <div class="pub-plan-top">
                <span class="pub-plan-nivel activo">Más elegido</span>
                <h3>Medio</h3>
                <div class="pub-plan-precio"><span>S/</span> 195.00</div>
                <small>por 30 días</small>
            </div>
            <ul class="pub-plan-lista">
                <li>Todo lo incluido en Básico</li>
                <li>Zona de cardio y zona lounge</li>
                <li>Ingreso a las duchas</li>
                <li>Equipo de entrenamiento y lavado</li>
            </ul>
        </div>

        <div class="pub-plan-col">
            <div class="pub-plan-top">
                <span class="pub-plan-nivel">Experiencia total</span>
                <h3>Pro</h3>
                <div class="pub-plan-precio"><span>S/</span> 410.00</div>
                <small>por 30 días</small>
            </div>
            <ul class="pub-plan-lista">
                <li>Todas las zonas de entrenamiento</li>
                <li>Sauna y relajación muscular</li>
                <li>Reloj de mano cardiomedidor</li>
                <li>Parking de auto y kit de aseo</li>
            </ul>
        </div>
    </div>

    <div class="pub-personalizado-barra">
        <div>
            <span class="pub-subtitulo-kicker">A TU MEDIDA</span>
            <h3>¿Prefieres armar tu propio plan personalizado?</h3>
            <p>Combina libremente los servicios que necesites y obtén <strong>15% de descuento automático</strong> al elegir 5 o más subproductos.</p>
        </div>
        <a class="btn" href="${pageContext.request.contextPath}/login">Configurar en recepción</a>
    </div>
</section>

<%-- SECCIÓN EDITORIAL ALTERNADA (SIN TARJETAS) --%>
<section class="pub-seccion">
    <div class="pub-encabezado">
        <div>
            <span class="pub-subtitulo-kicker">POR QUÉ ELEGIRNOS</span>
            <h2>Espacios pensados para entrenar mejor</h2>
        </div>
    </div>

    <div class="pub-filas-alternadas">
        <article class="pub-fila-feature">
            <div class="pub-feature-img">
                <div class="pub-feature-recorte">
                    <img src="${pageContext.request.contextPath}/img/equipos-gym.jpg" alt="Zona de máquinas y cardio" loading="lazy">
                </div>
                <span class="pub-feature-etiqueta">Sala de máquinas y cardio</span>
            </div>
            <div class="pub-feature-texto">
                <span class="pub-numero">01</span>
                <h3>Equipos modernos para cada objetivo</h3>
                <p>Contamos con zonas amplias de máquinas, pesas libres y equipamiento cardiovascular de última generación para entrenamientos de fuerza o resistencia.</p>
                <ul class="pub-checks">
                    <li>Sala de máquinas y pesas siempre disponible</li>
                    <li>Zona de cardio equipada y ventilada</li>
                    <li>Herramientas de monitoreo y bioimpedancia</li>
                </ul>
            </div>
        </article>

        <article class="pub-fila-feature invertida">
            <div class="pub-feature-img">
                <div class="pub-feature-recorte">
                    <img src="${pageContext.request.contextPath}/img/funcional-gym.jpg" alt="Zona de entrenamiento funcional" loading="lazy">
                </div>
                <span class="pub-feature-etiqueta">Entrenamiento funcional</span>
            </div>
            <div class="pub-feature-texto">
                <span class="pub-numero">02</span>
                <h3>Flexibilidad real en tu membresía</h3>
                <p>No te atamos a servicios que no utilizas. Puedes elegir un paquete predeterminado o armar el tuyo sumando solo los beneficios que prefieras.</p>
                <ul class="pub-checks">
                    <li>15% de descuento al elegir 5 o más subproductos</li>
                    <li>20% de descuento por fidelidad desde tu cuarta suscripción</li>
                    <li>Mejora de plan disponible en cualquier momento del mes</li>
                </ul>
            </div>
        </article>

        <article class="pub-fila-feature">
            <div class="pub-feature-img">
                <div class="pub-feature-recorte">
                    <img src="${pageContext.request.contextPath}/img/comodidad-gym.jpg" alt="Duchas, casilleros y sauna" loading="lazy">
                </div>
                <span class="pub-feature-etiqueta">Duchas, casilleros y sauna</span>
            </div>
            <div class="pub-feature-texto">
                <span class="pub-numero">03</span>
                <h3>Comodidad antes y después de entrenar</h3>
                <p>Completa tu rutina con áreas diseñadas para tu descanso, higiene y recuperación muscular en un ambiente limpio y ordenado.</p>
                <ul class="pub-checks">
                    <li>Casilleros, duchas, secadores y zona lounge</li>
                    <li>Sauna y máquinas de relajación muscular</li>
                    <li>Estacionamiento para auto, moto o bicicleta</li>
                </ul>
            </div>
        </article>
    </div>
</section>

<%-- FRANJA DE BENEFICIOS --%>
<section class="pub-banner-final">
    <div class="pub-banner-texto">
        <span class="pub-kicker">BENEFICIOS EXCLUSIVOS</span>
        <h2>50% de descuento por referido o 25% con cupón de campaña</h2>
        <p>Si eres cliente nuevo y vienes referido por un socio vigente, obtén mitad de precio en tu primer mes. Pregunta también por nuestros cupones activos en sede.</p>
    </div>
    <div class="pub-banner-accion">
        <a class="btn" href="${pageContext.request.contextPath}/contacto">Ver ubicación y horarios</a>
    </div>
</section>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerPublicoJB.jsp"/>
