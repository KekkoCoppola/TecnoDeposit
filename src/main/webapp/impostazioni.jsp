<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Impostazioni");
    request.setAttribute("contentPage", "impostazioniContent.jsp");
    String pageTitle = (String) request.getAttribute("pageTitle");
%>
<title><%= pageTitle %></title>

<jsp:include page="layout.jsp" />
