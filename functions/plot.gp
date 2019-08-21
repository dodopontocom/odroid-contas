set output "/tmp/003.png"
set terminal png

set style fill solid
set boxwidth 1.5

set xlabel "Comandos Executados"
set ylabel "Número de Vezes Executados"
plot "/home/odroid/odroid-contas/functions/test.dat" using 2: xtic(1) with boxes
