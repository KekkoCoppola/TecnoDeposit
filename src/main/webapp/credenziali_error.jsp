<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="it">
<head><meta charset="UTF-8"><meta name="robots" content="noindex"><title>Link non valido</title></head>
<body style="font-family:system-ui;background:#f6f7f9">
  <div style="max-width:520px;margin:40px auto;background:#fff;border-radius:14px;padding:24px">
    <h2 style="margin-top:0">Link non valido</h2>
    <p><%= request.getAttribute("error") %></p>
  </div>
</body>
</html>
