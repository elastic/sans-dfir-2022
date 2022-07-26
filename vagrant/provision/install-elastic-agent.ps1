
$STACK_VER = if ($env:ELASTIC_STACK_VERSION) { $env:ELASTIC_STACK_VERSION } else { "8.3.2" };
$ENROLLMENT_URL = if ($env:ENROLLMENT_URL) { $env:ENROLLMENT_URL } else { throw "Must set ENROLLMENT_URL environment variable!" };
$ENROLLMENT_TOKEN = if ($env:ENROLLMENT_TOKEN ) { $env:ENROLLMENT_TOKEN } else { throw "Must set ENROLLMENT_TOKEN environment variable!" };

### Configure Elastic Agent on host ###################################

$elastic_agent_url = "https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-${STACK_VER}-windows-x86_64.zip"
$agent_install_folder = "C:\Program Files"
$install_dir = "C:\Agent"

if (!(Test-Path $install_dir)) {
    New-Item -Path $install_dir -Type directory | Out-Null
}
if (!(Test-Path $agent_install_folder)) {
    New-Item -Path $agent_install_folder -Type directory | Out-Null
}

Write-Output "Downloading Elastic Agent"
Invoke-WebRequest -UseBasicParsing -Uri $elastic_agent_url -OutFile "${install_dir}\elastic-agent-${STACK_VER}-windows-x86_64.zip" -Resume

Write-Output "Installing Elastic Agent..."
Write-Output "Unzipping Elastic Agent from $agent_install_folder\elastic-agent-${STACK_VER}-windows-x86_64.zip to $agent_install_folder"
Expand-Archive -Force -LiteralPath "${install_dir}\elastic-agent-${STACK_VER}-windows-x86_64.zip" -DestinationPath "$agent_install_folder"

Rename-Item -Force "$agent_install_folder\elastic-agent-${STACK_VER}-windows-x86_64" "$agent_install_folder\Elastic-Agent"

Write-Output "Running enroll process of Elastic Agent with token: ${ENROLLMENT_TOKEN}"
Set-Location 'C:\Program Files\Elastic-Agent'
.\elastic-agent.exe install -f --url="${ENROLLMENT_URL}" --enrollment-token="${ENROLLMENT_TOKEN}"

# Ensure Elastic Agent is started
if ((Get-Service "Elastic Agent") -eq "Stopped") {
    Write-Output "Starting Agent Service"
    Start-Service "Elastic Agent"
}
