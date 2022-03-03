
function buildVS
{
    param
    (
        [parameter(Mandatory=$true)]
        [String] $path,

        [parameter(Mandatory=$false)]
        [bool] $nuget = $true,
        
        [parameter(Mandatory=$false)]
        [bool] $clean = $true
    )
    process
    {
        $latestVisualStudioPath = Get-VSSetupInstance | Select-VSSetupInstance -Latest | Select-Object -ExpandProperty InstallationPath

        echo $latestVisualStudioPath

        $msBuildPath = $latestVisualStudioPath + '\MSBuild\Current\Bin\MSBuild.exe'

        echo $msBuildPath

        if ($nuget) {
            Write-Host "Restoring NuGet packages" -foregroundcolor green
            & "$($msBuildPath)" "$($path)" /t:Restore /m

            # nuget restore "$($path)"
        }

        if ($clean) {
            Write-Host "Cleaning $($path)" -foregroundcolor green
            & "$($msBuildPath)" "$($path)" /t:Clean /m
        }

        Write-Host "Building $($path)" -foregroundcolor green
        & "$($msBuildPath)" "$($path)" /t:Build /m
    }
}

# Install-PackageProvider -Name nuget -RequiredVersion 2.8.5.201 -Force -Scope CurrentUser

# Get-PackageProvider -ListAvailable

# Import-PackageProvider -Name nuget -RequiredVersion 2.8.5.201

$childAPath = $PSScriptRoot + '\GitSubmodules-ChildA\GitSubmodulesApi-ChildA\GitSubmodulesApi-ChildA.sln';
$childBPath = $PSScriptRoot + '\GitSubmodules-ChildA\GitSubmodulesApi-ChildA\GitSubmodulesApi-ChildB.sln';

buildVS $childAPath -nuget $true -clean $false
buildVS $childBPath -nuget $true -clean $false

pause

