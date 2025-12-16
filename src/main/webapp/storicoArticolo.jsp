<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.Articolo" %>
<%@ page import="model.ListaArticoli" %>
<%@ page import="model.StoricoArticoloDAO" %>

<div class="history-scroll max-h-96 overflow-y-auto pr-2">
    <div class="relative">
        <%

			List<String> differenze = (List<String>) request.getAttribute("storico");
			
            if (differenze.isEmpty()) {
        %>
            <div class="p-4 text-center text-gray-500">Nessuna modifica registrata per questo articolo.</div>
        <%
            } else {
                for (String riga: differenze) {
                	String[] parte1 = riga.split(" da ", 2);
                	String campo = parte1[0].trim(); // es. "NOME"

                	// 2. Spezza per " -----> a "
                	String[] parte2 = parte1[1].split(" -----> a ", 2);
                	String oldValue = parte2[0].trim();

                	// 3. Spezza per " \\(il "
                	String[] parte3 = parte2[1].split(" \\(il ", 2);
                	String newValue = parte3[0].trim();

                	String dataGrezzaUtente = parte3[1].replace(")", "").trim(); // es: 2025-07-29 10:12, utente: Mario

                	// 4. Separiamo data e utente
                	String[] splitDataUtente = dataGrezzaUtente.split(", utente: ");
                	String dataGrezza = splitDataUtente[0].trim(); // es: 2025-07-29 10:12
                	String utente = splitDataUtente.length > 1 ? splitDataUtente[1].trim() : "-";

                	// 5. Formattiamo la data
                	SimpleDateFormat formatoDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                	SimpleDateFormat formatoITA = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                	String data = dataGrezza;
                	try {
                	    Date parsed = formatoDB.parse(dataGrezza);
                	    data = formatoITA.format(parsed);
                	} catch (Exception e) {
                	    System.err.println("⚠️ Errore parsing data, la lascio grezza: " + dataGrezza);
                	}

        %>
            <div class="timeline-item relative pl-8 pb-6">
                <div class="absolute left-0 top-0 h-5 w-5 rounded-full bg-red-500 flex items-center justify-center text-white text-xs">
                    <i class="fas fa-edit"></i>
                </div>
                <div class="bg-white p-3 rounded-lg border border-gray-200 shadow-sm">
                    <div class="flex justify-between items-start">
                        <div>
                            <div class="flex items-center text-sm text-gray-500 font-semibold mb-1">
							  <i class="fas fa-tag mr-1 text-gray-400"></i> <%= campo %>
							</div>

                            <div class="text-sm text-gray-700">
							  <span class="line-through text-gray-400"><%= oldValue %></span>
							  <span class="mx-2 text-gray-500">→</span>
							  <span class="text-green-600 font-semibold"><%= newValue %></span>
							</div>

                        </div>
                        <span class="text-xs text-gray-400">
                            <%=data %>
                        </span>
                    </div>

                    <div class="mt-2 flex items-center">
                        <div class="flex-shrink-0 h-6 w-6 rounded-full bg-gray-200 flex items-center justify-center text-gray-600 text-xs">
                            <i class="fas fa-user"></i>
                        </div>
                        <span class="ml-2 text-xs text-gray-600">
                          <%= utente %>
                        </span>
                    </div>

                    
             
                </div>
            </div>
        <%
                } // fine for
            } // fine else
        %>
    </div>
</div>
