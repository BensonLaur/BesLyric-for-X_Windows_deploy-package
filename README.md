# BesLyric-for-X Deployment and Packaging Scripts (Windows)

## Introduction

The scripts in this repository are used to deploy and package BesLyric-for-X on Windows.

## Environment

Windows 10 x64

## Dependent tools

These tools are required to complete the work:

- PowerShell 5 / 7
- qmake (used by CQtDeployer)
- CQtDeployer 1.4.7.0
- Inno Setup 6.0.5 (u)
- Enigma Virtual Box v9.60 Build 20210209

## How to use

### Prerequisites

- Add the path to the parent directory of `qmake` to your `PATH` environment variable (use the same `qmake` as when building BesLyric-for-X).

### Get scripts

```shell
PS > git clone --recurse-submodules https://github.com/BesLyric-for-X/BesLyric-for-X_Windows_deploy-package.git
PS > #         \--------__--------/
PS > #              Important!
```

### Execute with a bunch of parameters

First of all, we should not let go of any mistake:

```powershell
$ErrorActionPreference = 'Stop'  # set -e for cmdlet
Set-StrictMode -Version 3.0      # set -u
```

Then, I think creating some variables may be helpful. For example:

```powershell
# For qmake
${target}      = '<"TARGET" in qmake project. "BesLyric-for-X" by default>'
${installRoot} = '<"INSTALL_ROOT" of "qmake install">'

# For cqtdeployer
${cqtdeployerPath} = '<path to cqtdeployer.exe or cqtdeployer.bat>'
${libDirPath}      = '<path to "%B4X_DEP_PATH%\lib", contains all 3rd party dll files>'
${deployDirPath}   = '<path to the directory contains deployed files>'

# For Inno Setup
${isccPath}             = "<path to Inno Setup's ISCC.exe>"
${issCompression}       = '<https://jrsoftware.org/ishelp/topic_setup_compression.htm>'
${issInstallerFilePath} = '<path to generated Inno Setup installer>'

# For Enigma Virtual Box
${enigmavbconsolePath}  = "<path to Enigma Virtual Box's enigmavbconsole.exe>"
${doesEvbCompressFiles} = "does Enigma Virtual Box compress files: $true or $false"
${evbBoxFilePath}       = '<path to generated Enigma Virtual Box boxed exe>'
```

I'm using hashtable to reduce the line length of the code. Check out the documents:

- [about_Hash_Tables - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_hash_tables)
- [Everything you wanted to know about hashtables - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-hashtable)

#### Deployment script

```powershell
$cqtParams = @{
    CQTDEPLOYER_PATH = ${cqtdeployerPath}
    LIB_DIR_PATH     = ${libDirPath}
    TARGET           = ${target}
    INSTALL_ROOT     = ${installRoot}

    DEPLOY_DIR_PATH  = ${deployDirPath}
}

& '.\deploy\call_cqtdeployer.ps1' @cqtParams
```

#### Packaging scripts

##### Inno Setup

```powershell
$issParams = @{
    ISCC_PATH               = ${isccPath}
    ISS_COMPRESSION         = ${issCompression}
    TARGET                  = ${target}
    DEPLOY_DIR_PATH         = ${deployDirPath}

    ISS_INSTALLER_FILE_PATH = ${issInstallerFilePath}
}

& '.\package\call_iscc.ps1' @issParams
```

##### Enigma Virtual Box

```powershell
$evbParams = @{
    ENIGMAVBCONSOLE_PATH    = ${enigmavbconsolePath}
    DOES_EVB_COMPRESS_FILES = ${doesEvbCompressFiles}
    TARGET                  = ${target}
    DEPLOY_DIR_PATH         = ${deployDirPath}

    EVB_BOX_FILE_PATH       = ${evbBoxFilePath}
}

& '.\package\call_evbconsole.ps1' @evbParams
```

## Common code snippets

### Splatting

Source:

- [about_Splatting - PowerShell | Microsoft Docs](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting)
- [Use Splatting to Simplify Your PowerShell Scripts | Scripting Blog](https://devblogs.microsoft.com/scripting/use-splatting-to-simplify-your-powershell-scripts/)

```powershell
$hashTable = @{
    foo = 'bar'
}

Invoke-Cmdlet @hashTable
```

### Show all incoming parameters

Source: [about_Automatic_Variables - PowerShell | Microsoft Docs § $PSBoundParameters](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables#psboundparameters)

```powershell
$PSBoundParameters | Format-List
```

### Execute programs with call operator (&)

Source:

- [Call operator - Run - PowerShell - SS64.com](https://ss64.com/ps/call.html)
- [Powershell executable isn&#39;t outputting to STDOUT - Stack Overflow](https://stackoverflow.com/questions/51333183/powershell-executable-isnt-outputting-to-stdout)

```powershell
& 'foo' 'bar'
```

### Get temperary file with specific extension

Source: [Temporary file with given extension. | IT Pro PowerShell experience](https://becomelotr.wordpress.com/2011/11/29/temporary-file-with-given-extension/)

```powershell
${tempFile} = `
    [IO.Path]::GetTempFileName() | `
    Rename-Item -PassThru -NewName { $_ -replace @('\.tmp$', '.ext') }
```

## Credits

Projects:

- [QuasarApp/CQtDeployer](https://github.com/QuasarApp/CQtDeployer)
- [Inno Setup - jrsoftware](https://jrsoftware.org/isinfo.php)
- [idleberg.innosetup - Inno Setup - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=idleberg.innosetup)
- [alefragnani.pascal - Pascal - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=alefragnani.pascal)
- [kira-96/Inno-Setup-Chinese-Simplified-Translation](https://github.com/kira-96/Inno-Setup-Chinese-Simplified-Translation)
- [Enigma Virtual Box](https://www.enigmaprotector.com/en/aboutvb.html)

Documentation:

- [PowerShell commands - PowerShell - SS64.com](https://ss64.com/ps/)
- [Free Pascal - Advanced open source Pascal compiler for Pascal and Object Pascal - Home Page.html](https://www.freepascal.org/)
- [Pascal Tutorial - Tutorialspoint](https://www.tutorialspoint.com/pascal/)
