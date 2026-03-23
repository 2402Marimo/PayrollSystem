const MESSAGES = {
    "INF0001": "ID、パスワードは6文字以上10文字以内です",
    "INF0002": "半角英数字を入力してください",
    "INF0003": "IDまたはパスワードが違います",
    "INF0004": "社員名は3文字以上8文字いないです",
    "INF0005": "英字、日本語文字を入力してください",
    "INF0006": "新規登録が完了しました",
    "INF0007": "登録を変更しました",
    "INF0008": "[NAME]さんを削除してもよろしいですか？",
    "INF0009": "[NAME]さんを削除しました",
    "INF0010": "文字数は7文字まで、数字のみ入力してください",
    "INF0011": "入力値が不正です",
    "INF0012": "パスワードが一致しません",
    "INF0013": "登録できませんでした。既に存在するIDです",
    "INF0014": "[NAME]さんの[YEAR]年[MONTH]月の給与を￥[AMOUNT]に更新しました",
    "INF0015": "存在しない社員です",
    "INF0016": "社員を選択してください",
    "INF0017": "エラーが発生しました。システム担当へ連絡してください。"
};

function getMessage(msgCode, name) {	
    let message = MESSAGES[msgCode] || "Unknown Message Code";
    message = message.replace("[NAME]", name);
    return message;
}