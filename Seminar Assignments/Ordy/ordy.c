intro:
En aquesta pràctica el que volem és implementar un servei multicast que respecti diferents ordres, com FIFO, causal o total.

1.Cap de les opcions. En aquesta versió bàsica utilitzem la funció send_after que fa servir el Jitter per treure un temps de retard random, per tant, si tenim el cas d'un worker que té temps de resposta ( o d'enviar un altre missatge multicast) prou petit, llavors aquest segon worker enviarà abans que el primer worker, els missatges multicast.

2.
El vector clock fa que hi hagi una relació happened-before entre els missatges, per tant, es respectarà l'ordre causa. FIFO també ja que 2 missatges enviats pel mateix procés s'hauran de lliurar segons ho indiqui el vector clock. Però pel contrari no es respecta l'ordre total, ja que no hi ha una relació entre missatges de diferents procesos enviats al mateix temps.
En aquesta versió el paràmetre Jitter perd importancia a causa de l'ordre que implica els vectors clock i la cua.
