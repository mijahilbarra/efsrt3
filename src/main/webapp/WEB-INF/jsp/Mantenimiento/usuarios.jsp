<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="d-flex">
    <%@ include file="../sidebar.jsp" %>
    <div class="flex-grow-1">
        <div class="tab-content">
            <div class="tab-pane fade show active" id="usuarios" role="tabpanel">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Usuarios</h2>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#usuarioModal" id="addUsuarioBtn">Agregar Usuario</button>
                </div>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Email</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            java.util.List usuarios = (java.util.List) request.getAttribute("usuarios");
                            if (usuarios != null) {
                                for (Object obj : usuarios) {
                                    com.cibertec.model.Usuario usuario = (com.cibertec.model.Usuario) obj;
                        %>
                        <tr>
                            <td><%= usuario.getIdUsuario() %></td>
                            <td><%= usuario.getNombre() %></td>
                            <td><%= usuario.getEmail() %></td>
                            <td>
                                <button class="btn btn-sm btn-secondary edit-btn" 
                                        data-bs-toggle="modal" 
                                        data-bs-target="#usuarioModal"
                                        data-id="<%= usuario.getIdUsuario() %>"
                                        data-nombre="<%= usuario.getNombre() %>"
                                        data-email="<%= usuario.getEmail() %>">Editar</button>
                                <button class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-id="<%= usuario.getIdUsuario() %>" data-nombre="<%= usuario.getNombre() %>">Eliminar</button>
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

<!-- Add/Edit Usuario Modal -->
<div class="modal fade" id="usuarioModal" tabindex="-1" aria-labelledby="usuarioModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" id="usuarioForm">
                <input type="hidden" name="accion" id="usuarioAction" value="guardar" />
                <input type="hidden" name="id" id="usuarioId" />
                <div class="modal-header">
                    <h5 class="modal-title" id="usuarioModalLabel">Agregar Usuario</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="nombre" class="form-label">Nombre</label>
                        <input type="text" class="form-control" id="nombre" name="nombre" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Contraseña</label>
                        <input type="password" class="form-control" id="password" name="password" required>
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
                <input type="hidden" name="id" id="deleteUsuarioId" />
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    ¿Está seguro que desea eliminar al usuario <span id="deleteUsuarioNombre"></span>?
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
// Pass usuario id and name to delete modal
var deleteModal = document.getElementById('deleteModal');
deleteModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var id = button.getAttribute('data-id');
    var nombre = button.getAttribute('data-nombre');
    document.getElementById('deleteUsuarioId').value = id;
    document.getElementById('deleteUsuarioNombre').textContent = nombre;
});

// Edit functionality
var usuarioModal = document.getElementById('usuarioModal');
usuarioModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget;
    var modalTitle = document.getElementById('usuarioModalLabel');
    var actionInput = document.getElementById('usuarioAction');
    var idInput = document.getElementById('usuarioId');
    var nombreInput = document.getElementById('nombre');
    var emailInput = document.getElementById('email');
    var passwordInput = document.getElementById('password');
    if (button && button.classList.contains('edit-btn')) {
        modalTitle.textContent = 'Editar Usuario';
        actionInput.value = 'actualizar';
        idInput.value = button.getAttribute('data-id');
        nombreInput.value = button.getAttribute('data-nombre');
        emailInput.value = button.getAttribute('data-email');
        passwordInput.value = '';
    } else {
        modalTitle.textContent = 'Agregar Usuario';
        actionInput.value = 'guardar';
        idInput.value = '';
        nombreInput.value = '';
        emailInput.value = '';
        passwordInput.value = '';
    }
});
usuarioModal.addEventListener('hidden.bs.modal', function () {
    document.getElementById('usuarioForm').reset();
});
</script> 