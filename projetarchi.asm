	.data

message: .asciiz "Entrez le nom du fichier \n"
nomFichier: .space 1024
fichier: .space 1024

	.text

#Demander le nom du fichier
li $v0, 4		#syscall
la $a0, message		#lire "message"
syscall

#Scanf du nom
li $v0, 8		#syscall
la $a0, nomFichier	#adresse du tampon	#il faut entrer l'adresse du fichier ?
li $a1, 100		#nb max car lu
move $t0,$a0           #on met la chaîne de caractères correspondant au nom du fichier dans t0

syscall

#open file
li $v0, 13
la $a0, nomFichier
move $a0,$t0
li $a1, 0		#flag 
syscall
move $s0, $v0		#save file descriptor


#read the file
li $v0, 14
move $a0, $s0
la $a1, fichier
la $a2, 1024
syscall

#print
li $v0, 4
la $a0, fichier
syscall

#Close
li $v0, 16
move $a0, $s0
syscall

li $v0, 10
syscall
