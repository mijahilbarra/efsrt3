package com.cibertec.servlet;

import com.cibertec.dao.TutoriaDAO;
import com.cibertec.dao.TutoriaAsistenteDAO;
import com.cibertec.dao.UsuarioDAO;
import com.cibertec.model.Tutoria;
import com.cibertec.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ExplorarTutoriasServlet extends HttpServlet {
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
            // For each tutoria, get count of asistentes and list of inscritos
            Map<Long, Long> asistentesCount = new HashMap<>();
            Map<Long, List<Usuario>> inscritosPorTutoria = new HashMap<>();
            for (Tutoria t : tutorias) {
                Long tid = t.getIdTutoria();
                asistentesCount.put(tid, tutoriaDAO.contarAsistentes(tid));
                inscritosPorTutoria.put(tid, asistenteDAO.listarUsuariosPorTutoriaId(tid));
            }
            req.setAttribute("asistentesCount", asistentesCount);
            req.setAttribute("inscritosPorTutoria", inscritosPorTutoria);
            req.setAttribute("contentPage", "explorar-tutorias.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");
        TutoriaDAO tutoriaDAO = new TutoriaDAO();
        TutoriaAsistenteDAO asistenteDAO = new TutoriaAsistenteDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        try {
            if ("inscribirse".equals(accion)) {
                Long tutoriaId = Long.parseLong(req.getParameter("tutoriaId"));
                Long usuarioId = Long.parseLong(req.getParameter("usuarioId"));
                com.cibertec.model.Tutoria tutoria = tutoriaDAO.buscar(tutoriaId);
                com.cibertec.model.Usuario usuario = usuarioDAO.buscar(usuarioId);
                if (tutoria != null && usuario != null) {
                    if (!asistenteDAO.existeAsistente(tutoriaId, usuarioId)) {
                        com.cibertec.model.TutoriaAsistente asistente = new com.cibertec.model.TutoriaAsistente();
                        asistente.setTutoria(tutoria);
                        asistente.setUsuario(usuario);
                        asistenteDAO.insertar(asistente);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/explorar-tutorias");
    }
} 