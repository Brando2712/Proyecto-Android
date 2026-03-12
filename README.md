## Proyecto App Notas

Aplicación móvil de notas (prototipo) con arquitectura MVVM y persistencia local.

### Implementado
- Entidad `Note` en `lib/models/note.dart` con: `id`, `title`, `content`, `createdAt`, `updatedAt`, `isPinned`.
- Persistencia local con SQLite usando `sqflite` y helper en `lib/data/note_db.dart`.
- Repositorio `lib/repositories/note_repository.dart` que expone un `Stream<List<Note>>` y operaciones CRUD.
- `NoteViewModel` en `lib/viewmodels/note_view_model.dart` (extiende `ChangeNotifier`) que suscribe al stream del repositorio.
- UI:
	- `lib/screens/note_list_screen.dart`: lista de notas, FAB para nueva nota, orden por `isPinned` y `updatedAt`, swipe para eliminar con diálogo de confirmación.
	- `lib/screens/note_edit_screen.dart`: crear/editar nota (título y contenido), guardado y retorno a la lista.
- Entrada de la app en `lib/main.dart`: inicializa el repositorio/DB y provee `NoteViewModel` usando `provider`.
- Dependencias añadidas en `pubspec.yaml`: `sqflite`, `path`, `provider`.

### Comportamiento relevante
- La lista se actualiza automáticamente después de operaciones CRUD mediante streams y `notifyListeners()`; la UI no requiere recarga manual.
- Los datos persisten entre cierres de la app (almacenamiento en `notes.db`).
- Confirmación de eliminación implementada para evitar borrados accidentales.
- Inicialización de la BD: se realiza en `main.dart` (arranque síncrono antes de `runApp()`); `NoteViewModel` no repite la inicialización.

### Cómo ejecutar
1. Instalar dependencias:

```bash
flutter pub get
```

2. Ejecutar la app:

```bash
flutter run
```

### Próximos pasos recomendados
- Añadir inyección de dependencias (ej. `get_it`) y separar interfaces para testing.
- Añadir migraciones de DB y manejo de errores en inicialización.
- Implementar pruebas unitarias y de widget.
- Mejoras de UX: pantalla splash / indicador de carga, búsqueda, etiquetas, ordenación avanzada.

Si quieres, puedo:
- Añadir una pantalla splash que espere la inicialización de la BD.
- Implementar DI con `get_it` y adaptar `NoteViewModel` para recibir el repositorio por constructor.
- Preparar un commit con mensajes y estructura de ramas recomendada.

