package com.example.SistemaGimnasioV2.Service;

import com.example.SistemaGimnasioV2.Repository.PlanGestionRepositoryLDG;
import com.example.SistemaGimnasioV2.modelJB.PlanJB;
import com.example.SistemaGimnasioV2.modelJB.SubproductoJB;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class PlanGestionServiceLDG {

    private final PlanGestionRepositoryLDG repo;

    public PlanGestionServiceLDG(PlanGestionRepositoryLDG repo) {
        this.repo = repo;
    }

    public List<PlanJB> listarPlanes() {
        List<PlanJB> planes = repo.listarPlanes();
        List<PlanJB> resultado = new ArrayList<>();

        for (PlanJB plan : planes) {
            if (esPlanPredeterminado(plan)) {
                plan.setIncluye(repo.listarNombresSubproductos(plan.getIdPlan()));
                resultado.add(plan);
            }
        }
        return resultado;
    }

    public PlanJB buscarPlan(int idPlan) {
        PlanJB plan = repo.buscarPlan(idPlan);

        if (plan == null || !esPlanPredeterminado(plan)) {
            return null;
        }

        plan.setIncluye(repo.listarNombresSubproductos(idPlan));
        return plan;
    }

    public List<SubproductoJB> listarSubproductos() {
        return repo.listarSubproductos();
    }

    public List<Integer> listarIdsSubproductos(int idPlan) {
        return repo.listarIdsSubproductos(idPlan);
    }

    public BigDecimal calcularPrecioPlan(int idPlan) {
        List<Integer> ids = repo.listarIdsSubproductos(idPlan);
        List<SubproductoJB> subproductos = new ArrayList<>();

        for (Integer id : ids) {
            SubproductoJB subproducto = repo.buscarSubproducto(id);
            if (subproducto != null) {
                subproductos.add(subproducto);
            }
        }
        return calcularPrecio(subproductos);
    }

    @Transactional
    public String actualizarPlan(int idPlan, List<Integer> ids) {
        PlanJB plan = buscarPlan(idPlan);

        if (plan == null) {
            return "El plan indicado no existe o no es un plan predeterminado.";
        }

        if (ids != null) {
            for (Integer id : ids) {
                if (id == null || id <= 0) {
                    return "La selección de subproductos contiene identificadores inválidos.";
                }
            }
        }

        List<Integer> idsSinDuplicados = quitarDuplicados(ids);
        List<SubproductoJB> seleccionados = new ArrayList<>();

        for (Integer id : idsSinDuplicados) {
            SubproductoJB subproducto = repo.buscarSubproducto(id);
            if (subproducto == null) {
                return "Uno o más subproductos seleccionados no existen.";
            }
            seleccionados.add(subproducto);
        }

        BigDecimal precioBase = calcularPrecio(seleccionados);

        repo.actualizarPrecioPlan(idPlan, precioBase);
        repo.eliminarSubproductosPlan(idPlan);

        for (Integer id : idsSinDuplicados) {
            repo.insertarSubproductoPlan(idPlan, id);
        }

        return null;
    }

    private BigDecimal calcularPrecio(List<SubproductoJB> subproductos) {
        BigDecimal total = BigDecimal.ZERO;

        for (SubproductoJB subproducto : subproductos) {
            total = total.add(subproducto.getPrecioIndividual());
        }
        return total;
    }

    private List<Integer> quitarDuplicados(List<Integer> ids) {
        List<Integer> lista = new ArrayList<>();

        if (ids == null) {
            return lista;
        }

        for (Integer id : ids) {
            if (!lista.contains(id)) {
                lista.add(id);
            }
        }
        return lista;
    }

    private boolean esPlanPredeterminado(PlanJB plan) {
        if (plan == null || plan.getIdPlan() == null) {
            return false;
        }

        int id = plan.getIdPlan();
        String nombre = plan.getNombrePlan();

        if (id == 1) {
            return "Básico".equals(nombre);
        }
        if (id == 2) {
            return "Medio".equals(nombre);
        }
        if (id == 3) {
            return "Pro".equals(nombre);
        }
        return false;
    }
}
