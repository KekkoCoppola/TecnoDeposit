<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="robots" content="noindex, nofollow">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Credenziali TecnoDeposit</title>
  <style>
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,sans-serif;background:#f6f7f9;margin:0}
    .card{max-width:520px;margin:40px auto;background:#fff;border-radius:14px;box-shadow:0 10px 30px rgba(0,0,0,.06);padding:24px}
    .warn{background:#fff7ed;border:1px solid #fed7aa;color:#9a3412;border-radius:10px;padding:12px;margin-bottom:16px}
    code{font-size:18px;padding:10px 12px;background:#0b1020;color:#e6edf3;border-radius:8px;display:block;word-break:break-all}
    button{padding:10px 14px;border:0;border-radius:10px;background:#ef4444;color:#fff;cursor:pointer}
    .row{display:flex;gap:10px;align-items:center;justify-content:space-between;margin-top:12px}
    small{color:#6b7280}
  </style>
</head>
<body>
  <div class="card">
    <h2 style="margin:0 0 10px">La tua password</h2>
    <div class="warn">Questa pagina è <b>visibile una sola volta</b>. Copia e conserva la password in un luogo sicuro.</div>

    <code id="pwd"><%= request.getAttribute("password") %></code>

    <div class="row">
      <button id="copyBtn">Copia</button>
      <small>Se chiudi o aggiorni la pagina, non potrai rivederla.</small>
    </div>
  </div>
  <script>
    document.getElementById('copyBtn').onclick = async () => {
      const t = document.getElementById('pwd').innerText;
      try { await navigator.clipboard.writeText(t); alert('Password copiata ✅'); }
      catch(e){ alert('Copia non riuscita, seleziona e copia manualmente.'); }
    };
  </script>
</body>
</html>
