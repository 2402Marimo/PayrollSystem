<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="Model.Bean.PayrollBean"%>
<%@ page import="java.util.*" %>
    
<%
	if (session.getAttribute("loggedInStaff") == null) {
		response.sendRedirect("login.jsp");
	}

	List<PayrollBean> payrolls = (List<PayrollBean>) session.getAttribute("staff_payroll");
	String staff_payroll = "";
	if (payrolls != null) {
		staff_payroll = "[";
		int ctr = 0; 
		for (PayrollBean each : payrolls) { 
			ctr++; 
			staff_payroll += "{";
			staff_payroll += "\"payroll_date\": \"" + each.getDate() + "\""; 
			staff_payroll += ",\"salary\": " + each.getPayroll(); 
			staff_payroll += "}";
		  
			if (ctr < payrolls.size()) {staff_payroll += ",";} 
		} 
		staff_payroll += "]";
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>給与一覧</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="http://localhost:8080/PayrollSystem/script/Message.js"></script>
<style>
.container {
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	flex-direction:column;
}

.table-container {
	max-height: 400px;
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
	margin-bottom: 50px;
	width: 40%;
	flex-direction: column;
	gap: 10px;
}

.fixed {
	display: fixed;
}

	.action-button {
		border: 0;
		box-shadow: none;
		border-radius: 0px;
		height: 50px;
		width: 100px;
	}
</style>
</head>
<body>
	&nbsp;&nbsp;S120
	<div class="container">
		<div class='form-row'>
			<div class='fixed'>給与一覧</div>
			<div>給与年</div>
			<div>
				<select id="payrollyear">
				</select>
			</div>
			<div class="table-container">
				<table class="maintable">
					<thead>
						<tr>
							<th>支給年月日</th>
							<th>支給額</th>
						</tr>
					</thead>
					<tbody id="payroll_table">
					</tbody>
				</table>
			</div>
		</div>
		<div><button id="return" class='action-button'>戻る</button></div>
	</div>
</body>
<script>
	function limitTableRows() {
	    var maxRows = 15;
	    $('.maintable tbody tr:gt(' + (maxRows - 1) + ')').hide();
	}
	
	function showNextHiddenRow() {
        var maxRows = 15;
        var visibleRows = $('.maintable tbody tr:visible');
        var hiddenRows = $('.maintable tbody tr:hidden');
        
        if (visibleRows.length < maxRows && hiddenRows.length > 0) {
            hiddenRows.eq(0).show(); 
        }
    }
	
	$(function(){
		var years = [];
		var rows = [,];
		var selected_year = "";
		
		$("#return").click(function(){
			window.location.href = "menu.jsp";
		})

		var payrolls = <%= staff_payroll %>;
		
		if (payrolls != "") {
			$.each(payrolls, function (index, item) {
				years.push(item.payroll_date.substring(0,4))
				rows.push(item.payroll_date.substring(0,4), "<tr><td>" + item.payroll_date + "</td><td>" + item.salary + "</td></tr>");
	        });
			
			var uniqueYear = years.filter((value, index, self) => {
				return self.indexOf(value) === index;
			});
			
			uniqueYear.sort()
			uniqueYear.reverse()
			
			$.each(uniqueYear, function(index, item) {
				if (index == 0) 
					selected_year = item
				var option = "<option value='"+item+"'>"+item+"</option>"
				$("#payrollyear").append(option);
			})
			
			var apply_tr = false;
			
			$.each(rows, function(outerIndex, innerArray) {
				if (!apply_tr) {
				    if (innerArray == selected_year) {
				    	apply_tr = true
				    }
				} else {
			    	$("#payroll_table").append(innerArray);
			    	apply_tr = false;
				}
			});
			
			limitTableRows();
		}

		/* $.ajax({
			type: "GET",
			url: "/PayrollSystem/PayrollServlet?isDisp=false", 
			dataType: "json",
			success: function(result){
				
				
				var uniqueYear = years.filter((value, index, self) => {
					return self.indexOf(value) === index;
				});
				
				uniqueYear.sort()
				uniqueYear.reverse()
				
				$.each(uniqueYear, function(index, item) {
					if (index == 0) 
						selected_year = item
					var option = "<option value='"+item+"'>"+item+"</option>"
					$("#payrollyear").append(option);
				})
				
				var apply_tr = false;
				
				$.each(rows, function(outerIndex, innerArray) {
					if (!apply_tr) {
					    if (innerArray == selected_year) {
					    	apply_tr = true
					    }
					} else {
				    	$("#payroll_table").append(innerArray);
				    	apply_tr = false;
					}
				});
				
				limitTableRows();
  			},
  			error: function(xhr, textStatus, errorThrown) {
  		        console.error("AJAX Error:", textStatus, errorThrown)
  		        alert('Request failed. Check the console for details.')
  		    }
		}); */
		
		$("#payrollyear").on('change',function(){
			$(".maintable tbody").empty();
			var apply_tr = false;
			
			$.each(rows, function(outerIndex, innerArray) {
				if (!apply_tr) {
				    if (innerArray == $("#payrollyear").val()) {
				    	apply_tr = true
				    }
				} else {
			    	$("#payroll_table").append(innerArray);
			    	apply_tr = false;
				}
			});
		})
		
	})
</script>
</html>