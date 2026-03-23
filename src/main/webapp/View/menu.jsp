<%@page import="Model.Bean.StaffBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	StaffBean loggedInStaff = (StaffBean) session.getAttribute("loggedInStaff");
	String loggedInStaffName = "";
	String loggedInStaffId = "";
	boolean isAdmin = false;
	if (loggedInStaff == null) {
		response.sendRedirect("login.jsp");
	} else {
		loggedInStaffName = loggedInStaff.getStaff_name();
		loggedInStaffId = loggedInStaff.getStaff_id();
		isAdmin = loggedInStaff.isAdmin();
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
			<%= loggedInStaffName %>
		</span>
		<a id="logoutLink" href="/PayrollSystem/LogoutServlet">ログアウト</a>
	</div>
	<div></div>
	<div></div>
	<div></div><div></div><div></div>
	<div class="menurow">メニュー</div>
	<div class="menurow"><a href="/PayrollSystem/StaffInfoServlet?isDisp=true&title=update&staff_id=<%= loggedInStaffId %>&from=menu">社員情報変更</a></div>
	<div class="menurow"><a href="/PayrollSystem/PayrollServlet?from=menu">給与一覧</a></div>
	<div class="menurow adminmenu"><a href="/PayrollSystem/StaffAdminServlet?isDisp=true&after_delete=false">社員管理</a></div>
	<div class="menurow adminmenu"><a href="/PayrollSystem/PayrollServlet?from=admin">給与管理</a></div>
</div>
</body>
<script>
	if (!<%= isAdmin %>) {
		$(".adminmenu").hide();
	}
	
	$(".okOnly").click(function(){
		alert("未表示");
	});
</script>
</html>