package com.cibertec.dao;

import com.cibertec.model.TutoriaAsistente;
import com.cibertec.model.Usuario;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;

public class TutoriaAsistenteDAO {
    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("default");

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void insertar(TutoriaAsistente asistente) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(asistente);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
    
    public List<TutoriaAsistente> listar() {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery("SELECT a FROM TutoriaAsistente a", TutoriaAsistente.class).getResultList();
        } finally {
            em.close();
        }
    }
    
    public TutoriaAsistente buscar(Long id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(TutoriaAsistente.class, id);
        } finally {
            em.close();
        }
    }
    
    public void eliminar(Long id) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            TutoriaAsistente asistente = em.find(TutoriaAsistente.class, id);
            if (asistente != null) {
                em.remove(asistente);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    // New method: get all usuarios inscritos for a tutoria
    public List<Usuario> listarUsuariosPorTutoriaId(Long tutoriaId) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                "SELECT a.usuario FROM TutoriaAsistente a WHERE a.tutoria.idTutoria = :tutoriaId", Usuario.class)
                .setParameter("tutoriaId", tutoriaId)
                .getResultList();
        } finally {
            em.close();
        }
    }

    public boolean existeAsistente(Long tutoriaId, Long usuarioId) {
        EntityManager em = getEntityManager();
        try {
            Long count = em.createQuery(
                "SELECT COUNT(a) FROM TutoriaAsistente a WHERE a.tutoria.idTutoria = :tutoriaId AND a.usuario.idUsuario = :usuarioId", Long.class)
                .setParameter("tutoriaId", tutoriaId)
                .setParameter("usuarioId", usuarioId)
                .getSingleResult();
            return count > 0;
        } finally {
            em.close();
        }
    }
} 