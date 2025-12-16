package model;

import java.util.ArrayList;
import java.util.List;

public class Richiesta {
	private int id;
    private int richiedenteId;
    private String stato; // "in_attesa", "approvata", ...
    private java.time.LocalDateTime dataRichiesta;
    private String urgenza; // "bassa", "media", "alta"
    private String motivo;  // "Reintegro", "Fornitura"
    private String commento;
    private String note;

    // una richiesta ha più righe
    private List<RichiestaRiga> righe = new ArrayList<>();
    
    public Richiesta(int richiedenteId,String stato,java.time.LocalDateTime dataRichiesta,String urgenza, String motivo, String commento, String note) {
    	this.richiedenteId=richiedenteId;
    	this.stato=stato;
    	this.dataRichiesta=dataRichiesta;
    	this.urgenza=urgenza;
    	this.motivo=motivo;
    	this.commento=commento;
    	this.note=note;
    }
    public Richiesta() {}
    
    public void setId(int id) {this.id=id;}
    public void setRichiedenteId(int richiedenteId) {this.richiedenteId=richiedenteId;}
    public void setStato(String stato) {this.stato=stato;}
    public void setDataRichiesta(java.time.LocalDateTime dataRichiesta) {this.dataRichiesta=dataRichiesta;}
    public void setUrgenza(String urgenza) {this.urgenza=urgenza;}
    public void setMotivo(String motivo) {this.motivo=motivo;}
    public void setCommento(String commento) {this.commento=commento;}
    public void setNote(String note) {this.note=note;}
    public void setRighe(List<RichiestaRiga> righe) {this.righe=righe;}
    
    public int getId() {return this.id;}
    public int getRichiedenteId() {return this.richiedenteId;}
    public String getStato() {return this.stato;}
    public java.time.LocalDateTime getDataRichiesta() {return this.dataRichiesta;}
    public String getUrgenza() {return this.urgenza;}
    public String getMotivo() {return this.motivo;}
    public String getCommento() {return this.commento;}
    public String getNote() {return this.note;}
    public List<RichiestaRiga> getRighe() {return this.righe;}
}
