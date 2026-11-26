package com.example.SistemaGimnasioV2.modelJLHA;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** Datos ya calculados para el panel de métricas de ganancias. */
public class PanelMetricasJLHA {

    private String desde;            // yyyy-MM
    private String hasta;            // yyyy-MM
    private List<FilaMesJLHA> filas = new ArrayList<>();
    /** Ganancia por plan, un valor por mes (mismo orden que filas). */
    private Map<String, List<BigDecimal>> gananciaPorPlan = new LinkedHashMap<>();
    private BigDecimal totalGanancia = BigDecimal.ZERO;
    private int totalSuscripciones;
    private BigDecimal ticketPromedio = BigDecimal.ZERO;
    private String mejorMes = "-";
    private BigDecimal mejorMesMonto = BigDecimal.ZERO;

    public String getDesde() {
        return desde;
    }

    public void setDesde(String desde) {
        this.desde = desde;
    }

    public String getHasta() {
        return hasta;
    }

    public void setHasta(String hasta) {
        this.hasta = hasta;
    }

    public List<FilaMesJLHA> getFilas() {
        return filas;
    }

    public void setFilas(List<FilaMesJLHA> filas) {
        this.filas = filas;
    }

    public Map<String, List<BigDecimal>> getGananciaPorPlan() {
        return gananciaPorPlan;
    }

    public void setGananciaPorPlan(Map<String, List<BigDecimal>> gananciaPorPlan) {
        this.gananciaPorPlan = gananciaPorPlan;
    }

    public BigDecimal getTotalGanancia() {
        return totalGanancia;
    }

    public void setTotalGanancia(BigDecimal totalGanancia) {
        this.totalGanancia = totalGanancia;
    }

    public int getTotalSuscripciones() {
        return totalSuscripciones;
    }

    public void setTotalSuscripciones(int totalSuscripciones) {
        this.totalSuscripciones = totalSuscripciones;
    }

    public BigDecimal getTicketPromedio() {
        return ticketPromedio;
    }

    public void setTicketPromedio(BigDecimal ticketPromedio) {
        this.ticketPromedio = ticketPromedio;
    }

    public String getMejorMes() {
        return mejorMes;
    }

    public void setMejorMes(String mejorMes) {
        this.mejorMes = mejorMes;
    }

    public BigDecimal getMejorMesMonto() {
        return mejorMesMonto;
    }

    public void setMejorMesMonto(BigDecimal mejorMesMonto) {
        this.mejorMesMonto = mejorMesMonto;
    }
}
