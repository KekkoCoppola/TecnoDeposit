	setTimeout(() => {
		    document.getElementById('notificaErrore').style.display = 'none';
		  }, 5000); 
	  
	  document.querySelector('.fa-eye-slash').parentElement.addEventListener('click', function() {
	         const passwordInput = document.getElementById('password');
	         const icon = this.querySelector('i');
	         
	         if (passwordInput.type === 'password') {
	             passwordInput.type = 'text';
	             icon.classList.replace('fa-eye-slash', 'fa-eye');
	         } else {
	             passwordInput.type = 'password';
	             icon.classList.replace('fa-eye', 'fa-eye-slash');
	         }
	     });

	     // Simple form validation
	     document.querySelector('form').addEventListener('submit', function(e) {
	         const username = document.getElementById('username').value;
	         const password = document.getElementById('password').value;
	         
	         if (!username || !password) {
	             e.preventDefault();
	             alert('Compila Tutti I Campi');
	         }
	     });
		 VANTA.NET({
		   el: "#background",
		   mouseControls: true,
		   touchControls: true,
		   gyroControls: false,
		   minHeight: 200.00,
		   minWidth: 200.00,
		   scale: 1.00,
		   scaleMobile: 1.00,
		   color: 0xe0373c,
		   backgroundColor: 0x151516,
		   points: 20.00,
		   maxDistance: 10.00,
		   spacing: 13.00
		 })