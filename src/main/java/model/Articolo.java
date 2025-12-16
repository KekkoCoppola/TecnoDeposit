package model;

import java.time.LocalDate;


public class Articolo {
    private String nome;
    private String marca;
    private String compatibilita;
    private int id;
    private String tecnico;
    private String fornitore;
    private String pv;
    private String matricola;
    private String provenienza;
    private String note;
    private int ddt;
    private int ddtSpedizione;
    private boolean richiestaGaranzia;
    public enum Stato {
        ASSEGNATO,
        DESTINATO,
        GUASTO,
        IN_MAGAZZINO,
        IN_ATTESA,
        INSTALLATO,
        NON_RIPARATO,
        NON_RIPARABILE,
        RIPARATO;
        public String toString() {
            String nomeFormattato = this.name().replace("_", " ").toLowerCase();
            return Character.toUpperCase(nomeFormattato.charAt(0)) + nomeFormattato.substring(1);
        }
    }
    private Stato stato;
   
    private LocalDate dataRic;
    private LocalDate dataSpe;
    private LocalDate dataGaranzia;
    
    private String immagine;

    public Articolo(String nome, String marca, String compatibilita , String matricola, String provenienza, String note, int ddt, Stato stato, String tecnico,String fornitore,String pv, LocalDate dataRic, LocalDate dataSpe,LocalDate dataGaranzia,String immagine,int ddtSpedizione,boolean richiestaGaranzia) {
        this.nome = (nome != null) ? nome : "";
        this.marca = (marca != null) ? marca : "";
        this.compatibilita = (compatibilita != null) ? compatibilita : "";
        this.matricola = matricola;
        this.provenienza = provenienza;
        this.ddt = ddt;
        this.stato = stato;
        if(note.isEmpty()) note = " ";
        this.note = note;
        this.tecnico=tecnico;
        this.fornitore=fornitore;
        this.pv=pv;
        this.dataGaranzia=dataGaranzia;
        this.dataRic = dataRic;
        this.dataSpe = dataSpe;
        this.ddtSpedizione = ddtSpedizione;
        this.immagine = immagine;
        this.richiestaGaranzia=richiestaGaranzia;
    }

    public Articolo() {
		// TODO Auto-generated constructor stub
	}
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

	public String getNote(){return this.note;}

    public int getDdt(){return this.ddt;}

    public void setNote(String note){this.note=note;}

    public void setDdt(int ddt){this.ddt=ddt;}
    
    public int getDdtSpedizione(){return this.ddtSpedizione;}
    
    public void setDdtSpedizione(int ddtSpedizione){this.ddtSpedizione=ddtSpedizione;}

    public String getNome() {if(!nome.equals(" ")) return nome;else return nome="";}

    public void setNome(String nome) {this.nome = (nome != null) ? nome : "";}

    public String getMarca() {if(!marca.equals(" ")) return marca;else return marca="";}

    public String getMatricola() {if(!matricola.equals(" ")) return matricola;else return matricola="";}

    public String getProvenienza() {return provenienza;}

    public void setMatricola(String matricola) {this.matricola= matricola;}

    public void setProvenienza(String provenienza) {this.provenienza=provenienza;}

    public void setMarca(String marca) {this.marca = (marca != null) ? marca : "";}

    public String getCompatibilita() {if(!compatibilita.equals(" ")) return compatibilita;else return compatibilita="";}

    public void setCompatibilita(String compatibilita) {this.compatibilita = (compatibilita != null) ? compatibilita : "";}

    public Stato getStato(){return stato;}

    public void setStato(Stato stato) {this.stato=stato;}

    public LocalDate getDataRic_DDT() {return dataRic;}

    public void setDataRic_DDT(LocalDate dataRic) {this.dataRic = dataRic;}

    public LocalDate getDataSpe_DDT() {return dataSpe;}

    public void setDataSpe_DDT(LocalDate dataSpe) {this.dataSpe = dataSpe;}
    
    public String getTecnico() { return this.tecnico;}
    
    public String getPv() { return this.pv;}
    
    public String getFornitore() { return this.fornitore;}
    
    public void setTecnico(String tecnico) { this.tecnico=tecnico;}
    
    public void setPv(String pv) { this.pv=pv;}
    
    public void setFornitore(String fornitore) { this.fornitore=fornitore;}
    
    public void setImmagine(String immagine) { this.immagine=immagine;}
    
    public String getImmagine() { return this.immagine;}

    public LocalDate getDataGaranzia() {return dataGaranzia;}

    public void setDataGaranzia(LocalDate dataGaranzia) {this.dataGaranzia = dataGaranzia;}
    
    public boolean getRichiestaGaranzia() {return this.richiestaGaranzia;}
    
    public void setRichiestaGaranzia(Boolean flag) {this.richiestaGaranzia= flag;}
    
    @Override
    public boolean equals(Object obj) {
        if(obj instanceof Articolo) {
            Articolo o = (Articolo)obj;
            if(this.id==o.id);
            	return true;
        }
        return false;
    }
    @Override
    public String toString(){
        String init = "ID: "+id+" Nome: "+nome+"Immagine: "+immagine;
        return init;
    }
}
