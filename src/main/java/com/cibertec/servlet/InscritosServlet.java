package com.cibertec.servlet;

import com.cibertec.dao.TutoriaAsistenteDAO;
import com.cibertec.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class InscritosServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String tutoriaIdStr = request.getParameter("tutoriaId");
        try (PrintWriter out = response.getWriter()) {
            if (tutoriaIdStr == null) {
                out.print("[]");
                return;
            }
            Long tutoriaId;
            try {
                tutoriaId = Long.parseLong(tutoriaIdStr);
            } catch (NumberFormatException e) {
                out.print("[]");
                return;
            }
            TutoriaAsistenteDAO asistenteDAO = new TutoriaAsistenteDAO();
            List<Usuario> inscritos = asistenteDAO.listarUsuariosPorTutoriaId(tutoriaId);
            out.print("[");
            for (int i = 0; i < inscritos.size(); i++) {
                Usuario u = inscritos.get(i);
                out.print('"' + u.getNombre().replace("\"", "\\\"") + '"');
                if (i < inscritos.size() - 1) out.print(",");
            }
            out.print("]");
        } catch (Exception ex) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("[]");
        }
    }
} 