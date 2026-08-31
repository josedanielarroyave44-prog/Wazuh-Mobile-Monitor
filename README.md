# Borrador del proyecto de la aplicación de Android

**Estudiante:** José Daniel Arroyave Buriticá

## Descripción del proyecto

El proyecto es una aplicación móvil de monitoreo para la infraestructura de agentes de seguridad de Wazuh, siendo un cliente ligero estricto que sirve como sistema de chequeo centralizado, limpio y resumido de la salud general del SIEM y de sus alertas más importantes, mientras que implementa módulos de vista detallada de cada agente y Respuesta Activa a un botón.

## Exposición del problema

El problema de la simpleza en la ciberseguridad es más una característica estructural que un problema a resolver, porque la misma idiosincrasia de este campo es de complejidad; sin embargo, existen todavía nichos sin explotar de manera masiva que requieren de nuevas propuestas que hagan de esta complejidad algo mucho más llevadero y escalable. De forma más específica, la Seguridad Defensiva o Blue Teaming siempre está en una necesidad constante de evolución en sus soluciones de seguridad tipo SIEM, IDS/IPS y SOAR, pero un aspecto tan o, en ocasiones, más importante que las aplicaciones de defensa en sí mismas, es su integración eficiente en las operaciones normales de la empresa, donde estas deben ser modulares y fácilmente configurables y modificables. En esta misma línea, podemos concluir que el pico de la conveniencia tecnológica son los celulares y su capacidad actual de ejecutar tareas altamente complejas al vuelo y con conexiones sin límite en su alcance, por lo que son el medio ideal para desarrollar una solución con las características descritas (sencillez y escalabilidad, fácilmente configurables). Así, la idea que combina las necesidades de la Seguridad Defensiva, con la modularidad exigida en una empresa y la conveniencia del medio celular es la de un Dashboard SIEM multiplataforma, específicamente para la solución de seguridad Wazuh, la cual es Open Source y no tiene cliente móvil oficial.

El proyecto no intenta competir con el Dashboard Web oficial de Wazuh, sino que pretende servir como una aplicación ligera y rápida de evaluaciones críticas convenientes sin necesidad de un PC o portátil, con el valor agregado de ser más compacta y menos verbosa para triages y respuestas iniciales en caso de amenazas.

De esta forma, la aplicación resuelve el problema del set-up incómodo y que llega a ser engorroso de sacar una computadora en un lugar público o de acceder al Dashboard Web de Wazuh mediante el celular, el cual es una página sobrecargada de texto y funcionalidades que están adecuadas para investigaciones profundas, triage detallado e informes minuciosos en un viewport de tipo computador.

## Plataforma

La aplicación será multiplataforma y será desarrollada con Flutter y el lenguaje Dart.

## Interfaz de usuario e interfaz de administrador

La aplicación funcionará bajo una misma interfaz de control con todas las funcionalidades activas, en cuanto esta aplicación será usada exclusivamente por los líderes del SOC encargados de la seguridad defensiva de la empresa.

## Funcionalidad

Como la aplicación funciona bajo la arquitectura de un cliente estricto, no requiere un backend intermedio. En su lugar, la aplicación interactúa con la API RESTful de Wazuh alojada en el servidor Manager de Wazuh mediante autenticación JWT. Los componentes principales de esta aplicación son:

- Configuración y Autenticación: Formulario de conexión al servidor Manager de Wazuh con almacenamiento local cifrado de credenciales. La conexión se recomendará al usuario realizarla por medio de una VPN a la empresa o a la red en donde se encuentra alojado el servidor para no exponer la API al internet público. Después de la primera conexión e inicio de sesión exitoso, la aplicación permitirá configurar bloqueo por datos biométricos para abrirse de nuevo en lugar de ingresar de nuevo las credenciales.

- Dashboard General de Estado: Resumen inmediato del sistema. Contador global de agentes (junto a un gráfico circular representando el estado de los endpoints) y una tarjeta de resumen con la cantidad total de alertas altas (10-11) y críticas (12 a 16) detectadas en las últimas 24 horas en la infraestructura.

- Feed de emergencias: Lista con campo de búsqueda más detallada enfocada estrictamente en amenazas reales, ignorando el ruido de los primeros 9 niveles de alertas. El desglose por fila contendrá: Botón para ver la descripción entera con todos los campos de la alerta, timestamp, nombre de agente (con hipervínculo que lo llevará a la sección de Respuesta Activa), descripción de la regla gatillada, nivel de la alerta e ID de la regla.

- Sección de Agentes con más Alertas: Lista simple con nombre de agente y cantidad de alertas de nivel +10 ocurridas en las últimas 24 horas.

- Lista de agentes: Lista scrolleable y con campo de búsqueda donde cada fila representa un agente. Contiene las siguientes columnas: Nombre del host, dirección IP, OS (ícono) y círculo de color representando el estado (verde activo, rojo desconectado y gris nunca conectado). Al hacer click al fila: menú desplegable con datos de última hora de conexión (keep-alive), versión del agente de Wazuh, botón de silenciar alertas y botón de “Ir a Respuesta Activa”.

- Respuesta Activa: Pantalla emergente donde muestra varias opciones de Respuesta Activa disponibles para el agente seleccionado (e.g. “Aislar Endpoint”).

- Notificaciones de Push Simples: Servicio en segundo plano que revise la API cada cierto tiempo para enviar una notificación push al celular (e.g. “Agente Windows Server AD DC desconectado”).
