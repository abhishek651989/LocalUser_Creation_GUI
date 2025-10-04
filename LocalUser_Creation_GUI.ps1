#runas administrator
#This script creates a simple GUI to create local users in Windows.
#It uses Windows Forms to create the GUI and PowerShell cmdlets to create the users.
#Ensure you run this script with administrative privileges to create local users.

#-----Import required Modules-----#
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


#-----Create the Form-----#
$my_form1=New-Object System.Windows.Forms.Form
$my_form1.Text="Local User Management"
$my_form1.Size=New-Object System.drawing.size(800,300)
$my_form1.StartPosition="centerscreen"
$my_form1.BackColor=[System.Drawing.Color]::Black


#-----Create User Creation Section-----#
$lbl_User_Creation=new-object System.Windows.Forms.Label
$lbl_User_Creation.Text="User Creation:"
$lbl_User_Creation.location=new-object system.drawing.point(30,10)
$lbl_User_Creation.AutoSize=$true
$lbl_User_Creation.ForeColor=[System.Drawing.Color]::White
$lbl_User_Creation.Font=New-Object System.Drawing.Font("Calibri",16,[System.Drawing.FontStyle]::Bold)
$my_form1.Controls.Add($lbl_User_Creation)


#-----Create FirstName Label and TextBox-----#
$lbl1_enter_firstname=New-Object System.Windows.Forms.Label
$lbl1_enter_firstname.Text="First Name"
$lbl1_enter_firstname.location=New-Object system.drawing.point(30,40)
$lbl1_enter_firstname.AutoSize=$true
$lbl1_enter_firstname.ForeColor=[System.Drawing.Color]::White
$my_form1.Controls.Add($lbl1_enter_firstname)

$txt1_firstname=new-object System.Windows.Forms.TextBox
$txt1_firstname.Location=New-Object System.Drawing.Point(150,40)
$txt1_firstname.Size=New-Object System.Drawing.Size(150,40)
$txt1_firstname.ForeColor=[System.Drawing.Color]::Black
$my_form1.Controls.Add($txt1_firstname)


#-----Create LastName Label and TextBox-----#
$lbl2_enter_lastname=New-Object System.Windows.Forms.Label
$lbl2_enter_lastname.Text="Last Name"
$lbl2_enter_lastname.location=New-Object System.Drawing.Point(30,70)
$lbl2_enter_lastname.AutoSize=$true
$lbl2_enter_lastname.ForeColor=[System.Drawing.Color]::White
$my_form1.Controls.Add($lbl2_enter_lastname)

$txt2_lastname=new-object System.Windows.Forms.TextBox
$txt2_lastname.location=new-object system.drawing.point(150,70)
$txt2_lastname.size=new-object system.drawing.size(150,60)
$txt2_lastname.ForeColor=[System.Drawing.Color]::Black
$my_form1.Controls.add($txt2_lastname)


#-----Create UserName Label and TextBox-----#
$lbl3_enter_username=New-Object System.Windows.Forms.Label
$lbl3_enter_username.Text="Enter the username"
$lbl3_enter_username.Location=New-Object System.Drawing.Point(30,100)
$lbl3_enter_username.AutoSize=$true
$lbl3_enter_username.ForeColor=[System.Drawing.Color]::White
$my_form1.Controls.Add($lbl3_enter_username)

$txt3_username=new-object System.Windows.Forms.TextBox
$txt3_username.location=New-Object system.drawing.point(150,100)
$txt3_username.size=new-object System.Drawing.Size(150,100)
$txt3_username.ForeColor=[System.drawing.color]::Black  
$my_form1.Controls.Add($txt3_username)


#-----Create Button and Button Click Event-----#
$btn1_createuser=new-object System.Windows.Forms.Button
$btn1_createuser.Text="Create User"
$btn1_createuser.location=new-object System.Drawing.Point(150,130)
$btn1_createuser.size=New-Object System.Drawing.Size(100,40)
$btn1_createuser.ForeColor=[System.Drawing.color]::White
$my_form1.Controls.Add($btn1_createuser)

$btn1_createuser.Add_Click({
    $first_name=$txt1_firstname.Text
    $last_name=$txt2_lastname.Text
    $user_name=$txt3_username.Text
    $password="password@123"
    $secure_password=convertto-securestring $password -asplaintext -force
    
    #Create Local User
    try
    {
        $existing_user=get-localuser -name $user_name -ErrorAction SilentlyContinue
        if($existing_user)
        {
            [System.Windows.Forms.MessageBox]::show("User $user_name already exists. Please choose a different username.")
            $txt1_firstname.Clear()
            $txt2_lastname.Clear()
            $txt3_username.Clear()
            return
        }
        else 
        {
            New-LocalUser `
            -Name $user_name `
            -FullName "$first_name $last_name" `
            -Password $secure_password 
    
            Start-Sleep -Seconds 2
            $check_user=get-localuser -name $user_name
            if($check_user)
            {    
                [System.Windows.Forms.MessageBox]::show("User $user_name created successfully")
            }
            else
            {
                [System.Windows.Forms.MessageBox]::show("User $user_name creation failed")
            }
            $txt1_firstname.clear()
            $txt2_lastname.clear()
            $txt3_username.Clear() 
        }
    }
    catch
    {
        [System.Windows.Forms.MessageBox]::show("Error: $_.Exception.Message")
    }
    

})

#-----Show the Form-----#
[System.Windows.Forms.Application]::run($my_form1)

