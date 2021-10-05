<cfscript>
	message = "";
if(StructKeyExists(form, "username") AND StructKeyExists(form, "password")){
	loginCode = new controllers.login().authenticateUser(form.username, hash(form.password, "SHA-512", "UTF-8"));	
	
	switch (loginCode) {
		case 0: message = "Logging you in"
			break;
		case 1: message = "Your Account has been locked out. Either wait 24 hours or request a password reset"
			break;
		case 2: message = "Username or Password is incorrect, please try again."
			break;
		default: message = "Logging you in."
	}
}
</cfscript>
<cfoutput>
<html>
	<head>
		<title>Log in</title>
		<style>
		html, body {
			margin: 0;
			padding: 0;
		}
		##wrapper {
			height: 100vh;
			display: flex; 
			justify-content: center;
			align-items: center;
			background-color: ##696969

		}
		##loginBox {
			background-color: ##fff;
			display: flex;
			justify-self: center;
			align-self: center;
			border: 2px solid black;
			flex-direction: column;
			width: 20vw;
			height: 20vh;
		}
		##loginForm {
			display: flex;
			flex-direction: column;
			margin: 2vh;
		}
		##messagebox {
			display: flex;
			justify-content: center;
			color: ##fff;
		}
		.label {
			margin: 1vh 0 1vh 0;
			font-family: helvetica;
		}
		.textField {
			height 15px;
		}
		.btn {
			border: none;
			margin-top: 1vh;
			font-family: helvetica;
			color: ##ffffff;
			font-size: 20px;
			background: ##696969;
			padding: 10px 20px 10px 20px;
			text-decoration: none;
		}
		.btn:hover {
		background: ##3c49fd;
		text-decoration: none;
		}
		</style>
	</head>
	<body>
		<div id="wrapper">
			<div id="loginBox">
				<form id="loginForm" action="" method="post">
						<label class="label" for="username">Username:</label>
						<input class=textField name="username" type="text" id="username">
						<label class="label" for="password">Password:</label>
						<input class=textField name="password" type="password" id="password">
						<input class="btn" type="submit" value="Log in" name="submit">
				</form>
				<div id="messagebox">#message#</div>
			</div>
		</div>

	</body>
</html>
</cfoutput>
