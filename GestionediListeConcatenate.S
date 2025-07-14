.data
# Espressioni Comandi >>>
# ADD(1) ~ ADD(a) ~ ADD(a) ~ ADD(B) ~ ADD(;) ~ ADD(9) ~SORT~PRINT~DEL(b)~DEL(B) ~PRI~REV~PRINT
# ADD(1) ~ ADD(a) ~ add(B) ~ ADD(B) ~ ADD ~ ADD(9)~PRINT~SORT(a)~PRINT~DEL(bb) ~DEL(B) ~PRINT~REV~PRINT
# ADD(a) ~ ADD(.) ~ ADD(2) ~ ADD(E) ~ ADD(r) ~ ADD(4) ~ ADD(,) ~ ADD(w)~PRINT ~PRINT(a) ~REV(b) ~ REV ~ REV ~ SORT ~ PRINT
# “DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~DEL(a)~PRINT
# “ADD(a) ~ add(a) ~ ~ ADD(c) ~ ADDS(v) ~ ADD({) ~DELA({) ~ REV PRINT ~ SORT~PRINT
listInput:      .string "ADD(a) ~ add(a) ~ ~ ADD(c) ~ ADDS(v) ~ ADD({) ~DELA({) ~ REV PRINT ~ SORT~PRINT"
ADD:            .string "ADD"
DEL:            .string "DEL"
PRINT:          .string "PRINT"
SORT:           .string "SORT"
REV:            .string "REV"
MsgListInputError: .string "listInput non dovrà contenere più di 30 comandi!"
inputOperator:  .string "AAAAAAAA" 
list:.string ""
.text
Main:
    la a1, listInput # Carica l'indirizzo della lista di input in a1
    li a6,0 # Inizializza il contatore delle operazioni eseguite a 0
    loop_Main:
        li t0,30
        bgt a6,t0,end # Se sono state eseguite più di 30 operazioni, termina
        la a2, inputOperator 
        jal clear_inputOperator # Pulisce il buffer dell'operatore
        jal trim # Legge e pulisce il prossimo comando; se t0 == 0, input finito
        beqz t0,end # Se non c’è più input, termina
        jal receive_Operator # Salva il comando letto nella variabile inputOperator
        case_ADD:
            la t0,ADD # t0 punta alla stringa "ADD"
            la t1,inputOperator # t1 punta al comando letto
            compare_strings_ADD:
                lb t3,0(t0) # Legge il carattere corrente di "ADD"
                lb t4,0(t1) # Legge il carattere corrente del comando utente
                beqz t4,finish_check_add # Fine del comando utente, verifica corrispondenza completa
                bne t3,t4,case_DEL # Se i caratteri non corrispondono, passa al caso DEL
                next_char_ADD:
                    addi t0,t0,1 # Passa al prossimo carattere di "ADD"
                    addi t1,t1,1 # Passa al prossimo carattere del comando utente
                    j compare_strings_ADD
                finish_check_add:
                    beqz t3,isadd # Se anche "ADD" è finito, è una corrispondenza esatta 
                    j next_operator  # Altrimenti ignora e passa al prossimo comando
                isadd:
                    jal add # Chiama la procedura per gestire il comando ADD
                    addi a6,a6,1 # Incrementa il contatore delle operazioni
                    j next_operator
        case_DEL:
            la t0,DEL
            la t1,inputOperator
            compare_strings_DEL:
                lb t3,0(t0)
                lb t4,0(t1)
                beqz t4,finish_check_del
                beq t3,t4,next_char_DEL
                j case_PRINT
                next_char_DEL:
                    addi t0,t0,1
                    addi t1,t1,1
                    j compare_strings_DEL
                finish_check_del:
                    beqz t3,isdel
                    j next_operator  
                isdel:
                    jal del
                    addi a6,a6,1
                    j next_operator
        case_PRINT:
            la t0,PRINT
            la t1,inputOperator
            compare_strings_PRINT:
                lb t3,0(t0)
                lb t4,0(t1)
                beqz t4,finish_check_print
                beq t3,t4,next_char_PRINT
                j case_SORT
                next_char_PRINT:
                    addi t0,t0,1
                    addi t1,t1,1
                    j compare_strings_PRINT
                finish_check_print:
                    beqz t3,isprint
                    j next_operator                    
                isprint:
                        li a0,10
                        li a7,11
                        ecall
                        jal print
                        addi a6,a6,1
                        j next_operator 
        case_SORT:
            la t0,SORT
            la t1,inputOperator
            compare_strings_SORT:
                lb t3,0(t0)
                lb t4,0(t1)
                beqz t4,finish_check_sort
                beq t3,t4,next_char_SORT
                j case_REV
                next_char_SORT:
                    addi t0,t0,1
                    addi t1,t1,1
                    j compare_strings_SORT
                finish_check_sort:
                    beqz t3,isSort
                    j next_operator
                isSort:
                        jal sort
                        addi a6,a6,1
                        j next_operator
        case_REV:
            la t0,REV
            la t1,inputOperator
            compare_strings_REV:
                lb t3,0(t0)
                lb t4,0(t1)
                beqz t4,finish_check_rev
                beq t3,t4,next_char_REV
                j next_operator
                next_char_REV:
                    addi t0,t0,1
                    addi t1,t1,1
                    j compare_strings_REV
                finish_check_rev:
                    beqz t3,isrev
                    j next_operator  
                isrev:
                        jal rev
                        addi a6,a6,1
                        j next_operator  
        j loop_Main # Continua il ciclo per processare il prossimo comando



receive_Operator:
    addi sp,sp,-4 
    sw ra,0(sp)
    jal trim # Elimina eventuali spazi all'inizio dell’input
    mv t3,zero # Inizializza il contatore di caratteri letti (t3 = 0)
    loop_receive:
        lb t0,0(a1) # Legge il prossimo byte dalla lista di input (a1)
        beqz t0, end_receive_Operator # Se fine stringa (null terminator), esce
        li t1,65 # ASCII 'A'
        li t2,90 # ASCII 'Z'
        blt t0,t1,end_receive_Operator # Se carattere < 'A', non valido → fine
        bgt t0,t2,end_receive_Operator # Se carattere > 'Z', non valido → fine
        sb t0,0(a2) # Salva il carattere valido nel buffer inputOperator (a2)
        addi a2,a2,1 # Avanza il puntatore del buffer inputOperator
        addi a1,a1,1 # Avanza il puntatore della lista input originale
        addi t3,t3,1 # Incrementa il contatore dei caratteri letti

        li t4,7 # Se superato il limite, termina la lettura
        bgt t3,t4,end_receive_Operator    
        j loop_receive
    end_receive_Operator:
        lw ra,0(sp)
        addi sp,sp,4
        ret


clear_inputOperator:
    la t0, inputOperator   
    li t1, 0               
    li t2, 8      # t2 = 8, numero massimo di byte da azzerare       
    clear_loop:
        sb t1, 0(t0)     # Scrive il byte nullo (0) nella posizione corrente      
        addi t0, t0, 1    # Passa al byte successivo del buffer     
        addi t2, t2, -1   # Decrementa il contatore dei byte rimanenti     
        bnez t2, clear_loop   # Se non ha finito, ripete il ciclo
        ret   

getWeight:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw a3, 8(sp)
    lb t0, 0(a3) 
    # Controllo: è una lettera maiuscola? (A-Z: 65-90)  
    li t1,90
    li t2,65
    bgt t0,t1,not_maiuscola # Se > 'Z', passa oltre
    blt t0,t2,not_maiuscola # Se < 'A', passa oltre
    addi t0,t0,37 # Peso: maiuscole +37
    sb t0,0(a3) # Salva il nuovo "peso"
    lw t3,1(a3) # Carica il puntatore al nodo successivo
    mv a3,t3 # Aggiorna il puntatore
    beqz t3, getWeight_end # Se lista finita, termina
    j loop_getWeight # Altrimenti, continua ricorsivamente
    not_maiuscola:
        # Controllo: è una lettera minuscola? (a-z: 97-122)
        li t1,122
        li t2,97
        bgt t0,t1,not_minuscola
        blt t0,t2,not_minuscola
        addi t0,t0,-21 # Peso: minuscole -21
        sb t0,0(a3)
        lw t3,1(a3)
        mv a3,t3
        beqz t3, getWeight_end
        j loop_getWeight
    not_minuscola:
        # Controllo: è un numero? (0-9: 48-57)
        li t1,57
        li t2,48
        bgt t0,t1,not_number
        blt t0,t2,not_number
        addi t0,t0,18 # Peso: numeri +18
        sb t0,0(a3)
        lw t3,1(a3)
        mv a3,t3
        beqz t3, getWeight_end
        j loop_getWeight
    not_number:
        # È un carattere speciale valido (tra 32 e 47, 58-64, 91-96, 123-125)?
        addi t0,t0,-60  # Peso: caratteri extra -60
        sb t0,0(a3)
        lw t3,1(a3)
        mv a3,t3
        beqz t3, getWeight_end
        j loop_getWeight  # Chiamata ricorsiva alla stessa procedura
    loop_getWeight:
        jal getWeight
    getWeight_end:
        lw ra, 12(sp)
        lw a3, 8(sp)
        addi sp, sp, 16
        ret

#Procedura inversa di getWeight, con una struttura simile a quella della funzione precedente.
cancelWeight:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw a3, 8(sp)
    lb t0, 0(a3)   
    li t1,127
    li t2,102
    bgt t0,t1,not_maiuscola_cancelWeight
    blt t0,t2,not_maiuscola_cancelWeight
    addi t0,t0,-37
    sb t0,0(a3)
    lw t3,1(a3)
    mv a3,t3
    beqz t3, cancelWeight_end
    j loop_cancelWeight
    not_maiuscola_cancelWeight:
        li t1,101
        li t2,76
        bgt t0,t1,not_minuscola_cancelWeight
        blt t0,t2,not_minuscola_cancelWeight
        addi t0,t0,21
        sb t0,0(a3)
        lw t3,1(a3)
        mv a3,t3
        beqz t3, cancelWeight_end
        j loop_cancelWeight
    not_minuscola_cancelWeight:
        li t1,75    
        li t2,66
        bgt t0,t1,not_number_cancelWeight
        blt t0,t2,not_number_cancelWeight
        addi t0,t0,-18
        sb t0,0(a3)
        lw t3,1(a3)
        mv a3,t3
        beqz t3, cancelWeight_end
        j loop_cancelWeight
    not_number_cancelWeight:
        addi t0,t0,60
        sb t0,0(a3)
        lw t3,1(a3)
        mv a3,t3
        beqz t3, cancelWeight_end
        j loop_cancelWeight
    loop_cancelWeight:
        jal cancelWeight
    cancelWeight_end:
        lw ra, 12(sp)
        lw a3, 8(sp)
        addi sp, sp, 16
        ret       
trim:
    li t1,32
    loop_trim:
        lb t0, 0(a1) # Carica il byte corrente puntato da a1 in t0
        beqz t0, end_trim # Se è il terminatore di stringa (zero), termina
        beq t0,t1,skip # Se è uno spazio, salta e passa al carattere successivo
        j end_trim # Altrimenti, la stringa non inizia con spazi -> termina
        
    skip:
        addi a1, a1, 1 # Incrementa il puntatore a1 per saltare lo spazio
        j loop_trim 
        
    end_trim:
        ret     


next_operator:
    li t2,126
    loop_next_operator:
        lb t0, 0(a1) # Carica il byte puntato da a1 in t0
        beqz t0, end # Se è fine stringa, vai alla fine del programma
        bne t0,t2,skip_char # Se non è '~', salta e controlla il prossimo carattere
        beq t0,t2,end_next_operator # Se è '~', vai alla fine
        j end # Altrimenti esci
        
    skip_char:
        addi a1, a1, 1
        j loop_next_operator # Continua a cercare '~'
        
    end_next_operator:
        addi a1,a1,1 # Avanza oltre il carattere '~'
        j loop_Main

receive_parameter:
    addi sp,sp,-20
    sw ra,0(sp)
    sw s0,4(sp)
    sw s1,8(sp)
    li s0 40 # Carica "(" (ASCII 40) in s0
    li s1 41 # Carica ")" (ASCII 41) in s1
    lb t0,0(a1) # Carica il primo carattere da input
    bne t0,s0,next_operator # Se non è "(", salta al prossimo operatore
    addi a1,a1,1 
    lb t0,0(a1) # Carica il carattere contenuto tra parentesi
    li t1,32 # Carattere minimo valido (spazio)
    li t2,125 # Carattere massimo valido
    blt t0,t1,next_operator # Se troppo piccolo, salto
    bgt t0,t2,next_operator # Se troppo grande, salto
    mv a5,t0 # Salva il parametro in a5
    addi a1,a1,1 # Avanza il puntatore
    lb t0,0(a1) # Carica il prossimo carattere
    bne t0,s1,next_operator # Se non è ")", salto
    li t2,126 # Carica '~' in t2
    addi a1,a1,1
    lb t0,0(a1)  # Carica il prossimo carattere
    beq t0,zero end_receive_parameter # Se fine stringa, termina
    jal trim # Rimuove eventuali spazi iniziali
    beq t2,t0 end_receive_parameter # Se il prossimo è '~', fine OK
    j next_operator # Altrimenti, passo al prossimo operatore
    
    end_receive_parameter:
        lw ra,0(sp)
        lw s0,4(sp)
        lw s1,8(sp)
        addi sp,sp,20
        ret


add:
    addi sp,sp,-16
    sw ra,0(sp)
    sw s0,4(sp)
    sw s1,8(sp)
    sw s2,12(sp)
    jal receive_parameter # Chiama la funzione per ricevere il parametro da aggiungere
    la s0,list # Carica l’indirizzo base della lista in s0

    
    save_data:
        lb t0,0(s0) # Legge il primo byte (carattere) dalla posizione corrente
        beqz t0,complete_save_data # Se è zero (fine lista), pronto a salvare il nuovo dato
        addi s0,s0,5 # Avanza di 5 byte (struttura nodo: 1 byte dato + 4 byte puntatore)
        j save_data # Continua la ricerca dello spazio vuoto
        complete_save_data:
            sb a5,0(s0) # Salva il nuovo carattere ricevuto in a5 nella lista
            sw zero,1(s0) # Inizializza il puntatore "next" a NULL (0)
            mv s2,s0 # Salva il nuovo nodo in s2 per collegarlo dopo
            beqz a3,setHead # Se la lista è vuota (a3 == 0), imposta come testa
    
    mv s1,a3 # s1 scorre la lista a partire dalla testa
    loop_find_tail:
        lw t0,1(s1) # Legge il campo "next"
        beqz t0,end_add # Se è l’ultimo nodo (next == 0), pronto a collegare
        mv s1,t0 # Passa al nodo successivo
        j loop_find_tail # Continua il ciclo

    
    setHead:
        mv a3,s0 # Imposta a3 (head) al nuovo nodo
        lw ra,0(sp)
        lw s0,4(sp)
        lw s1,8(sp)
        lw s2,12(sp)    
        addi sp,sp,16
        ret
    
    end_add:
        sw s2,1(s1) # Passa all’istruzione successiva
        lw ra,0(sp)
        lw s0,4(sp)
        lw s1,8(sp)
        lw s2,12(sp)    
        addi sp,sp,16
        ret

del:
    addi sp,sp,16
    sw ra,0(sp)
    sw s0,4(sp)
    sw s1,8(sp)
    sw s2,12(sp)
    jal receive_parameter # Riceve il parametro (valore da cancellare)
    beqz a3,end_del # Se la lista è vuota (head == 0), esci subito
    mv s0,zero # s0 = predecessore (inizialmente nullo)
    mv s1,a3 # s1 = corrente (inizio dalla testa)
    mv s2,zero # s2 = successore (inizialmente nullo)

    loop_del:
        lb t1,0(s1) # Carica il valore del nodo corrente
        lw s2,1(s1) # Carica il puntatore al prossimo nodo
        beq a5,t1,complete_del # Se il valore corrisponde a quello da cancellare, vai alla rimozione
        mv s0,s1 # Aggiorna predecessore (s0 = nodo corrente)
        mv s1,s2 # Avanza al prossimo nodo
        beqz s1 end_del # Se raggiunge fine lista, termina
        j loop_del # Altrimenti continua a cercare
    
    complete_del:
        beqz s0,case_del_non_predecessor # Se non c'è predecessore, nodo è testa
        beqz s2,case_del_non_successor # Se non c'è successore, nodo è finale
        lw t0,1(s1) # Carica il puntatore successivo del nodo da eliminare
        sw t0,1(s0)     # Collega il predecessore con il successore (salta nodo da eliminare)
        mv s0,zero # Reset variabili
        mv s1,a3
        mv s2,zero
        j loop_del # Continua a cercare e rimuovere eventuali occorrenze
            
        case_del_non_predecessor:
            beqz s2,case_del_non_predecessor_successor # Se è testa e non c'è successore, lista diventa vuota
            lw t0,1(s1) # Carica next del nodo testa
            mv a3,t0 # Imposta la nuova testa al nodo successivo
            mv s0,zero
            mv s1,a3
            mv s2,zero
            j loop_del            
            
            case_del_non_predecessor_successor:
                mv a3,zero # Lista vuota dopo la rimozione
                j end_del
            
        case_del_non_successor:
            sw zero,1(s0) # Se nodo finale, collega predecessore a null (fine lista)
            j end_del

        
    
        
        
    end_del:
        lw ra,0(sp)
        lw s0,4(sp)
        lw s1,8(sp)
        lw s2,12(sp)
        addi sp,sp,16
        ret
    
print:
    addi sp,sp,-8
    sw ra,0(sp)
    li t2,126 # Carica il carattere '~' in t2 (ASCII 126)
    jal trim # Chiama la procedura trim per pulire l'input
    lw ra,0(sp) # Ripristina l'indirizzo di ritorno
    addi sp,sp,8 
    beqz t0,print_core # Se t0 è zero, salta a print_core (stampa lista)
    beq t0,t2,print_core # Se t0 è '~' (126), salta a print_core
    ret # Altrimenti ritorna senza fare nulla
    print_core:
        addi sp, sp, -16
        sw ra, 12(sp)
        sw a3, 8(sp)
        lb t0, 0(a3)  # Carica il byte (carattere) del nodo corrente  
        li a7, 11 
        mv a0, t0 
        ecall # Esegui syscall (stampa carattere)
        lw t1, 1(a3)  # Carica il puntatore al prossimo nodo 
        mv a3, t1 # Aggiorna a3 al prossimo nodo
        beqz t1, print_core_end # Se prossimo nodo è nullo, fine stampa
        jal print_core  # Altrimenti chiama ricorsivamente print_core
        print_core_end:
            lw ra, 12(sp)
            lw a3, 8(sp)
            addi sp, sp, 16
            ret
    print_end:
        lw ra,0(sp)
        ret
    
sort:
    li t2,126 # Carica il codice ASCII del carattere '~' in t2
    jal trim # Chiama la funzione trim per pulire l'input puntato da a1
    beqz t0,sort_no_error # Se t0 == 0 (trim restituisce 0), vai a sort_no_error per continuare con l'ordinamento
    beq t0,t2,sort_no_error # Se t0 == '~', vai comunque a sort_no_error
    j next_operator  # Altrimenti salta a next_operator, termina la funzione

    sort_no_error:
        addi sp,sp,-8
        sw ra,4(sp)
        jal getWeight # Chiama getWeight per elaborare i pesi degli elementi
        mv a4,a3 # Salva l'indirizzo della testa della lista in a4
        mv t5,zero # Inizializza t5 a zero, usato come flag di stato
        jal sort_core # Chiama la funzione principale di ordinamento ricorsivo
        jal cancelWeight # Ripristina i dati originali dopo l'ordinamento
        lw ra,4(sp)
        addi sp,sp,8
        ret # Ritorna alla funzione main

        
        sort_core:
            addi sp, sp, -20
            sw ra, 12(sp)
            sw s0, 8(sp)
            sw s1, 4(sp)
            sw s2, 0(sp)
            mv s0,zero # Inizializza s0 a zero (nodo predecessore)
            mv s1,zero # Inizializza s1 a zero (nodo corrente)
            mv s2,zero # Inizializza s2 a zero (nodo successivo)


            mv t0,a4 # t0 punta alla testa della lista (inizio dell'ordinamento)

            mv t1,a4 # t1 punta al nodo con il valore minimo trovato, inizialmente testa della lista
            mv s1,a4 # s1 punta al nodo corrente nella ricerca, inizia dalla testa

            lb t2,0(t0) # Carica il valore del primo nodo per il confronto
            lw t0,1(t0) # t0 punta al prossimo nodo nella lista
            loop_find_minimo:
                beqz t0, sort_start # Se t0 è zero (fine lista), passa all'inizio dell'ordinamento
                lb t4,0(t0) # Carica il valore del nodo corrente
                blt t4,t2,update_min # Se il valore corrente è minore del minimo, aggiorna il minimo
                lw t0,1(t0) # Altrimenti vai al prossimo nodo
                j loop_find_minimo
            update_min:
                mv t1,t0 # Aggiorna il nodo minimo
                mv t2,t4 # Aggiorna il valore minimo
                lw t0,1(t0) # Continua a scorrere la lista
                j loop_find_minimo
            
            sort_start:
                lw s2,1(s1) # s2 punta al nodo successivo di s1
                beq s1,t1,found_minimum # Se s1 è il nodo minimo trovato, passa alla gestione del nodo minimo
                mv s0,s1 # Altrimenti, aggiorna il nodo predecessore
                mv s1,s2 # e passa al nodo successivo
                j sort_start # Continua la ricerca del minimo
                found_minimum:
                beqz s0,case_non_predecessor
                beqz s2,case_non_successor
                sw s2,1(s0)
                j sort_ricorsivo
                    case_non_predecessor:
                    beqz s2,case_non_predecessor_successor
                    mv a4,s2
                    j sort_ricorsivo
                        case_non_predecessor_successor:
                        mv a4,zero # Lista vuota dopo rimozione
                        j sort_ricorsivo
                case_non_successor:
                    sw zero,1(s0) # Il predecessore diventa coda (nulla successore)
                    j sort_ricorsivo  
                


            sort_ricorsivo:
                bnez t5,has_head_sort # Se la testa è già stata impostata, salta a has_head_sort
                li t5,1 # Segna che la testa è stata impostata
                sw zero,1(s1) # Imposta successore del nodo corrente a zero (nuova coda)
                mv a3,s1  # Imposta a3 come testa della lista ordinata
                sw a3,16(sp)  # Salva la testa sullo stack
                beqz a4,sort_end # Se lista vuota, termina l'ordinamento
                jal sort_core # Chiamata ricorsiva per ordinare il resto della lista
                j sort_end
                has_head_sort:
                    sw zero,1(s1) # Imposta successore a zero
                    sw s1,1(a3) # Collega il nodo corrente alla lista ordinata
                    mv a3,s1 # Aggiorna la coda della lista ordinata
                    sw a3, 16(sp) # Salva la coda nello stack
                    beqz a4,sort_end # Se lista vuota, termina
                    jal sort_core # Ordina ricorsivamente il resto della lista
            sort_end:
                lw ra, 12(sp)
                lw a3,16(sp)
                addi sp, sp, 20
                ret



rev:
    addi sp,sp,-4
    sw ra,0(sp)
    beqz a3, end_rev # Se a3 è zero (lista vuota), salta a end_rev
    jal trim
    lw ra,0(sp)
    addi sp,sp,4
    beqz t0,rev_core # Se t0 == 0 (trim ha successo), vai a rev_core
    li t1,126 # Carica '~' in t1
    beq t0,t1,rev_core # Se t0 == '~', vai a rev_core
    ret # Altrimenti ritorna (fine funzione)

    rev_core:
        mv      t0, a3  # t0 punta alla testa della lista
    rev_push_loop:
        lb      t1, 0(t0) # Carica il byte dal nodo corrente
        addi    sp, sp, -4 # Alloca spazio sullo stack per push
        sw      t1, 0(sp) # Salva il byte sullo stack

        lw      t2, 1(t0) # Carica il puntatore al nodo successivo
        beqz    t2, rev_pop_start # Se fine lista, inizia a poppare dal stack
        mv      t0, t2 # Altrimenti sposta t0 al prossimo nodo
        j       rev_push_loop # Continua il push

    rev_pop_start:
        mv      t0, a3 # Ripristina t0 alla testa della lista

    rev_pop_loop:
        lw      t1, 0(sp) # Pop dal stack il byte salvato
        addi    sp, sp, 4 # Libera lo spazio sullo stack
        sb      t1, 0(t0)  # Scrivi il byte nel nodo corrente

        lw      t2, 1(t0) # Carica il nodo successivo
        beqz    t2, end_rev # Se fine lista, termina
        mv      t0, t2 # Altrimenti vai al nodo successivo
        j       rev_pop_loop # Continua il pop e la scrittura
    

    end_rev:
        sw zero,1(t3) # Imposta successore del nodo t3 a zero (fine lista)
        addi a6,a6,1
        j next_operator
        lw ra,0(sp)
        addi sp,sp,4
        ret

end:
    li t0,30
    bgt a6,t0,listInput_error # Se a6 > 30, salta a listInput_error (errore di input)

    li a7, 10 # Carica il codice sistema per terminare il programma (exit)
    ecall

    listInput_error:
    li a7, 11         
    li a0, 10         
    ecall             
    la a0,MsgListInputError
    li a7,4
    ecall
    li a7, 10
    ecall
