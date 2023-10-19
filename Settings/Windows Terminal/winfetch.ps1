# ===== WINFETCH CONFIGURATION =====
# $image = "wallpaper"
$image = "G:\Mi unidad\Devoteam\Icon.png"
# $noimage = $true
# Display image using ASCII characters
# $ascii = $true
# Set the version of Windows to derive the logo from.
# $logo = "Windows 11"
# Specify width for image/logo
$imgwidth = 23
# Specify minimum alpha value for image pixels to be visible
# $alphathreshold = 50
# Custom ASCII Art
# This should be an array of strings, with positive
# height and width equal to $imgwidth defined above.
# $CustomAscii = @(
# 	"   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣦"
# 	"⠀⠀⠀⠀⠀⠀⠀⠀⢠⣶⣶⣾⣷⣶⣆⠸⣿⣿⡟"
# 	"⠀⠀⠀⠀⠀⣠⣾⣷⡈⠻⠿⠟⠻⠿⢿⣷⣤⣤⣄"
# 	"⠀⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣦"
# 	"⢀⣤⣤⡘⢿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⡇"
# 	"⣿⣿⣿⡇⢸⣿⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣉⣉⡁"
# 	"⠈⠛⠛⢡⣾⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⡇"
# 	"⠀⠀⠀⠀⠻⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⠟"
# 	"⠀⠀⠀⠀⠀⠙⢿⡿⢁⣴⣶⣦⣴⣶⣾⡿⠛⠛⠋"
# 	"⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⠿⢿⡿⠿⠏⢰⣿⣿⣧"
# 	"     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⠟"
# )
$CustomAscii = @(
	"`e[91m    ⢀⣠⣤⣤⣤⣤⣤⣤⣄⡀"
	"  ⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄"
	" ⣼⣿⣿⣿⣿⣿⣿⣿   ⣿⣿⣿⣿⣧"
	"⢸⣿⣿⣿⣿⣿⣿⣿⣿   ⣿⣿⣿⣿⣿⡇"
	"⢸⣿⣿⣿⠏   ⠙      ⣿⣿⡇"
	"⠸⣿⣿⣿   ⣼⣿   ⣿⣿⣿⣿⣿⡇"
	" ⢻⣿⣿   ⢿⣿   ⣿⣿⣿⣿⣿⠃"
	"  ⠻⣿⣆⡀      ⣿⣿⣿⣿⡟"
	"    ⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⠟⠋`e[39m"
)
# Make the logo blink
$blink = $true
# Display all built-in info segments.
# $all = $true
# Add a custom info line
# function info_custom_time {
#     return @{
#         title = "Time"
#         content = (Get-Date)
#     }
# }
# Configure which disks are shown
$ShowDisks = @("C:")
# Show all available disks
# $ShowDisks = @("*")
# Configure which package managers are shown
# disabling unused ones will improve speed
$ShowPkgs = @("winget")
# Use the following option to specify custom package managers.
# Create a function with that name as suffix, and which returns
# the number of packages. Two examples are shown here:
# $CustomPkgs = @("cargo", "just-install")
# function info_pkg_cargo {
#     return (cargo install --list | Where-Object {$_ -like "*:" }).Length
# }
# function info_pkg_just-install {
#     return (just-install list).Length
# }
# Configure how to show info for levels
# Default is for text only.
# 'bar' is for bar only.
# 'textbar' is for text + bar.
# 'bartext' is for bar + text.
$cpustyle = "bartext"
$memorystyle = "bartext"
$diskstyle = "bartext"
$batterystyle = "bartext"
# Remove the '#' from any of the lines in
# the following to **enable** their output.
@(
	# "title"
	# "dashes"
	"computer"
	"motherboard"
	"gpu"
	"cpu"
	#"cpu_usage"
	# "resolution"
	"memory"
	"disk"
	"battery"
	# "uptime"
	"blank"
	"os"
	# "pkgs"
	"terminal"
	"kernel"
	"pwsh"
	# "custom_time"  # use custom info line
	# "ps_pkgs"  # takes some time
	# "theme"
	# "locale"
	# "weather"
	# "local_ip"
	# "public_ip"
	# "blank"
	# "colorbar"
)