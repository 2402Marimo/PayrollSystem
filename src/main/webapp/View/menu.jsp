<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String staffSession = (String) session.getAttribute("loggedInStaffId");
	if (staffSession == null) {
 		
	} 
%>
<!DOCTYPE html>
<html>
<head>
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
	  	
	  	.menurow {
	  		display: flex;
		  	right: center; 
		  	gap: 10px;
		  	text-align:left;
		  	width:150px;
		  	margin-left:150px;
	  	}
	</style>
</head>
<body>
&nbsp;&nbsp;S100
<div class="container">
	<div>社員名：
		<span>
			${sessionScope.loggedInStaffName}
		</span>
		<a id="logoutLink" href="/PayrollSystem/LogoutServlet">ログアウト</a>
	</div>
	<div></div>
	<div></div>
	<div></div><div></div><div></div>
	<div class="menurow">メニュー</div>
	<div class="menurow"><a href="/PayrollSystem/StaffInfoServlet?title=update">社員情報変更</a></div>
	<div class="menurow"><a href="" class="okOnly">給与一覧</a></div>
	<div class="menurow adminmenu"><a href="/PayrollSystem/StaffAdminServlet">社員管理</a></div>
	<div class="menurow adminmenu" class="okOnly"><a href="">給与管理</a></div>
</div>
</body>
<script>
	var isAdmin = ${sessionScope.loggedInStaffIsAdmin};
	if (!isAdmin) {
		$(".adminmenu").hide();
	}
	
	$(".okOnly").click(function(){
		alert("未表示");
	});
</script>
</html>