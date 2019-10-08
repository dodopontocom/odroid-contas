set title "OdroidBOT Estatísticas dos Comandos"

set terminal png
set output "${GNU_PLOT_IMAGE_OUTPUT}"

set style fill solid border -1
set boxwidth 0.8

set object 1 rectangle from screen 0,0 to screen 1,1 fillcolor rgb"gray" behind

set xlabel "Comandos Executados"
set ylabel "Número de Vezes Executados"
set xtics rotate by -45

plot "${GNU_PLOT_DAT}" using 2: xtic(1) with histogram notitle
