package com.example.SistemaGimnasioV2.Service;

import com.example.SistemaGimnasioV2.Repository.GimnasioRepositoryJLHA;
import com.example.SistemaGimnasioV2.modelJB.ClienteJB;
import com.example.SistemaGimnasioV2.modelJLHA.AccesoResultadoJLHA;
import com.example.SistemaGimnasioV2.modelJLHA.CuponJLHA;
import com.example.SistemaGimnasioV2.modelJLHA.FilaMesJLHA;
import com.example.SistemaGimnasioV2.modelJLHA.MarcacionAccesoJLHA;
import com.example.SistemaGimnasioV2.modelJLHA.PanelMetricasJLHA;
import com.example.SistemaGimnasioV2.modelJLHA.SuscripcionVigenteJLHA;
import com.example.SistemaGimnasioV2.modelJLHA.VentaJLHA;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.YearMonth;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Operación diaria y promociones (JLHA):
 * INT20 control de acceso, INT21 cupones y las 4 métricas de ganancias.
 */
@Service
public class OperacionServiceJLHA {

    /** RN01: los cupones promocionales que se crean en INT21 siempre otorgan 25% de descuento. */
    public static final int PORCENTAJE_CUPON_RN01 = 25;

    private final GimnasioRepositoryJLHA repo;

    public OperacionServiceJLHA(GimnasioRepositoryJLHA repo) {
        this.repo = repo;
    }

    // ===================== INT20 - Control de acceso =====================




    /**
     * Verifica el DNI y, si el cliente existe, registra la marcación:
     * PERMITIDO (con id_suscripcion) o DENEGADO (id_suscripcion = NULL).
     * Si el DNI no existe no se inserta nada.
     */
    public AccesoResultadoJLHA verificar(String dniIngresado) {
        String dni = dniIngresado == null ? "" : dniIngresado.trim();
        AccesoResultadoJLHA r = new AccesoResultadoJLHA();
        r.setDni(dni);

        if (!dni.matches("\\d{8}")) {
            r.setEstado(AccesoResultadoJLHA.DNI_INVALIDO);
            r.setMensaje("El DNI debe tener 8 dígitos.");
            return r;
        }

        ClienteJB cliente = repo.buscarClientePorDni(dni);
        if (cliente == null) {
            r.setEstado(AccesoResultadoJLHA.NO_REGISTRADO);
            r.setMensaje("El cliente no está registrado.");
            return r;
        }
        r.setNombreCompleto(cliente.getNombre() + " " + cliente.getApellido());

        LocalDate hoy = LocalDate.now();
        LocalTime ahora = LocalTime.now().withNano(0);
        SuscripcionVigenteJLHA vigente = repo.buscarSuscripcionVigente(cliente.getIdCliente(), hoy);

        if (vigente != null) {
            repo.insertarMarcacion(cliente.getIdCliente(), vigente.getIdSuscripcion(),
                    hoy, ahora, AccesoResultadoJLHA.PERMITIDO);
            r.setEstado(AccesoResultadoJLHA.PERMITIDO);
            r.setFechaFin(vigente.getFechaFin());
            r.setDiasRestantes(ChronoUnit.DAYS.between(hoy, vigente.getFechaFin()));
            r.setServicios(separarServicios(vigente.getDetalle()));
        } else {
            repo.insertarMarcacion(cliente.getIdCliente(), null,
                    hoy, ahora, AccesoResultadoJLHA.DENEGADO);
            r.setEstado(AccesoResultadoJLHA.DENEGADO);
            r.setMensaje("Suscripción vencida o inexistente.");
        }
        return r;
    }

    public List<MarcacionAccesoJLHA> ultimasMarcaciones() {
        return repo.ultimasMarcaciones(8);
    }

    /** El detalle de la suscripción guarda los servicios separados por ";". */
    private List<String> separarServicios(String detalle) {
        List<String> lista = new ArrayList<>();
        if (detalle != null) {
            for (String s : detalle.split(";")) {
                if (!s.trim().isEmpty()) {
                    lista.add(s.trim());
                }
            }
        }
        return lista;
    }

    // ===================== INT21 - Cupones =====================




    public List<CuponJLHA> listarCupones() {
        return repo.listarCupones();
    }

    /**
     * Valida los datos del formulario y, si todo es correcto, inserta el cupón como ACTIVO.
     * Devuelve la lista de errores (vacía cuando el cupón se guardó).
     * Los valores llegan como texto para poder dar mensajes claros ante datos mal escritos.
     */
    public List<String> crearCupon(String codigo, String descripcion,
                              String fechaInicio, String fechaFin) {
        List<String> errores = new ArrayList<>();

        String cod = texto(codigo).toUpperCase();
        String desc = texto(descripcion);

        if (!cod.matches("[A-ZÑ0-9_-]{3,30}")) {
            errores.add("El código debe tener entre 3 y 30 caracteres (letras, números, guion o guion bajo).");
        }
        if (desc.isEmpty()) {
            errores.add("La descripción es obligatoria.");
        } else if (desc.length() > 150) {
            errores.add("La descripción no puede superar los 150 caracteres.");
        }

        LocalDate inicio = fecha(fechaInicio, "inicio", errores);
        LocalDate fin = fecha(fechaFin, "fin", errores);
        if (inicio != null && fin != null) {
            if (fin.isBefore(inicio)) {
                errores.add("La fecha de fin no puede ser anterior a la fecha de inicio.");
            } else if (fin.isBefore(LocalDate.now())) {
                errores.add("La fecha de fin no puede estar en el pasado.");
            }
        }

        if (errores.isEmpty() && repo.existeCodigo(cod)) {
            errores.add("El código \"" + cod + "\" ya existe. Elige otro código promocional.");
        }
        if (!errores.isEmpty()) {
            return errores;
        }

        CuponJLHA cupon = new CuponJLHA();
        cupon.setCodigo(cod);
        cupon.setDescripcion(desc);
        cupon.setPorcentajeDescuento(PORCENTAJE_CUPON_RN01);
        cupon.setFechaInicio(inicio);
        cupon.setFechaFin(fin);
        try {
            repo.insertarCupon(cupon);
        } catch (DuplicateKeyException e) {
            // dos recepcionistas guardando el mismo código a la vez
            errores.add("El código \"" + cod + "\" ya existe. Elige otro código promocional.");
        }
        return errores;
    }

    /** Código tal como se guardó (mayúsculas y sin espacios), para el mensaje de confirmación. */
    public String normalizarCodigo(String codigo) {
        return texto(codigo).toUpperCase();
    }

    private LocalDate fecha(String valor, String nombre, List<String> errores) {
        try {
            return LocalDate.parse(texto(valor));
        } catch (DateTimeParseException e) {
            errores.add("La fecha de " + nombre + " es obligatoria y debe ser válida.");
            return null;
        }
    }

    private String texto(String valor) {
        return valor == null ? "" : valor.trim();
    }

    // ===================== Métricas de ganancias =====================


    private static final int MESES_POR_DEFECTO = 6;
    private static final int MESES_MAXIMO = 24;
    private static final String[] MES_CORTO =
            {"ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic"};



    public PanelMetricasJLHA armarMetricas(String desdeTexto, String hastaTexto) {
        YearMonth hasta = parsear(hastaTexto, YearMonth.now());
        YearMonth desde = parsear(desdeTexto, hasta.minusMonths(MESES_POR_DEFECTO - 1));
        if (desde.isAfter(hasta)) {
            YearMonth aux = desde;
            desde = hasta;
            hasta = aux;
        }
        if (desde.plusMonths(MESES_MAXIMO).isBefore(hasta.plusMonths(1))) {
            desde = hasta.minusMonths(MESES_MAXIMO - 1);
        }

        List<YearMonth> meses = new ArrayList<>();
        for (YearMonth m = desde; !m.isAfter(hasta); m = m.plusMonths(1)) {
            meses.add(m);
        }
        int n = meses.size();

        BigDecimal[] ganancia = ceros(n);
        int[] cantidad = new int[n];
        Map<String, BigDecimal[]> porPlan = new LinkedHashMap<>();

        for (VentaJLHA v : repo.listarVentas(desde.atDay(1), hasta.atEndOfMonth())) {
            int i = indice(meses, YearMonth.from(v.getFecha()));
            if (i < 0) {
                continue;
            }
            ganancia[i] = ganancia[i].add(v.getMonto());
            cantidad[i]++;
            porPlan.computeIfAbsent(v.getPlan(), k -> ceros(n));
            porPlan.get(v.getPlan())[i] = porPlan.get(v.getPlan())[i].add(v.getMonto());
        }

        PanelMetricasJLHA panel = new PanelMetricasJLHA();
        panel.setDesde(desde.toString());
        panel.setHasta(hasta.toString());

        BigDecimal acumulado = BigDecimal.ZERO;
        int totalSusc = 0;
        for (int i = 0; i < n; i++) {
            acumulado = acumulado.add(ganancia[i]);
            totalSusc += cantidad[i];

            FilaMesJLHA fila = new FilaMesJLHA();
            fila.setEtiqueta(etiqueta(meses.get(i)));
            fila.setGanancia(ganancia[i]);
            fila.setCantidad(cantidad[i]);
            fila.setTicketPromedio(promedio(ganancia[i], cantidad[i]));
            fila.setAcumulado(acumulado);
            panel.getFilas().add(fila);

            if (ganancia[i].compareTo(panel.getMejorMesMonto()) > 0) {
                panel.setMejorMesMonto(ganancia[i]);
                panel.setMejorMes(fila.getEtiqueta());
            }
        }
        panel.setTotalGanancia(acumulado);
        panel.setTotalSuscripciones(totalSusc);
        panel.setTicketPromedio(promedio(acumulado, totalSusc));

        // Planes ordenados de mayor a menor ganancia total; "Personalizado" siempre al final.
        List<Map.Entry<String, BigDecimal[]>> planes = new ArrayList<>(porPlan.entrySet());
        planes.sort((a, b) -> {
            boolean pa = "Personalizado".equals(a.getKey());
            boolean pb = "Personalizado".equals(b.getKey());
            if (pa != pb) {
                return pa ? 1 : -1;
            }
            return suma(b.getValue()).compareTo(suma(a.getValue()));
        });
        for (Map.Entry<String, BigDecimal[]> e : planes) {
            List<BigDecimal> valores = new ArrayList<>();
            for (BigDecimal v : e.getValue()) {
                valores.add(v);
            }
            panel.getGananciaPorPlan().put(e.getKey(), valores);
        }
        return panel;
    }

    /** JSON que consume metricasJLHA.js (se arma a mano para no depender de otra librería). */
    public String aJson(PanelMetricasJLHA p) {
        StringBuilder sb = new StringBuilder("{");
        sb.append("\"labels\":").append(lista(p.getFilas(), f -> jsonTexto(f.getEtiqueta())));
        sb.append(",\"ganancia\":").append(lista(p.getFilas(), f -> num(f.getGanancia())));
        sb.append(",\"cantidad\":").append(lista(p.getFilas(), f -> String.valueOf(f.getCantidad())));
        sb.append(",\"ticket\":").append(lista(p.getFilas(), f -> f.getCantidad() == 0 ? "null" : num(f.getTicketPromedio())));
        sb.append(",\"acumulado\":").append(lista(p.getFilas(), f -> num(f.getAcumulado())));
        sb.append(",\"planes\":[");
        boolean primero = true;
        for (Map.Entry<String, List<BigDecimal>> e : p.getGananciaPorPlan().entrySet()) {
            if (!primero) {
                sb.append(',');
            }
            primero = false;
            sb.append("{\"nombre\":").append(jsonTexto(e.getKey()))
                    .append(",\"valores\":").append(lista(e.getValue(), OperacionServiceJLHA::num)).append('}');
        }
        return sb.append("]}").toString();
    }

    // ---------- utilidades ----------

    private YearMonth parsear(String valor, YearMonth porDefecto) {
        if (valor == null || valor.trim().isEmpty()) {
            return porDefecto;
        }
        try {
            return YearMonth.parse(valor.trim());
        } catch (DateTimeParseException e) {
            return porDefecto;
        }
    }

    private int indice(List<YearMonth> meses, YearMonth m) {
        return meses.indexOf(m);
    }

    private BigDecimal[] ceros(int n) {
        BigDecimal[] a = new BigDecimal[n];
        for (int i = 0; i < n; i++) {
            a[i] = BigDecimal.ZERO;
        }
        return a;
    }

    private BigDecimal suma(BigDecimal[] valores) {
        BigDecimal s = BigDecimal.ZERO;
        for (BigDecimal v : valores) {
            s = s.add(v);
        }
        return s;
    }

    private BigDecimal promedio(BigDecimal total, int cantidad) {
        return cantidad == 0 ? BigDecimal.ZERO
                : total.divide(BigDecimal.valueOf(cantidad), 2, RoundingMode.HALF_UP);
    }

    private String etiqueta(YearMonth m) {
        return MES_CORTO[m.getMonthValue() - 1] + " " + m.getYear();
    }

    private static String num(BigDecimal v) {
        return v.setScale(2, RoundingMode.HALF_UP).toPlainString();
    }

    private static String jsonTexto(String s) {
        StringBuilder sb = new StringBuilder("\"");
        for (char c : s.toCharArray()) {
            switch (c) {
                case '"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '<': sb.append("\\u003c"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                default: sb.append(c);
            }
        }
        return sb.append('"').toString();
    }

    private static <T> String lista(List<T> items, java.util.function.Function<T, String> f) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < items.size(); i++) {
            if (i > 0) {
                sb.append(',');
            }
            sb.append(f.apply(items.get(i)));
        }
        return sb.append(']').toString();
    }
}
