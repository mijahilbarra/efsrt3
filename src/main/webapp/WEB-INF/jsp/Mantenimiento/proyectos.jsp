<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="proyectos" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Proyectos</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#proyectoModal" id="addProyectoBtn">Agregar Proyecto</button>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Descripción</th>
                            <th>Usuario</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List proyectos = (java.util.List) request.getAttribute("proyectos");
                            if (proyectos != null) {
                                for (Object obj : proyectos) {
                                    com.cibertec.model.Proyecto proyecto = (com.cibertec.model.Proyecto) obj;
                        %>
                        <tr>
                            <td><%= proyecto.getIdProyecto() %></td>
                            <td><%= proyecto.getNombre() %></td>
                            <td><%= proyecto.getDescripcion() %></td>
                            <td><%= proyecto.getUsuario() != null ? proyecto.getUsuario().getNombre() : "" %></td>
                            <td>
                                <button class="btn btn-sm btn-secondary edit-btn" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#proyectoModal"
                                        data-id="<%= proyecto.getIdProyecto() %>"
                                        data-nombre="<%= proyecto.getNombre() %>"
                                        data-descripcion="<%= proyecto.getDescripcion() %>"
                                        data-usuarioid="<%= proyecto.getUsuario() != null ? proyecto.getUsuario().getIdUsuario() : "" %>">Editar</button>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="<%= proyecto.getIdProyecto() %>" data-nombre="<%= proyecto.getNombre() %>" >Eliminar</button>
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

<!-- Add/Edit Proyecto Modal -->
<div class="modal fade" id="proyectoModal" tabindex="-1" aria-labelledby="proyectoModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" id="proyectoForm">
                <input type="hidden" name="accion" id="proyectoAction" value="guardar" />
                <input type="hidden" name="id" id="proyectoId" />
                <div class="modal-header">
                    <h5 class="modal-title" id="proyectoModalLabel">Agregar Proyecto</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="nombre" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="nombre" name="nombre" required>
                    </div>
                    <div class="mb-3">
                        <label for="descripcion" class="form-label">Descripción</label>
                        <input type="text" class="form-control" id="descripcion" name="descripcion">
                    </div>
                    <div class="mb-3">
                        <label for="usuarioId" class="form-label">Usuario</label>
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
                <input type="hidden" name="id" id="deleteProyectoId" />
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    ¿Está seguro que desea eliminar el proyecto <span id="deleteProyectoNombre"></span>?
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
// Pass proyecto id and name to delete modal
var deleteModal = document.getElementById('deleteModal');
deleteModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var id = button.getAttribute('data-id');
    var nombre = button.getAttribute('data-nombre');
    document.getElementById('deleteProyectoId').value = id;
    document.getElementById('deleteProyectoNombre').textContent = nombre;
});

// Edit functionality
var proyectoModal = document.getElementById('proyectoModal');
proyectoModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var modalTitle = document.getElementById('proyectoModalLabel');
    var actionInput = document.getElementById('proyectoAction');
    var idInput = document.getElementById('proyectoId');
    var nombreInput = document.getElementById('nombre');
    var descripcionInput = document.getElementById('descripcion');
    var usuarioIdInput = document.getElementById('usuarioId');
    if (button && button.classList.contains('edit-btn')) {
        modalTitle.textContent = 'Editar Proyecto';
        actionInput.value = 'actualizar';
        idInput.value = button.getAttribute('data-id');
        nombreInput.value = button.getAttribute('data-nombre');
        descripcionInput.value = button.getAttribute('data-descripcion');
        usuarioIdInput.value = button.getAttribute('data-usuarioid');
    } else {
        modalTitle.textContent = 'Agregar Proyecto';
        actionInput.value = 'guardar';
        idInput.value = '';
        nombreInput.value = '';
        descripcionInput.value = '';
        usuarioIdInput.value = '';
    }
});
proyectoModal.addEventListener('hidden.bs.modal', function () {
    document.getElementById('proyectoForm').reset();
});
</script> 