Add-Type -AssemblyName System.Windows.Forms

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
            X = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width*.25;
            Y = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height*.25;
        }; 
    };
    Button = @{ 
        TextColour = "#000000";
        Size = @{
            X = 30
            Y = 30
        }; 
    };
    DefaultDownloadURLConfig = "http://127.0.0.1/content.json";
}

$formHeader = ($config.Info.Name + " (" + $config.Info.Abbr + ")" + " " + $config.Info.Version + "-" + $config.Info.State)



function loadMasterForm(){
    $masterForm = New-Object system.Windows.Forms.Form

    $masterForm.ClientSize = ([string]$config.Form.Size.X + "," + [string]$config.Form.Size.Y)
    $masterForm.FormBorderStyle = "FixedDialog"
    $masterForm.text = $formHeader
    $masterForm.BackColor = $config.Form.BackgroundColour


    $applicationInstallButton = New-Object system.Windows.Forms.Button
    $applicationInstallButton.ForeColor = $config.Button.TextColour
    $applicationInstallButton.text = "Install Applications"
    $applicationInstallButton.width = [Int]$config.Form.Size.X - 10
    $applicationInstallButton.height = $config.Button.Size.Y
    $applicationInstallButton.location = New-Object System.Drawing.Point(5,5)
    $applicationInstallButton.Font = 'Microsoft Sans Serif,10'
    $applicationInstallButton.Add_Click({ loadDaughterForm("Applications") })
    $masterForm.Controls.Add($applicationInstallButton)


    $domainJoinButton = New-Object system.Windows.Forms.Button
    $domainJoinButton.ForeColor = $config.Button.TextColour
    $domainJoinButton.text = "Domain Controls"
    $domainJoinButton.width = [Int]$config.Form.Size.X - 10
    $domainJoinButton.height = $config.Button.Size.Y
    $domainJoinButton.location = New-Object System.Drawing.Point(5,40)
    $domainJoinButton.Font = 'Microsoft Sans Serif,10'
    $domainJoinButton.Add_Click({ loadDaughterForm("Domain") })
    $masterForm.Controls.Add($domainJoinButton)

    [void]$masterForm.ShowDialog()
}

function loadDaughterForm($option){

    $daughterForm = New-Object system.Windows.Forms.Form

    switch($option){
        "Applications"{
            $applicationURLsHT = @{}
            $applicationURLsPSO = Invoke-RestMethod -Method Get -ContentType 'application/json' -Uri $config.DefaultDownloadURLConfig
            $applicationURLsPSO.psobject.properties | Foreach { $applicationURLsHT[$_.Name] = $_.Value }

            $daughterForm.ClientSize = ([string]([Math]::Round([int]$config.Form.Size.X*0.45,0)) + "," + [string](([Math]::Round([int]$config.Form.Size.Y*0.75,0))+35))
            $daughterForm.FormBorderStyle = "FixedDialog"
            $daughterForm.text = $formHeader + " " + $option
            $daughterForm.BackColor = $config.Form.BackgroundColour

            $scrollableControl = New-Object System.Windows.Forms.ScrollableControl
            $scrollableControl.Size = New-Object System.Drawing.Size(([Math]::Round([int]$config.Form.Size.X*0.45,0)),([Math]::Round([int]$config.Form.Size.Y*0.75,0)))
            $scrollableControl.Location = New-Object System.Drawing.Point(5, 35)
            $scrollableControl.AutoScroll = $true

            $checkboxPanel = New-Object System.Windows.Forms.Panel
            $checkboxPanel.AutoSize = $true

            $applicationCheckbox = @{}
            $firstRun = 0
            foreach($application in $applicationURLsHT.keys){
                $applicationCheckbox[[string]$application] = New-Object System.Windows.Forms.CheckBox
                $applicationCheckbox[[string]$application].location = New-Object System.Drawing.Point(5,$firstRun)
                $applicationCheckbox[[string]$application].text = $application
                $checkboxPanel.Controls.Add($applicationCheckbox[[string]$application])
                $firstRun += 22
            }
            $scrollableControl.Controls.Add($checkboxPanel)

            $installButton = New-Object system.Windows.Forms.Button
            $installButton.ForeColor = $config.Button.TextColour
            $installButton.text = "Install Selected"
            $installButton.width = [Int]$daughterForm.Width - 15
            $installButton.height = $config.Button.Size.Y
            $installButton.location = New-Object System.Drawing.Point(5,5)
            $installButton.Font = 'Microsoft Sans Serif,10'
            $installButton.Add_Click({ loadDaughterForm("Applications") }) #NEEDS CORRECTING

            $daughterForm.Controls.Add($installButton)
            $daughterForm.Controls.Add($scrollableControl)
        }

        "Domain"{
            $daughterForm.ClientSize = ([string]([Math]::Round([int]$config.Form.Size.X*0.45,0)) + ",75")
            $daughterForm.FormBorderStyle = "FixedDialog"
            $daughterForm.text = $formHeader + " " + $option
            $daughterForm.BackColor = $config.Form.BackgroundColour

            $domainLeaveButton = New-Object system.Windows.Forms.Button
            $domainLeaveButton.ForeColor = $config.Button.TextColour
            $domainLeaveButton.text = "Leave Domain"
            $domainLeaveButton.width = [Int]$daughterForm.Width - 15
            $domainLeaveButton.height = $config.Button.Size.Y
            $domainLeaveButton.location = New-Object System.Drawing.Point(5,5)
            $domainLeaveButton.Font = 'Microsoft Sans Serif,10'
            $domainLeaveButton.Add_Click({ loadDaughterForm("Applications") }) #NEEDS CORRECTING

            $domainJoinButton = New-Object system.Windows.Forms.Button
            $domainJoinButton.ForeColor = $config.Button.TextColour
            $domainJoinButton.text = "Join Domain"
            $domainJoinButton.width = [Int]$daughterForm.Width - 15
            $domainJoinButton.height = $config.Button.Size.Y
            $domainJoinButton.location = New-Object System.Drawing.Point(5,40)
            $domainJoinButton.Font = 'Microsoft Sans Serif,10'
            $domainJoinButton.Add_Click({ loadDaughterForm("Applications") }) #NEEDS CORRECTING


            $daughterForm.Controls.Add($domainLeaveButton)
            $daughterForm.Controls.Add($domainJoinButton)
        }
    }

    [void]$daughterForm.ShowDialog()
}













loadMasterForm
