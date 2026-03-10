$(document).ready(function() {
	const nameCheck = /^[一-龯ぁ-んァ-ヾー々\u3000-\u303F\uFF00-\uFFEF0-9a-zA-Z]*$/
	const idpassCheck = /^[a-zA-Z0-9]+$/
	
	$('.loginInput').focusout(function(){
		if (idpassCheck.test($('#staff_id').val())) {
			if (idpassCheck.test($('#staff_password').val())) {
				let passFlag = $('#staff_id').val().length >= 6 && $('#staff_id').val().length <= 10 && $('#staff_password').val().length >= 6 && $('#staff_password').val().length <= 10;
					if (!passFlag) {
					$("#message").text('ID、パスワードは6文字以上10文字以内です');
					$("#loginBtn").prop('disabled', true);
				} else {
					$("#message").text('');
					$("#loginBtn").prop('disabled', false);
				}
			} else {
				$("#message").text('半角英数字を入力してください');
				$("#loginBtn").prop('disabled', true);
			}
		} else {
			$("#message").text('半角英数字を入力してください');
			$("#loginBtn").prop('disabled', true);
		}
    });
	
	
	
	$("#tb_staff_name").focusout(function(){
		checkInputs();
	});
	
	$("#tb_staff_id").focusout(function(){
		checkInputs();
	});
	
	$("#tb_staff_password").focusout(function(){
		checkInputs();
	});
	
	$("#tb_staff_password_new").focusout(function(){
		checkInputs();
	});

	$("#tb_staff_password_confirm").focusout(function(){
		checkInputs();
		if ($("#tb_staff_password_new").val() != $(this).val()) {
			$("#message").text('パスワードが一致しません');
			$("#tb_staff_password_confirm").css("border-color", "red");
			$("#submitBtn").prop('disabled', true);
		} else {
			$("#tb_staff_password_confirm").css("border-color", "black");
			$("#submitBtn").prop('disabled', false);
		}
	});
	
	function checkInputs() {
		$("#message").text('');
		$("#message").css("color", "red");
		var disableSubmit = true;
		var msgtext = "";
		if (!nameCheck.test($("#tb_staff_name").val())){
			msgtext = "英字、日本語文字を入力してください";
			$("#tb_staff_name").css("border-color", "red");
		} else {
			if ($("#tb_staff_name").val().length < 3 || $("#tb_staff_name").val().length > 8) {
				msgtext = "社員名は3文字以上8文字以内です";
				$("#tb_staff_name").css("border-color", "red");
			} else {
				$("#tb_staff_name").css("border-color", "black");
				if (!idpassCheck.test($('#tb_staff_id').val())) {
					msgtext = "半角英数字を入力してください"
					$("#tb_staff_id").css("border-color", "red");
				} else {
					if ($('#tb_staff_id').val().length < 6 || $('#tb_staff_id').val().length > 10) {
						msgtext = "ID、パスワードは6文字以上10文字以内です"
						$("#tb_staff_id").css("border-color", "red");
					} else {
						$("#tb_staff_id").css("border-color", "black");
						if (!$("#tb_staff_password").is(':hidden')) {
							if ($('#tb_staff_password').val().length < 6 || $('#tb_staff_password').val().length > 10) {
								msgtext = "ID、パスワードは6文字以上10文字以内です"
								$("#tb_staff_password").css("border-color", "red");
							} else {
								if (!idpassCheck.test($('#tb_staff_password').val())) {
									$("#tb_staff_password").css("border-color", "red");
									msgtext = "半角英数字を入力してください"
								} else {
									$("#tb_staff_password").css("border-color", "black");
								}
							}
						}
						
						if ($('#tb_staff_password_new').val().length < 6 || $('#tb_staff_password_new').val().length > 10) {
							msgtext = "ID、パスワードは6文字以上10文字以内です"
							$("#tb_staff_password_new").css("border-color", "red");
						} else {
							if (!idpassCheck.test($('#tb_staff_password_new').val())) {
								msgtext = "半角英数字を入力してください"
								$("#tb_staff_password_new").css("border-color", "red");
							} else {
								$("#tb_staff_password_new").css("border-color", "black");
								if ($('#tb_staff_password_confirm').val().length < 6 || $('#tb_staff_password_confirm').val().length > 10) {
									msgtext = "ID、パスワードは6文字以上10文字以内です"
									$("#tb_staff_password_confirm").css("border-color", "red");
								} else {
									if (!idpassCheck.test($('#tb_staff_password_confirm').val())) {
										msgtext = "半角英数字を入力してください"
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
		
		$("#message").text(msgtext);
		$("#submitBtn").prop('disabled', disableSubmit);
	}
});
