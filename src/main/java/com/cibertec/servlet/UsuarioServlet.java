package com.cibertec.servlet;

import com.cibertec.dao.UsuarioDAO;
import com.cibertec.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class UsuarioServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        try {
            List<Usuario> usuarios = usuarioDAO.listar();
            req.setAttribute("usuarios", usuarios);
            req.setAttribute("contentPage", "Mantenimiento/usuarios.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            req.setAttribute("contentPage", "Mantenimiento/usuarios.jsp");
        }
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        String accion = req.getParameter("accion");
        try {
            if ("guardar".equals(accion)) {
                Usuario usuario = new Usuario();
                usuario.setNombre(req.getParameter("nombre"));
                usuario.setEmail(req.getParameter("email"));
                usuario.setPassword(req.getParameter("password"));
                usuarioDAO.insertar(usuario);
            } else if ("actualizar".equals(accion)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Usuario usuario = usuarioDAO.buscar(id);
                if (usuario != null) {
                    usuario.setNombre(req.getParameter("nombre"));
                    usuario.setEmail(req.getParameter("email"));
                    usuario.setPassword(req.getParameter("password"));
                    usuarioDAO.actualizar(usuario);
                }
            } else if ("eliminar".equals(accion)) {
                Long id = Long.parseLong(req.getParameter("id"));
                usuarioDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/usuario");
    }
} 