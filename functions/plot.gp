set title "OdroidBOT Estatísticas dos Comandos"

set terminal png
set output "/tmp/003.png"

set style fill solid
set boxwidth 0.75 border -1

set border 2

set xlabel "Comandos Executados"
set ylabel "Número de Vezes Executados"
plot "/home/odroid/odroid-contas/functions/test.dat" using 2: xtic(1) with histogram
