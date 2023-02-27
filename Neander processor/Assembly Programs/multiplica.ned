;CONSTANTES
;SOMA A MATRIZ A E A MATRIZ B
;COLOCA O RESULTADO NA MATRIZ R
ORG 128
index:
	DB 9
matrizA11:
	DB 1
matrizA12:
	DB 1
matrizA13:
	DB 1
matrizA21:
	DB 1
matrizA22:
	DB 1
matrizA23:
	DB 1
matrizA31:
	DB 1
matrizA32:
	DB 1
matrizA33:
	DB 1

matrizB11:
	DB 2
matrizB12:
	DB 2
matrizB13:
	DB 2
matrizB21:
	DB 2
matrizB22:
	DB 2
matrizB23:
	DB 2
matrizB31:
	DB 2
matrizB32:
	DB 2
matrizB33:
	DB 2

matrizR11:
	DB 2
matrizR12:
	DB 2
matrizR13:
	DB 2
matrizR21:
	DB 2
matrizR22:
	DB 2
matrizR23:
	DB 2
matrizR31:
	DB 2
matrizR32:
	DB 2
matrizR33:
	DB 2
fim:
	HLT

;PROGRAMA PRINCIPAL
ORG 0	
	LDA matrizA11
	ADD matrizB11
	STA matrizR11
	
	

