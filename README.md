# Proyecto de la aplicación de Android

**Estudiante:** José Daniel Arroyave Buriticá

## Descripción del proyecto

El proyecto es una aplicación móvil de monitoreo para la infraestructura de agentes de seguridad de Wazuh, siendo un cliente ligero estricto que sirve como sistema de chequeo centralizado, limpio y resumido de la salud general del SIEM y de sus alertas más importantes, mientras que implementa módulos de vista detallada de cada agente y Respuesta Activa a un botón.

## Exposición del problema

El problema de la simpleza en la ciberseguridad es más una característica estructural que un problema a resolver, porque la misma idiosincrasia de este campo es de complejidad; sin embargo, existen todavía nichos sin explotar de manera masiva que requieren de nuevas propuestas que hagan de esta complejidad algo mucho más llevadero y escalable. De forma más específica, la Seguridad Defensiva o Blue Teaming siempre está en una necesidad constante de evolución en sus soluciones de seguridad tipo SIEM, IDS/IPS y SOAR, pero un aspecto tan o, en ocasiones, más importante que las aplicaciones de defensa en sí mismas, es su integración eficiente en las operaciones normales de la empresa, donde estas deben ser modulares y fácilmente configurables y modificables. En esta misma línea, podemos concluir que el pico de la conveniencia tecnológica son los celulares y su capacidad actual de ejecutar tareas altamente complejas al vuelo y con conexiones sin límite en su alcance, por lo que son el medio ideal para desarrollar una solución con las características descritas (sencillez y escalabilidad, fácilmente configurables). Así, la idea que combina las necesidades de la Seguridad Defensiva, con la modularidad exigida en una empresa y la conveniencia del medio celular es la de un Dashboard SIEM multiplataforma, específicamente para la solución de seguridad Wazuh, la cual es Open Source y no tiene cliente móvil oficial.

El proyecto no intenta competir con el Dashboard Web oficial de Wazuh, sino que pretende servir como una aplicación ligera y rápida de evaluaciones críticas convenientes sin necesidad de un PC o portátil, con el valor agregado de ser más compacta y menos verbosa para triages y respuestas iniciales en caso de amenazas.

De esta forma, la aplicación resuelve el problema del set-up incómodo y que llega a ser engorroso de sacar una computadora en un lugar público o de acceder al Dashboard Web de Wazuh mediante el celular, el cual es una página sobrecargada de texto y funcionalidades que están adecuadas para investigaciones profundas, triage detallado e informes minuciosos en un viewport de tipo computador.

## Plataforma y Arquitectura

-   **Tecnología:** La aplicación será multiplataforma y será desarrollada con Flutter y el lenguaje Dart.
-   **Arquitectura:** Implementación estricta del patrón **MVVM (Model-View-ViewModel)** junto con el **Patrón Repositorio** para separar la capa de red, la lógica de negocio y la interfaz de usuario.
-   **Estado e Inyección:** Gestión de estado reactiva y Dependency Injection centralizada mediante el paquete `provider` (`MultiProvider`, `ChangeNotifierProvider`).
-   **Metodología:** Desarrollo estructurado mediante *Vertical Slicing* (rebanadas verticales por funcionalidad completa).

## Interfaz de usuario e interfaz de administrador

La aplicación funcionará bajo una misma interfaz de control con todas las funcionalidades activas, en cuanto esta aplicación será usada exclusivamente por los líderes del SOC encargados de la seguridad defensiva de la empresa.

## Funcionalidad

Como la aplicación funciona bajo la arquitectura de un cliente estricto, no requiere un backend intermedio. En su lugar, la aplicación interactúa con la API RESTful de Wazuh alojada en el servidor Manager de Wazuh mediante autenticación JWT. Los componentes principales de esta aplicación son:

-   **Configuración y Autenticación:** Formulario de conexión al servidor Manager de Wazuh con almacenamiento local cifrado de credenciales. La conexión se recomendará al usuario realizarla por medio de una VPN a la empresa o a la red en donde se encuentra alojado el servidor para no exponer la API al internet público. Se aborda la problemática de los certificados autofirmados (CWE-295) mediante un interruptor de "Modo Laboratorio" activable por el usuario, el cual configura de forma segura un cliente `IOClient` dinámico. Después de la primera conexión e inicio de sesión exitoso, la aplicación permitirá configurar bloqueo por datos biométricos para abrirse de nuevo en lugar de ingresar de nuevo las credenciales.
-   **Dashboard General de Estado:** Resumen inmediato del sistema. Contador global de agentes (junto a un gráfico circular representando el estado de los endpoints) y una tarjeta de resumen con la cantidad total de alertas altas (10-11) y críticas (12 a 16) detectadas en las últimas 24 horas en la infraestructura.
-   **Feed de emergencias:** Lista con campo de búsqueda más detallada enfocada estrictamente en amenazas reales, ignorando el ruido de los primeros 9 niveles de alertas. El desglose por fila contendrá: Botón para ver la descripción entera con todos los campos de la alerta, timestamp, nombre de agente (con hipervínculo que lo llevará a la sección de Respuesta Activa), descripción de la regla gatillada, nivel de la alerta e ID de la regla.
-   **Sección de Agentes con más Alertas:** Lista simple con nombre de agente y cantidad de alertas de nivel +10 ocurridas en las últimas 24 horas.
-   **Lista de agentes:** Lista scrolleable y con campo de búsqueda donde cada fila representa un agente. Contiene las siguientes columnas: Nombre del host, dirección IP, OS (ícono) y círculo de color representando el estado (verde activo, rojo desconectado y gris nunca conectado). Al hacer click al fila: menú desplegable con datos de última hora de conexión (keep-alive), versión del agente de Wazuh, botón de silenciar alertas y botón de “Ir a Respuesta Activa”.
-   **Respuesta Activa:** Pantalla emergente donde muestra varias opciones de Respuesta Activa disponibles para el agente seleccionado (e.g. “Aislar Endpoint”).
-   **Notificaciones de Push Simples:** Servicio en segundo plano que revise la API cada cierto tiempo para enviar una notificación push al celular (e.g. “Agente Windows Server AD DC desconectado”).

## Funcionalidades Faltantes (Roadmap)

Aunque las bases arquitectónicas y los módulos principales de autenticación y estado general están operativos, el proyecto requiere el desarrollo de las siguientes funcionalidades para cumplir con el alcance total propuesto:

-   **Integración Biométrica:** Implementar validación por huella dactilar o reconocimiento facial para reabrir la aplicación de forma segura sin reingresar credenciales.
-   **Módulo Feed de Emergencias:** Construir la rebanada vertical completa (Modelo, Repositorio, ViewModel y Vista) para consultar la API y mostrar un historial filtrado y detallado de alertas con niveles entre 10 y 16.
-   **Módulo Lista de Agentes (Detallada):** Desarrollar la vista scrolleable con campo de búsqueda y menús desplegables para consultar keep-alives y versiones del software de los agentes.
-   **Módulo de Respuesta Activa:** Configurar la lógica de red y la interfaz emergente (modal) que permita gatillar comandos predefinidos (como aislar un endpoint) directamente desde la aplicación móvil hacia la API del Manager.
-   **Notificaciones Push (Background Services):** Implementar un *worker* en segundo plano que sondee la API de forma periódica y emita alertas nativas del sistema operativo móvil cuando detecte desconexiones de agentes críticos.
-   **Gráficos Circulares Dinámicos:** Integrar el paquete `fl_chart` para renderizar visualmente las métricas de endpoints (activos, inactivos, nunca conectados) en el Dashboard.

## Registro de Cambios (Changelog)

### Cambios Pasados

-   Definición del alcance del proyecto y planteamiento del problema.
-   Diseño de esquemas y wireframes iniciales de la interfaz de usuario.
-   Elección de Flutter y Dart como ecosistema de desarrollo principal.
-   Configuración inicial del repositorio de control de versiones en GitHub.
-   **Arquitectura Base:** Instauración del patrón MVVM y el patrón Repositorio para la separación de responsabilidades.
-   **Autenticación (Capa de Servicios):** Creación de `WazuhAuthService` para gestionar peticiones HTTP asíncronas a la API RESTful de Wazuh mediante Basic Auth (Base64) para la obtención y decodificación del token JWT.
-   **Seguridad:** Integración de un `IOClient` dinámico para permitir interacciones con servidores mediante certificados autofirmados únicamente cuando el usuario activa explícitamente la configuración, documentando el manejo de vulnerabilidades CWE-295.
-   **Orquestación y Estado (Data & Lógica):** Construcción del `AuthRepository` para abstraer la fuente de datos, y del `AuthViewModel` para la gestión de estados reactivos (`isLoading`, `errorMessage`) a través de `ChangeNotifier`.
-   **Interfaz de Usuario (Vista):** Desarrollo de `LoginView` conectando el estado visual a la lógica de negocio mediante el paquete `provider` y mitigación de fugas de memoria en los controladores de entrada sobrescribiendo el método `dispose()`.
-   **Ensamblaje del Sistema:** Configuración del punto de entrada `main.dart` utilizando `MultiProvider` para asegurar la correcta inyección de dependencias en el árbol de la aplicación.

### Cambios Actuales

-   **Almacenamiento Persistente y Seguro:** Implementación del paquete `flutter_secure_storage` en la capa de datos para guardar el Token JWT, IP, usuario y contraseña de forma cifrada en el hardware del dispositivo (Keystore/Keychain), estableciendo al Repositorio como la Fuente Única de Verdad (SSOT).
-   **Interceptor y Reautenticación Silenciosa:** Creación de un *Wrapper* centralizado (`makeAuthenticatedRequest`) que inyecta automáticamente el token en cada petición. Si el token expira y la API devuelve un error 401, el interceptor atrapa el error de forma transparente, extrae las credenciales cifradas, renegocia un token nuevo en segundo plano y reintenta la petición original sin afectar la experiencia del usuario (Política *Zero Trust*).
-   **Desacoplamiento de Servicios:** Separación del cliente HTTP en una nueva capa `WazuhApiService` enfocada exclusivamente en peticiones GET genéricas, cumpliendo con el Principio de Responsabilidad Única (SRP) y aislando la lógica de bajo nivel del Repositorio.
-   **Módulo Dashboard General (Modelo):** Creación de las entidades de dominio inmutables `DashboardSummary` y `TopAgent` para tipar estrictamente la estructura de los datos del estado general y los agentes críticos.
-   **Módulo Dashboard General (Repositorio y Mapeo):** Construcción de `DashboardRepository` encargado de orquestar peticiones reales a la API (`/agents/summary/status`, `/agents`, `/manager/stats`) utilizando el interceptor autenticado, parseando los DTOs JSON, filtrando agentes reales y extrayendo contadores exactos de alertas altas (L10-11) y críticas (L12+).
-   **Módulo Dashboard General (ViewModel y UI):** Desarrollo de `DashboardViewModel` para el manejo de estado y diseño de `DashboardView` para la interfaz visual, implementando un ciclo reactivo seguro en `initState()` y un manejo de excepciones con *fallbacks* (por ejemplo, textos condicionales si no existen agentes registrados).
-   **Navegación Fluida:** Actualización de la pantalla de inicio de sesión (`LoginView`) para ejecutar una transición destructiva (`Navigator.pushReplacement`) hacia el Dashboard inmediatamente después de una validación de credenciales exitosa.
