<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>
    <%@ page import="java.util.List" %>
        <%@ page import="model.Fornitore" %>
            <%@ page import="model.ListaFornitori" %>

                <% List<Fornitore> fornitori = (List<Fornitore>) request.getAttribute("fornitori");
                        if (fornitori != null && !fornitori.isEmpty()) {
                        for (int i = 0; i < fornitori.size(); i++) { Fornitore f=fornitori.get(i); %>

                            <!-- Supplier Card -->
                            <div data-id="<%= f.getId() %>" data-nome="<%= f.getNome() %>"
                                data-mail="<%= f.getMail() %>" data-indirizzo="<%= f.getIndirizzo() %>"
                                data-piva="<%= f.getPiva() %>" data-telefono="<%= f.getTelefono() %>"
                                class="supplier-card bg-white rounded-2xl border border-gray-200 overflow-hidden hover:shadow-lg transition-all duration-300">

                                <!-- Header con nome -->
                                <div
                                    class="px-5 py-4 border-b border-gray-100 bg-gradient-to-r from-[#e52c1f] to-[#c5271b]">
                                    <h3 class="font-semibold text-white text-lg flex items-center gap-2">
                                        <i class="fas fa-building opacity-80"></i>
                                        <%= f.getNome() %>
                                    </h3>
                                </div>

                                <!-- Contenuto -->
                                <div class="p-5">

                                    <!-- Info contatti -->
                                    <div class="space-y-3 mb-5">

                                        <div class="flex items-center gap-3">
                                            <div
                                                class="w-9 h-9 rounded-lg bg-emerald-100 flex items-center justify-center flex-shrink-0">
                                                <i class="fas fa-phone text-emerald-600 text-sm"></i>
                                            </div>
                                            <div class="min-w-0 flex-1">
                                                <p class="text-[11px] text-gray-400 uppercase font-medium">Telefono</p>
                                                <p class="text-gray-800 font-medium truncate">
                                                    <%= f.getTelefono() !=null && !f.getTelefono().isEmpty() ?
                                                        f.getTelefono() : "Non specificato" %>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="flex items-center gap-3">
                                            <div
                                                class="w-9 h-9 rounded-lg bg-blue-100 flex items-center justify-center flex-shrink-0">
                                                <i class="fas fa-envelope text-blue-600 text-sm"></i>
                                            </div>
                                            <div class="min-w-0 flex-1">
                                                <p class="text-[11px] text-gray-400 uppercase font-medium">Email</p>
                                                <p class="text-gray-800 font-medium truncate">
                                                    <%= f.getMail() !=null && !f.getMail().isEmpty() ? f.getMail()
                                                        : "Non specificata" %>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="flex items-center gap-3">
                                            <div
                                                class="w-9 h-9 rounded-lg bg-violet-100 flex items-center justify-center flex-shrink-0">
                                                <i class="fas fa-map-marker-alt text-violet-600 text-sm"></i>
                                            </div>
                                            <div class="min-w-0 flex-1">
                                                <p class="text-[11px] text-gray-400 uppercase font-medium">Indirizzo</p>
                                                <p class="text-gray-800 font-medium truncate">
                                                    <%= f.getIndirizzo() !=null && !f.getIndirizzo().isEmpty() ?
                                                        f.getIndirizzo() : "Non specificato" %>
                                                </p>
                                            </div>
                                        </div>

                                        <div class="flex items-center gap-3">
                                            <div
                                                class="w-9 h-9 rounded-lg bg-amber-100 flex items-center justify-center flex-shrink-0">
                                                <i class="fas fa-file-alt text-amber-600 text-sm"></i>
                                            </div>
                                            <div class="min-w-0 flex-1">
                                                <p class="text-[11px] text-gray-400 uppercase font-medium">Partita IVA
                                                </p>
                                                <p class="text-gray-800 font-medium font-mono text-sm truncate">
                                                    <%= f.getPiva() !=null && !f.getPiva().isEmpty() ? f.getPiva()
                                                        : "Non specificata" %>
                                                </p>
                                            </div>
                                        </div>

                                    </div>

                                    <!-- Azioni -->
                                    <div class="flex flex-wrap gap-2 pt-4 border-t border-gray-100">
                                        <button onclick="caricaCatalogoFornitore(<%= f.getId() %>)"
                                            class="catalog-suppliers flex-1 min-w-[100px] flex items-center justify-center gap-2 px-3 py-2.5 rounded-xl bg-gray-100 hover:bg-gray-200 text-gray-700 text-sm font-medium transition-all">
                                            <i class="fas fa-box-open"></i>
                                            <span>Catalogo</span>
                                        </button>
                                        <button
                                            class="view-suppliers flex-1 min-w-[80px] flex items-center justify-center gap-2 px-3 py-2.5 rounded-xl bg-blue-50 hover:bg-blue-100 text-blue-700 text-sm font-medium transition-all">
                                            <i class="fas fa-eye"></i>
                                            <span>Dettagli</span>
                                        </button>
                                        <button
                                            class="edit-suppliers px-3 py-2.5 rounded-xl bg-emerald-50 hover:bg-emerald-100 text-emerald-700 transition-all"
                                            title="Modifica">
                                            <i class="fas fa-pen"></i>
                                        </button>
                                        <button
                                            class="delete-suppliers px-3 py-2.5 rounded-xl bg-red-50 hover:bg-red-100 text-red-600 transition-all"
                                            title="Elimina">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>

                                </div>
                            </div>

                            <% } } else { %>

                                <!-- Empty State -->
                                <div class="col-span-full flex flex-col items-center justify-center py-16">
                                    <div
                                        class="w-20 h-20 rounded-2xl bg-gray-100 flex items-center justify-center mb-5">
                                        <i class="fas fa-users text-3xl text-gray-400"></i>
                                    </div>
                                    <h3 class="text-lg font-semibold text-gray-700 mb-1">Nessun fornitore</h3>
                                    <p class="text-gray-400 text-sm">Aggiungi il tuo primo fornitore</p>
                                </div>

                                <% } %>

    </html>