<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Richieste Materiale");
    request.setAttribute("contentPage", "richiesteContent.jsp");
    String pageTitle = (String) request.getAttribute("pageTitle");
%>
<title><%= pageTitle %></title>

<jsp:include page="layout.jsp" />
