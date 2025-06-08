package com.cibertec.dao;

import com.cibertec.model.Proyecto;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;

public class ProyectoDAO {
    private EntityManagerFactory emf;
    private EntityManager em;
    
    public ProyectoDAO() {
        emf = Persistence.createEntityManagerFactory("default");
        em = emf.createEntityManager();
    }
    
    public void insertar(Proyecto proyecto) {
        try {
            em.getTransaction().begin();
            em.persist(proyecto);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        }
    }
    
    public List<Proyecto> listar() {
        return em.createQuery("SELECT p FROM Proyecto p", Proyecto.class).getResultList();
    }
    
    public Proyecto buscar(Long id) {
        return em.find(Proyecto.class, id);
    }
    
    public void actualizar(Proyecto proyecto) {
        try {
            em.getTransaction().begin();
            em.merge(proyecto);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        }
    }
    
    public void eliminar(Long id) {
        try {
            em.getTransaction().begin();
            Proyecto proyecto = em.find(Proyecto.class, id);
            if (proyecto != null) {
                em.remove(proyecto);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        }
    }
} 