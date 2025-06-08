package com.cibertec.dao;

import com.cibertec.model.Tutoria;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;

public class TutoriaDAO {
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("default");

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void insertar(Tutoria tutoria) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(tutoria);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
    
    public List<Tutoria> listar() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT t FROM Tutoria t", Tutoria.class).getResultList();
        } finally {
            em.close();
        }
    }
    
    public Tutoria buscar(Long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Tutoria.class, id);
        } finally {
            em.close();
        }
    }
    
    public void actualizar(Tutoria tutoria) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(tutoria);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
    
    public void eliminar(Long id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Tutoria tutoria = em.find(Tutoria.class, id);
            if (tutoria != null) {
                em.remove(tutoria);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public long contarAsistentes(Long idTutoria) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(a) FROM TutoriaAsistente a WHERE a.tutoria.idTutoria = :idTutoria", Long.class)
                .setParameter("idTutoria", idTutoria)
                .getSingleResult();
        } finally {
            em.close();
        }
    }
} 