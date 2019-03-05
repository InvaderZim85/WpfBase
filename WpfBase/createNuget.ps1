Param
(
    [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The version of the nuget package.", ValueFromPipeline = $true)]
    $version
)

# Function to edit the config file
function SetConfig($file, $key, $value) 
{
    $content = Get-Content $file;

    if ($content -match $key) 
    {
        Write-Host "Edit version in $file to $value";
        $content -replace $key, $value | Set-Content $file;
    }
    else 
    {
        Write-Host "Can't find the specified string. Please try again.";
        throw;
    }
}

# Function to change the version
function ChangeVersion($path) 
{
    SetConfig $path "<version>.*</version>" "<version>$version</version>";
}

# Create the nupkg file
Write-Host "Change version";
ChangeVersion(Resolve-Path "nuget\WpfBase.nuspec");

Write-Host "Create nupkg file";
& "nuget\nuget.exe" pack "nuget\WpfBase.nuspec";

Copy-Item -Path "ZimLabs.WpfBase.$version.nupkg" -Destination "\\diskstation\Programming\nuget" -Force