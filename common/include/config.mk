export TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

# On my system, according to fontconfig, Arial maps to Liberation Sans,
# whereas Sans maps to DejaVu which seems to be a very bad default, here.
# (Every character is too wide, texts won't fit where they belong, ...)
export C19C_GNUPLOT_TERMINAL := pngcairo font "Arial,12"
