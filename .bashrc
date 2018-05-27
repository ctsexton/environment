#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
export PATH=${HOME}/bin:${PATH}
export PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"

# clone the current terminal window
clone () { 
	for ((i=0;i<$1;i++)) 
	do 
		nohup alacritty &
	done
}

# set up JACK for onboard sound
jack_setup () {
	if [ "$1" == "onboard" ]; then
		jack_control dps device hw:PCH,0
		jack_control dps rate 48000
		jack_control dps period 256
		jack_control dps inchannels 2
		jack_control dps outchannels 2
	else
		jack_control dps device hw:AVB,0
		jack_control dps rate 48000
		jack_control dps period 128
		jack_control dps inchannels 24
		jack_control dps outchannels 24
	fi
}

# setup motu ultralite direct networking over ethernet
ultra_net () {
	interface=$(ip link | sed -n 's/.*\(enp0s.*\):.*/\1/p')
	ip link set $interface up
	ip address add 169.254.12.237 dev $interface
	ip route add 169.254.12.238 dev $interface
	echo "interface $interface connected and ultralite set up"
}

# start second display
second_display () {
	xrandr --output DP2 --auto --right-of eDP1
}

# mount a hdd
dmount () {
	lsblk -f 
	echo "Carefully type the device label and mount point"
	read -p 'Device Label: ' device_label
	read -p 'Mount point: ' mount_point
	sudo mount -o gid=users -L "$device_label" "$mount_point"
}
