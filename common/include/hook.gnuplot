# hook.gnuplot - This gnuplot include file is for
# setting, manipulating and running hooks, e.g., PreplotHook.

HookUsage = "Usage: call 'hook.gnuplot' { 'clear' | 'set' | 'prepend' | 'append' | 'run' } HookName [Value]"

if (!(ARGC >= 1)) { exit error "Sub-command missing.\n".HookUsage }
if (!(ARGC >= 2)) { exit error "Hook name missing.\n".HookUsage }
if (ARG1 ne 'run' && ARG1 ne 'clear') {
	if (!(ARGC >= 3)) { exit error "Value missing.\n".HookUsage }
	if (ARGC > 3) { exit error "Trailing arguments.\n".HookUsage }
} else {
	if (ARGC > 2) { exit error "Trailing arguments.\n".HookUsage }
}

# Avoid errors due to the hook not having been set at all...
if (!exists(ARG2)) { @ARG2 = "" }

if          (ARG1 eq 'run')     { eval value(ARG2)
} else { if (ARG1 eq 'clear')   { @ARG2 = ""
} else { if (ARG1 eq 'set')     { @ARG2 = ARG3
} else { if (ARG1 eq 'prepend') { @ARG2 = ARG3.'; '.value(ARG2)
} else { if (ARG1 eq 'append')  { @ARG2 = value(ARG2).'; '.ARG3
} else { exit error sprintf("Invalid sub-command '%s'\n", ARG1).HookUsage }
}}}}
