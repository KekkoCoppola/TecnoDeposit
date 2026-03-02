<div align="center">
  <br />
  <img src="src/main/webapp/img/Icon.png" alt="TecnoDeposit Logo" width="180" />
  <br /><br />

  <h1>📦 TecnoDeposit</h1>
  <h3>✨ Il Tuo Magazzino Digitale Intelligente, Sicuro e Veloce ✨</h3>

  <p>
    <a href="https://tecnodeposit.it/">
      <img src="https://img.shields.io/badge/LIVE_DEMO-TECNODEPOSIT.IT-2ea44f?style=for-the-badge&logo=googlechrome&logoColor=white&labelColor=1a1a1a" alt="Live Demo" />
    </a>
  </p>

  <p>
    <strong><a href="#-funzionalità-core" style="text-decoration: none;">Funzionalità</a></strong> •
    <strong><a href="#%EF%B8%8F-architettura-e-stack" style="text-decoration: none;">Architettura</a></strong> •
    <strong><a href="#-ruoli-e-permessi" style="text-decoration: none;">Ruoli</a></strong> •
    <strong><a href="#-setup-e-configurazione" style="text-decoration: none;">Setup</a></strong>
  </p>
  
  <div>
    <img src="https://img.shields.io/badge/Java-17%2B-orange?style=flat-square&logo=openjdk&logoColor=white" alt="Java" />
    <img src="https://img.shields.io/badge/Jakarta_EE-Servlet-007396?style=flat-square&logo=java&logoColor=white" alt="Jakarta EE" />
    <img src="https://img.shields.io/badge/Apache_Tomcat-10.1%2B-F8DC75?style=flat-square&logo=apachetomcat&logoColor=black" alt="Tomcat" />
    <img src="https://img.shields.io/badge/MySQL-8.0%2B-4479A1?style=flat-square&logo=mysql&logoColor=white" alt="MySQL" />
    <img src="https://img.shields.io/badge/Tailwind_CSS-3.x-38B2AC?style=flat-square&logo=tailwind-css&logoColor=white" alt="Tailwind" />
  </div>
</div>

<br />

---

## 📖 Cos'è TecnoDeposit?

**TecnoDeposit** è una Web Application Java EE di livello enterprise (scolastico/aziendale) nata per snellire, digitalizzare e tracciare l'intero ecosistema di un magazzino moderno. Abbandona i fogli di calcolo disordinati: TecnoDeposit gestisce **articoli**, **fornitori**, **flussi di garanzia** e, soprattutto, introduce un **sistema di richieste materiali** dinamico tra i tecnici e l'amministrazione, con cambi di stato fluenti (In Attesa ➔ Approvata ➔ Spedita ➔ Consegnata).

Pensato per la logistica rapida, il software integra **lettura e stampa di QR Code**, un sistema di **Accesso Totem** tramite token a vita brevissima e un design full-responsive motorizzato Tailwind CSS.

---

## ⚡ Architettura e Stack Tecnologico

Il progetto segue il classico e solido pattern architetturale **MVC (Model-View-Controller)** applicato all'ecosistema Jakarta EE, spinto ad alte prestazioni:

### ⚙️ Backend (Java 17 / Jakarta Servlets)
- **Controller Layer**: Un set di `HttpServlet` esposti via URI map (`@WebServlet`). Gestiscono esclusivamente smistamento dati, validazioni e risposte JSON (per API AJAX) o inoltro (`RequestDispatcher`) alle JSP.
- **DAO Layer (Data Access Object)**: Classi dedicate (`TokenDAO`, `UserDAO`, ecc.) che implementano `PreparedStatement` crudi e transazioni `JDBC` verso MySQL.
- **Security**: 
  - Hash delle password tramite `JBCrypt`.
  - Crittografia a riposo `AES-256` per dati critici (Payload chiavi o OTP interni).
  - Filtri Servlet (`AuthFilter`) per blindare le interfacce sensibili contro accessi non autenticati.
- **Background Tasks**: Listener Java (es. `TokenCleanupListener`) per la logistica automatica del databse (pulizia token scaduti).

### 🎨 Frontend (JSP / JS Vanilla / Tailwind)
- **Views (JSP)**: Pagine modulari sviluppate con frammenti riutilizzabili (`.jspf` inclusi dinamicamente come Header e Footer).
- **Styling**: `Tailwind CSS`, caricato via CDN/asset, per prototipazione fulminea e UI pixel-perfect.
- **Interattività Vanilla**: Niente framework pesanti come React o Angular. Tutto il DOM è manipolato on-demand da JS ES6, per la massima leggerezza.
- **Librerie Client-side**:
  - `qrcodejs`: Generazione ultra-low-latency di ticket e accessi QR.
  - `jsPDF` / `XLSX.js`: Esportazioni massive di etichette PDF ad alta qualità o database Excel interamente nel browser client (Zero overhead sul server).

---

## 🚀 Funzionalità Core

*   **🏭 Gestione Articoli & Fornitori**: Tracciamento di numeri di matricola, invii DDT, resi in garanzia e rientri con associazione grafica.
*   **🛒 Richieste Materiale Interattive**: I tecnici compilano carrelli della spesa, l'amministratore valuta, rifiuta, o approva e scatena il flusso logistico. 
*   **🖨️ Stampa Etichette Termiche**: Auto-generazione di layout PDF 64x25mm per stampanti termiche contenenti QR matricolari.
*   **📱 Modale "Accesso Totem"**: Sistema di Single-Sign-On a termine (scadenza automatica rigida a 2 minuti) per il login veloce dei tecnici tramite fotocamera del totem in azienda, senza immettere password. 
*   **🔐 Svuotamento Magazzino Protetto**: Distruzione atomica via "Drop" protetta non solo da password ma da OTP e consensi espliciti.

---

## 🎭 Ruoli e Permessi

L'app scala in base all'utenza loggata:

| Ruolo | Poteri e Visuali |
| :--- | :--- |
| 👑 **Amministratore / Developer** | Accesso divino. Può gestire utenti, accettare carrelli richieste da tech, avviare reset magazzino, refresh blob immagini ed esportazioni Excel totali. |
| 📦 **Magazziniere** | Cuore pulsante dell'inventario. Aggiunge/modifica scorte liberamente, smarca e spedisce materiale. Non può gestire utenti o distruggere il database. |
| 🔧 **Tecnico** | Utente "cliente" del magazzino. Sfoglia il catalogo base, fa ordini tramite flussi "Richiesta" e inquadra il proprio "Modulo Totem" per operare dal tablet aziendale. |

---

## ⚙️ Setup e Configurazione

> [!IMPORTANT]
> **Codice Svuota Magazzino** (OTP per svuotamento):
> ```text
> a3D!9fLk7@pQ4zV6m#Y1dR8wK$eJ0tN3cX7zT1wF5hR8uP2sL0vM9gB6dQ3yC4
> ```

### 1️⃣ Clone del Repository

```bash
git clone https://github.com/yourusername/TecnoDeposit.git
cd TecnoDeposit
```

### 2️⃣ Configurazione Database

Esegui i comandi nel tuo client MySQL per inizializzare il DB:

```sql
CREATE DATABASE tecnodeposit CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'tecnodeposit_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON tecnodeposit.* TO 'tecnodeposit_user'@'localhost';
FLUSH PRIVILEGES;
```

Importa lo schema:

```bash
mysql -u tecnodeposit_user -p tecnodeposit < src/main/resources/DB.sql
```

### 3️⃣ Configurazione Applicazione

Copia il template e configura le credenziali:

```bash
cp src/main/resources/config.properties.template src/main/resources/config.properties
```

Modifica `config.properties`:

```properties
# 🗄️ Database
db.url=jdbc:mysql://localhost:3306/tecnodeposit
db.username=tecnodeposit_user
db.password=your_secure_password

# 📧 Email SMTP (Notifiche)
email.smtp.host=smtp.gmail.com
email.smtp.port=587
email.smtp.username=your-email@gmail.com
email.smtp.password=your-app-password
email.smtp.from=noreply@tecnodeposit.it

# 🔒 AES Key (Crittografia)
crypto.aes.key.b64=YOUR_BASE64_KEY_HERE
```

### 4️⃣ Generare Chiave AES

Per la sicurezza dei dati, genera una chiave **AES-256**:

**Linux/Mac:**
```bash
openssl rand -base64 32
```

**Windows (PowerShell):**
```powershell
$bytes = New-Object byte[] 32; (New-Object System.Security.Cryptography.RNGCryptoServiceProvider).GetBytes($bytes); [Convert]::ToBase64String($bytes)
```
*Incolla il risultato in `crypto.aes.key.b64` nel file config.*

### 5️⃣ Build e Deploy

#### 🦁 Con Maven
```bash
mvn clean package
cp target/TecnoDeposit.war /path/to/tomcat/webapps/
```

#### 🌑 Con Eclipse IDE
1.  **File > New Project > Dynamic Web Project**
2.  Configura il progetto seguendo la procedura standard.
3.  <img src="https://github.com/user-attachments/assets/8f1d74e3-8a99-499d-80b2-f120f746e5bc" width="400" alt="Configurazione Eclipse" />
4.  Copia il contenuto della repository nella cartella del progetto (**Sostituisci tutto**).
5.  Scarica le librerie (se non usi Maven):
    *   🔗 **SQL Connector**: [link](https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/9.2.0/mysql-connector-j-9.2.0.jar)
    *   🔐 **JBCrypt**: [link](https://repo1.maven.org/maven2/org/mindrot/jbcrypt/0.4/jbcrypt-0.4.jar)
    *   📩 **Jakarta Mail**: [link](https://repo1.maven.org/maven2/com/sun/mail/jakarta.mail/2.0.2/jakarta.mail-2.0.2.jar)
    *   ✔️ **Jakarta Activation**: [link](https://repo1.maven.org/maven2/jakarta/activation/jakarta.activation-api/2.1.3/jakarta.activation-api-2.1.3.jar)
6.  Aggiungi le librerie in `src/main/webapp/WEB-INF/lib` al Build Path.
7.  <img src="https://github.com/user-attachments/assets/0e7bd2b4-8ce8-4021-9440-375b91ad19be" width="200" alt="Librerie" />
8.  Aggiungi il progetto al Server Tomcat (`Add & Remove`).
9.  Avvia Tomcat.

🌐 **Accesso Default Locale**: `http://localhost:8080/TecnoDeposit`

---

## 🔐 Configurazione Email (Gmail)

Se utilizzi Gmail per l'SMTP:

1.  Vai su [Google Account Security](https://myaccount.google.com/security)
2.  Abilita **2-Step Verification**
3.  Genera una **App Password** per "TecnoDeposit"
4.  Usa quella password in `config.properties`

---

## 🛡️ Sicurezza

> [!CAUTION]
> **NON committare mai** il file `config.properties`!

Il file `.gitignore` protegge automaticamente:
*   `config.properties`
*   File di build (`*.class`, `*.war`, `target/`)
*   File IDE (`.idea`, `.settings`, `.classpath`)

**Best Practices:**
*   ✅ Cambia tutte le password DB e AES di default prima della messa in live.
*   ✅ Usa HTTPS tra proxy inverso (Nginx/Apache) e Tomcat.

---

## 👨‍💻 Autore e License

<div align="center">
  <a href="https://github.com/KekkoCoppola">
    <img src="https://github.com/KekkoCoppola.png" width="80" style="border-radius: 50%; border: 3px solid #38B2AC;" alt="Avatar" />
  </a>
  <br />
  <strong>Francesco Coppola</strong>
  <br />
  <p>Progetto Proprietario - Tutti i Diritti Riservati <br> 📧 assistenza@tecnodeposit.it</p>
</div>
