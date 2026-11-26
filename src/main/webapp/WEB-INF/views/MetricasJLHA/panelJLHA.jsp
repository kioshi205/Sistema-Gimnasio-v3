<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/WEB-INF/views/fragmentsJB/headerJB.jsp">
    <jsp:param name="titulo" value="Métricas de Ganancias"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/gimnasioJLHA.css">

<div class="titulo-pagina">
    <h1>Métricas de ganancias</h1>
    <span class="codigo">MÉTRICAS</span>
</div>
<p class="sub">Cuatro métricas para medir las ganancias del gimnasio en el tiempo. Cada suscripción se cuenta en el mes de su fecha de inicio.</p>

<form class="panel filtros" method="get" action="${pageContext.request.contextPath}/metricas">
    <div>
        <label for="desde">Desde (mes)</label>
        <input type="month" id="desde" name="desde" value="${panel.desde}">
    </div>
    <div>
        <label for="hasta">Hasta (mes)</label>
        <input type="month" id="hasta" name="hasta" value="${panel.hasta}">
    </div>
    <button class="btn" type="submit">Actualizar</button>
</form>

<div class="kpis">
    <div class="kpi">
        <span>Ganancia total</span>
        <strong>S/ <fmt:formatNumber value="${panel.totalGanancia}" minFractionDigits="2" maxFractionDigits="2"/></strong>
    </div>
    <div class="kpi">
        <span>Suscripciones vendidas</span>
        <strong>${panel.totalSuscripciones}</strong>
    </div>
    <div class="kpi">
        <span>Ticket promedio</span>
        <strong>S/ <fmt:formatNumber value="${panel.ticketPromedio}" minFractionDigits="2" maxFractionDigits="2"/></strong>
    </div>
    <div class="kpi">
        <span>Mejor mes</span>
        <strong>${panel.mejorMes}</strong>
        <small>S/ <fmt:formatNumber value="${panel.mejorMesMonto}" minFractionDigits="2" maxFractionDigits="2"/></small>
    </div>
</div>

<c:choose>
    <c:when test="${panel.totalSuscripciones == 0}">
        <div class="panel sin-datos">No hay suscripciones vendidas en el rango seleccionado.</div>
    </c:when>
    <c:otherwise>
        <div class="graficos">
            <div class="panel grafico">
                <h3>M1 · Ganancia mensual</h3>
                <p class="variables">Independiente: tiempo (mes) &rarr; Dependiente: ganancia (S/) · Gráfico de líneas</p>
                <div id="grafico1"></div>
            </div>
            <div class="panel grafico">
                <h3>M2 · Ganancia por plan</h3>
                <p class="variables">Independiente: plan, en cada mes &rarr; Dependiente: ganancia (S/) · Barras apiladas</p>
                <div id="grafico2"></div>
            </div>
            <div class="panel grafico">
                <h3>M3 · Ventas y ticket promedio</h3>
                <p class="variables">Independiente: suscripciones vendidas por mes &rarr; Dependiente: ticket promedio (S/) · Barras + línea</p>
                <div id="grafico3"></div>
            </div>
            <div class="panel grafico">
                <h3>M4 · Ganancia acumulada</h3>
                <p class="variables">Independiente: tiempo (acumulado) &rarr; Dependiente: ganancia (S/) · Área</p>
                <div id="grafico4"></div>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<div class="panel">
    <h3>Detalle mensual</h3>
    <table class="tabla">
        <thead>
        <tr>
            <th>Mes</th>
            <th class="num">Ganancia (S/)</th>
            <th class="num">Suscripciones</th>
            <th class="num">Ticket promedio (S/)</th>
            <th class="num">Acumulado (S/)</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="f" items="${panel.filas}">
            <tr>
                <td>${f.etiqueta}</td>
                <td class="num"><fmt:formatNumber value="${f.ganancia}" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td class="num">${f.cantidad}</td>
                <td class="num"><fmt:formatNumber value="${f.ticketPromedio}" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td class="num"><fmt:formatNumber value="${f.acumulado}" minFractionDigits="2" maxFractionDigits="2"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<c:if test="${panel.totalSuscripciones > 0}">
    <script>
/* Gráficos SVG de las 4 métricas de ganancias (sin librerías externas). Autor: JLHA */
var MetricasJLHA = (function () {
    'use strict';

    var NS = 'http://www.w3.org/2000/svg';
    var COLOR = {
        cian: '#00b8d9', oscuro: '#0090ad', tinta: '#0b2a33', ambar: '#f5a524',
        texto: '#5b7c86', rejilla: '#d4eef3'
    };
    var COLOR_PLAN = {'Básico': '#9be4f0', 'Medio': '#00b8d9', 'Pro': '#0b2a33', 'Personalizado': '#f5a524'};
    var EXTRA = ['#7c5cff', '#2fb872', '#e5484d', '#8aa1a9'];

    function soles(v) {
        return 'S/ ' + Number(v).toLocaleString('es-PE', {minimumFractionDigits: 0, maximumFractionDigits: 2});
    }

    function entero(v) {
        return String(Math.round(v));
    }

    function el(tag, attrs, texto) {
        var e = document.createElementNS(NS, tag);
        for (var k in attrs) {
            if (Object.prototype.hasOwnProperty.call(attrs, k)) {
                e.setAttribute(k, attrs[k]);
            }
        }
        if (texto !== undefined) {
            e.textContent = texto;
        }
        return e;
    }

    function titulo(nodo, texto) {
        nodo.appendChild(el('title', {}, texto));
        return nodo;
    }

    /** Máximo "bonito" del eje y paso de las 5 divisiones. */
    function escala(max, esEntero) {
        if (max <= 0) {
            return {max: esEntero ? 1 : 10, paso: esEntero ? 1 : 2};
        }
        if (esEntero && max <= 5) {
            var t = Math.ceil(max);
            return {max: t, paso: 1};
        }
        var exp = Math.pow(10, Math.floor(Math.log(max) / Math.LN10));
        var f = max / exp;
        var nf = f <= 1 ? 1 : f <= 2 ? 2 : f <= 2.5 ? 2.5 : f <= 5 ? 5 : 10;
        return {max: nf * exp, paso: nf * exp / 5};
    }

    function maximo(series, n) {
        var mx = 0, i;
        var apiladas = series.filter(function (s) { return s.tipo === 'barra' && s.apilado; });
        for (i = 0; i < n; i++) {
            var suma = 0;
            apiladas.forEach(function (s) { suma += s.valores[i]; });
            mx = Math.max(mx, suma);
        }
        series.forEach(function (s) {
            if (!(s.tipo === 'barra' && s.apilado)) {
                s.valores.forEach(function (v) { mx = Math.max(mx, v); });
            }
        });
        return mx;
    }

    /**
     * cfg: {titulo, labels[], fmtIzq, fmtDer, enteroIzq,
     *       series:[{nombre, tipo:'linea'|'area'|'barra', valores[], eje:'izq'|'der', color, apilado, fmt, etiqueta}]}
     */
    function dibujar(host, cfg) {
        var W = 640, H = 300;
        var conDer = cfg.series.some(function (s) { return s.eje === 'der'; });
        var m = {t: 24, r: conDer ? 58 : 18, b: 40, l: 62};
        var iw = W - m.l - m.r, ih = H - m.t - m.b;
        var n = cfg.labels.length;
        var izq = cfg.series.filter(function (s) { return s.eje !== 'der'; });
        var der = cfg.series.filter(function (s) { return s.eje === 'der'; });
        var eI = escala(maximo(izq, n), cfg.enteroIzq);
        var eD = conDer ? escala(maximo(der, n)) : null;

        var svg = el('svg', {viewBox: '0 0 ' + W + ' ' + H, role: 'img', 'aria-label': cfg.titulo});
        svg.style.fontFamily = '"Segoe UI", system-ui, Arial, sans-serif';

        function x(i) { return m.l + (iw / n) * (i + 0.5); }
        function yI(v) { return m.t + ih - (v / eI.max) * ih; }
        function yD(v) { return m.t + ih - (v / eD.max) * ih; }
        function yDe(s, v) { return s.eje === 'der' ? yD(v) : yI(v); }

        var fmtIzq = cfg.fmtIzq || soles, fmtDer = cfg.fmtDer || soles;

        // Rejilla y ejes
        var v, y;
        for (v = 0; v <= eI.max + 1e-9; v += eI.paso) {
            y = yI(v);
            svg.appendChild(el('line', {x1: m.l, x2: W - m.r, y1: y, y2: y,
                stroke: COLOR.rejilla, 'stroke-width': 1}));
            svg.appendChild(el('text', {x: m.l - 8, y: y + 4, 'text-anchor': 'end',
                'font-size': 11, fill: COLOR.texto}, fmtIzq(v)));
        }
        if (conDer) {
            for (v = 0; v <= eD.max + 1e-9; v += eD.paso) {
                svg.appendChild(el('text', {x: W - m.r + 8, y: yD(v) + 4, 'text-anchor': 'start',
                    'font-size': 11, fill: COLOR.texto}, fmtDer(v)));
            }
        }
        var salto = n > 18 ? 3 : n > 9 ? 2 : 1;
        cfg.labels.forEach(function (l, i) {
            if (i % salto === 0) {
                svg.appendChild(el('text', {x: x(i), y: H - m.b + 18, 'text-anchor': 'middle',
                    'font-size': 11, fill: COLOR.texto}, l));
            }
        });
        svg.appendChild(el('line', {x1: m.l, x2: W - m.r, y1: m.t + ih, y2: m.t + ih,
            stroke: COLOR.texto, 'stroke-width': 1}));

        var verEtiquetas = n <= 8;

        // Barras (agrupadas o apiladas)
        var barras = cfg.series.filter(function (s) { return s.tipo === 'barra'; });
        var apiladas = barras.filter(function (s) { return s.apilado; });
        var sueltas = barras.filter(function (s) { return !s.apilado; });
        var grupos = sueltas.length + (apiladas.length ? 1 : 0);
        if (grupos > 0) {
            var banda = iw / n;
            var ancho = Math.min(52, banda * 0.62 / grupos);
            var base = yI(0);
            for (var i = 0; i < n; i++) {
                var g = 0;
                var inicio = x(i) - (ancho * grupos) / 2;
                if (apiladas.length) {
                    var acum = 0;
                    apiladas.forEach(function (s) {
                        var val = s.valores[i];
                        if (val > 0) {
                            var y0 = yI(acum), y1 = yI(acum + val);
                            svg.appendChild(titulo(el('rect', {x: inicio, y: y1, width: ancho, height: y0 - y1,
                                fill: s.color, stroke: '#fff', 'stroke-width': 1}),
                                cfg.labels[i] + ' · ' + s.nombre + ': ' + s.fmt(val)));
                        }
                        acum += val;
                    });
                    if (verEtiquetas && acum > 0 && cfg.totalApilado) {
                        svg.appendChild(el('text', {x: inicio + ancho / 2, y: yI(acum) - 6, 'text-anchor': 'middle',
                            'font-size': 11, 'font-weight': 700, fill: COLOR.tinta}, cfg.totalApilado(acum)));
                    }
                    g++;
                }
                sueltas.forEach(function (s) {
                    var val = s.valores[i];
                    var xr = inicio + g * ancho;
                    svg.appendChild(titulo(el('rect', {x: xr, y: yI(val), width: ancho, height: base - yI(val),
                        fill: s.color, rx: 3}), cfg.labels[i] + ' · ' + s.nombre + ': ' + s.fmt(val)));
                    if (verEtiquetas && s.etiqueta && val > 0) {
                        svg.appendChild(el('text', {x: xr + ancho / 2, y: yI(val) - 6, 'text-anchor': 'middle',
                            'font-size': 11, 'font-weight': 700, fill: COLOR.tinta}, (s.fmtEt || s.fmt)(val)));
                    }
                    g++;
                });
            }
        }

        // Áreas y líneas
        cfg.series.forEach(function (s) {
            if (s.tipo !== 'linea' && s.tipo !== 'area') {
                return;
            }
            // valores null = mes sin dato: se deja un hueco en la línea
            var puntos = s.valores.map(function (val, i) { return val === null ? null : [x(i), yDe(s, val)]; });
            var d = '', abierto = false;
            puntos.forEach(function (p) {
                if (!p) { abierto = false; return; }
                d += (abierto ? ' L' : (d ? ' M' : 'M')) + p[0].toFixed(1) + ' ' + p[1].toFixed(1);
                abierto = true;
            });
            var validos = puntos.filter(function (p) { return p; });
            if (s.tipo === 'area' && validos.length > 1) {
                var cierre = d + ' L' + validos[validos.length - 1][0].toFixed(1) + ' ' + (m.t + ih) +
                    ' L' + validos[0][0].toFixed(1) + ' ' + (m.t + ih) + ' Z';
                svg.appendChild(el('path', {d: cierre, fill: s.color, 'fill-opacity': 0.16}));
            }
            if (validos.length > 1) {
                svg.appendChild(el('path', {d: d, fill: 'none', stroke: s.color, 'stroke-width': 2.5,
                    'stroke-linejoin': 'round', 'stroke-linecap': 'round'}));
            }
            puntos.forEach(function (p, i) {
                if (!p) { return; }
                svg.appendChild(titulo(el('circle', {cx: p[0], cy: p[1], r: 4, fill: '#fff',
                    stroke: s.color, 'stroke-width': 2.5}), cfg.labels[i] + ' · ' + s.nombre + ': ' + s.fmt(s.valores[i])));
                var mostrar = s.etiqueta === 'ultimo' ? i === n - 1 : (s.etiqueta && verEtiquetas && s.valores[i] > 0);
                if (mostrar) {
                    svg.appendChild(el('text', {x: p[0], y: p[1] - 10, 'text-anchor': i === n - 1 && n > 1 ? 'end' : 'middle',
                        'font-size': 11, 'font-weight': 700, fill: COLOR.tinta}, s.fmt(s.valores[i])));
                }
            });
        });

        host.innerHTML = '';
        host.appendChild(svg);

        if (cfg.series.length > 1) {
            var ley = document.createElement('div');
            ley.className = 'leyenda';
            cfg.series.forEach(function (s) {
                var item = document.createElement('span');
                var cuadro = document.createElement('i');
                cuadro.style.background = s.color;
                item.appendChild(cuadro);
                item.appendChild(document.createTextNode(s.nombre));
                ley.appendChild(item);
            });
            host.appendChild(ley);
        }
    }

    function colorPlan(nombre, i) {
        return COLOR_PLAN[nombre] || EXTRA[i % EXTRA.length];
    }

    function iniciar(d) {
        var L = d.labels;
        dibujar(document.getElementById('grafico1'), {
            titulo: 'Ganancia mensual', labels: L,
            series: [{nombre: 'Ganancia', tipo: 'linea', valores: d.ganancia, color: COLOR.cian, fmt: soles, etiqueta: true}]
        });
        dibujar(document.getElementById('grafico2'), {
            titulo: 'Ganancia por plan', labels: L, totalApilado: soles,
            series: d.planes.map(function (p, i) {
                return {nombre: p.nombre, tipo: 'barra', apilado: true, valores: p.valores,
                    color: colorPlan(p.nombre, i), fmt: soles};
            })
        });
        dibujar(document.getElementById('grafico3'), {
            titulo: 'Suscripciones vendidas y ticket promedio', labels: L, enteroIzq: true, fmtIzq: entero,
            series: [
                {nombre: 'Suscripciones vendidas', tipo: 'barra', eje: 'izq', valores: d.cantidad, color: COLOR.cian,
                    fmt: function (v) { return v + (v === 1 ? ' suscripción' : ' suscripciones'); }, fmtEt: entero, etiqueta: true},
                {nombre: 'Ticket promedio (S/)', tipo: 'linea', eje: 'der', valores: d.ticket, color: COLOR.ambar, fmt: soles}
            ]
        });
        dibujar(document.getElementById('grafico4'), {
            titulo: 'Ganancia acumulada', labels: L,
            series: [{nombre: 'Ganancia acumulada', tipo: 'area', valores: d.acumulado, color: COLOR.oscuro,
                fmt: soles, etiqueta: 'ultimo'}]
        });
    }

    return {iniciar: iniciar};
})();

        MetricasJLHA.iniciar(${datosJson});
    </script>
</c:if>

<jsp:include page="/WEB-INF/views/fragmentsJB/footerJB.jsp"/>
