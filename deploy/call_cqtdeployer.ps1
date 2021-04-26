
param (
    [Parameter(Mandatory = $true)]
    [string]
    ${CQTDEPLOYER_PATH},
    [Parameter(Mandatory = $true)]
    [string]
    ${LIB_DIR_PATH},
    [Parameter(Mandatory = $true)]
    [string]
    ${TARGET},
    [Parameter(Mandatory = $true)]
    [string]
    ${INSTALL_ROOT},

    [Parameter(Mandatory = $true)]
    [string]
    ${DEPLOY_DIR_PATH}
)


$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0


$PSBoundParameters | Format-List


${exeFilePath} = `
    Join-Path -Path ${INSTALL_ROOT} -ChildPath "${TARGET}.exe"

${iconFilePath} = `
    Join-Path -Path ${INSTALL_ROOT} -ChildPath 'Beslyric.ico'
${versionTxtFilePath} = `
    Join-Path -Path ${INSTALL_ROOT} -ChildPath 'version.txt'

${libsslFilePath} = `
    Join-Path -Path ${LIB_DIR_PATH} -ChildPath 'libssl-1_1-x64.dll'
${libcryptoFilePath} = `
    Join-Path -Path ${LIB_DIR_PATH} -ChildPath 'libcrypto-1_1-x64.dll'


Write-Output -InputObject "exeFilePath = ${exeFilePath}"
Get-Item -Path ${exeFilePath} | Format-List

Write-Output -InputObject "iconFilePath = ${iconFilePath}"
Get-Item -Path ${iconFilePath} | Format-List
Write-Output -InputObject "versionTxtFilePath = ${versionTxtFilePath}"
Get-Item -Path ${versionTxtFilePath} | Format-List

Write-Output -InputObject "libsslFilePath = ${libsslFilePath}"
Get-Item -Path ${libsslFilePath} | Format-List
Write-Output -InputObject "libcryptoFilePath = ${libcryptoFilePath}"
Get-Item -Path ${libcryptoFilePath} | Format-List


# CQtDeployer -bin "all,deployable,files"
#   https://github.com/QuasarApp/CQtDeployer/issues/394

& ${CQTDEPLOYER_PATH} `
    '-bin' "${exeFilePath},${iconFilePath},${versionTxtFilePath},${libsslFilePath},${libcryptoFilePath}" `
    '-libDir' ${LIB_DIR_PATH} `
    '-targetDir' ${DEPLOY_DIR_PATH} `
    '-verbose' '3' `
    'noTranslations' 'clear'

if ($LASTEXITCODE -ne 0) {
    throw "${CQTDEPLOYER_PATH} exited with code $LASTEXITCODE."
}
