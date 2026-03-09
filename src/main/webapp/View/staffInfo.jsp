<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>社員情報変更・新規登録画面</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<meta charset="UTF-8">
	<title>メニュー画面</title>
	<style>
		.container {
		    display: flex;
		    justify-content: center; 
		    align-items: center;     
		    height: 100vh;           
		    flex-direction: column;
		    gap: 15px;
	  	}
	  	
	  	#logoutLink {
	  		margin-left:300px;
	  	}
	  	
	  	.form-row {
	  		display: flex;
		  	align-items: center; 
		  	gap: 10px;
		  	width: 30%;
		}

		.form-row span {
		 	text-align: left;
		  	width: 130px;
		}
		
		.form-row label {
			text-align: left;
		  	margin-left: 10px;
		}

		.form-row input {
		  	float:left;
		  	margin-left:10px;
		}
		
		.form-row button {
		border: 0;
		box-shadow: none;
		border-radius: 0px;
		height:30px;
		width:100px;
		margin-left:10px;
	}
	</style>
</head>
<body>
&nbsp;&nbsp;S110
<div class="container">
	<div id="PageTitle"></div>
	<div id="message"></div>
	<div></div>
	<div></div><div></div><div></div>
	<div class="form-row">
		<span>社員名</span><label>:</label>
		<input type='text'>
	</div>
	<div></div>
	<div class="form-row">
		<span>社員ID</span><label>:</label>
		<input type='text'>
	</div>
	<div></div>
	<div class="form-row" id="password_now">
		<span>現在のパスワード</span><label>:</label>
		<input type='password'>
	</div>
	<div></div>
	<div class="form-row">
		<span id="password"></span><label>:</label>
		<input type='password'>
	</div>
	<div></div>
	<div class="form-row">
		<span id="confirm_password"></span><label>:</label>
		<input type='password'>
	</div>
	<div></div>
	<div class="form-row adminmenu">
		<span>権限</span><label>:</label>
		<input type='radio' value=0 name='role'> 一般 <input type='radio' value=1 name='role'> 管理
	</div>
	<div></div>
	<div class="form-row">
		<button id="submitBtn"></button> <button id="return">戻る</button>
	</div>
	<div></div>
</div>
</body>
<script>
	$(function() {
		var title = '${param.title}';
		if (title == "update") {
			$("#PageTitle").html("社員情報変更");
			$("#password").html("新しいパスワード");
			$("#confirm_password").html("新しいパスワード（確認用）");
			$("#submitBtn").html("更新");
		}
		else {
			$("#PageTitle").html("社員新規登録");
			$("#password_now").hide();
			$("#password").html("パスワード");
			$("#confirm_password").html("パスワード（確認用）");
			$("#submitBtn").html("更新");
		}
		
		var isAdmin = ${sessionScope.loggedInStaffIsAdmin};
		if (!isAdmin) {
			$(".adminmenu").hide();
		}
	});
</script>
</html>
