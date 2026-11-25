package com.example.SistemaGimnasioV2.modelJB;

import java.math.BigDecimal;
import java.util.List;

public class PlanJB {
    private Integer idPlan;
    private String nombrePlan;
    private BigDecimal precioBase;
    private Integer duracionDias;
    private List<String> incluye;
    private boolean disponible;
    private List<String> serviciosInactivos;

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
        return incluye;
    }

    public void setIncluye(List<String> incluye) {
        this.incluye = incluye;
    }
    public boolean isDisponible() {
        return disponible;
    }

    public void setDisponible(boolean disponible) {
        this.disponible = disponible;
    }

    public List<String> getServiciosInactivos() {
        return serviciosInactivos;
    }

    public void setServiciosInactivos(List<String> serviciosInactivos) {
        this.serviciosInactivos = serviciosInactivos;
    }
}