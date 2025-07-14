
void main() {
    int operationCount = 0;
    final int MAX_OPERATIONS = 30;

    while (operationCount <= MAX_OPERATIONS) {
        clearInputOperator();
        boolean hasInput = trim(); 
        if (!hasInput) break; 

        String command = receiveOperator();

        if (command.equals("ADD")) {
            add();
            operationCount++;
        } else if (command.equals("DEL")) {
            del();
            operationCount++;
        } else if (command.equals("PRINT")) {
            System.out.println(); 
            print();
            operationCount++;
        } else if (command.equals("SORT")) {
            sort();
            operationCount++;
        } else if (command.equals("REV")) {
            rev();
            operationCount++;
        }

        // 否则无效命令，忽略
    }
}

void clearInputOperator() {
    // Ottiene il puntatore all'array inputOperator (lunghezza massima = 8)
    for (int i = 0; i < 8; i++) {
        inputOperator[i] = '\0';  // Imposta ogni byte a 0 (carattere nullo)
    }
}


void receiveOperator() {
    trim();  // Rimuove gli spazi iniziali nell’input

    int count = 0; // Contatore dei caratteri letti

    while (true) {
        char c = *a1; // Legge il prossimo carattere dalla lista di input
        if (c == '\0') break; // Fine della stringa

        // Controlla se il carattere è una lettera maiuscola ('A' ... 'Z')
        if (c < 'A' || c > 'Z') break;

        *a2 = c;  // Salva il carattere valido nel buffer inputOperator
        a2++;     // Passa al prossimo byte del buffer
        a1++;     // Passa al prossimo carattere dell'input originale
        count++;  // Incrementa il contatore

        if (count > 7) break; // Massimo 8 caratteri (0-7)
    }
}
void getWeight(Node a3) {
    // Salva stato del chiamante
    if (a3 == null) return;  // Lista finita
    
    char c = a3.data;

    // Controlla se è una lettera maiuscola (A-Z)
    if (c >= 'A' && c <= 'Z') {
        c += 37; // Aggiunge peso
    }
    // Altrimenti, è una lettera minuscola (a-z)?
    else if (c >= 'a' && c <= 'z') {
        c -= 21; // Sottrae peso
    }
    // Altrimenti, è una cifra (0-9)?
    else if (c >= '0' && c <= '9') {
        c += 18; // Aggiunge peso
    }
    // Altrimenti, è un carattere speciale accettato
    else {
        c -= 60; // Sottrae peso
    }

    // Salva il nuovo valore nel nodo
    a3.data = c;

    // Passa al nodo successivo
    getWeight(a3.next);
}

void trim() {
    // t1 = codice ASCII per spazio ' '
    while (true) {
        char c = *a1;
        if (c == '\0') break;  // Fine stringa
        if (c == ' ') {
            a1++; // Salta spazio
        } else {
            break; // Trovato primo carattere utile
        }
    }
}


void next_operator() {
    // Valore ASCII del carattere '~' è 126
    char target = '~';
    
    while (true) {
        char c = *a1;

        if (c == '\0') {
            // Se è fine stringa (null terminator), termina il programma
            goto end;
        }

        if (c == target) {
            // Se trova '~', avanza il puntatore oltre il carattere
            a1++;
            goto loop_Main;  // Continua con la logica principale
        }

        // Altrimenti, continua a scansionare il carattere successivo
        a1++;
    }

end:
    // Termina il programma
    exit();
}

void receive_parameter() {
    // Salva i registri nel stack frame
    push(ra);
    push(s0);  // s0 sarà '('
    push(s1);  // s1 sarà ')'

    char c = *a1;
    char par_aperta = '(';  // ASCII 40
    char par_chiusa = ')';  // ASCII 41

    if (c != par_aperta) {
        // Se non inizia con '(', passa al prossimo operatore
        goto next_operator;
    }

    a1++; // Avanza oltre '('
    c = *a1;

    // Controlla se il carattere tra le parentesi è valido
    if (c < 32 || c > 125) {
        goto next_operator;
    }

    a5 = c; // Salva il parametro
    a1++;   // Avanza al prossimo carattere

    c = *a1;
    if (c != par_chiusa) {
        goto next_operator;
    }

    a1++; // Avanza oltre ')'

    c = *a1;
    if (c == '\0') {
        // Se fine stringa, termina
        goto end_receive_parameter;
    }

    trim(); // Rimuove eventuali spazi iniziali

    if (*a1 == '~') {
        // Se il prossimo carattere è '~', è tutto ok
        goto end_receive_parameter;
    }

    // Se non è '~', allora è un errore → cerca il prossimo operatore
    goto next_operator;

end_receive_parameter:
    // Ripristina i registri salvati e ritorna
    pop(s1);
    pop(s0);
    pop(ra);
    return;
}


// Struttura del nodo
class Node {
    char data;
    Node next;

    Node(char d) {
        data = d;
        next = null;
    }
}

Node head = null; // Corrisponde al registro a3 (testa della lista)

void add(char value) {
    // Crea un nuovo nodo con il valore ricevuto
    Node newNode = new Node(value);

    // Se la lista è vuota, imposta il nuovo nodo come testa
    if (head == null) {
        head = newNode;
        return;
    }

    // Scorre fino alla fine della lista
    Node current = head;
    while (current.next != null) {
        current = current.next;
    }

    // Collega il nuovo nodo alla fine della lista
    current.next = newNode;
}

void del(char value) {
    // Se la lista è vuota, esce subito
    if (head == null) return;

    // Rimuove eventuali nodi all'inizio della lista che corrispondono al valore
    while (head != null && head.data == value) {
        head = head.next;
    }

    // Rimuove i nodi successivi che corrispondono al valore
    Node prev = head;
    Node current = (head != null) ? head.next : null;

    while (current != null) {
        if (current.data == value) {
            // Salta il nodo corrente
            prev.next = current.next;
        } else {
            // Avanza al nodo successivo
            prev = current;
        }
        current = current.next;
    }
}

void print() {
    char c = trim(); // Pulisce l'input e restituisce il primo carattere significativo

    if (c == 0 || c == '~') {
        print_core(head); // Se l'input è vuoto o è '~', stampa la lista
    }
    // Altrimenti non fa nulla
}

void print_core(Node node) {
    if (node == null) return;

    System.out.print((char) node.data); // Stampa il carattere del nodo
    print_core(node.next);              // Chiamata ricorsiva al nodo successivo
}

void rev() {
    if (head == null) return; // Se la lista è vuota, esce

    char c = trim(); // Pulisce l'input
    if (c != 0 && c != '~') return; // Se non valido, esce

    Stack<Character> stack = new Stack<>();
    Node temp = head;

    // Push dei dati dei nodi nello stack
    while (temp != null) {
        stack.push((char) temp.data);
        temp = temp.next;
    }

    // Pop e riscrittura nei nodi
    temp = head;
    while (temp != null) {
        temp.data = stack.pop();
        temp = temp.next;
    }

    next_operator(); // Passa al prossimo comando
}
void sort() {
    char c = trim();
    if (c != 0 && c != '~') {
        next_operator(); // Input invalido
        return;
    }

    getWeight(); // Elabora i pesi per ogni nodo

    Node sorted = sort_core(head);
    cancelWeight(); // Rimuove i pesi temporanei
    head = sorted; // Aggiorna la testa
}

Node sort_core(Node head) {
    if (head == null) return null;

    Node min = head, minPrev = null;
    Node curr = head, prev = null;

    // Cerca il nodo con valore minimo
    while (curr != null) {
        if (curr.data < min.data) {
            min = curr;
            minPrev = prev;
        }
        prev = curr;
        curr = curr.next;
    }

    // Rimuove il nodo minimo dalla lista
    if (minPrev != null) {
        minPrev.next = min.next;
    } else {
        head = min.next;
    }

    // Ricorsione sull'elenco rimanente
    min.next = sort_core(head);
    return min;
}

void end() {
    if (a6 > 30) {
        System.out.println((char) 10); // newline
        System.out.println(MsgListInputError);
        System.exit(1); // Errore
    }

    System.exit(0); // Terminazione corretta
}
