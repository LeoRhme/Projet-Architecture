	.data

message: .asciiz "Entrez le chemin dossier du fichier que vous souhaitez jouer: \n"
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


syscall

addi $t0,$t0,0 			#on initialise un indice à 0
jal CALCULNOMBRECARACTERES 	#on va à la boucle qui permet de calculer le nombre de caractères de la chaîne pour pouvoir supprimer le caractère de fin de chaîne et empêchant d'ouvrir le fichier

CONTINUER:
#open file
li $v0, 13
la $a0, nomFichier
li $a1, 0		#flag 
li $a2, 0               #mode lecture seulement
syscall
move $s0, $v0		#on enregistre le file descriptor dans $s0


#read the file
li $v0, 14
move $a0, $s0
la $a1, fichier
la $a2, 1024
syscall


#test print fichier utilisé au début pour vérifier l'ouverture du fichier#
#li $v0, 4
#la $a0, fichier
#syscall

#________ANALYSE DE L'EN TETE_________#
la $t1,fichier
lh $t2,2($t1) 		# $t2 contient le type de fichier MIDI
lh $t3,10($t1)		# $t3 contient le nombre de tracks
lh $t4,12($t1)		# $t4 contient le nombre de ticks par crochet (quarter note = au quart d'un temps)
#_____________________________________#

addi $a2,$a2,0
beq $t2,$a2, MIDI0

#on entre ici si c'est un fichier midi de type 0 i.e avec une seule track obligatoirement#
MIDI0:
#récupération du nombre d'octets de la track#
lb $s0, 18($t1)
lb $s1, 19($t1)
lb $s2, 20($t1)
lb $s3, 21($t1)

sll $s0,$s0,0
sll $s1,$s1,8
sll $s2,$s2,16
sll $s3,$s3,24

or $s0,$s0,$s1
or $s0,$s0,$s2
or $s0,$s0,$s3












#Close
li $v0, 16
move $a0, $s0
syscall

li $v0, 10
syscall

#----PROCEDURE POUR SUPPRIMER LE CARACTERE DE FIN DE CHAINE EMPECHANT D'ENREGISTRER CORRECTEMENT LE NOM DU FICHIER-----#
CALCULNOMBRECARACTERES:
lb $t1,nomFichier($t0) 			#On load le caractère à l'indice contenu dans $t0 
addi $t0,$t0,1 				#On incrémente l'indice
bnez $t1, CALCULNOMBRECARACTERES	#tant que le caratère n'est pas 0 on continue 
j SUPPRCARACTFIN 			#on sort de la boucle mais il reste quelques instructions à exécuter au niveau de l'étiquette mentionnée

SUPPRCARACTFIN:
addi $t0, $t0, -2 			#on diminue l'indice de deux enlevant ainsi le caractère de fin de chaîne
sb $zero, nomFichier($t0) 		#on "corrige le nom du fichier" en remplaçant le / du caractère de fin de chaîne par un 0
jr $ra
#---------------------------------------------------------------------------------------------------------------------#

