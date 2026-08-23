# ============================================================
#                  CHRONOSTECH TOOLKIT
#                  Windows Support Toolkit
#                  Version 2.0
# ============================================================

# ------------------------------------------------------------
# ELEVAR PARA ADMINISTRADOR
# ------------------------------------------------------------

if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {

    Start-Process powershell.exe `
        -Verb RunAs `
        -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`""

    exit
}

# ------------------------------------------------------------
# CONFIGURAÇÃO
# ------------------------------------------------------------

Clear-Host

$Host.UI.RawUI.WindowTitle = "ChronosTech Toolkit"

$Version = "2.0"

# ------------------------------------------------------------
# FUNÇÃO DE TEXTO ANIMADO
# ------------------------------------------------------------

function Type-Text {

    param(
        [string]$Text,
        [string]$Color = "Cyan",
        [int]$Speed = 15
    )

    foreach ($c in $Text.ToCharArray()) {

        Write-Host $c `
            -NoNewline `
            -ForegroundColor $Color

        Start-Sleep -Milliseconds $Speed
    }

    Write-Host
}

# ------------------------------------------------------------
# LOGO
# ------------------------------------------------------------

$logo = @'
 ██████╗██╗  ██╗██████╗  ██████╗ ███╗   ██╗ ██████╗ ███████╗
██╔════╝██║  ██║██╔══██╗██╔═══██╗████╗  ██║██╔════╝ ██╔════╝
██║     ███████║██████╔╝██║   ██║██╔██╗ ██║██║  ███╗███████╗
██║     ██╔══██║██╔══██╗██║   ██║██║╚██╗██║██║   ██║╚════██║
╚██████╗██║  ██║██║  ██║╚██████╔╝██║ ╚████║╚██████╔╝███████║
 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝

                 C H R O N O S T E C H
                    TOOLKIT v2.0
'@

# ------------------------------------------------------------
# PAUSE
# ------------------------------------------------------------

function Pause-CT {

    Write-Host ""
    Write-Host "Pressione qualquer tecla para continuar..." `
        -ForegroundColor DarkGray

    $null = $Host.UI.RawUI.ReadKey(
        "NoEcho,IncludeKeyDown"
    )
}

# ------------------------------------------------------------
# TELA DE INICIALIZAÇÃO
# ------------------------------------------------------------

Clear-Host

Type-Text `
    "Inicializando ChronosTech Toolkit..." `
    "Cyan" `
    10

Start-Sleep -Milliseconds 300

$frames = @("|", "/", "-", "\")

$mensagens = @(
    "Carregando módulos",
    "Verificando sistema",
    "Preparando interface",
    "Inicializando ferramentas",
    "Verificando privilégios",
    "Finalizando"
)

foreach ($msg in $mensagens) {

    for ($i = 0; $i -lt 18; $i++) {

        $frame = $frames[$i % $frames.Count]

        Write-Host `
            "`r[$frame] $msg..." `
            -NoNewline `
            -ForegroundColor Yellow

        Start-Sleep -Milliseconds 70
    }

    Write-Host `
        "`r[OK] $msg concluído.      " `
        -ForegroundColor Green
}

Write-Host ""

# ------------------------------------------------------------
# BARRA DE PROGRESSO
# ------------------------------------------------------------

for ($i = 0; $i -le 100; $i++) {

    $barSize = 50
    $filled = [math]::Floor($i / 2)
    $empty = $barSize - $filled

    $bars = "█" * $filled
    $spaces = " " * $empty

    Write-Host `
        "`r[$bars$spaces] $i%" `
        -NoNewline `
        -ForegroundColor Cyan

    Start-Sleep -Milliseconds 15
}

Start-Sleep -Milliseconds 400

# ------------------------------------------------------------
# MENU PRINCIPAL
# ------------------------------------------------------------

function Show-MainMenu {

    Clear-Host

    Write-Host $logo -ForegroundColor Cyan

    Write-Host ""
    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    Write-Host " [1] " -NoNewline -ForegroundColor Green
    Write-Host "Liberar Espaço"

    Write-Host " [2] " -NoNewline -ForegroundColor Green
    Write-Host "Windows / Licenciamento"

    Write-Host " [3] " -NoNewline -ForegroundColor Green
    Write-Host "Diagnóstico de Rede"

    Write-Host " [4] " -NoNewline -ForegroundColor Green
    Write-Host "Informações do Sistema"

    Write-Host " [5] " -NoNewline -ForegroundColor Green
    Write-Host "Manutenção do Windows"

    Write-Host " [6] " -NoNewline -ForegroundColor Green
    Write-Host "Ferramentas do Windows"

    Write-Host " [7] " -NoNewline -ForegroundColor Yellow
    Write-Host "Em desenvolvimento"

    Write-Host " [0] " -NoNewline -ForegroundColor Red
    Write-Host "Sair"

    Write-Host ""

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    return Read-Host "ChronosTech"
}

# ============================================================
# LIBERAR ESPAÇO
# ============================================================

function Liberar-Espaco {

    Clear-Host

    Write-Host $logo -ForegroundColor Cyan

    Write-Host ""
    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host "                 LIBERAR ESPAÇO" `
        -ForegroundColor Green

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    Write-Host "[1/5] Limpando arquivos temporários..." `
        -ForegroundColor Yellow

    Remove-Item `
        "$env:TEMP\*" `
        -Recurse `
        -Force `
        -ErrorAction SilentlyContinue

    Remove-Item `
        "C:\Windows\Temp\*" `
        -Recurse `
        -Force `
        -ErrorAction SilentlyContinue


    Write-Host "[2/5] Esvaziando a Lixeira..." `
        -ForegroundColor Yellow

    Clear-RecycleBin `
        -Force `
        -ErrorAction SilentlyContinue


    Write-Host "[3/5] Limpando cache de miniaturas..." `
        -ForegroundColor Yellow

    Remove-Item `
        "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" `
        -Force `
        -ErrorAction SilentlyContinue


    Write-Host "[4/5] Limpando cache do Windows Update..." `
        -ForegroundColor Yellow

    Stop-Service `
        wuauserv `
        -Force `
        -ErrorAction SilentlyContinue

    Remove-Item `
        "C:\Windows\SoftwareDistribution\Download\*" `
        -Recurse `
        -Force `
        -ErrorAction SilentlyContinue

    Start-Service `
        wuauserv `
        -ErrorAction SilentlyContinue


    Write-Host "[5/5] Otimizando componentes do Windows..." `
        -ForegroundColor Yellow

    DISM /Online /Cleanup-Image /StartComponentCleanup


    Write-Host ""
    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host "Limpeza concluída!" `
        -ForegroundColor Green

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Pause-CT
}

# ============================================================
# WINDOWS / LICENCIAMENTO
# ============================================================

function Windows-Licenciamento {

    Clear-Host

    Write-Host $logo -ForegroundColor Cyan

    Write-Host ""
    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host "              WINDOWS / LICENCIAMENTO" `
        -ForegroundColor Green

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    Write-Host "[1] Informações da licença"
    Write-Host "[2] Versão do Windows"
    Write-Host "[3] Ver chave instalada"
    Write-Host "[0] Voltar"

    Write-Host ""

    $opcao = Read-Host "ChronosTech\Windows"

    switch ($opcao) {

        "1" {

            Clear-Host

            Write-Host "=== LICENÇA DO WINDOWS ===" `
                -ForegroundColor Cyan

            Write-Host ""

            cscript.exe `
                "$env:SystemRoot\System32\slmgr.vbs" `
                /dli

            Pause-CT
        }

        "2" {

            Clear-Host

            Write-Host "=== VERSÃO DO WINDOWS ===" `
                -ForegroundColor Cyan

            Write-Host ""

            Get-ComputerInfo |
                Select-Object `
                    WindowsProductName,
                    WindowsVersion,
                    OsBuildNumber,
                    OsArchitecture

            Pause-CT
        }

        "3" {

            Clear-Host

            Write-Host "=== CHAVE INSTALADA ===" `
                -ForegroundColor Cyan

            Write-Host ""

            $key = Get-CimInstance `
                -ClassName SoftwareLicensingService |
                Select-Object -ExpandProperty OA3OriginalProductKey

            if ($key) {

                Write-Host "Chave OEM:" `
                    -ForegroundColor Green

                Write-Host $key

            } else {

                Write-Host `
                    "Nenhuma chave OEM encontrada." `
                    -ForegroundColor Yellow
            }

            Pause-CT
        }

        "0" {
            return
        }
    }
}

# ============================================================
# DIAGNÓSTICO DE REDE
# ============================================================

function Diagnostico-Rede {

    Clear-Host

    Write-Host $logo -ForegroundColor Cyan

    Write-Host ""
    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host "                 DIAGNÓSTICO DE REDE" `
        -ForegroundColor Green

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    Write-Host "[1] Informações de IP"
    Write-Host "[2] Testar Internet"
    Write-Host "[3] Testar DNS"
    Write-Host "[4] Limpar DNS"
    Write-Host "[5] Adaptadores"
    Write-Host "[0] Voltar"

    Write-Host ""

    $opcao = Read-Host "ChronosTech\Rede"

    switch ($opcao) {

        "1" {

            Clear-Host
            ipconfig /all
            Pause-CT
        }

        "2" {

            Clear-Host

            Write-Host "Testando conectividade..." `
                -ForegroundColor Cyan

            Test-Connection `
                8.8.8.8 `
                -Count 4

            Pause-CT
        }

        "3" {

            Clear-Host

            Resolve-DnsName google.com

            Pause-CT
        }

        "4" {

            Clear-Host

            ipconfig /flushdns

            Pause-CT
        }

        "5" {

            Clear-Host

            Get-NetAdapter |
                Format-Table `
                    Name,
                    Status,
                    LinkSpeed,
                    MacAddress `
                    -AutoSize

            Pause-CT
        }

        "0" {
            return
        }
    }
}

# ============================================================
# INFORMAÇÕES DO SISTEMA
# ============================================================

function Informacoes-Sistema {

    Clear-Host

    Write-Host $logo -ForegroundColor Cyan

    Write-Host ""
    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host "                INFORMAÇÕES DO SISTEMA" `
        -ForegroundColor Green

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    $computer = Get-CimInstance Win32_ComputerSystem
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor |
        Select-Object -First 1

    Write-Host "Computador : " -NoNewline
    Write-Host $computer.Name -ForegroundColor Cyan

    Write-Host "Fabricante : " -NoNewline
    Write-Host $computer.Manufacturer

    Write-Host "Modelo     : " -NoNewline
    Write-Host $computer.Model

    Write-Host "CPU        : " -NoNewline
    Write-Host $cpu.Name

    Write-Host "RAM        : " -NoNewline
    Write-Host "$([math]::Round($computer.TotalPhysicalMemory / 1GB,2)) GB"

    Write-Host "Windows    : " -NoNewline
    Write-Host $os.Caption

    Write-Host "Versão     : " -NoNewline
    Write-Host $os.Version

    Write-Host "Build      : " -NoNewline
    Write-Host $os.BuildNumber

    Write-Host "Arquitetura: " -NoNewline
    Write-Host $os.OSArchitecture

    Pause-CT
}

# ============================================================
# MANUTENÇÃO
# ============================================================

function Manutencao-Windows {

    Clear-Host

    Write-Host $logo -ForegroundColor Cyan

    Write-Host ""
    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host "                 MANUTENÇÃO WINDOWS" `
        -ForegroundColor Green

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    Write-Host "[1] SFC /SCANNOW"
    Write-Host "[2] DISM RestoreHealth"
    Write-Host "[3] Verificar disco"
    Write-Host "[4] Limpeza de Disco"
    Write-Host "[0] Voltar"

    Write-Host ""

    $opcao = Read-Host "ChronosTech\Manutencao"

    switch ($opcao) {

        "1" {

            Clear-Host

            Write-Host "Executando SFC..." `
                -ForegroundColor Cyan

            sfc /scannow

            Pause-CT
        }

        "2" {

            Clear-Host

            Write-Host "Executando DISM..." `
                -ForegroundColor Cyan

            DISM /Online /Cleanup-Image /RestoreHealth

            Pause-CT
        }

        "3" {

            Clear-Host

            chkdsk C: /scan

            Pause-CT
        }

        "4" {

            Start-Process cleanmgr
        }

        "0" {
            return
        }
    }
}

# ============================================================
# FERRAMENTAS WINDOWS
# ============================================================

function Ferramentas-Windows {

    Clear-Host

    Write-Host $logo -ForegroundColor Cyan

    Write-Host ""
    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host "                  FERRAMENTAS WINDOWS" `
        -ForegroundColor Green

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    Write-Host "[1] CMD"
    Write-Host "[2] PowerShell"
    Write-Host "[3] Gerenciador de Tarefas"
    Write-Host "[4] Editor do Registro"
    Write-Host "[5] Visualizador de Eventos"
    Write-Host "[6] Gerenciador de Dispositivos"
    Write-Host "[7] Gerenciamento de Disco"
    Write-Host "[8] Serviços"
    Write-Host "[9] Informações do Sistema"
    Write-Host "[0] Voltar"

    Write-Host ""

    $opcao = Read-Host "ChronosTech\Ferramentas"

    switch ($opcao) {

        "1" {
            Start-Process cmd
        }

        "2" {
            Start-Process powershell
        }

        "3" {
            Start-Process taskmgr
        }

        "4" {
            Start-Process regedit
        }

        "5" {
            Start-Process eventvwr
        }

        "6" {
            Start-Process devmgmt.msc
        }

        "7" {
            Start-Process diskmgmt.msc
        }

        "8" {
            Start-Process services.msc
        }

        "9" {
            Start-Process msinfo32
        }

        "0" {
            return
        }
    }
}

# ============================================================
# MENU PRINCIPAL
# ============================================================

while ($true) {

    $opcao = Show-MainMenu

    switch ($opcao) {

        "1" {
            Liberar-Espaco
        }

        "2" {
            Windows-Licenciamento
        }

        "3" {
            Diagnostico-Rede
        }

        "4" {
            Informacoes-Sistema
        }

        "5" {
            Manutencao-Windows
        }

        "6" {
            Ferramentas-Windows
        }

        "7" {

            Clear-Host

            Write-Host $logo -ForegroundColor Cyan
            Write-Host ""

            Write-Host "Esta função está em desenvolvimento." `
                -ForegroundColor Yellow

            Pause-CT
        }

        "0" {

            Clear-Host

            Write-Host ""
            Write-Host "============================================================" `
                -ForegroundColor Cyan

            Write-Host "       Obrigado por utilizar a ChronosTech Toolkit!" `
                -ForegroundColor Cyan

            Write-Host "============================================================" `
                -ForegroundColor Cyan

            Write-Host ""

            exit
        }

        default {

            Write-Host ""
            Write-Host "Opção inválida!" `
                -ForegroundColor Red

            Start-Sleep -Seconds 2
        }
    }
}
