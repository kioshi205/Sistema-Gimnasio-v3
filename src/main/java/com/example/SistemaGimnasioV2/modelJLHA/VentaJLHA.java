package com.example.SistemaGimnasioV2.modelJLHA;

import java.math.BigDecimal;
import java.time.LocalDate;


public class VentaJLHA {

    private LocalDate fecha;
    private String plan;
    private BigDecimal monto;

    public LocalDate getFecha() {
        return fecha;
    }

    public void setFecha(LocalDate fecha) {
        this.fecha = fecha;
    }

    public String getPlan() {
        return plan;
    }

    public void setPlan(String plan) {
        this.plan = plan;
    }

    public BigDecimal getMonto() {
        return monto;
    }

    public void setMonto(BigDecimal monto) {
        this.monto = monto;
    }
}
