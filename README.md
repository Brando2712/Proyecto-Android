## Proyecto App Notas

Aplicación móvil de notas (prototipo) con arquitectura MVVM y persistencia local.

### Implementado
- Entidad `Note` en `lib/models/note.dart` con: `id`, `title`, `content`, `createdAt`, `updatedAt`, `isPinned`.
- Persistencia local con SQLite usando `sqflite` y helper en `lib/data/note_db.dart`.
- Repositorio `lib/repositories/note_repository.dart` que expone un `Stream<List<Note>>` y operaciones CRUD.
- `NoteViewModel` en `lib/viewmodels/note_view_model.dart` (extiende `ChangeNotifier`) que suscribe al stream del repositorio y maneja el estado de carga.
- UI:
	- `lib/screens/note_list_screen.dart`: lista de notas con búsqueda por título, FAB para nueva nota, orden por `isPinned` y `updatedAt`, swipe para eliminar con diálogo de confirmación.
	- `lib/screens/note_edit_screen.dart`: crear/editar nota (título y contenido) con validación (el título no puede quedar vacío).
	- `lib/widgets/note_card.dart`: componente de tarjeta personalizado con truncado de descripción, timestamp, icono de favorito y animación al presionar.
- Visual: paleta de colores aplicada en `lib/main.dart` (Space Indigo, Blue Slate, Ash Grey, Dark Khaki, Black Forest) y ajustes tipográficos.
- Funcionalidades adicionales: búsqueda en AppBar, marcar/desmarcar como favorito (campo `isPinned`) con destacado visual, confirmación al eliminar, validación de título, carga asíncrona de la BD para reducir tiempo de arranque.
- Dependencias añadidas en `pubspec.yaml`: `sqflite`, `path`, `provider`.

### Comportamiento relevante
- La lista se actualiza automáticamente después de operaciones CRUD mediante streams y `notifyListeners()`; la UI no requiere recarga manual.
- Los datos persisten entre cierres de la app (almacenamiento en `notes.db`).
- Confirmación de eliminación implementada para evitar borrados accidentales.
- Validación de título: al crear/editar, el título no puede quedar vacío; se muestra un `SnackBar` si no se cumple.
- Búsqueda: campo en el `AppBar` para filtrar notas por título en tiempo real.
- Fav/Pin: las notas se pueden marcar como favoritas (`isPinned`); las tarjetas cambian sutilmente de color y el icono de estrella indica el estado.
- Inicialización de la BD: ahora se realiza de forma asíncrona en el `ViewModel` para no bloquear el arranque; se muestra un indicador de carga mientras se inicializa.

### Cómo ejecutar
1. Instalar dependencias:

```bash
flutter pub get
```

2. Ejecutar la app (dispositivo conectado o emulador):

```bash
flutter run
```

### Próximos pasos recomendados
- Añadir inyección de dependencias (ej. `get_it`) y separar interfaces para testing.
- Añadir migraciones de DB y manejo de errores en inicialización.
- Implementar pruebas unitarias y de widget (ej. para `NoteCard`, búsqueda y validación).
- Medir tiempos de arranque y evaluar mover consultas iniciales a un isolate si la carga inicial es pesada.
- Mejoras de UX adicionales: pantalla splash, animaciones más elaboradas, búsqueda avanzada y etiquetas.

Si quieres, puedo:
- Añadir una pantalla splash que espere la inicialización de la BD.
- Implementar DI con `get_it` y adaptar `NoteViewModel` para recibir el repositorio por constructor.
- Añadir animación al icono de favorito y preparar tests de widget.
- Preparar un commit con mensaje y rama recomendada.

