#region Author-Info
########################################################################################################################## 
# Author: Zewwy (Aemilianus Kehler)
# Date:   Feb 19, 2019
# Script: Clear-ExchangeLogs
# This script allows to clear the Exchange server logs.
# 
# Required parameters: 
#   Permissions on the folders and files of the Exchange Front End which holds the log files 
##########################################################################################################################
#endregion
#region Variables
##########################################################################################################################
#   Variables
##########################################################################################################################
#MyLogoArray
$MylogoArray = @(
    ("              This script is brought to you by:              "),
    ("      ___         ___         ___         ___                "),
    ("     /  /\       /  /\       /__/\       /__/\        ___    "),
    ("    /  /::|     /  /:/_     _\_ \:\     _\_ \:\      /__/|   "),
    ("   /  /:/:|    /  /:/ /\   /__/\ \:\   /__/\ \:\    |  |:|   "),
    ("  /  /:/|:|__ /  /:/ /:/_ _\_ \:\ \:\ _\_ \:\ \:\   |  |:|   "),
    (" /__/:/ |:| //__/:/ /:/ //__/\ \:\ \:/__/\ \:\ \:\__|__|:|   "),
    (" \__\/  |:|/:\  \:\/:/ /:\  \:\ \:\/:\  \:\ \:\/:/__/::::\   "),
    ("     |  |:/:/ \  \::/ /:/ \  \:\ \::/ \  \:\ \::/\__\\~~\:\  "),
    ("     |  |::/   \  \:\/:/   \  \:\/:/   \  \:\/:/      \  \:\ "),
    ("     |  |:/     \  \::/     \  \::/     \  \::/        \__\/ "),
    ("     |__|/       \__\/       \__\/       \__\/               "),
    (" ")
)
#Script Definition
$ScriptName = "Clear-ExhcangeLogs; cause sometimes; Logs."
$LogScript = @(
("   _________________________________________                "),
("  /                                         \               "),
(" | What?! Logs have taken up all your hard   |              "),
(" | drive space on your server?!?!?!!!!!!     |              "),
("  \_________________________________________/               "),
("         \                                                  "),
(" ")
)

#Script Variables, known log locations of Exhange Server
$IISLogPath="C:\inetpub\logs\LogFiles\"
$ExchangeLoggingPath="C:\Program Files\Microsoft\Exchange Server\V15\Logging\"
$ETLLoggingPath="C:\Program Files\Microsoft\Exchange Server\V15\Bin\Search\Ceres\Diagnostics\ETLTraces\"
$ETLLoggingPath2="C:\Program Files\Microsoft\Exchange Server\V15\Bin\Search\Ceres\Diagnostics\Logs"

#------------------------------------------------------------------------------------------------------------------------
#Static Variables
#------------------------------------------------------------------------------------------------------------------------
$pswheight = (get-host).UI.RawUI.MaxWindowSize.Height
$pswwidth = (get-host).UI.RawUI.MaxWindowSize.Width
#endregion
#region Functions
##########################################################################################################################
#   Functions
##########################################################################################################################

#function takes in a name to alert confirmation of an action
function confirm()
{
  param(
  [Parameter(Position=0,Mandatory=$true)]
  [string]$name,
  [Parameter(Position=1,Mandatory=$false,ParameterSetName="color")]
  [string]$C
  )
    Centeralize "$name" "$C" -NoNewLine;$answer = Read-Host;Write-Host " "
    Switch($answer)
    {
        yes{$result=0}
        ye{$result=0}
        y{$result=0}
        no{$result=1}
        n{$result=1}
        default{confirm $name $C}
    }
    Switch ($result)
        {
              0 { Return $true }
              1 { Return $false }
        }
}

#Function to Centeralize Write-Host Output, Just take string variable parameter and pads it
function Centeralize()
{
  param(
  [Parameter(Position=0,Mandatory=$true)]
  [string]$S,
  [Parameter(Position=1,Mandatory=$false,ParameterSetName="color")]
  [string]$C,
  [Parameter(Mandatory=$false)]
  [switch]$NoNewLine = $false
  )
    $sLength = $S.Length
    $padamt =  "{0:N0}" -f (($pswwidth-$sLength)/2)
    $PadNum = $padamt/1 + $sLength #the divide by one is a quick dirty trick to covert string to int
    $CS = $S.PadLeft($PadNum," ").PadRight($PadNum," ") #Pad that shit
    if (!$NoNewLine)
    {
        if ($C) #if variable for color exists run below
        {    
            Write-Host $CS -ForegroundColor $C #write that shit to host with color
        }
        else #need this to prevent output twice if color is provided
        {
            $CS #write that shit without color
        }
    }
    else
    {
        if ($C) #if variable for color exists run below
        {    
            Write-Host $CS -ForegroundColor $C -NoNewLine #write that shit to host with color
        }
        else #need this to prevent output twice if color is provided
        {
            Write-Host $CS -NoNewLine #write that shit without color
        }
    }
}

Function CleanLogFiles($TargetFolder)
{
    if (Test-Path $TargetFolder) {
        try
        {
            $Files = Get-ChildItem $TargetFolder -Recurse -ErrorAction Stop # | Where-Object {$_.Name -like "*.log" -or $_.Name -like "*.blg" -or $_.Name -like "*.etl"}  | where {$_.lastWriteTime -le "$lastwrite"} | Select-Object FullName  
        }
        catch [System.UnauthorizedAccessException]
        {
            $ErrorMessage = $_.Exception.Message
            Centeralize "Message is: $ErrorMessage `n" "red"
            Centeralize "Please Check your permissions! Maybe run Exchange mgmt shell as an admin? `n" "Yellow"
        }
        if (confirm "Delete $TargetFolder logs? " "red")
        {

            Remove-item -Recurse $TargetFolder -ErrorAction SilentlyContinue
         }   
    }
    Else 
    {
        Write-Host "The folder $TargetFolder doesn't exist! Check the folder path!" -ForegroundColor "red"
    }
}
#endregion
#region Run

#region DisplayLogo
#Start actual script by posting and asking user for responses
foreach($L in $MylogoArray){Centeralize $L "green"}
Centeralize $ScriptName "White"
foreach($L in $LogScript){Centeralize $L "white"}
#endregion
#GO

CleanLogfiles($IISLogPath)
CleanLogfiles($ExchangeLoggingPath)
CleanLogfiles($ETLLoggingPath)
CleanLogfiles($ETLLoggingPath2)



#endregion
