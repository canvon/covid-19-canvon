if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
}

TitleSuffix = " (logarithmic scale)"
call '../common/include/hook.gnuplot' 'append' 'PreplotHook' "set logscale y"
call 'examples/2.1-total_confirmed_cases.gnuplot'
