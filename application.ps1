$config = @{ 
    Info = @{ 
        Version = "v0.0.1";  #Semantic Versioning
        State = "alpha"; #Alpha, Beta, Internal Release, Live Release
        Name = "Lazy Admin Suite";
        Abbr = "LAS";
        Author = "ColonistDeme";

    };
    Form = @{ 
        BackgroundColour = "#ffffff";
        Size = @{
            X = "1250";
            Y = "600";
        }; 
    };
    Button = @{ 
        TextColour = "#000000";
        Size = @{
            X = 90;
            Y = 30;
        }; 
    };
    DefaultDownloadURLConfig = "http://127.0.0.1/content.json";
}

$formHeader = ($config.Info.Name + " (" + $config.Info.Abbr + ")" + " " + $config.Info.Version + "-" + $config.Info.State)

Add-Type -AssemblyName System.Windows.Forms

function loadMasterForm(){
    $masterForm = New-Object system.Windows.Forms.Form

    $masterForm.ClientSize = ($config.Form.Size.X + "," + $config.Form.Size.Y)
    $masterForm.FormBorderStyle = "FixedDialog"
    $masterForm.text = $formHeader
    $masterForm.BackColor = $config.Form.BackgroundColour


    $applicationInstallButton = New-Object system.Windows.Forms.Button
    $applicationInstallButton.FlatAppearance.BorderSize = 0
    $applicationInstallButton.ForeColor = $config.Button.TextColour
    $applicationInstallButton.text = "Install Applications"
    $applicationInstallButton.width = [Int]$config.Form.Size.X - 10
    $applicationInstallButton.height = $config.Button.Size.Y
    $applicationInstallButton.location = New-Object System.Drawing.Point(5,5)
    $applicationInstallButton.Font = 'Microsoft Sans Serif,10'
    $applicationInstallButton.Add_Click({ loadDaughterForm("Applications") })

    $masterForm.Controls.Add($applicationInstallButton)

    [void]$masterForm.ShowDialog()
}

function loadDaughterForm($option){

    $daughterForm = New-Object system.Windows.Forms.Form

    switch($option){
        "Applications"{
            $applicationURLsHT = @{}
            $applicationURLsPSO = Invoke-RestMethod -Method Get -ContentType 'application/json' -Uri $config.DefaultDownloadURLConfig
            $applicationURLsPSO.psobject.properties | Foreach { $applicationURLsHT[$_.Name] = $_.Value }

            $daughterForm.ClientSize = ([string]([Math]::Round([int]$config.Form.Size.X*0.45,0)) + "," + [string]([Math]::Round([int]$config.Form.Size.Y*1.75,0)))
            $daughterForm.FormBorderStyle = "FixedDialog"
            $daughterForm.text = $formHeader + " " + $option
            $daughterForm.BackColor = $config.Form.BackgroundColour

            foreach($application in $applicationURLsHT.keys){
                write-host $application
            }
        }
    }

    [void]$daughterForm.ShowDialog()
}

loadMasterForm
