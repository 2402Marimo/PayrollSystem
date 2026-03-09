$(document).ready(function() {
	$('.loginInput').focusout(function(){
		if ((!/[^a-zA-Z0-9]/.test($('#staff_id').val()) && !/[^a-zA-Z0-9]/.test($('#staff_password').val())) == true) {
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
    });
});
