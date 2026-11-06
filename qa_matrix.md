| ID | Prueba | Pasos | Resultado esperado | Resultado obtenido |
|---|---|---|---|---|
| QA-01 | Registro y autenticación | Crear cuenta con correo/contraseña, cerrar sesión e iniciar sesión | Cuenta autenticada; documento users/{uid} creado con rol usuario | |
| QA-02 | Roles y seguridad | Registrar usuario; cambiar rol a administrador y acceso desde Firebase Console; verificar navegación y denegación de acciones ajenas al rol | Cada rol solo ve y ejecuta sus funciones; usuario nunca elige rol en la app | |
| QA-03 | Persistencia local | Crear solicitud sin conexión, cerrar y volver a abrir la app | Solicitud local sigue visible tras reiniciar | |
| QA-04 | Catálogo HTTP exitoso | Publicar spaces.json, configurar baseUrl y actualizar catálogo | Se muestran los espacios descargados y se guardan en Drift | |
| QA-05 | Catálogo HTTP sin red | Desconectar la red y actualizar el catálogo ya descargado | Se muestra caché Drift y SnackBar informa del fallo de red | |
| QA-06 | Sincronización offline e idempotencia | Crear solicitudes sin red; restaurar conexión; sincronizar varias veces | Solicitudes pendientes pasan a sincronizadas, sin duplicados; conflicto permanece visible | |
| QA-07 | SharedPreferences | Seleccionar un espacio y cerrar/volver a abrir su lista | Se restaura el último espacio seleccionado | |
| QA-08 | Crashlytics | Abrir menú y ejecutar Probar Crashlytics; revisar Firebase Crashlytics | Se reporta una excepción no fatal de prueba | |
| QA-09 | APK release | Ejecutar flutter build apk --release e instalar el APK resultante | APK release compilado e instalable en Android | |
| QA-10 | Regla de negocio: franjas y capacidad | Intentar reservar horas fuera de 07:00–20:00, franja pasada, cero asistentes y asistentes por encima de capacidad | Las solicitudes inválidas se rechazan en código y las reglas aplicables en Firestore | |
| QA-11 | Regla de negocio: confirmación atómica | Confirmar una reserva y revisar slot; intentar confirmar otra para el mismo espacio/franja | Confirmación y ocupación son atómicas; slot ocupado/bloqueado rechaza la siguiente | |
| QA-12 | Regla de negocio: cancelación | Intentar cancelar como otro usuario o con menos de una hora; cancelar confirmada con anticipación | Solo propietario puede cancelar con plazo; cancelar confirmada libera su slot atómicamente | |
| QA-13 | Regla de negocio: uso y conservación | Intentar ingreso fuera de horario; registrar ingreso válido y salida; intentar borrar reserva | Ingreso fuera de franja falla; checkIn/checkOut y estados se conservan; borrado denegado | |
| QA-14 | Regla de negocio: roles y transiciones | Intentar confirmar/rechazar como usuario, usar la propia reserva como administrador y registrar acceso con otro rol | Operaciones no autorizadas fallan; solo rol y transición válidos avanzan | |
| QA-15 | Aceptación: solicitudes concurrentes | Dos usuarios solicitan el mismo espacio y franja; administrador confirma ambas en secuencia | Una confirmación gana; la segunda falla con mensaje de conflicto | |
| QA-16 | Aceptación: capacidad | Intentar solicitar y aprobar un grupo que exceda la capacidad del espacio | Solicitud y aprobación se impiden | |
| QA-17 | Aceptación: historial de acceso | Probar ingreso fuera de franja y luego ingreso válido seguido de salida | Ingreso fuera de hora se bloquea; ingreso y salida válidos quedan registrados | |
