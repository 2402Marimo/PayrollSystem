const MESSAGES = {
    "INFO0001": "ID、パスワードは6文字以上10文字以内です",
    "INFO0002": "半角英数字を入力してください",
    "INFO0003": "IDまたはパスワードが違います",
    "INFO0004": "社員名は3文字以上8文字いないです",
    "INFO0005": "英字、日本語文字を入力してください",
    "INFO0006": "新規登録が完了しました",
    "INFO0007": "登録を変更しました",
    "INFO0008": "[NAME]さんを削除してもよろしいですか？",
    "INFO0009": "[NAME]さんを削除しました",
    "INFO0010": "文字数は7文字まで、数字のみ入力してください",
    "INFO0011": "入力値が不正です",
    "INFO0012": "パスワードが一致しません",
    "INFO0013": "登録できませんでした。既に存在するIDです",
    "INFO0014": "[NAME]さんの[YEAR]年[MONTH]月の給与を￥[AMOUNT]に更新しました",
    "INFO0015": "存在しない社員です",
    "INFO0016": "社員を選択してください",
    "INFO0017": "エラーが発生しました。システム担当へ連絡してください。"
};

function getMessage(msgCode, name) {	
	// 1. Get the raw message template
    let message = MESSAGES[msgCode] || "Unknown Message Code";
    message = message.replace("[NAME]", name);
    return message;
}