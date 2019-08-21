set output "/tmp/003.png"
set terminal png

set style fill solid
set boxwidth 0.5

set xlabel "Comandos Executados"
set ylabel "Número de Vezes Executados"
plot "/home/odroid/odroid-contas/functions/test.dat" using 1:2 with boxes
