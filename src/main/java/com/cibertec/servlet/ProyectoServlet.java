package com.cibertec.servlet;

import com.cibertec.dao.ProyectoDAO;
import com.cibertec.dao.UsuarioDAO;
import com.cibertec.model.Proyecto;
import com.cibertec.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ProyectoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ProyectoDAO proyectoDAO = new ProyectoDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        try {
            List<Proyecto> proyectos = proyectoDAO.listar();
            List<Usuario> usuarios = usuarioDAO.listar();
            req.setAttribute("proyectos", proyectos);
            req.setAttribute("usuarios", usuarios);
            req.setAttribute("contentPage", "Mantenimiento/proyectos.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            req.setAttribute("contentPage", "Mantenimiento/proyectos.jsp");
        }
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ProyectoDAO proyectoDAO = new ProyectoDAO();
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        String accion = req.getParameter("accion");
        try {
            if ("guardar".equals(accion)) {
                Proyecto proyecto = new Proyecto();
                proyecto.setNombre(req.getParameter("nombre"));
                proyecto.setDescripcion(req.getParameter("descripcion"));
                Long usuarioId = Long.parseLong(req.getParameter("usuarioId"));
                Usuario usuario = usuarioDAO.buscar(usuarioId);
                proyecto.setUsuario(usuario);
                proyectoDAO.insertar(proyecto);
            } else if ("actualizar".equals(accion)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Proyecto proyecto = proyectoDAO.buscar(id);
                if (proyecto != null) {
                    proyecto.setNombre(req.getParameter("nombre"));
                    proyecto.setDescripcion(req.getParameter("descripcion"));
                    Long usuarioId = Long.parseLong(req.getParameter("usuarioId"));
                    Usuario usuario = usuarioDAO.buscar(usuarioId);
                    proyecto.setUsuario(usuario);
                    proyectoDAO.actualizar(proyecto);
                }
            } else if ("eliminar".equals(accion)) {
                Long id = Long.parseLong(req.getParameter("id"));
                proyectoDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/proyecto");
    }
} 