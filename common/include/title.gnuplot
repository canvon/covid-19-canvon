# title.gnuplot - This gnuplot include file is used to
# set the title of the plot, from the environment.

NewTitle = ""

if (exists("TitleBase"))   { NewTitle = TitleBase }
if (exists("TitleSuffix")) { NewTitle = NewTitle.TitleSuffix }
if (exists("TitlePrefix")) { NewTitle = TitlePrefix.NewTitle }

if (strlen(NewTitle) > 0) {
	set title NewTitle
} else {
	unset title
}
