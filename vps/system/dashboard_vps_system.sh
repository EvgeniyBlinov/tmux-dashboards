#!/usr/bin/env bash
# vim: set noet ci pi sts=0 sw=4 ts=4 :
set -euC
SCRIPT_PATH=`dirname $0`
DASHBOARD_PATH=`readlink -m ${SCRIPT_PATH}`
TMUX_SESSION_NAME=${TMUX_SESSION_NAME:-$(basename $0 .sh|cut -d _ -f 2-)}
########################################################################
REQUIRE_BIN_UTILS="tmux htop watch grep sort awk"
########################################################################
WINDOW_L1_CMD=${WINDOW_L1_CMD:-"htop"}
WINDOW_L2_C1_CMD="watch -n 20 'df -h|cut -c -60'"
WINDOW_L2_C2_CMD="watch -n 10 $DASHBOARD_PATH/assets/ssh_auth_ip.sh"
WINDOW_L2_C3_CMD="watch -n 10 $DASHBOARD_PATH/assets/docker_ps_short.sh"
########################################################################

function att {
	[ -n "${TMUX:-}" ] &&
		tmux switch-client -t "=${TMUX_SESSION_NAME}" ||
		tmux attach-session -t "=${TMUX_SESSION_NAME}"
}

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
	tmux kill-session -t $TMUX_SESSION_NAME
}

########################################################################
function _run {
	#if tmux has-session -t "=${TMUX_SESSION_NAME}" 2> /dev/null; then
		#att
		#exit 0
	#fi

	#tmux -2 new-session -d -s $TMUX_SESSION_NAME

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
				tmux send-keys "$WINDOW_L2_C2_CMD" C-m
					tmux split-window -h
						tmux select-pane -t 4
						tmux resize-pane -L 40
						tmux send-keys "$WINDOW_L2_C3_CMD" C-m

	#att
}
########################################################################
case "${1:-run}" in
	test|kill) _${1};;
	*) _test && _run ;;
esac
