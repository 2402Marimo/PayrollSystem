$(document).ready(function() {
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
});
