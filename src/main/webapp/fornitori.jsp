
<%
    request.setAttribute("pageTitle", "Centri Revisione");
    request.setAttribute("contentPage", "fornitoriContent.jsp");
    String pageTitle = (String) request.getAttribute("pageTitle");
%>
<title><%= pageTitle %></title>

<jsp:include page="layout.jsp" />
