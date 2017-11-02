package Conf;
$Conf::char='#';		# command char, don't forget to update
$Conf::sep=';';			# Command separator, cannot be changed at runtime
$Conf::defprompt=""; 		# default prompt when the client is not
$Conf::incolor=3;		# user input color, be sure to call
$Conf::iccolor=8;		# control chars color
$Conf::icbg=7;			# control chars background
$Conf::statusbg=0;		# status line background
$Conf::statusfg=8;		# status line default foreground
$Conf::send_verbose=0;		# display all text that gets sent to the server
$Conf::verbose=0;		# display various sucky messages
$Conf::status_type=2;		# status line position
$Conf::status_height=1;		# number of status lines
$Conf::save_stuff=0;		# automatically save triggers, aliases, keybindings,
$Conf::ansi_log=0;		# write ansi escapes into logs if true
$Conf::speedwalk_delay=0;	# delay for 5 rooms
$Conf::logsub=1;		# log lines _after_ substitutions take place
$Conf::skipws=0;		# ignore whitespace at start of command when searching
$Conf::timedlog=0;		# timestamp each logged line
$Conf::prefixall=0;		# prefix ALL commands, even from triggers and aliases
$Conf::hideinput=1;		# don't copy input line to main window when processing newline
$Conf::fullinput=1;		# don't truncate the input line and prompt when copying

$Conf::windows= $^O eq "MSWin32";		#windows system ?

$Conf::config_name = 'kcir';
$Conf::config_version = '3.4.1';
if ($Conf::windows)
{
	$Conf::mmc_folder = "C:\\mmc_kcir3.4.1";
	$Conf::config_rc_folder = "$mmc_folder\\config\\";
	$Conf::config_rc_proxy_file = "$config_rc_folder\\proxy";
	$Conf::tables_rc_proxy_file = "$config_rc_folder\\tables";
	$Conf::logs_folder = "$mmc_folder\\logs\\";
	$Conf::pk_file = "$config_rc_folder\\pkl";
}
else
{
	$Conf::mmc_folder = "$ENV{HOME}/mmc";
	$Conf::config_rc_folder = "$mmc_folder/config/";
	$Conf::config_rc_proxy_file = "$config_rc_folder/proxy";
	$Conf::tables_rc_proxy_file = "$config_rc_folder/tables";
	$Conf::logs_folder = "$mmc_folder/logs/";
	$Conf::pk_file = "$config_rc_folder/pkl";
}

$Conf::config_modules_folder = $Conf::mmc_folder;
$Conf::connect_delay = 2000;
$Conf::public_server_out = "adsoft.cea.ru:3000";
$Conf::public_server_in = "adsoft.cea.ru:3001";

1;
