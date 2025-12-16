// ArticoloImportParser.java
package util;

import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.Optional;

import model.Articolo;
import model.ListaArticoli;
import model.Articolo.Stato;

public final class ArticoloImportParser {

    private ArticoloImportParser() {}

    // Formati date tollerati (primario: dd/MM/yyyy)
    private static final DateTimeFormatter[] DATE_FORMATS = new DateTimeFormatter[] {
        DateTimeFormatter.ofPattern("dd/MM/uuuu").withLocale(Locale.ITALY),
        DateTimeFormatter.ofPattern("dd-MM-uuuu").withLocale(Locale.ITALY),
        DateTimeFormatter.ISO_LOCAL_DATE // uuuu-MM-dd
    };

    /** Pulisce stringa: trim, collassa spazi multipli; ritorna null se vuota. */
    private static String clean(String s) {
        if (s == null) return null;
        // normalizza spazi, rimuove NBSP e trim
        String t = s.replace('\u00A0',' ').trim();
        if (t.isEmpty()) return null;
        // collassa spazi multipli interni (utile per stati/note)
        return t.replaceAll("\\s{2,}", " ");
    }

    private static LocalDate parseDate(String raw) {
        String s = clean(raw);
        if (s == null) return null;
        for (DateTimeFormatter f : DATE_FORMATS) {
            try { return LocalDate.parse(s, f); }
            catch (DateTimeParseException ignore) {}
        }
        // se non parse, lasciamo null (potremmo loggare)
        return null;
    }

    /** Parser DI UNA RIGA. Salta la colonna 1 (SERIALE). */
    public static List<Articolo> read(List<String> lines) {
        List<Articolo> result = new ArrayList<>();

        for (String line : lines) {
            if (line == null || line.isBlank()) continue;

            try {
                String[] p = line.split("£", -1);

                // helper sicuro
                java.util.function.IntFunction<String> col = i ->
                        (i >= 0 && i < p.length) ? p[i].trim() : null;

                String statoRaw = col.apply(0);
                String nome     = col.apply(2);
                String marca    = col.apply(3);
                String compat   = col.apply(4);
                String matric   = col.apply(5);
                String proven   = col.apply(6);
                String ddtStr   = col.apply(7);
                String note     = col.apply(10);
                String pvDest   = col.apply(11);

                LocalDate dataSped  = parseDate(col.apply(8));
                LocalDate dataRicez = parseDate(col.apply(9));
                LocalDate dataGar   = parseDate(col.apply(12));

                // se tutti i campi principali sono vuoti → ignora la riga
                if ((nome == null || nome.isEmpty()) &&
                    (marca == null || marca.isEmpty()) &&
                    (matric == null || matric.isEmpty())) {
                    continue;
                }

                Articolo a = new Articolo();
                a.setNome(nome);
                a.setMarca(marca);
                a.setCompatibilita(compat);
                a.setMatricola(matric);
                a.setProvenienza(proven);
                a.setPv(pvDest);
                a.setNote(note);

                // parse int sicuro
                if (ddtStr != null && !ddtStr.isBlank()) {
                    try {
                        a.setDdt(Integer.parseInt(ddtStr.replaceAll("\\D+", "")));
                    } catch (NumberFormatException ex) {
                        a.setDdt(-1); // ignora se non numerico
                    }
                }

                // date sicure
                a.setDataSpe_DDT(dataSped);
                a.setDataRic_DDT(dataRicez);
                a.setDataGaranzia(dataGar);

                // mapping stato
                if (statoRaw != null && !statoRaw.isBlank()) {
                    try {
                        Stato s = Stato.valueOf(statoRaw.trim().replace(" ", "_").toUpperCase());
                        a.setStato(s);
                    } catch (IllegalArgumentException ex) {
                        a.setStato(Stato.GUASTO); // default se non riconosciuto
                    }
                }

                result.add(a);

            } catch (Exception e) {
                // se una riga causa problemi, la saltiamo senza bloccare tutto
                System.err.println("Errore parsing riga: " + line);
            }
        }

        return result;
    }
    
}
