<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
%>
<%@page import="Model.Bean.StaffBean"%>

<%
	StaffBean loggedInStaff = (StaffBean) session.getAttribute("loggedInStaff");
	int loggedInStaffCode = -1;
	boolean isAdmin = false;
	if (loggedInStaff == null) {
		response.sendRedirect("login.jsp");
	} else {
		loggedInStaffCode = loggedInStaff.getStaff_code();
		isAdmin = loggedInStaff.isAdmin();
	}
	
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>社員情報変更・新規登録画面</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="http://localhost:8080/PayrollSystem/script/Message.js"></script>
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
		
		#message {
			display:flex;
			width:35%;
			text-align: left;
			color:red;
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
		<input type='text' id='tb_staff_name'>
	</div>
	<div></div>
	<div class="form-row">
		<span>社員ID</span><label>:</label>
		<input type='text' id='tb_staff_id'>
	</div>
	<div></div>
	<div class="form-row" id="password_now">
		<span>現在のパスワード</span><label>:</label>
		<input type='password' id='tb_staff_password'>
	</div>
	<div></div>
	<div class="form-row">
		<span id="password"></span><label>:</label>
		<input type='password' id='tb_staff_password_new'>
	</div>
	<div></div>
	<div class="form-row">
		<span id="confirm_password"></span><label>:</label>
		<input type='password' id='tb_staff_password_confirm'>
	</div>
	<div></div>
	<div class="form-row adminmenu">
		<span>権限</span><label>:</label>
		<input type='radio' value=0 name='role' checked> 一般 <input type='radio' value=1 name='role'> 管理
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
		
		function checkAdmin() {
			if (<%= isAdmin %>) 
				$(".adminmenu").hide();
		}
		
		$("#submitBtn").prop('disabled','true')
		var title = '${param.title}';
		var from = '${param.from}';
		if (title == "update") {
			$("#PageTitle").html("社員情報変更");
			$("#password").html("新しいパスワード");
			$("#confirm_password").html("新しいパスワード（確認用）");
			$("#submitBtn").html("更新");
		} else {
			$("#PageTitle").html("社員新規登録");
			$("#password_now").hide();
			$("#password").html("パスワード");
			$("#confirm_password").html("パスワード（確認用）");
			$("#submitBtn").html("新規登録");
		}
		
		$("#return").click(function(){
			if (from=='admin')
				window.location.href = "staffAdmin.jsp";
			else
				window.location.href = "menu.jsp";
		});
		
		checkAdmin();
		
		var staff_code = 0;
		var loggedInStaffCode = <%= loggedInStaffCode %>;
		var staff_id = '${param.staff_id}';
		
		function GetStaffData() {
			$.ajax({
				type: "GET",
				url: "/PayrollSystem/StaffInfoServlet?isDisp=false&staff_id="+staff_id, 
				dataType: "json",
				success: function(result){
					$("#tb_staff_name").val(result.staff_name);
					$("#tb_staff_id").val(result.staff_id);
					$("input[type='radio'][name='role'][value=" + result.authority_cd + "]").prop('checked', true);
					staff_code = result.staff_code;
	  			},
	  			error: function(xhr, textStatus, errorThrown) {
	  		        console.error("AJAX Error:", textStatus, errorThrown);
	  		        alert('Request failed. Check the console for details.');
	  		    }
			});
		}
		
		if (title == 'update') 
			GetStaffData();
			
		$("#submitBtn").click(function(){	
			let input_staff_id = $("#tb_staff_id").val()
			let input_staff_name = $("#tb_staff_name").val()
			let input_staff_password = $("#tb_staff_password").val()
			let input_staff_password_new = $("#tb_staff_password_new").val()
			let input_authority_cd = $("input[name='role']:checked").val()

			$.ajax({
				type: "POST",
				url: "/PayrollSystem/StaffInfoServlet", 
				data:{'type': title,
					'staff_code':staff_code,
					'staff_id':input_staff_id, 
					'staff_password':input_staff_password,
					'staff_password_new':input_staff_password_new,
					'staff_name':input_staff_name, 
					'authority_cd':input_authority_cd},
				dataType: "json",
				success: function(result){
	    			if (result.status != '200')
						$("#message").text(getMessage(result.message, ""));
	    			else {
	    				$("#message").css("color","blue");
	    				$("#message").text(getMessage(result.message, ""));
	    				if (title=='update') {
	    					$("#tb_staff_password").val("");
		    				$("#tb_staff_password_new").val("");
		    				$("#tb_staff_password_confirm").val("");
		    				if (input_authority_cd != 1 && staff_code == loggedInStaffCode) 
		    					$(".adminmenu").hide();
		    				GetStaffData();
	    				} else {
	    					$("#tb_staff_name").val('')
	    					$("#tb_staff_id").val('')
	    					$("#tb_staff_password").val('')
	    					$("#tb_staff_password_new").val('')
	    					$("#tb_staff_password_confirm").val('')
	    					$("input[type='radio'][name='role'][value=0]").prop('checked', true);
	    				}
	    			}
	  			},
	  			error: function(xhr, textStatus, errorThrown) {
	  		        console.error("AJAX Error:", textStatus, errorThrown);
	  		        alert('Request failed. Check the console for details.');
	  		    }
			});  
		});
		$("#tb_staff_name").focusout(function(){
			checkInputs(false);
		});
		
		$("#tb_staff_id").focusout(function(){
			checkInputs(false);
		});
		
		$("#tb_staff_password").focusout(function(){
			checkInputs(false);
		});
		
		$("#tb_staff_password_new").focusout(function(){
			checkInputs(false);
		});

		$("#tb_staff_password_confirm").focusout(function(){
			if ($("#tb_staff_password_new").val() != $(this).val()) {
				$("#message").text(getMessage("INF0012", ""));
				$("#tb_staff_password_confirm").css("border-color", "red");
				$("#submitBtn").prop('disabled', true);
			} else {
				$("#tb_staff_password_confirm").css("border-color", "black");
				$("#submitBtn").prop('disabled', false);
				checkInputs(true);
			}
		});
		
		const nameCheck = /^[一-龯ぁ-んァ-ヾー々\u3000-\u303F\uFF00-\uFFEF0-9a-zA-Z]*$/
		const idpassCheck = /^[a-zA-Z0-9]+$/
		
		function checkInputs(afterConfirm) {
			$("#message").text('');
			$("#message").css("color", "red");
			var disableSubmit = true;
			var passOk = false;
			var msgtext = "";
			if (!nameCheck.test($("#tb_staff_name").val())){
				msgtext = getMessage("INF0004", "");
				$("#tb_staff_name").css("border-color", "red");
			} else {
				if ($("#tb_staff_name").val().length < 3 || $("#tb_staff_name").val().length > 8) {
					msgtext = getMessage("INF0005", "");
					$("#tb_staff_name").css("border-color", "red");
				} else {
					$("#tb_staff_name").css("border-color", "black");
					if (!idpassCheck.test($('#tb_staff_id').val())) {
						msgtext = getMessage("INF0001", "");
						$("#tb_staff_id").css("border-color", "red");
					} else {
						if ($('#tb_staff_id').val().length < 6 || $('#tb_staff_id').val().length > 10) {
							msgtext = getMessage("INF0002", "");
							$("#tb_staff_id").css("border-color", "red");
						} else {
							$("#tb_staff_id").css("border-color", "black");
							if ($("#tb_staff_password").is(':hidden') == false) {
								if (!idpassCheck.test($('#tb_staff_password').val())) {
									msgtext = getMessage("INF0002", "");
									$("#tb_staff_password").css("border-color", "red");
								} else {
									if ($('#tb_staff_password').val().length < 6 || $('#tb_staff_password').val().length > 10) {
										$("#tb_staff_password").css("border-color", "red");
										msgtext = getMessage("INF0001", "");
									} else {
										$("#tb_staff_password").css("border-color", "black");
										passOk=true;
									}
								}
							} else {
								passOk = true;
							}
							
							if (passOk) {
								if (!idpassCheck.test($('#tb_staff_password_new').val())) {
									msgtext = getMessage("INF0002", "");
									$("#tb_staff_password_new").css("border-color", "red");
								} else {
									if ($('#tb_staff_password_new').val().length < 6 || $('#tb_staff_password_new').val().length > 10) {
										msgtext = getMessage("INF0001", "");
										$("#tb_staff_password_new").css("border-color", "red");
									} else {
										$("#tb_staff_password_new").css("border-color", "black");
										if (afterConfirm) {
											disableSubmit = false;
										} else {
											if ($("#tb_staff_password_new").val() != $('#tb_staff_password_confirm').val()) {
												msgText = getMessage('INF0012', '');
												$("#tb_staff_password_confirm").css("border-color", "red");
											} else {
												disableSubmit = false;
											}
										}
									}
								}
							}
						}
					}
				}
			}
			
			$("#message").text(msgtext);
			$("#submitBtn").prop('disabled', disableSubmit);
		}
	});
</script>
</html>
