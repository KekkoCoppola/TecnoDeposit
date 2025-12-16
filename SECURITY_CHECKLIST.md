# 🔒 Checklist Sicurezza Pre-Upload GitHub

## ✅ Completati

- [x] **`.gitignore` creato** - Esclude file sensibili, build, IDE
- [x] **`DBConnection.java` refactored** - Usa `config.properties` invece di credenziali hardcoded
- [x] **`config.properties.template` creato** - Template con placeholder
- [x] **`EmailConfig.java` creato** - Helper per configurazione email
- [x] **`README.md` creato** - Documentazione completa setup

## ⚠️ DA FARE MANUALMENTE PRIMA DEL PUSH

### 1. Refactoring ImpostazioniServlet.java

**File**: `src/main/java/controller/ImpostazioniServlet.java`  
**Linee**: 192-198

**Codice da modificare**:
```java
// PRIMA (HARDCODED - NON SICURO!)
EmailService mailer = new EmailService(
    "smtp.gmail.com",
    465,
    "fcoppola.dev@gmail.com",    // ❌ RIMUOVERE!
    "wulh zyfu vxjj clzz",       // ❌ PASSWORD IN CHIARO!
    true,
    "no-reply@tecnodeposit.it"
);
```

**SOSTITUIRE CON**:
```java
// DOPO (SICURO!)
EmailService mailer = EmailConfig.createEmailService();
```

### 2. Verifica Altri File Sensibili

Esegui una ricerca nel progetto per verificare altre occorrenze:

#### Cerca Password Hardcoded
```bash
# Linux/Mac
grep -r "password.*=" src/ --include="*.java" | grep -v "getParameter\|setParameter\|request.getParameter"

# Windows PowerShell
Get-ChildItem -Path "src\" -Recurse -Include *.java | Select-String -Pattern 'password.*=' | Where-Object { $_ -notmatch 'getParameter|setParameter' }
```

#### Cerca Email Hardcoded
```bash
grep -r "@gmail.com\|@" src/ --include="*.java" | grep -v "mailto:"
```

#### Cerca URL o Indirizzi IP
```bash
grep -r "192\.168\|localhost:8080" src/ --include="*.java" --include="*.jsp"
```

### 3. Crea config.properties Locale

```bash
cp src/main/resources/config.properties.template src/main/resources/config.properties
```

Poi modifica con le TUE credenziali locali (NON committare questo file!).

### 4. Rimuovi File Sensibili Esistenti

**Elimina questi file se presenti**:
- `TecnoDeposit.exe` (già presente, non committarlo!)
- Eventuali file `*.sql` con dump database contenenti dati reali
- File di log con informazioni sensibili
- Backup database

```bash
# Rimuovi exe già tracciato
git rm --cached TecnoDeposit.exe

# Rimuovi eventuali file build tracciati
git rm -r --cached build/
```

### 5. Aggiorna URL Hardcoded

**File**: `ImpostazioniServlet.java` line 191

```java
// PRIMA
String revealUrl = "192.168.1.25:8080/TecnoDeposit/credenziali?token=" + tokenHex;

// DOPO (usa configurazione o placeholder)
String baseUrl = System.getProperty("app.base.url", "http://localhost:8080/TecnoDeposit");
String revealUrl = baseUrl + "/credenziali?token=" + tokenHex;
```

Aggiungi in `config.properties.template`:
```properties
# Application Base URL (for email links)
app.base.url=http://localhost:8080/TecnoDeposit
```

### 6. Schema Database

Se hai uno schema SQL, assicurati di:
- Rimuovere eventuali dati di test sensibili
- Non includere password di utenti
- Creare una versione "clean" solo con struttura tabelle

```sql
-- Esporta solo struttura (no dati)
mysqldump -u root -p --no-data tecnodeposit > schema_only.sql
```

### 7. Variabili Ambiente (Opzionale ma Consigliato)

Aggiungi `.env.example` per deployment:

```bash
# File: .env.example
DB_URL=jdbc:mysql://localhost:3306/tecnodeposit
DB_USERNAME=your_db_user
DB_PASSWORD=your_db_password
EMAIL_SMTP_HOST=smtp.gmail.com
EMAIL_SMTP_PORT=587
EMAIL_SMTP_USERNAME=your-email@example.com
EMAIL_SMTP_PASSWORD=your-app-password
TD_AES_KEY_B64=your-base64-aes-key
```

## 🔍 Checklist Finale Pre-Push

Prima di eseguire `git push`:

- [ ] `config.properties` NON è committato (verificare con `git status`)
- [ ] `ImpostazioniServlet.java` refactored (usa `EmailConfig`)
- [ ] `TecnoDeposit.exe` rimosso dalla cache git
- [ ] Nessuna password in chiaro nei file `.java`
- [ ] Nessun indirizzo email personale hardcoded
- [ ] README.md completo e aggiornato
- [ ] `.gitignore` funzionante
- [ ] Test locale che tutto funziona con nuovo sistema config

## ✅ Comandi Git per Primo Push

```bash
# Verifica status e file tracciati
git status

# Aggiungi tutti i file (esclusi quelli in .gitignore)
git add .

# Verifica che config.properties NON sia in staging
git status

# Se config.properties appare, rimuovilo:
git reset HEAD src/main/resources/config.properties

# Commit
git commit -m "Initial commit - Secure configuration setup"

# Crea repository su GitHub e collega
git remote add origin https://github.com/yourusername/TecnoDeposit.git

# Push
git branch -M main
git push -u origin main
```

## 🚨 Post-Upload: Verifica Sicurezza

Dopo il push su GitHub:

1. **Controlla repository pubblico**: Vai su GitHub e naviga i file
2. **Cerca credenziali**: Usa la ricerca GitHub per "password", "smtp", "@gmail"
3. **GitHub Secret Scanning**: Controlla se GitHub ha rilevato secrets esposti
4. **Se trovi credenziali esposte**:
   - NON eliminare solo il commit! La history mantiene i dati
   - Cambia IMMEDIATAMENTE tutte le password esposte
   - Usa `git filter-branch` o BFG Repo-Cleaner per rimuovere dalla history
   - Considera di ricreare il repository da zero se necessario

## 📚 Risorse Utili

- [GitHub: Removing sensitive data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
- [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
- [GitGuardian](https://www.gitguardian.com/) - Scansione automatica secrets

---

**RICORDA**: Una volta che dati sensibili sono su GitHub, anche se eliminati, rimangono nella history. La prevenzione è fondamentale!
