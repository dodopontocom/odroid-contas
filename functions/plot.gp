set title "OdroidBOT Estatísticas dos Comandos"

set terminal png
set output "/tmp/003.png"

set style fill solid border -1
set boxwidth 0.8

set xlabel "Comandos Executados"
set ylabel "Número de Vezes Executados"
set xtics rotate by -45

plot "/home/odroid/odroid-contas/functions/test.dat" using 2: xtic(1) with histogram notitle
