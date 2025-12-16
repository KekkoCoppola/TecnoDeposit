package model;

public class RichiestaRiga {
	 private int id;
	 private int richiestaId; // FK verso Richiesta
	 private int articoloId;  // FK verso Articolo
	 private int quantita;
	 private String note;
	 
	 public RichiestaRiga(int richiestaId,int articoloId,int quantita,String note) {
		 this.richiestaId=richiestaId;
		 this.articoloId=articoloId;
		 this.quantita=quantita;
		 this.note=note;
	 }
	 public RichiestaRiga() {}
	 
	 public void setId(int id) { this.id=id;}
	 public void setRichiestaId(int richiestaId) { this.richiestaId=id;}
	 public void setArticoloId(int articoloId) {this.articoloId=articoloId;}
	 public void setQuantita(int quantita) {this.quantita = quantita;}
	 public void setNote(String note) {this.note = note;}
	 
	 public int getId() {return this.id;}
	 public int getRichiestaId() {return this.richiestaId;}
	 public int getArticoloId() {return this.articoloId;}
	 public int getQuantita() {return this.quantita;}
	 public String getNote() {return this.note;}
}
