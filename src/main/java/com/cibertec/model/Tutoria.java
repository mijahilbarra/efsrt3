package com.cibertec.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import java.util.List;

@Entity
@Table(name = "tutorias")
public class Tutoria {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_tutoria")
    private Long idTutoria;

    @NotNull
    @Column(name = "titulo", length = 100, nullable = false)
    private String titulo;

    @NotNull
    @Column(name = "tema", length = 100, nullable = false)
    private String tema;

    @Column(name = "imagen", length = 255)
    private String imagen;

    @NotNull
    @Column(name = "horario", length = 100, nullable = false)
    private String horario;

    @ManyToOne
    @JoinColumn(name = "creado_por", nullable = false)
    private Usuario creadoPor;

    @OneToMany(mappedBy = "tutoria", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TutoriaAsistente> asistentes;

    // Getters and Setters
    public Long getIdTutoria() { return idTutoria; }
    public void setIdTutoria(Long idTutoria) { this.idTutoria = idTutoria; }
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    public String getTema() { return tema; }
    public void setTema(String tema) { this.tema = tema; }
    public String getImagen() { return imagen; }
    public void setImagen(String imagen) { this.imagen = imagen; }
    public String getHorario() { return horario; }
    public void setHorario(String horario) { this.horario = horario; }
    public Usuario getCreadoPor() { return creadoPor; }
    public void setCreadoPor(Usuario creadoPor) { this.creadoPor = creadoPor; }
    public List<TutoriaAsistente> getAsistentes() { return asistentes; }
    public void setAsistentes(List<TutoriaAsistente> asistentes) { this.asistentes = asistentes; }
} 