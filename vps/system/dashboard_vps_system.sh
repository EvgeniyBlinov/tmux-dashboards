#!/bin/bash
# vim: set noet ci pi sts=0 sw=4 ts=4 :
SCRIPT_PATH=`dirname $0`
DASHBOARD_PATH=`readlink -m ${SCRIPT_PATH}`
SESSION_NAME=${SESSION_NAME:-$(basename $0 .sh|cut -d _ -f 2-)}
########################################################################
REQUIRE_BIN_UTILS="tmux htop watch grep sort awk"
########################################################################
WINDOW_L1_CMD=${WINDOW_L1_CMD:-"htop"}
WINDOW_L2_C1_CMD="watch -n 20 'df -h|cut -c -60'"
WINDOW_L2_C2_CMD="watch -n 10 $DASHBOARD_PATH/assets/ssh_auth_ip.sh"
########################################################################

function _error {
	echo "$1"
	exit ${2:-"1"}
}
function _test {
	for bu in $REQUIRE_BIN_UTILS; do
		which $bu 1> /dev/null || _error "${bu} required!"
	done
	echo "Done"
}

function _kill {
	tmux kill-session -t $SESSION_NAME
}

########################################################################
function _run {
	tmux -2 new-session -d -s $SESSION_NAME

	tmux split-window -v
		tmux select-pane -t 1
		tmux resize-pane -U 7
		tmux send-keys "$WINDOW_L1_CMD" C-m

		tmux select-pane -t 2
			tmux split-window -h
				tmux select-pane -t 2
				tmux resize-pane -L 35
				tmux send-keys "$WINDOW_L2_C1_CMD" C-m

				tmux select-pane -t 3
					tmux split-window -h
						tmux select-pane -t 3
						tmux send-keys "$WINDOW_L2_C2_CMD" C-m
}
########################################################################
case "$1" in
	test|kill) _${1};;
	*) _test && _run ;;
esac
