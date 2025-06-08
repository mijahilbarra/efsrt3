<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<div class="d-flex">
    <%@ include file="sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="container py-4">
            <h2>Explorar Tutorías</h2>
            <div class="row">
                <%
                    List tutorias = (List) request.getAttribute("tutorias");
                    Map asistentesCount = (Map) request.getAttribute("asistentesCount");
                    Map inscritosPorTutoria = (Map) request.getAttribute("inscritosPorTutoria"); // Map<Long, List<Usuario>>
                    if (tutorias != null) {
                        for (Object obj : tutorias) {
                            com.cibertec.model.Tutoria tutoria = (com.cibertec.model.Tutoria) obj;
                            Long tutoriaId = tutoria.getIdTutoria();
                            int inscritos = asistentesCount != null && asistentesCount.get(tutoriaId) != null ? ((Number)asistentesCount.get(tutoriaId)).intValue() : 0;
                %>
                <div class="col-md-4 mb-4">
                    <div class="card h-100">
                        <% if (tutoria.getImagen() != null && !tutoria.getImagen().isEmpty()) { %>
                            <img src="<%= tutoria.getImagen() %>" class="card-img-top" alt="Imagen de Tutoría" style="max-height:180px;object-fit:cover;">
                        <% } %>
                        <div class="card-body">
                            <h5 class="card-title"><%= tutoria.getTitulo() %></h5>
                            <p class="card-text mb-1"><strong>Tema:</strong> <%= tutoria.getTema() %></p>
                            <p class="card-text mb-1"><strong>Horario:</strong> <%= tutoria.getHorario() %></p>
                            <p class="card-text mb-1"><strong>Creador:</strong> <%= tutoria.getCreadoPor() != null ? tutoria.getCreadoPor().getNombre() : "" %></p>
                            <span class="badge bg-info">Inscritos: <%= inscritos %></span>
                        </div>
                        <div class="card-footer bg-white border-0">
                            <button class="btn btn-primary w-100 inscribirse-btn" 
                                data-bs-toggle="modal" 
                                data-bs-target="#inscribirseModal"
                                data-tutoria-id="<%= tutoriaId %>"
                                data-tutoria-titulo="<%= tutoria.getTitulo().replace("'", "&#39;").replace("\"", "&quot;") %>"
                            >
                                Inscribirse
                            </button>
                        </div>
                    </div>
                </div>
                <%      }
                    }
                %>
            </div>
        </div>
        <!-- Inscribirse Modal -->
        <div class="modal fade" id="inscribirseModal" tabindex="-1" aria-labelledby="inscribirseModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form method="post" action="<%= request.getContextPath() %>/explorar-tutorias">
                        <input type="hidden" name="accion" value="inscribirse" />
                        <input type="hidden" name="tutoriaId" id="modalTutoriaId" />
                        <div class="modal-header">
                            <h5 class="modal-title" id="inscribirseModalLabel">Inscribirse en Tutoría</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="usuarioId" class="form-label">Selecciona tu usuario</label>
                                <select class="form-select" id="usuarioId" name="usuarioId" required>
                                    <option value="">Selecciona un usuario</option>
                                    <%
                                        List usuarios = (List) request.getAttribute("usuarios");
                                        if (usuarios != null) {
                                            for (Object obj : usuarios) {
                                                com.cibertec.model.Usuario usuario = (com.cibertec.model.Usuario) obj;
                                    %>
                                    <option value="<%= usuario.getIdUsuario() %>"><%= usuario.getNombre() %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Inscritos en esta tutoría:</label>
                                <ul class="list-group" id="inscritosList">
                                    <!-- Will be filled by JS -->
                                </ul>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary">Inscribirse</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function showInscribirseModal(tutoriaId, tutoriaTitulo) {
    document.getElementById('modalTutoriaId').value = tutoriaId;
    document.getElementById('inscribirseModalLabel').textContent = 'Inscribirse en: ' + tutoriaTitulo;
    var inscritosList = document.getElementById('inscritosList');
    inscritosList.innerHTML = '';
    // Fetch inscritos via AJAX
    fetch('<%= request.getContextPath() %>/inscritos?tutoriaId=' + tutoriaId)
        .then(response => response.json())
        .then(data => {
            if (data.length > 0) {
                data.forEach(function(nombre) {
                    var li = document.createElement('li');
                    li.className = 'list-group-item';
                    li.textContent = nombre;
                    inscritosList.appendChild(li);
                });
            } else {
                var li = document.createElement('li');
                li.className = 'list-group-item text-muted';
                li.textContent = 'No hay inscritos aún.';
                inscritosList.appendChild(li);
            }
        })
        .catch(() => {
            var li = document.createElement('li');
            li.className = 'list-group-item text-danger';
            li.textContent = 'Error al cargar inscritos.';
            inscritosList.appendChild(li);
        });
}

document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.inscribirse-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var tutoriaId = this.getAttribute('data-tutoria-id');
            var tutoriaTitulo = this.getAttribute('data-tutoria-titulo');
            showInscribirseModal(tutoriaId, tutoriaTitulo);
        });
    });
});
</script> 