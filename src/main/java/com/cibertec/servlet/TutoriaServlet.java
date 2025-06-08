package com.cibertec.servlet;

import com.cibertec.dao.TutoriaDAO;
import com.cibertec.dao.TutoriaAsistenteDAO;
import com.cibertec.dao.UsuarioDAO;
import com.cibertec.model.Tutoria;
import com.cibertec.model.TutoriaAsistente;
import com.cibertec.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class TutoriaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        TutoriaDAO tutoriaDAO = new TutoriaDAO();
        TutoriaAsistenteDAO asistenteDAO = new TutoriaAsistenteDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        try {
            List<Tutoria> tutorias = tutoriaDAO.listar();
            List<Usuario> usuarios = usuarioDAO.listar();
            req.setAttribute("tutorias", tutorias);
            req.setAttribute("usuarios", usuarios);
            // For each tutoria, get count of asistentes
            Map<Long, Long> asistentesCount = new HashMap<>();
            Map<Long, List<Usuario>> inscritosPorTutoria = new HashMap<>();
            for (Tutoria t : tutorias) {
                Long tid = t.getIdTutoria();
                asistentesCount.put(tid, tutoriaDAO.contarAsistentes(tid));
                inscritosPorTutoria.put(tid, asistenteDAO.listarUsuariosPorTutoriaId(tid));
            }
            req.setAttribute("asistentesCount", asistentesCount);
            req.setAttribute("inscritosPorTutoria", inscritosPorTutoria);
            req.setAttribute("contentPage", "Mantenimiento/tutorias.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            req.setAttribute("contentPage", "Mantenimiento/tutorias.jsp");
        }
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        TutoriaDAO tutoriaDAO = new TutoriaDAO();
        TutoriaAsistenteDAO asistenteDAO = new TutoriaAsistenteDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        String accion = req.getParameter("accion");
        try {
            if ("guardar".equals(accion)) {
                Tutoria tutoria = new Tutoria();
                tutoria.setTitulo(req.getParameter("titulo"));
                tutoria.setTema(req.getParameter("tema"));
                tutoria.setImagen(req.getParameter("imagen"));
                tutoria.setHorario(req.getParameter("horario"));
                Long usuarioId = Long.parseLong(req.getParameter("usuarioId"));
                Usuario usuario = usuarioDAO.buscar(usuarioId);
                tutoria.setCreadoPor(usuario);
                tutoriaDAO.insertar(tutoria);
            } else if ("actualizar".equals(accion)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Tutoria tutoria = tutoriaDAO.buscar(id);
                if (tutoria != null) {
                    tutoria.setTitulo(req.getParameter("titulo"));
                    tutoria.setTema(req.getParameter("tema"));
                    tutoria.setImagen(req.getParameter("imagen"));
                    tutoria.setHorario(req.getParameter("horario"));
                    Long usuarioId = Long.parseLong(req.getParameter("usuarioId"));
                    Usuario usuario = usuarioDAO.buscar(usuarioId);
                    tutoria.setCreadoPor(usuario);
                    tutoriaDAO.actualizar(tutoria);
                }
            } else if ("eliminar".equals(accion)) {
                Long id = Long.parseLong(req.getParameter("id"));
                tutoriaDAO.eliminar(id);
            } else if ("inscribirme".equals(accion)) {
                Long tutoriaId = Long.parseLong(req.getParameter("tutoriaId"));
                Long usuarioId = Long.parseLong(req.getParameter("usuarioId"));
                Tutoria tutoria = tutoriaDAO.buscar(tutoriaId);
                Usuario usuario = usuarioDAO.buscar(usuarioId);
                if (tutoria != null && usuario != null) {
                    TutoriaAsistente asistente = new TutoriaAsistente();
                    asistente.setTutoria(tutoria);
                    asistente.setUsuario(usuario);
                    asistenteDAO.insertar(asistente);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/tutoria");
    }
} 