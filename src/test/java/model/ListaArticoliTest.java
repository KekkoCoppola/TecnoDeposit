package model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class ListaArticoliTest {

    private ListaArticoli listaArticoli;

    @BeforeEach
    void setUp() {
        listaArticoli = new ListaArticoli() {
            @Override
            public List<Articolo> getAllarticoli() {
                Articolo a1 = new Articolo();
                a1.setId(1);
                a1.setNome("Computer");
                a1.setMarca("Dell");
                a1.setMatricola("M123");
                a1.setTecnico("Mario");
                a1.setStato(Articolo.Stato.IN_MAGAZZINO);

                Articolo a2 = new Articolo();
                a2.setId(2);
                a2.setNome("Monitor");
                a2.setMarca("Samsung");
                a2.setMatricola("M456");
                a2.setTecnico("Luigi");
                a2.setStato(Articolo.Stato.INSTALLATO);

                Articolo a3 = new Articolo();
                a3.setId(3);
                a3.setNome("Tastiera");
                a3.setMarca("Logitech");
                a3.setMatricola("M789");
                a3.setTecnico("Mario");
                a3.setStato(Articolo.Stato.GUASTO);

                return List.of(a1, a2, a3);
            }
        };
    }

    @Test
    void testFiltraBySearch() {
        List<Articolo> result = listaArticoli.filtra("Computer", "", "", "", "", "mostra", "", "");
        assertEquals(1, result.size());
        assertEquals("Computer", result.get(0).getNome());
    }

    @Test
    void testFiltraByMarca() {
        List<Articolo> result = listaArticoli.filtra("", "", "Samsung", "", "", "mostra", "", "");
        assertEquals(1, result.size());
        assertEquals("Monitor", result.get(0).getNome());
    }

    @Test
    void testFiltraNascondiInstallati() {
        List<Articolo> result = listaArticoli.filtra("", "", "", "", "", "nascondi", "", "");
        assertEquals(2, result.size());
        assertTrue(result.stream().noneMatch(a -> a.getStato() == Articolo.Stato.INSTALLATO));
    }

    @Test
    void testFiltraByStato() {
        List<Articolo> result = listaArticoli.filtra("", "GUASTO", "", "", "", "mostra", "", "");
        assertEquals(1, result.size());
        assertEquals("Tastiera", result.get(0).getNome());
    }
}
