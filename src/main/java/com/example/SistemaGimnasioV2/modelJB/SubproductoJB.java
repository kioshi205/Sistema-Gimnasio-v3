package com.example.SistemaGimnasioV2.modelJB;

import java.math.BigDecimal;

public class SubproductoJB {

    private Integer idSubproducto;
    private Integer idCategoria;
    private String nombreCategoria;
    private String nombreSubproducto;
    private BigDecimal precioIndividual;
    private String estado;

    public Integer getIdSubproducto() {
        return idSubproducto;
    }

    public void setIdSubproducto(Integer idSubproducto) {
        this.idSubproducto = idSubproducto;
    }

    public Integer getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(Integer idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNombreCategoria() {
        return nombreCategoria;
    }

    public void setNombreCategoria(String nombreCategoria) {
        this.nombreCategoria = nombreCategoria;
    }

    public String getNombreSubproducto() {
        return nombreSubproducto;
    }

    public void setNombreSubproducto(String nombreSubproducto) {
        this.nombreSubproducto = nombreSubproducto;
    }

    public BigDecimal getPrecioIndividual() {
        return precioIndividual;
    }

    public void setPrecioIndividual(BigDecimal precioIndividual) {
        this.precioIndividual = precioIndividual;
    }
    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}
