<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="tutorias" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Tutorías</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#tutoriaModal" id="addTutoriaBtn">Agregar Tutoría</button>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Título</th>
                            <th>Tema</th>
                            <th>Imagen</th>
                            <th>Horario</th>
                            <th>Creador</th>
                            <th>Asistentes</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List tutorias = (java.util.List) request.getAttribute("tutorias");
                            java.util.Map asistentesCount = (java.util.Map) request.getAttribute("asistentesCount");
                            Long currentUserId = (Long) request.getAttribute("currentUserId");
                            if (tutorias != null) {
                                for (Object obj : tutorias) {
                                    com.cibertec.model.Tutoria tutoria = (com.cibertec.model.Tutoria) obj;
                        %>
                        <tr>
                            <td><%= tutoria.getIdTutoria() %></td>
                            <td><%= tutoria.getTitulo() %></td>
                            <td><%= tutoria.getTema() %></td>
                            <td>
                                <% if (tutoria.getImagen() != null && !tutoria.getImagen().isEmpty()) { %>
                                    <img src="<%= tutoria.getImagen() %>" alt="Imagen" style="max-width:60px;max-height:60px;">
                                <% } %>
                            </td>
                            <td><%= tutoria.getHorario() %></td>
                            <td><%= tutoria.getCreadoPor() != null ? tutoria.getCreadoPor().getNombre() : "" %></td>
                            <td><%= asistentesCount != null ? asistentesCount.get(tutoria.getIdTutoria()) : 0 %></td>
                            <td>
                                <button class="btn btn-sm btn-secondary edit-btn" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#tutoriaModal"
                                        data-id="<%= tutoria.getIdTutoria() %>"
                                        data-titulo="<%= tutoria.getTitulo() %>"
                                        data-tema="<%= tutoria.getTema() %>"
                                        data-imagen="<%= tutoria.getImagen() %>"
                                        data-horario="<%= tutoria.getHorario() %>"
                                        data-usuarioid="<%= tutoria.getCreadoPor() != null ? tutoria.getCreadoPor().getIdUsuario() : "" %>">Editar</button>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="<%= tutoria.getIdTutoria() %>" data-titulo="<%= tutoria.getTitulo() %>">Eliminar</button>
                                <% if (currentUserId != null && tutoria.getCreadoPor() != null && !currentUserId.equals(tutoria.getCreadoPor().getIdUsuario())) { %>
                                    <form method="post" action="<%= request.getContextPath() %>/tutoria" style="display:inline;">
                                        <input type="hidden" name="accion" value="inscribirme" />
                                        <input type="hidden" name="tutoriaId" value="<%= tutoria.getIdTutoria() %>" />
                                        <input type="hidden" name="usuarioId" value="<%= currentUserId %>" />
                                        <button type="submit" class="btn btn-sm btn-success">Inscribirme</button>
                                    </form>
                                <% } %>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Add/Edit Tutoria Modal -->
<div class="modal fade" id="tutoriaModal" tabindex="-1" aria-labelledby="tutoriaModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" id="tutoriaForm">
                <input type="hidden" name="accion" id="tutoriaAction" value="guardar" />
                <input type="hidden" name="id" id="tutoriaId" />
                <div class="modal-header">
                    <h5 class="modal-title" id="tutoriaModalLabel">Agregar Tutoría</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="titulo" class="form-label">Título</label>
                        <input type="text" class="form-control" id="titulo" name="titulo" required>
                    </div>
                    <div class="mb-3">
                        <label for="tema" class="form-label">Tema</label>
                        <input type="text" class="form-control" id="tema" name="tema" required>
                    </div>
                    <div class="mb-3">
                        <label for="imagen" class="form-label">Imagen (URL)</label>
                        <input type="text" class="form-control" id="imagen" name="imagen">
                    </div>
                    <div class="mb-3">
                        <label for="horario" class="form-label">Horario</label>
                        <input type="text" class="form-control" id="horario" name="horario" required>
                    </div>
                    <div class="mb-3">
                        <label for="usuarioId" class="form-label">Creador</label>
                        <select class="form-select" id="usuarioId" name="usuarioId" required>
                            <option value="">Seleccione un usuario</option>
                            <%
                                java.util.List usuarios = (java.util.List) request.getAttribute("usuarios");
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
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post">
                <input type="hidden" name="accion" value="eliminar" />
                <input type="hidden" name="id" id="deleteTutoriaId" />
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    ¿Está seguro que desea eliminar la tutoría <span id="deleteTutoriaTitulo"></span>?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-danger">Eliminar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
// Pass tutoria id and titulo to delete modal
var deleteModal = document.getElementById('deleteModal');
deleteModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var id = button.getAttribute('data-id');
    var titulo = button.getAttribute('data-titulo');
    document.getElementById('deleteTutoriaId').value = id;
    document.getElementById('deleteTutoriaTitulo').textContent = titulo;
});

// Edit functionality
var tutoriaModal = document.getElementById('tutoriaModal');
tutoriaModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var modalTitle = document.getElementById('tutoriaModalLabel');
    var actionInput = document.getElementById('tutoriaAction');
    var idInput = document.getElementById('tutoriaId');
    var tituloInput = document.getElementById('titulo');
    var temaInput = document.getElementById('tema');
    var imagenInput = document.getElementById('imagen');
    var horarioInput = document.getElementById('horario');
    var usuarioIdInput = document.getElementById('usuarioId');
    if (button && button.classList.contains('edit-btn')) {
        modalTitle.textContent = 'Editar Tutoría';
        actionInput.value = 'actualizar';
        idInput.value = button.getAttribute('data-id');
        tituloInput.value = button.getAttribute('data-titulo');
        temaInput.value = button.getAttribute('data-tema');
        imagenInput.value = button.getAttribute('data-imagen');
        horarioInput.value = button.getAttribute('data-horario');
        usuarioIdInput.value = button.getAttribute('data-usuarioid');
    } else {
        modalTitle.textContent = 'Agregar Tutoría';
        actionInput.value = 'guardar';
        idInput.value = '';
        tituloInput.value = '';
        temaInput.value = '';
        imagenInput.value = '';
        horarioInput.value = '';
        usuarioIdInput.value = '';
    }
});
tutoriaModal.addEventListener('hidden.bs.modal', function () {
    document.getElementById('tutoriaForm').reset();
});
</script> 