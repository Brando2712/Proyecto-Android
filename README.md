# 📱 App Notas (Flutter)

Aplicación móvil de notas desarrollada con **Flutter** utilizando arquitectura **MVVM** y persistencia local con **SQLite**.

El objetivo del proyecto es implementar una aplicación sencilla de gestión de notas que permita crear, editar, eliminar, buscar y destacar notas importantes, manteniendo los datos almacenados localmente en el dispositivo.

---

# 🚀 Tecnologías utilizadas

* Flutter
* Dart
* SQLite (sqflite)
* Provider (gestión de estado)
* Arquitectura MVVM

Dependencias principales definidas en `pubspec.yaml`:

* `sqflite`
* `path`
* `provider`

---

# ✅ Requisitos mínimos para compilar

## Entorno base

* **Flutter SDK:** `3.41.4` (canal stable)
* **Dart SDK:** `3.11.1`
* **Java (JDK):** `17` (requerido por el proyecto Android)
* **Gradle Wrapper:** `8.14`
* **Android Gradle Plugin (AGP):** `8.11.1`
* **Kotlin Android Plugin:** `2.2.20`

## Android (app)

En este proyecto, los valores Android se heredan desde Flutter en `android/app/build.gradle.kts`:

* `minSdk = flutter.minSdkVersion`
* `targetSdk = flutter.targetSdkVersion`
* `compileSdk = flutter.compileSdkVersion`

Esto significa que la versión exacta depende del Flutter SDK instalado.

Como referencia, en plantillas actuales de Flutter el **mínimo soportado suele ser Android 5.0 (API 21)**, pero debes validar en tu entorno con:

```bash
flutter doctor -v
```

## Herramientas Android recomendadas

* Android Studio (última estable)
* Android SDK Platform + Build-Tools para el `compileSdk` resuelto por Flutter
* Dispositivo físico con depuración USB o emulador Android

---

# 🏗 Arquitectura del proyecto

El proyecto sigue el patrón **MVVM (Model - View - ViewModel)** para separar responsabilidades.

```
lib/
│
├── models/
│   └── note.dart
│
├── data/
│   └── note_db.dart
│
├── repositories/
│   └── note_repository.dart
│
├── viewmodels/
│   └── note_view_model.dart
│
├── screens/
│   ├── note_list_screen.dart
│   └── note_edit_screen.dart
│
├── widgets/
│   └── note_card.dart
│
└── main.dart
```

### Model

Define la estructura de datos de las notas.

### Repository

Encapsula el acceso a datos y expone métodos CRUD.

### ViewModel

Gestiona el estado de la aplicación y comunica la lógica entre la UI y el repositorio.

### View

Pantallas y widgets que presentan la información al usuario.

---

# 📦 Funcionalidades implementadas

### Gestión de notas

* Crear notas
* Editar notas
* Eliminar notas
* Persistencia local con SQLite

### Organización

* Marcar notas como favoritas (`isPinned`)
* Orden automático por favoritas y fecha de actualización

### Búsqueda

* Búsqueda en tiempo real por título desde el `AppBar`

### Interfaz

* Tarjetas personalizadas para mostrar notas
* Animación al presionar tarjetas
* Icono de favorito
* Confirmación antes de eliminar

### Validaciones

* El título de la nota no puede quedar vacío
* Se muestra un `SnackBar` si la validación falla

---

# 💾 Persistencia de datos

Los datos se almacenan en una base de datos local SQLite:

```
notes.db
```

Esto permite que las notas **persistan incluso después de cerrar la aplicación**.

---

# 🎨 Diseño visual

Se aplicó una paleta de colores personalizada definida en `main.dart`:

* Space Indigo
* Blue Slate
* Ash Grey
* Dark Khaki
* Black Forest

Además se realizaron ajustes tipográficos para mejorar la legibilidad de la aplicación.

---

# ⚙️ Cómo ejecutar el proyecto

### 1️⃣ Clonar el repositorio

```
git clone <url-del-repositorio>
cd app_notas
```

### 2️⃣ Instalar dependencias

```
flutter pub get
```

### 3️⃣ Ejecutar la aplicación

Con un dispositivo conectado o emulador activo:

```
flutter run
```

Hay que tener en cuenta tambien que al conectar un dispositivo hay que identificar su id, para eso usamos el comando:

```
flutter devices
```

y con el id de nuestro dispositivo usamos el siguiente comando para ejecutarlo en dicho dispositivo:

```
flutter run -d <id>
```

---

# 📦 Generar APK de la aplicación

Para generar el APK de distribución ejecutar:

```
flutter build apk --release
```

El archivo se generará en:

```
build/app/outputs/flutter-apk/app-release.apk
```

Para la entrega del proyecto el APK se encuentra en:

```
release/app-release.apk
```

---

# 📸 Screenshots

Agregar aquí capturas de la aplicación funcionando.

Ejemplo:

```
/screenshots/home.png
/screenshots/edit_note.png
```

---

# 🧠 Decisiones de diseño

* Se utilizó **MVVM** para mantener una separación clara entre la lógica de negocio y la interfaz de usuario.
* Se empleó **Provider** para la gestión de estado por ser una solución simple y ampliamente utilizada en Flutter.
* La persistencia se implementó con **SQLite** para permitir almacenamiento local sin necesidad de conexión a internet.
* Se utilizó un **Stream<List<Note>>** en el repositorio para que la interfaz se actualice automáticamente tras operaciones CRUD.
* La base de datos se inicializa de forma **asíncrona** para evitar bloquear el inicio de la aplicación.

---

# 📌 Mejoras futuras

* Sincronización en la nube
* Etiquetas o categorías para notas
* Modo oscuro
* Recordatorios o notificaciones

---

# 👨‍💻 Autor Brando Andrade

Proyecto desarrollado como práctica académica.
