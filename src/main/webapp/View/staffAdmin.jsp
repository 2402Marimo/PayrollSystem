<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String staffSession = (String) session.getAttribute("loggedInStaffId");
if (staffSession == null) {
	response.sendRedirect("login.jsp");
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>社員管理画面</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="http://localhost:8080/PayrollSystem/script/Message.js"></script>
<style>
.container {
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
}

.table-container {
	max-height: 400px;
	width: 50%;
	margin-left: 10px;
	overflow-y: auto;
	overflow-x: auto;
	border: 1px solid #ccc;
}

.maintable {
	border-collapse: collapse;
	width: 100%;
}

.maintable thead th {
	position: sticky;
	top: 0;
	background: #fff;
}

.maintable, th, td {
	border: 1px solid black;
}

.maintable tr.selected {
	background-color: rgb(192, 192, 192) !important;
	vertical-align: middle;
	padding: 1.5em;
}

.maintable td {
	margin-left: 10px;
}

#message {
	color: red;
}

.form-row {
	display: flex;
	margin-bottom: 200px;
	width: 40%;
	flex-direction: column;
	gap: 25px;
}

.form-button {
	display: flex;
	align-items: right;
	margin-bottom: 15%;
	gap: 25px;
	flex-direction: column;
}

.action-button {
	border: 0;
	box-shadow: none;
	border-radius: 0px;
	height: 50px;
	width: 100px;
}

.fixed {
	display: fixed;
}
</style>
</head>
<body>
	&nbsp;&nbsp;S210
	<div class="container">
		<div class='form-row'>
			<div class='fixed'>社員管理</div>
			<div>
				<span id="message"></span>
			</div>
			<div class="table-container">
				<table class="maintable">
					<thead>
						<tr>
							<th>社員ID</th>
							<th>社員名</th>
						</tr>
					</thead>
					<tbody id="staff_table">
					</tbody>
				</table>
			</div>
		</div>
		<div class='form-button'>
			<div>
				<button class='action-button' id="insertStaff">新規</button>
			</div>
			<div>
				<button class='action-button' id="updateStaff">更新</button>
			</div>
			<div>
				<button class='action-button' id="deleteStaff">削除</button>
			</div>
			<div>
				<button class='action-button' id="return">戻る</button>
			</div>
		</div>
	</div>
</body>
<script>
	function limitTableRows() {
	    var maxRows = 100;
	    $('.maintable tbody tr:gt(' + (maxRows - 1) + ')').hide();
	}
	
	function showNextHiddenRow() {
        var maxRows = 100;
        var visibleRows = $('.maintable tbody tr:visible');
        var hiddenRows = $('.maintable tbody tr:hidden');
        
        if (visibleRows.length < maxRows && hiddenRows.length > 0) {
            hiddenRows.eq(0).show(); 
        }
    }
	
	$(function(){
		var selected_id = "";
		var selected_name = "";
		
		$(".maintable tbody").on('click', 'tr', function () {
            $('.selected').removeClass('selected');
            $(this).addClass("selected");
            selected_id = $('.staff_id',this).html();
            selected_name = $('.staff_name',this).html();
        });
		
		$("#insertStaff").click(function(){
			window.location.href = "staffInfo.jsp?title=insert&from=admin"
		})
		
		$("#updateStaff").click(function(){
			if (selected_id=="") {
				$("#message").text('社員を選択してください');
			} else {
				window.location.href = '//' + "localhost:8080/PayrollSystem/StaffInfoServlet?isDisp=true&title=update&staff_id="+selected_id+"&from=admin";
			}
		})
		
		$("#deleteStaff").click(function(){
			if (selected_id=="") {
				$("#message").text('社員を選択してください');
			} else {
				if (confirm(getMessage("INFO0008", selected_name))) {
					$.ajax({
						type: "POST",
						url: "/PayrollSystem/StaffAdminServlet", 
						data:{'type': 'delete',
							'staff_id':selected_id},
						dataType: "json",
						success: function(result){
							if (result.status != '200')
								$("#message").text(result.message)
			    			else {
			    				$("#" + selected_id).remove();
			    				alert(getMessage("INFO0009", selected_name));
			    				showNextHiddenRow();
			    				selected_id = '';
			    				selected_name='';
			    			}
			  			},
			  			error: function(xhr, textStatus, errorThrown) {
			  		        console.error("AJAX Error:", textStatus, errorThrown);
			  		        alert('Request failed. Check the console for details.');
			  		    }
					});
			    }				
			}
		})
		
		$("#return").click(function(){
			window.location.href = "menu.jsp";
		})
		
		$.ajax({
			type: "GET",
			url: "/PayrollSystem/StaffAdminServlet?isDisp=false", 
			dataType: "json",
			success: function(result){
				$.each(result, function (index, item) {
					var markup = "<tr id='"+ item.staff_id +"'><td class='staff_id'>" + item.staff_id + "</td><td class='staff_name'>" + item.staff_name + "</td></tr>";
		            $("#staff_table").append(markup);
		        });
				limitTableRows();
  			},
  			error: function(xhr, textStatus, errorThrown) {
  		        console.error("AJAX Error:", textStatus, errorThrown);
  		        alert('Request failed. Check the console for details.');
  		    }
		});
		
		
	})
</script>
</html>