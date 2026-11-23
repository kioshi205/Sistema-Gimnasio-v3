package com.example.SistemaGimnasioV2.modelJB;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

public class PlanJB {

    private Integer idPlan;
    private String nombrePlan;
    private String descripcion;
    private BigDecimal precioBase;
    private Integer duracionDias;

    public Integer getIdPlan() {
        return idPlan;
    }

    public void setIdPlan(Integer idPlan) {
        this.idPlan = idPlan;
    }

    public String getNombrePlan() {
        return nombrePlan;
    }

    public void setNombrePlan(String nombrePlan) {
        this.nombrePlan = nombrePlan;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public BigDecimal getPrecioBase() {
        return precioBase;
    }

    public void setPrecioBase(BigDecimal precioBase) {
        this.precioBase = precioBase;
    }

    public Integer getDuracionDias() {
        return duracionDias;
    }

    public void setDuracionDias(Integer duracionDias) {
        this.duracionDias = duracionDias;
    }

    public List<String> getIncluye() {
        return Arrays.asList(descripcion.split(";"));
    }
}
