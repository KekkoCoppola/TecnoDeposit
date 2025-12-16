package model;

public class Fornitore {
    private String nome;
    private String mail;
    private String piva;
    private int id;
    private String telefono;
    private String indirizzo;

    public Fornitore(String nome, String mail, String piva , String indirizzo, String telefono) {
        this.nome = (nome != null) ? nome : "";
        this.mail = (mail != null) ? mail : "";
        this.piva = (piva != null) ? piva : "";
        this.telefono = (telefono != null) ? telefono : "";
        this.indirizzo = (indirizzo != null) ? indirizzo : "";
        
    }

    public Fornitore() {
		// TODO Auto-generated constructor stub
	}
    
    public int getId() {return id;}
    public void setId(int id) {this.id = id;}
    
    public String getNome(){return this.nome;}
	public void setNome(String nome){this.nome=nome;}

	public String getMail(){return this.mail;}
	public void setMail(String mail){this.mail=mail;}
	
	public String getPiva(){return this.piva;}
	public void setPiva(String piva){this.piva=piva;}
	
	public String getTelefono(){return this.telefono;}
	public void setTelefono(String telefono){this.telefono=telefono;}

	public String getIndirizzo(){return this.indirizzo;}
	public void setIndirizzo(String indirizzo){this.indirizzo=indirizzo;}


    @Override
    public String toString(){
        String init = "(FORNITORE) ID: "+id+" Nome: "+nome+"Mail: "+mail;
        return init;
    }
}
