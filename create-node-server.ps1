# ============================================================
#  create-node-server.ps1
#  Crea un servidor web Node.js + Express + ES6 desde cero
#
#  USO:
#    .\create-node-server.ps1 -name "mi-proyecto"
#    .\create-node-server.ps1 -name "mi-api" -port 4000
#
#  Si PowerShell bloquea scripts, ejecuta UNA sola vez:
#    Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
# ============================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$name,
    [int]$port = 3000
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Creando proyecto Node.js + Express ES6" -ForegroundColor Cyan
Write-Host "  Proyecto : $name"                        -ForegroundColor Cyan
Write-Host "  Puerto   : $port"                        -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

if (Test-Path $name) {
    Write-Host "[ERROR] La carpeta '$name' ya existe en este directorio." -ForegroundColor Red
    exit 1
}

# ── PASO 1: Estructura de carpetas ──────────────────────────────────────────
Write-Host "[1/5] Creando estructura de carpetas..." -ForegroundColor Yellow

New-Item -ItemType Directory -Path "$name\src\config" -Force | Out-Null
New-Item -ItemType Directory -Path "$name\src\server" -Force | Out-Null
New-Item -ItemType Directory -Path "$name\public"     -Force | Out-Null

# ── PASO 2: Generar archivos del proyecto ────────────────────────────────────
Write-Host "[2/5] Generando archivos..." -ForegroundColor Yellow

# ── package.json ─────────────────────────────────────────────────────────────
@"
{
  "name": "$name",
  "version": "0.0.1",
  "description": "Servidor web estatico con Express",
  "license": "ISC",
  "type": "module",
  "main": "src/app.js",
  "scripts": {
    "dev": "nodemon src/app.js"
  },
  "devDependencies": {
    "nodemon": "^3.1.14"
  },
  "dependencies": {
    "dotenv": "^17.3.1",
    "env-var": "^7.5.0",
    "express": "^5.2.1"
  }
}
"@ | Set-Content "$name\package.json" -Encoding UTF8

# ── .env ─────────────────────────────────────────────────────────────────────
@"
PORT=$port
PUBLIC_PATH=public
"@ | Set-Content "$name\.env" -Encoding UTF8

# ── .gitignore ───────────────────────────────────────────────────────────────
@'
node_modules/
.env
'@ | Set-Content "$name\.gitignore" -Encoding UTF8

# ── src/config/env.js ────────────────────────────────────────────────────────
@'
import env from 'dotenv';
import envvar from 'env-var';

env.config();

export const envs = {
    PORT: envvar.get('PORT').required().asPortNumber(),
    PUBLIC_PATH: envvar.get('PUBLIC_PATH').default('public').asString()
}
'@ | Set-Content "$name\src\config\env.js" -Encoding UTF8

# ── src/server/server.js ─────────────────────────────────────────────────────
@'
import express from 'express'
import path from 'path'
import { fileURLToPath } from 'url'

const __dirname = path.dirname(fileURLToPath(import.meta.url))

export const startServer = (options) => {
    const { port, public_path = 'public' } = options

    const app = express()

    app.use(express.static(public_path))

    app.get('*splat', (req, res) => {
        const indexPath = path.join(__dirname, `../../${public_path}/index.html`)
        res.sendFile(indexPath)
    })

    app.listen(port, () => {
        console.log(`Servidor corriendo en http://localhost:${port}`)
    })
}
'@ | Set-Content "$name\src\server\server.js" -Encoding UTF8

# ── src/app.js ───────────────────────────────────────────────────────────────
@'
import { envs } from './config/env.js';
import { startServer } from './server/server.js';

const main = () => {
    startServer({
        port: envs.PORT,
        public_path: envs.PUBLIC_PATH
    })
}

main()
'@ | Set-Content "$name\src\app.js" -Encoding UTF8

# ── public/index.html ────────────────────────────────────────────────────────
@"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$name</title>
</head>
<body>
    <h1>$name</h1>
    <p>Servidor Express funcionando correctamente en el puerto $port.</p>
</body>
</html>
"@ | Set-Content "$name\public\index.html" -Encoding UTF8

# ── PASO 3: npm install ──────────────────────────────────────────────────────
Write-Host "[3/5] Instalando dependencias (npm install)..." -ForegroundColor Yellow
Push-Location $name
npm install
Pop-Location

# ── PASO 4: Arbol de archivos ────────────────────────────────────────────────
Write-Host ""
Write-Host "[4/5] Proyecto listo. Estructura creada:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  $name\"                              -ForegroundColor Cyan
Write-Host "  +-- public\"                         -ForegroundColor Cyan
Write-Host "  |   \-- index.html"                  -ForegroundColor White
Write-Host "  +-- src\"                            -ForegroundColor Cyan
Write-Host "  |   +-- config\"                     -ForegroundColor Cyan
Write-Host "  |   |   \-- env.js"                  -ForegroundColor White
Write-Host "  |   +-- server\"                     -ForegroundColor Cyan
Write-Host "  |   |   \-- server.js"               -ForegroundColor White
Write-Host "  |   \-- app.js"                      -ForegroundColor White
Write-Host "  +-- node_modules\  (generado por npm)" -ForegroundColor DarkGray
Write-Host "  +-- .env"                            -ForegroundColor White
Write-Host "  +-- .gitignore"                      -ForegroundColor White
Write-Host "  \-- package.json"                    -ForegroundColor White
Write-Host ""

# ── PASO 5: Arrancar servidor ────────────────────────────────────────────────
Write-Host "[5/5] Arrancando servidor con nodemon..." -ForegroundColor Green
Write-Host ""
Write-Host "  >> Abre el navegador en: http://localhost:$port" -ForegroundColor Cyan
Write-Host "  >> Ctrl+C para detener el servidor"              -ForegroundColor Gray
Write-Host ""

Set-Location $name
npm run dev
