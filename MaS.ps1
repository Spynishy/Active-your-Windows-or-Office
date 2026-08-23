# ============================================================
#                  CHRONOS-TECH TOOLKIT
#                  Windows Support Toolkit
#                  Version 2.2
# ============================================================

# ------------------------------------------------------------
# ELEVAR PARA ADMINISTRADOR
# ------------------------------------------------------------

$currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()

$principal = New-Object Security.Principal.WindowsPrincipal(
    $currentIdentity
)

$isAdmin = $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)

if (-not $isAdmin) {

    if (-not $PSCommandPath) {

        Write-Host ""
        Write-Host "Execute este arquivo como um script .PS1." `
            -ForegroundColor Red

        Pause

        exit
    }

    try {

        Start-Process powershell.exe `
            -Verb RunAs `
            -ArgumentList @(
                "-NoProfile"
                "-ExecutionPolicy Bypass"
                "-File `"$PSCommandPath`""
            )

    }
    catch {

        Write-Host ""
        Write-Host "Não foi possível obter privilégios de administrador." `
            -ForegroundColor Red

        Pause
    }

    exit
}

# ------------------------------------------------------------
# CONFIGURAÇÃO
# ------------------------------------------------------------

$ErrorActionPreference = "SilentlyContinue"

Clear-Host

$Host.UI.RawUI.WindowTitle = "Chronos-Tech Toolkit"

$Version = "2.2"

# ------------------------------------------------------------
# TEXTO ANIMADO
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
██████╗██╗  ██╗██████╗  ██████╗ ███╗   ██╗ ██████╗ ███████╗   ████████╗███████╗ ██████╗██╗  ██╗
██╔════╝██║  ██║██╔══██╗██╔═══██╗████╗  ██║██╔═══██╗██╔════╝   ╚══██╔══╝██╔════╝██╔════╝██║  ██║
██║     ███████║██████╔╝██║   ██║██╔██╗ ██║██║   ██║███████╗█████╗██║   █████╗  ██║     ███████║
██║     ██╔══██║██╔══██╗██║   ██║██║╚██╗██║██║   ██║╚════██║╚════╝██║   ██╔══╝  ██║     ██╔══██║
╚██████╗██║  ██║██║  ██║╚██████╔╝██║ ╚████║╚██████╔╝███████║      ██║   ███████╗╚██████╗██║  ██║
 ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝      ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝

              C H R O N O S -- T E C H
                   TOOLKIT v2.2
'@

# ------------------------------------------------------------
# PAUSA
# ------------------------------------------------------------

function Pause-CT {

    Write-Host ""

    Write-Host "Pressione qualquer tecla para continuar..." `
        -ForegroundColor DarkGray

    try {

        $null = $Host.UI.RawUI.ReadKey(
            "NoEcho,IncludeKeyDown"
        )

    }
    catch {

        Read-Host | Out-Null
    }
}

# ------------------------------------------------------------
# CABEÇALHO
# ------------------------------------------------------------

function Show-Header {

    Clear-Host

    Write-Host $logo `
        -ForegroundColor Cyan

    Write-Host ""

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan
}

# ============================================================
# TELA DE INICIALIZAÇÃO
# ============================================================

Clear-Host

Type-Text `
    "Inicializando Chronos-Tech Toolkit..." `
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

        Start-Sleep -Milliseconds 50
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

    Start-Sleep -Milliseconds 10
}

Start-Sleep -Milliseconds 300

# ============================================================
# LIBERAR ESPAÇO
# ============================================================

function Liberar-Espaco {

    Show-Header

    Write-Host "                 LIBERAR ESPAÇO" `
        -ForegroundColor Green

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    # --------------------------------------------------------
    # TEMP
    # --------------------------------------------------------

    Write-Host "[1/5] Limpando arquivos temporários..." `
        -ForegroundColor Yellow

    try {

        Remove-Item `
            "$env:TEMP\*" `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue

        Remove-Item `
            "$env:WINDIR\Temp\*" `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue

        Write-Host "[OK] Arquivos temporários processados." `
            -ForegroundColor Green
    }
    catch {

        Write-Host "[!] Algumas pastas não puderam ser limpas." `
            -ForegroundColor Yellow
    }

    Write-Host ""

    # --------------------------------------------------------
    # LIXEIRA
    # --------------------------------------------------------

    Write-Host "[2/5] Esvaziando a Lixeira..." `
        -ForegroundColor Yellow

    try {

        Clear-RecycleBin `
            -Force `
            -ErrorAction SilentlyContinue

        Write-Host "[OK] Lixeira processada." `
            -ForegroundColor Green
    }
    catch {

        Write-Host "[!] Não foi possível limpar a Lixeira." `
            -ForegroundColor Yellow
    }

    Write-Host ""

    # --------------------------------------------------------
    # CACHE DE MINIATURAS
    # --------------------------------------------------------

    Write-Host "[3/5] Limpando cache de miniaturas..." `
        -ForegroundColor Yellow

    Remove-Item `
        "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" `
        -Force `
        -ErrorAction SilentlyContinue

    Write-Host "[OK] Cache processado." `
        -ForegroundColor Green

    Write-Host ""

    # --------------------------------------------------------
    # WINDOWS UPDATE
    # --------------------------------------------------------

    Write-Host "[4/5] Limpando cache do Windows Update..." `
        -ForegroundColor Yellow

    Stop-Service `
        wuauserv `
        -Force `
        -ErrorAction SilentlyContinue

    Remove-Item `
        "$env:WINDIR\SoftwareDistribution\Download\*" `
        -Recurse `
        -Force `
        -ErrorAction SilentlyContinue

    Start-Service `
        wuauserv `
        -ErrorAction SilentlyContinue

    Write-Host "[OK] Cache do Windows Update processado." `
        -ForegroundColor Green

    Write-Host ""

    # --------------------------------------------------------
    # DISM
    # --------------------------------------------------------

    Write-Host "[5/5] Otimizando componentes do Windows..." `
        -ForegroundColor Yellow

    DISM.exe `
        /Online `
        /Cleanup-Image `
        /StartComponentCleanup

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

    while ($true) {

        Show-Header

        Write-Host "              WINDOWS / LICENCIAMENTO" `
            -ForegroundColor Green

        Write-Host "============================================================" `
            -ForegroundColor DarkCyan

        Write-Host ""

        Write-Host "[1] Informações da licença"
        Write-Host "[2] Versão do Windows"
        Write-Host "[3] Ver chave OEM instalada"
        Write-Host "[0] Voltar"

        Write-Host ""

        $opcao = Read-Host "ChronosTech\Windows"

        switch ($opcao) {

            "1" {

                Show-Header

                Write-Host "=== LICENÇA DO WINDOWS ===" `
                    -ForegroundColor Cyan

                Write-Host ""

                cscript.exe `
                    "$env:SystemRoot\System32\slmgr.vbs" `
                    /dli

                Pause-CT
            }

            "2" {

                Show-Header

                Write-Host "=== VERSÃO DO WINDOWS ===" `
                    -ForegroundColor Cyan

                Write-Host ""

                $os = Get-CimInstance `
                    Win32_OperatingSystem

                Write-Host "Sistema     : " -NoNewline
                Write-Host $os.Caption `
                    -ForegroundColor Green

                Write-Host "Versão      : " -NoNewline
                Write-Host $os.Version

                Write-Host "Build       : " -NoNewline
                Write-Host $os.BuildNumber

                Write-Host "Arquitetura : " -NoNewline
                Write-Host $os.OSArchitecture

                Pause-CT
            }

            "3" {

                Show-Header

                Write-Host "=== CHAVE OEM ===" `
                    -ForegroundColor Cyan

                Write-Host ""

                $key = Get-CimInstance `
                    -ClassName SoftwareLicensingService |
                    Select-Object -ExpandProperty OA3OriginalProductKey

                if ($key) {

                    Write-Host "Chave OEM encontrada:" `
                        -ForegroundColor Green

                    Write-Host ""

                    Write-Host $key `
                        -ForegroundColor Cyan
                }
                else {

                    Write-Host `
                        "Nenhuma chave OEM encontrada no firmware." `
                        -ForegroundColor Yellow
                }

                Pause-CT
            }

            "0" {
                return
            }

            default {

                Write-Host ""

                Write-Host "Opção inválida!" `
                    -ForegroundColor Red

                Start-Sleep -Seconds 1
            }
        }
    }
}

# ============================================================
# DIAGNÓSTICO DE REDE
# ============================================================

function Diagnostico-Rede {

    while ($true) {

        Show-Header

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

                Show-Header

                Write-Host "=== CONFIGURAÇÃO DE REDE ===" `
                    -ForegroundColor Cyan

                Write-Host ""

                ipconfig /all

                Pause-CT
            }

            "2" {

                Show-Header

                Write-Host "=== TESTE DE INTERNET ===" `
                    -ForegroundColor Cyan

                Write-Host ""

                Write-Host "Testando conectividade com 8.8.8.8..." `
                    -ForegroundColor Yellow

                Write-Host ""

                Test-Connection `
                    -ComputerName 8.8.8.8 `
                    -Count 4

                Pause-CT
            }

            "3" {

                Show-Header

                Write-Host "=== TESTE DE DNS ===" `
                    -ForegroundColor Cyan

                Write-Host ""

                Resolve-DnsName google.com

                Pause-CT
            }

            "4" {

                Show-Header

                Write-Host "=== LIMPEZA DE DNS ===" `
                    -ForegroundColor Cyan

                Write-Host ""

                ipconfig /flushdns

                Pause-CT
            }

            "5" {

                Show-Header

                Write-Host "=== ADAPTADORES DE REDE ===" `
                    -ForegroundColor Cyan

                Write-Host ""

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

            default {

                Write-Host ""

                Write-Host "Opção inválida!" `
                    -ForegroundColor Red

                Start-Sleep -Seconds 1
            }
        }
    }
}

# ============================================================
# INFORMAÇÕES DO SISTEMA
# ============================================================

function Informacoes-Sistema {

    Show-Header

    Write-Host "                INFORMAÇÕES DO SISTEMA" `
        -ForegroundColor Green

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    $computer = Get-CimInstance `
        Win32_ComputerSystem

    $os = Get-CimInstance `
        Win32_OperatingSystem

    $cpu = Get-CimInstance `
        Win32_Processor |
        Select-Object -First 1

    Write-Host "Computador : " -NoNewline
    Write-Host $computer.Name `
        -ForegroundColor Cyan

    Write-Host "Fabricante : " -NoNewline
    Write-Host $computer.Manufacturer

    Write-Host "Modelo     : " -NoNewline
    Write-Host $computer.Model

    Write-Host "CPU        : " -NoNewline
    Write-Host $cpu.Name

    Write-Host "Núcleos    : " -NoNewline
    Write-Host $cpu.NumberOfCores

    Write-Host "RAM        : " -NoNewline
    Write-Host "$([math]::Round($computer.TotalPhysicalMemory / 1GB, 2)) GB"

    Write-Host "Windows    : " -NoNewline
    Write-Host $os.Caption

    Write-Host "Versão     : " -NoNewline
    Write-Host $os.Version

    Write-Host "Build      : " -NoNewline
    Write-Host $os.BuildNumber

    Write-Host "Arquitetura: " -NoNewline
    Write-Host $os.OSArchitecture

    Write-Host ""

    Pause-CT
}

# ============================================================
# MANUTENÇÃO DO WINDOWS
# ============================================================

function Manutencao-Windows {

    while ($true) {

        Show-Header

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

                Show-Header

                Write-Host "=== SFC /SCANNOW ===" `
                    -ForegroundColor Cyan

                Write-Host ""

                sfc.exe /scannow

                Pause-CT
            }

            "2" {

                Show-Header

                Write-Host "=== DISM RESTOREHEALTH ===" `
                    -ForegroundColor Cyan

                Write-Host ""

                DISM.exe `
                    /Online `
                    /Cleanup-Image `
                    /RestoreHealth

                Pause-CT
            }

            "3" {

                Show-Header

                Write-Host "=== VERIFICAÇÃO DO DISCO ===" `
                    -ForegroundColor Cyan

                Write-Host ""

                chkdsk.exe C: /scan

                Pause-CT
            }

            "4" {

                Start-Process `
                    cleanmgr.exe
            }

            "0" {
                return
            }

            default {

                Write-Host ""

                Write-Host "Opção inválida!" `
                    -ForegroundColor Red

                Start-Sleep -Seconds 1
            }
        }
    }
}

# ============================================================
# FERRAMENTAS DO WINDOWS
# ============================================================

function Ferramentas-Windows {

    while ($true) {

        Show-Header

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
        Write-Host "[10] Painel de Controle"
        Write-Host "[11] Gerenciador de Computador"
        Write-Host "[12] Firewall do Windows"
        Write-Host "[0] Voltar"

        Write-Host ""

        $opcao = Read-Host "ChronosTech\Ferramentas"

        switch ($opcao) {

            "1" {
                Start-Process cmd.exe
            }

            "2" {
                Start-Process powershell.exe
            }

            "3" {
                Start-Process taskmgr.exe
            }

            "4" {
                Start-Process regedit.exe
            }

            "5" {
                Start-Process eventvwr.msc
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
                Start-Process msinfo32.exe
            }

            "10" {
                Start-Process control.exe
            }

            "11" {
                Start-Process compmgmt.msc
            }

            "12" {
                Start-Process wf.msc
            }

            "0" {
                return
            }

            default {

                Write-Host ""

                Write-Host "Opção inválida!" `
                    -ForegroundColor Red

                Start-Sleep -Seconds 1
            }
        }
    }
}

# ============================================================
# MAS
# ============================================================

function MAS-Active {

    while ($true) {

        Show-Header

        Write-Host "                       MAS ACTIVE" `
            -ForegroundColor Yellow

        Write-Host "============================================================" `
            -ForegroundColor DarkCyan

        Write-Host ""

        Write-Host "Microsoft Activation Scripts" `
            -ForegroundColor Cyan

        Write-Host ""

        Write-Host "Ferramenta externa para gerenciamento de ativação." `
            -ForegroundColor Gray

        Write-Host ""

        Write-Host "[1] Abrir site oficial"
        Write-Host "[2] Exibir comando oficial"
        Write-Host "[3] Ver status da licença"
        Write-Host "[0] Voltar"

        Write-Host ""

        $opcao = Read-Host "ChronosTech\MaS"

        switch ($opcao) {

            "1" {

                Write-Host ""

                Write-Host "Abrindo site oficial..." `
                    -ForegroundColor Yellow

                Start-Process `
                    "https://github.com/massgravel/Microsoft-Activation-Scripts"

                Start-Sleep -Seconds 2
            }

            "2" {

                Show-Header

                Write-Host "                  COMANDO DO MAS" `
                    -ForegroundColor Yellow

                Write-Host "============================================================" `
                    -ForegroundColor DarkCyan

                Write-Host ""

                Write-Host "Repositório oficial:" `
                    -ForegroundColor Gray

                Write-Host "https://github.com/massgravel/Microsoft-Activation-Scripts" `
                    -ForegroundColor Cyan

                Write-Host ""

                Write-Host "O MAS possui métodos oficiais documentados" `
                    -ForegroundColor Gray

                Write-Host "no próprio repositório do projeto." `
                    -ForegroundColor Gray

                Write-Host ""

                Write-Host "ATENÇÃO:" `
                    -ForegroundColor Red

                Write-Host "Evite executar comandos remotos de fontes desconhecidas." `
                    -ForegroundColor Yellow

                Write-Host ""

                Pause-CT
            }

            "3" {

                Show-Header

                Write-Host "                 STATUS DA LICENÇA" `
                    -ForegroundColor Cyan

                Write-Host "============================================================" `
                    -ForegroundColor DarkCyan

                Write-Host ""

                cscript.exe `
                    "$env:SystemRoot\System32\slmgr.vbs" `
                    /xpr

                Write-Host ""

                Pause-CT
            }

            "0" {
                return
            }

            default {

                Write-Host ""

                Write-Host "Opção inválida!" `
                    -ForegroundColor Red

                Start-Sleep -Seconds 1
            }
        }
    }
}

# ============================================================
# SOBRE O CHRONOS-TECH
# ============================================================

function Sobre-Chronos {

    Show-Header

    Write-Host "                 SOBRE O CHRONOS-TECH" `
        -ForegroundColor Green

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    Write-Host "Chronos-Tech Toolkit" `
        -ForegroundColor Cyan

    Write-Host "Windows Support Toolkit"

    Write-Host ""

    Write-Host "Versão: $Version" `
        -ForegroundColor Yellow

    Write-Host ""

    Write-Host "Ferramentas desenvolvidas para auxiliar" `
        -ForegroundColor Gray

    Write-Host "na manutenção, diagnóstico e suporte técnico"

    Write-Host "de computadores Windows."

    Write-Host ""

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Pause-CT
}

# ============================================================
# MENU PRINCIPAL
# ============================================================

function Show-MainMenu {

    Clear-Host

    Write-Host $logo `
        -ForegroundColor Cyan

    Write-Host ""

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    Write-Host " [1] " `
        -NoNewline `
        -ForegroundColor Green

    Write-Host "Liberar Espaço"

    Write-Host " [2] " `
        -NoNewline `
        -ForegroundColor Green

    Write-Host "Windows / Licenciamento"

    Write-Host " [3] " `
        -NoNewline `
        -ForegroundColor Green

    Write-Host "Diagnóstico de Rede"

    Write-Host " [4] " `
        -NoNewline `
        -ForegroundColor Green

    Write-Host "Informações do Sistema"

    Write-Host " [5] " `
        -NoNewline `
        -ForegroundColor Green

    Write-Host "Manutenção do Windows"

    Write-Host " [6] " `
        -NoNewline `
        -ForegroundColor Green

    Write-Host "Ferramentas do Windows"

    Write-Host " [7] " `
        -NoNewline `
        -ForegroundColor Yellow

    Write-Host "MaS Active"

    Write-Host " [8] " `
        -NoNewline `
        -ForegroundColor Cyan

    Write-Host "Sobre o Chronos-Tech"

    Write-Host " [0] " `
        -NoNewline `
        -ForegroundColor Red

    Write-Host "Sair"

    Write-Host ""

    Write-Host "============================================================" `
        -ForegroundColor DarkCyan

    Write-Host ""

    return Read-Host "ChronosTech"
}

# ============================================================
# EXECUÇÃO PRINCIPAL
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
            MAS-Active
        }

        "8" {
            Sobre-Chronos
        }

        "0" {

            Clear-Host

            Write-Host ""

            Write-Host "============================================================" `
                -ForegroundColor Cyan

            Write-Host "       Obrigado por utilizar o Chronos-Tech Toolkit!" `
                -ForegroundColor Cyan

            Write-Host ""

            Write-Host "                    Até a próxima!" `
                -ForegroundColor Green

            Write-Host "============================================================" `
                -ForegroundColor Cyan

            Write-Host ""

            Start-Sleep -Seconds 2

            exit
        }

        default {

            Write-Host ""

            Write-Host "Opção inválida!" `
                -ForegroundColor Red

            Start-Sleep -Seconds 1
        }
    }
}
