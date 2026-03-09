<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
  	String staffSession = (String) session.getAttribute("loggedInStaffId");
  	if (staffSession != null) {
	 	response.sendRedirect("menu.jsp");
  	} 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ログイン画面</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="http://localhost:8080/PayrollSystem/script/inputcheck.js"></script>
<style>
	.container {
	    display: flex;
	    justify-content: center; 
	    align-items: center;     
	    height: 100vh;           
	    flex-direction: column;
	    gap: 15px;
  	}
  
	.form-row {
  		display: flex;
	  	align-items: center; 
	  	gap: 10px;
	  	width: 300px;
	}

	.form-row label {
	 	text-align: left;
	  	width: 150px;
	  	float:left;
	}

	.form-row input {
	  	float:left;
	  	margin-left:10px;
	}
	
	#emptyLabel {
		width: 110px;
	}
  
	.FormTitle {
		font-size:30px;
 	}
  
	.no-ime {
    	ime-mode: inactive;
	}
	
	#message {
		color:red;
	}
	
	#loginBtn {
		border: 0;
		box-shadow: none;
		border-radius: 0px;
		height:50px;
		width:100px;
	}
</style>

</head>
<body>
    &nbsp;&nbsp;S000
	<div class="container">
		<div class="FormTitle">給与管理システム</div>
		<div id="message"></div>
		<div class="form-row">
		  <label>社員ID : </label>
		  <input type="text" id="staff_id" class='loginInput no-ime'>
		</div>
		<div class="form-row">
		  <label>パスワード : </label>
		  <input type="password" id="staff_password" class='loginInput no-ime'>
		</div>
		<div class="form-row">
			<label id="emptyLabel"></label>
			<input type='checkbox' id='showPassword'>　表示
		</div>
		<button id='loginBtn'>ログイン</button>
	</div>
</body>
<script>
	//　パスワード表示対応　開始
	$("#showPassword").change(function() {
	    if(this.checked) {
	    	$('#staff_password').get(0).type = 'text';
	    } else {
	    	$('#staff_password').get(0).type = 'password';
	    }
	});
	//　パスワード表示対応　終了
	
	$("#loginBtn").click(function(){
		let passFlag = false;
		if (!/[^a-zA-Z0-9]/.test($('#staff_id').val())) {
			if (!/[^a-zA-Z0-9]/.test($('#staff_password').val())) {
				passFlag = true;
			}
		}
		
		if (!passFlag) {
			$("#message").text('ID、パスワードは6文字以上10文字以内です');
			$("#loginBtn").prop('disabled', true);
		} else {
			let staff_id = $("#staff_id").val();
			let password = $("#staff_password").val();
			$.ajax({
				type: "POST",
				url: "/PayrollSystem/LoginServlet", 
				data:{'staff_id':staff_id, 'staff_password':password},
				dataType: "json",
				success: function(result){
	    			if (result.status != '200')
						$("#message").text(result.message);
	    			else
	    				window.location.href = "menu.jsp";
	  			},
	  			error: function(xhr, textStatus, errorThrown) {
	  		        console.error("AJAX Error:", textStatus, errorThrown);
	  		        alert('Request failed. Check the console for details.');
	  		    }
			});
		}
	});
</script>
</html>