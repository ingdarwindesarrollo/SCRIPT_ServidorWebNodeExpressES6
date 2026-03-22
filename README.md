# create-node-server.ps1
## Script PowerShell — Crea un servidor Node.js + Express + ES6 con un solo comando

---

## Requisitos previos

| Requisito | Cómo verificar |
|-----------|---------------|
| Node.js v18+ | `node -v` |
| npm v8+ | `npm -v` |
| PowerShell 5.1+ | ya viene con Windows 10/11 |

---

## Preparación única (solo la primera vez)

Por defecto Windows bloquea la ejecución de scripts `.ps1`.  
Ejecuta esto **una sola vez** en PowerShell como usuario normal (no hace falta administrador):

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

> Solo afecta a tu usuario. No cambia nada del sistema.

---

## Dónde colocar el script

Copia `create-node-server.ps1` a la **carpeta donde quieras que se creen los proyectos**, por ejemplo:

```
D:\CURSOS\TICS\04 CURSO NODE\
└── create-node-server.ps1   ← aquí
```

Cada vez que ejecutes el script, creará una subcarpeta nueva con el nombre del proyecto dentro de esa misma carpeta.

---

## Cómo ejecutarlo

1. Abre el Explorador de Windows y navega a la carpeta donde está el script.
2. **Shift + clic derecho** en un área vacía de la carpeta.
3. Selecciona **"Abrir ventana de PowerShell aquí"**.
4. Escribe el comando:

```powershell
# Puerto por defecto (3000)
.\create-node-server.ps1 -name "mi-nuevo-proyecto"

# Puerto personalizado
.\create-node-server.ps1 -name "mi-api" -port 4000
```

---

## Parámetros

| Parámetro | Obligatorio | Valor por defecto | Descripción |
|-----------|------------|-------------------|-------------|
| `-name`   | Sí | — | Nombre del proyecto y de la carpeta que se crea |
| `-port`   | No | `3000` | Puerto en el que arrancará el servidor |

---

## Qué hace el script paso a paso

### [1/5] Crea la estructura de carpetas

```
mi-proyecto\
├── public\
└── src\
    ├── config\
    └── server\
```

### [2/5] Genera todos los archivos del proyecto

| Archivo | Contenido generado |
|---------|--------------------|
| `package.json` | Nombre del proyecto, `"type":"module"` (ES6), dependencias, script `dev` |
| `.env` | `PORT=<puerto>` y `PUBLIC_PATH=public` |
| `.gitignore` | Excluye `node_modules/` y `.env` |
| `src/config/env.js` | Lee y valida las variables de entorno con `dotenv` + `env-var` |
| `src/server/server.js` | Configura Express: archivos estáticos + fallback a `index.html` |
| `src/app.js` | Punto de entrada: une config + servidor y llama a `startServer()` |
| `public/index.html` | Página HTML de bienvenida con el nombre y puerto del proyecto |

### [3/5] Instala las dependencias

```powershell
npm install
```

Descarga e instala automáticamente:

| Paquete | Tipo | Para qué |
|---------|------|----------|
| `express` | producción | servidor HTTP / framework web |
| `dotenv` | producción | carga el archivo `.env` |
| `env-var` | producción | valida y convierte variables de entorno |
| `nodemon` | desarrollo | reinicia el servidor al guardar cambios |

> **¿Por qué tarda este paso?**  
> npm descarga los paquetes desde internet. La primera vez puede tardar
> 30–60 segundos dependiendo de la conexión. Es normal quedarse en `[3/5]` un rato.

### [4/5] Muestra el árbol de archivos

Imprime en consola la estructura completa del proyecto recién creado para
que puedas confirmar que todo se generó correctamente.

### [5/5] Arranca el servidor con nodemon

```powershell
npm run dev
# equivale a: nodemon src/app.js
```

Salida esperada:
```
[nodemon] starting `node src/app.js`
Servidor corriendo en http://localhost:3000
```

Abre el navegador en **http://localhost:3000** (o el puerto que hayas elegido).

Para detener el servidor: **Ctrl + C**

---

## Estructura del proyecto generado

```
mi-nuevo-proyecto\
├── public\
│   └── index.html          ← página servida al navegador
├── src\
│   ├── config\
│   │   └── env.js          ← lee y valida variables de entorno
│   ├── server\
│   │   └── server.js       ← configura Express
│   └── app.js              ← punto de entrada
├── node_modules\           ← generado por npm install (no tocar)
├── .env                    ← configuración local (NO subir a git)
├── .gitignore
└── package.json
```

---

## Errores frecuentes

| Error | Causa | Solución |
|-------|-------|----------|
| `no se puede cargar el archivo .ps1` | PowerShell bloquea scripts externos | Ejecuta `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` |
| `[ERROR] La carpeta 'xxx' ya existe` | Ya hay una carpeta con ese nombre | Usa un nombre diferente o borra la carpeta existente |
| `npm : no se reconoce el término` | Node.js no está instalado o no está en el PATH | Instala Node.js desde https://nodejs.org |
| Se queda parado en `[3/5]` mucho tiempo | npm está descargando paquetes desde internet | Esperar. Si supera 5 minutos, revisar la conexión a internet |

---

## Después de crear el proyecto

Para volver a arrancarlo en el futuro (sin recrearlo):

```powershell
cd mi-nuevo-proyecto
npm run dev
```

---

## Ejemplo completo de uso

```powershell
# 1. Abrir PowerShell en la carpeta del script
# 2. Ejecutar:
.\create-node-server.ps1 -name "tienda-online" -port 8080

# El script:
# - Crea la carpeta tienda-online\
# - Genera todos los archivos
# - Instala express, dotenv, env-var, nodemon
# - Muestra el árbol de archivos
# - Arranca: http://localhost:8080
```
