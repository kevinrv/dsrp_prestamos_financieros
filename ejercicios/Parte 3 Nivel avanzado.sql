USE dsrp_prestamos_financieros;

/*Ejercicio 1: An�lisis de Tasa de Inter�s y Monto de Pr�stamos
Obt�n un informe que muestre la relaci�n entre la tasa de inter�s y el monto del pr�stamo para todos los
pr�stamos desembolsados. Muestra la desviaci�n est�ndar, promedio y varianza de la tasa de inter�s por rango de montos de pr�stamo (ej: menores de $10,000, entre $10,000 y $50,000, mayores de $50,000).

*/
--Forma 1
SELECT 
	'Menores a 10000' AS 'Rango',
	STDEV(tasa_interes) AS 'desviaci�n_estandar',
	AVG(tasa_interes) AS 'promedio',
	VAR(tasa_interes) AS 'Varianza'
FROM prestamos
WHERE monto<'10000'
UNION
SELECT 
	'Entre 10000 y 50000' AS 'Rango',
	STDEV(tasa_interes) AS 'desviaci�n_estandar',
	AVG(tasa_interes) AS 'promedio',
	VAR(tasa_interes) AS 'Varianza'
FROM prestamos
WHERE monto BETWEEN '10000' AND '50000'
UNION
SELECT 
	'Mayores a 50000' AS 'Rango',
	STDEV(tasa_interes) AS 'desviaci�n_estandar',
	AVG(tasa_interes) AS 'promedio',
	VAR(tasa_interes) AS 'Varianza'
FROM prestamos
WHERE monto >'50000';
/*

Ejercicio 2: Historial Completo de un Cliente
Genera un historial completo de transacciones y pr�stamos para un cliente espec�fico. 
Muestra todos los pr�stamos asociados a este cliente, todas las cuotas y pagos realizados, 
as� como los saldos restantes y cualquier cuota vencida.*/


/*

Ejercicio 3: Impacto de la Mora en el Monto Total Pagado
Analiza el impacto de las cuotas vencidas en el monto total pagado por los clientes. Compara el total pagado entre clientes con cuotas vencidas y clientes sin cuotas vencidas, mostrando diferencias porcentuales y absolutas.

Ejercicio 4: Determinar la Sucursal con Mayor Tasa de Mora
Identifica cu�l sucursal tiene la mayor cantidad de cuotas en mora en relaci�n con el n�mero total de cuotas generadas en esa sucursal. Muestra el porcentaje de cuotas en mora por sucursal y determina cu�l es la sucursal con el peor desempe�o.

Ejercicio 5: Pr�stamos con Pagos Fuera de Tiempo
Encuentra los pr�stamos en los que se han realizado pagos fuera de la fecha de vencimiento de la cuota. Muestra el ID del pr�stamo, el nombre del cliente, las fechas de vencimiento de las cuotas y las fechas reales de pago, calculando tambi�n la diferencia en d�as.

Ejercicio 6: Estudio de Tasa de Inter�s Promedio por Tipo de Pr�stamo
Analiza la tasa de inter�s promedio aplicada por cada tipo de pr�stamo. Muestra el tipo de pr�stamo, el promedio de tasa de inter�s y la cantidad de pr�stamos en cada categor�a, ordenado por la tasa de inter�s promedio m�s alta.

Ejercicio 7: Predicci�n de Saldos Pendientes
Genera una proyecci�n de los saldos pendientes para cada pr�stamo activo en funci�n del historial de pagos realizados. Calcula el saldo proyectado en funci�n de la tasa de inter�s y los pagos ya efectuados.

Ejercicio 8: An�lisis de Pagos Parciales
Obt�n una lista de todos los pr�stamos con pagos parciales y muestra qu� porcentaje del monto total de la cuota ha sido cubierto. Calcula tambi�n el total pendiente por cuota y por pr�stamo.

Ejercicio 9: Empleados con Mejores Resultados en Gesti�n de Cr�ditos
Identifica cu�les empleados han gestionado el mayor n�mero de pr�stamos con cuotas completamente pagadas sin mora.
Muestra el nombre del empleado y el nombre de su supervisor, la sucursal y el n�mero de pr�stamos exitosos gestionados.*/
SELECT c.prestamo_id,c.id AS 'cuota_id',c.monto_cuota,p.monto_pagado
FROM cuotas c
INNER JOIN detalles_cuotas_pagos dcp ON dcp.cuota_id=c.id
INNER JOIN pagos p ON p.id=dcp.pago_id;

SELECT DISTINCT 
	s.nombre AS 'Sucursal',
	CONCAT(nt.nombres,' ',nt.apellido_paterno,' ',nt.apellido_materno) AS 'empleado',
	CONCAT(nts.nombres,' ',nts.apellido_paterno,' ',nts.apellido_materno) AS 'empleado_supervisor',
	COUNT(p.id) AS 'num_prestamos'
FROM empleados e 
	INNER JOIN sucursales s ON s.id=e.sucursal_id
	INNER JOIN personas_naturales nt ON nt.id=e.persona_id
	INNER JOIN empleados es ON es.id=e.supervisor_id --AND es.supervisor_id IS NULL
	INNER JOIN personas_naturales nts ON nts.id=es.persona_id
	INNER JOIN prestamos p ON p.oficial_credito_id=e.id
	INNER JOIN cuotas c ON c.prestamo_id=p.id
WHERE 
	p.estado_prestamo_id=5 AND
	c.estado_cuota_id=2 
GROUP BY 
	s.nombre,
	nt.nombres,
	nt.apellido_paterno,
	nt.apellido_materno,
	nts.nombres,
	nts.apellido_paterno,
	nts.apellido_materno;
	

SELECT*FROM estados_prestamo;
SELECT*FROM estados_cuota;
SELECT*FROM cuotas;
SELECT*FROM pagos;


/*

Ejercicio 10: Comparaci�n de Pr�stamos por Tipos de Clientes
Realiza una comparaci�n entre personas naturales y personas jur�dicas en t�rminos del monto promedio de los pr�stamos solicitados, tasa de inter�s aplicada y porcentaje de cuotas vencidas. Muestra las diferencias entre estos dos tipos de clientes en un informe consolidado.
*/
