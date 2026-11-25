package com.example.SistemaGimnasioV2.modelJB;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

public class ResumenSuscripcionJB {
    private ClienteJB cliente;
    private String nombrePlan;
    private String detalle;
    private BigDecimal subtotal;
    private BigDecimal descuentoPersonalizado;
    private BigDecimal descuentoPromocion;
    private String nombrePromocion;
    private Integer idCuponAplicado;
    private String mensajePromocion;
    private BigDecimal montoTotal;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private LocalDate fechaFinVigente;

    public ClienteJB getCliente() {
        return cliente;
    }

    public void setCliente(ClienteJB cliente) {
        this.cliente = cliente;
    }

    public String getNombrePlan() {
        return nombrePlan;
    }

    public void setNombrePlan(String nombrePlan) {
        this.nombrePlan = nombrePlan;
    }

    public String getDetalle() {
        return detalle;
    }

    public void setDetalle(String detalle) {
        this.detalle = detalle;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public BigDecimal getDescuentoPersonalizado() {
        return descuentoPersonalizado;
    }

    public void setDescuentoPersonalizado(BigDecimal descuentoPersonalizado) {
        this.descuentoPersonalizado = descuentoPersonalizado;
    }

    public BigDecimal getDescuentoPromocion() {
        return descuentoPromocion;
    }

    public void setDescuentoPromocion(BigDecimal descuentoPromocion) {
        this.descuentoPromocion = descuentoPromocion;
    }

    public String getNombrePromocion() {
        return nombrePromocion;
    }

    public void setNombrePromocion(String nombrePromocion) {
        this.nombrePromocion = nombrePromocion;
    }

    public Integer getIdCuponAplicado() {
        return idCuponAplicado;
    }

    public void setIdCuponAplicado(Integer idCuponAplicado) {
        this.idCuponAplicado = idCuponAplicado;
    }

    public String getMensajePromocion() {
        return mensajePromocion;
    }

    public void setMensajePromocion(String mensajePromocion) {
        this.mensajePromocion = mensajePromocion;
    }

    public BigDecimal getMontoTotal() {
        return montoTotal;
    }

    public void setMontoTotal(BigDecimal montoTotal) {
        this.montoTotal = montoTotal;
    }

    public LocalDate getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(LocalDate fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public LocalDate getFechaFin() {
        return fechaFin;
    }

    public void setFechaFin(LocalDate fechaFin) {
        this.fechaFin = fechaFin;
    }

    public LocalDate getFechaFinVigente() {
        return fechaFinVigente;
    }

    public void setFechaFinVigente(LocalDate fechaFinVigente) {
        this.fechaFinVigente = fechaFinVigente;
    }

    public List<String> getIncluye() {
        return Arrays.asList(detalle.split(";"));
    }
}