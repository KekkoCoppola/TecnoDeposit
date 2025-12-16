<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Statistiche");
    request.setAttribute("contentPage", "statisticheContent.jsp");
    String pageTitle = (String) request.getAttribute("pageTitle");
%>
<title><%= pageTitle %></title>

<jsp:include page="layout.jsp" />
