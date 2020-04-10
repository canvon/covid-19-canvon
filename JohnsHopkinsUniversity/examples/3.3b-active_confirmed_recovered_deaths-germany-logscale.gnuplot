if (!exists("CommonLoaded") || CommonLoaded == 0) {
  load '../common/include/common.gnuplot'
}
if (!exists("JHULoaded") || JHULoaded == 0) {
  load 'include/jhu.gnuplot'
}

TitleSuffix = " (logarithmic scale)"
call '../common/include/hook.gnuplot' 'append' 'PreplotHook' "set logscale y"
call 'examples/3.3-active_confirmed_recovered_deaths-germany.gnuplot'
