# terminal.gnuplot - This gnuplot include file is used to
# setup different terminals in a common way.

TerminalUsage = "Usage: call 'terminal.gnuplot' TERMINAL [OUTPUT]"

if (!(ARGC >= 1)) { exit error "Missing TERMINAL argument.\n".TerminalUsage }
set terminal @ARG1 size 1024,768

if (!(ARGC >= 2)) { exit }
set output ARG2

if (ARGC >= 3) { exit error "Trailing arguments.\n".TerminalUsage }
