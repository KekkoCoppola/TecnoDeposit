package model;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class User {
	private String username;
	private int id;
	private String mail;
	private String ruolo;
	private String stato;
	private String nome;
	private String cognome;
	private String telefono;
	
	private Timestamp ultimo_accesso;
	
	public User(String username,String mail,String nome,String cognome,String ruolo,String stato,Timestamp ultimo_accesso) {
		this.username=username;
		this.mail=mail;
		this.nome=nome;
		this.cognome=cognome;
		this.ruolo=ruolo;
		this.stato=stato;
		this.ultimo_accesso=ultimo_accesso;
	}
	
	public User() {}
	
	public int getId() {return this.id;}
	public String getMail() {return this.mail;}
	public String getTelefono() {return this.telefono;}
	public String getUsername(){return this.username;}
	public String getNome(){return this.nome;}
	public String getCognome(){return this.cognome;}
	public String getRuolo(){return this.ruolo;}
	public String getStato(){return this.stato;}
	public String getUltimoAccesso2(){
		if (ultimo_accesso == null) {
            return "Mai effettuato";
        }

        LocalDateTime ldt = ultimo_accesso.toLocalDateTime();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return ldt.format(formatter);
		}
	
	public void setTelefono(String telefono) { this.telefono=telefono;}
	public void setId(int id) { this.id=id;}
	public void setMail(String mail) { this.mail=mail;}
	public void setUsername(String username){this.username=username;}
	public void setNome(String nome){this.nome=nome;}
	public void setCognome(String cognome){this.cognome=cognome;}
	public void setRuolo(String ruolo){this.ruolo=ruolo;}
	public void setStato(String stato){this.stato=stato;}
	public void setUltimoAccesso(Timestamp ultimo_accesso){this.ultimo_accesso=ultimo_accesso;}
	
	
}
