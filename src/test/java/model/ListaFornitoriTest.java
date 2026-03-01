package model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class ListaFornitoriTest {

    private ListaFornitori listaFornitori;

    @BeforeEach
    void setUp() {
        listaFornitori = new ListaFornitori() {
            @Override
            public List<Fornitore> getAllfornitori() {
                Fornitore f1 = new Fornitore();
                f1.setId(1);
                f1.setNome("Fornitore A");
                f1.setMail("a@example.com");

                Fornitore f2 = new Fornitore();
                f2.setId(2);
                f2.setNome("Fornitore B");
                f2.setMail("b@example.com");

                return List.of(f1, f2);
            }
        };
    }

    @Test
    void testFiltraNomeExactMatch() {
        List<Fornitore> result = listaFornitori.filtra("Fornitore A");
        assertEquals(1, result.size());
        assertEquals("Fornitore A", result.get(0).getNome());
    }

    @Test
    void testFiltraNomePartialMatch() {
        List<Fornitore> result = listaFornitori.filtra("fornitore");
        assertEquals(2, result.size());
    }

    @Test
    void testFiltraNomeNoMatch() {
        List<Fornitore> result = listaFornitori.filtra("Non Esiste");
        assertEquals(0, result.size());
    }

    @Test
    void testFiltraNomeEmpty() {
        List<Fornitore> result = listaFornitori.filtra("");
        assertEquals(2, result.size());
    }
}
