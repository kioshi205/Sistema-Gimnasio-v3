package com.example.SistemaGimnasioV2.Service;

import com.example.SistemaGimnasioV2.Repository.GimnasioRepositoryJB;
import com.example.SistemaGimnasioV2.modelJB.ClienteJB;
import com.example.SistemaGimnasioV2.modelJB.PlanJB;
import com.example.SistemaGimnasioV2.modelJB.ResumenSuscripcionJB;
import com.example.SistemaGimnasioV2.modelJB.SubproductoJB;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class SuscripcionServiceJB {

    private static final int DIAS_PERSONALIZADO = 30;

    private final GimnasioRepositoryJB repo;

    public SuscripcionServiceJB(GimnasioRepositoryJB repo) {
        this.repo = repo;
    }

    public List<PlanJB> listarPlanes() {
        return repo.listarPlanes();
    }

    public List<SubproductoJB> listarSubproductos() {
        return repo.listarSubproductos();
    }

    public List<SubproductoJB> buscarSubproductos(List<Integer> ids) {
        return repo.buscarSubproductos(ids);
    }

    public boolean seleccionValida(Integer idPlan, List<Integer> ids) {
        return idPlan != null || (ids != null && !ids.isEmpty());
    }

    public BigDecimal total(List<SubproductoJB> subproductos) {
        BigDecimal suma = BigDecimal.ZERO;
        for (SubproductoJB s : subproductos) {
            suma = suma.add(s.getPrecioIndividual());
        }
        return suma;
    }

    public List<String> validarCliente(ClienteJB c) {
        c.setDni(texto(c.getDni()));
        c.setNombre(texto(c.getNombre()));
        c.setApellido(texto(c.getApellido()));
        c.setTelefono(texto(c.getTelefono()));
        c.setEmail(texto(c.getEmail()));

        List<String> errores = new ArrayList<>();
        if (!c.getDni().matches("\\d{8}")) {
            errores.add("El DNI debe tener 8 dígitos.");
        } else if (repo.buscarClientePorDni(c.getDni()) == null) {
            if (c.getNombre().isEmpty()) {
                errores.add("El nombre es obligatorio.");
            }
            if (c.getApellido().isEmpty()) {
                errores.add("El apellido es obligatorio.");
            }
            if (!c.getTelefono().isEmpty() && !c.getTelefono().matches("\\d{9}")) {
                errores.add("El teléfono debe tener 9 dígitos.");
            }
            if (!c.getEmail().isEmpty() && repo.existeEmail(c.getEmail())) {
                errores.add("Ese correo ya está registrado.");
            }
        }
        return errores;
    }

    public int guardarCliente(ClienteJB c) {
        ClienteJB existente = repo.buscarClientePorDni(c.getDni());
        if (existente != null) {
            return existente.getIdCliente();
        }
        if (c.getTelefono().isEmpty()) {
            c.setTelefono(null);
        }
        if (c.getEmail().isEmpty()) {
            c.setEmail(null);
        }
        return repo.insertarCliente(c);
    }

    public ResumenSuscripcionJB armarResumen(Integer idPlan, List<Integer> ids, int idCliente) {
        ResumenSuscripcionJB resumen = new ResumenSuscripcionJB();
        int dias;

        if (idPlan != null) {
            PlanJB plan = repo.buscarPlan(idPlan);
            resumen.setNombrePlan(plan.getNombrePlan());
            resumen.setDetalle(String.join(";", plan.getIncluye()));
            resumen.setMontoTotal(plan.getPrecioBase());
            dias = plan.getDuracionDias();
        } else {
            List<SubproductoJB> subproductos = repo.buscarSubproductos(ids);
            List<String> nombres = new ArrayList<>();
            for (SubproductoJB s : subproductos) {
                nombres.add(s.getNombreSubproducto());
            }
            resumen.setNombrePlan("Personalizado");
            resumen.setDetalle(String.join(";", nombres));
            resumen.setMontoTotal(total(subproductos));
            dias = DIAS_PERSONALIZADO;
        }

        LocalDate hoy = LocalDate.now();
        resumen.setCliente(repo.buscarCliente(idCliente));
        resumen.setFechaInicio(hoy);
        resumen.setFechaFin(hoy.plusDays(dias));
        resumen.setFechaFinVigente(repo.fechaFinVigente(idCliente, hoy));
        return resumen;
    }

    public int confirmar(Integer idPlan, List<Integer> ids, int idCliente) {
        ResumenSuscripcionJB resumen = armarResumen(idPlan, ids, idCliente);
        return repo.insertarSuscripcion(idCliente, idPlan, resumen.getDetalle(),
                resumen.getFechaInicio(), resumen.getFechaFin(), resumen.getMontoTotal());
    }

    public boolean tieneSuscripcionVigente(int idCliente) {
        return repo.fechaFinVigente(idCliente, LocalDate.now()) != null;
    }

    private String texto(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
