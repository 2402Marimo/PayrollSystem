<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="Model.Bean.PayrollBean"%>
<%@page import="Model.Bean.StaffBean"%>
<%@ page import="java.util.*" %>
<%@ page import="Model.共有.StaffLogic" %>
<%@ page import="Model.共有.PayrollLogic" %>
<%@ page import="java.util.stream.Collectors" %>
<!DOCTYPE html>
<html>
<head>
<%
	if (session.getAttribute("loggedInStaff") == null) {
		response.sendRedirect("login.jsp");
	}

	class ReturnData {
		public String staff_id, staff_name, payroll_date;
		public int staff_code, salary;
	
		public ReturnData(int staff_code, String staff_id, String staff_name, String payroll_date,
				int salary) {
			super();
			this.staff_code = staff_code;
			this.staff_id = staff_id;
			this.staff_name = staff_name;
			this.payroll_date = payroll_date;
			this.salary = salary;
		}
		
		public String getStaff_id() {
			return this.staff_id.toLowerCase();
		}
	}
	
	int ctr = 0;
	
	List<PayrollBean> payrolls = (List<PayrollBean>) session.getAttribute("staff_payroll");
	String staff_payroll = "";
	StaffLogic staffLogic = new StaffLogic();
	ArrayList<StaffBean> staffs = staffLogic.getStaffList(); 
    ArrayList<ReturnData> returnDatas = new ArrayList<>();
    
    if (payrolls != null) {
	    for (PayrollBean each : payrolls) {
	    	StaffBean staff = staffs.stream().filter(s -> s.getStaff_code() == each.getStaff_code()).collect(Collectors.toList()).get(0);
	    	String staff_name = staff.getStaff_name();
	    	String staff_id = staff.getStaff_id();
	    	
	    	returnDatas.add(new ReturnData(each.getStaff_code(), staff_id, staff_name, each.getDate(), each.getPayroll()));
		}
	    
	    returnDatas.sort(Comparator.comparing(ReturnData::getStaff_id));
	    
	    if (returnDatas.size() > 0) {
	    	staff_payroll = "[";
		    for (ReturnData each : returnDatas) {
		    	ctr++;
		    	staff_payroll += "{";
		    	staff_payroll += "\"staff_code\": " + each.staff_code + ",";
		    	staff_payroll += "\"staff_name\": \"" + each.staff_name + "\",";
		    	staff_payroll += "\"payroll_date\": \"" + each.payroll_date + "\",";
		    	staff_payroll += "\"salary\": " + each.salary;
		    	staff_payroll += "}";
				
				if (ctr < payrolls.size()) {staff_payroll += ",";}
			}
		    staff_payroll += "]";
	    }
    }
%>
<meta charset="UTF-8">
<title>給与管理画面</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="http://localhost:8080/PayrollSystem/script/Message.js"></script>
<style>
	.container {
		display: flex;
		justify-content: center;
		align-items: center;
		height: 100vh;
	}

	.table-container {
		max-height: 700px;
		overflow-y: auto;
		overflow-x: auto;
		width: 91%;
		margin-left:9%;
	}

	.maintable {
		border-collapse: collapse;
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

	.form-row {
		display: flex;
		margin-bottom: 20%;
		width: 30%;
		flex-direction: column;
		gap: 10px;
	}

	.fixed {
		display: fixed;
		margin-left:0;
	}

	.action-button {
		border: 0;
		box-shadow: none;
		border-radius: 0px;
		height: 25px;
		width: 75px;
	}
	
	.salary {
		margin-left :10%;
		margin-right:10%;
		width:80%;
	}
	
	#left_head {
		width:50%;
	}
	
	#message {
		display:flex;
		text-align: left;
		margin-left:3%;
		color:red;
	}
	
	.payrollyeardiv {
		margin-left:6%;
	}
	
	#labeltable td { 
		border:none;
	}
	
	.form-button {
		display: flex;
		align-items: right;
		margin-bottom: 15%;
		gap: 5px;
		flex-direction: column;
	}
	
	.labeltablediv {
		display: flex;
		align-items: right;
		margin-bottom: 25%;
		gap: 5px;
		flex-direction: column;
		margin-left:5%;
	}
</style>
</head>
<body>
	&nbsp;&nbsp;S220
	<div class="container">
		<div class='form-row'>
			<div class='fixed'>給与管理</div>
			<div id="message"></div>
			<div class="payrollyeardiv">支給年月日</div>
			<div class="payrollyeardiv">
				<select id="payrollyear">
				</select>
			</div>
			<div class="table-container">
				<table class="maintable">
					<thead>
						<tr>
							<th id="left_head">社員名</th>
							<th id="right_head">支給額</th>
						</tr>
					</thead>
					<tbody id="payroll_table">
					</tbody>
				</table>
			</div>
		</div>
		<div class='form-button'>
			<button id="return" class='action-button'>戻る</button>
			<button id="updateBtn" class='action-button' disabled>更新</button>
		</div>
		<div class='labeltablediv'>
			<table id="labeltable">
				<tr>
					<td>支給額合計</td>
					<td>：</td>
					<td id="total"></td>
				</tr>
				<tr>
					<td>支給額平均</td>
					<td>：</td>
					<td id="avg"></td>
				</tr>
				<tr>
					<td>支給額最大</td>
					<td>：</td>
					<td id="max"></td>
				</tr>
				<tr>
					<td>支給額最小</td>
					<td>：</td>
					<td id="min"></td>
				</tr>
			</table>
		</div>
	</div>
</body>
<script>
	function limitTableRows() {
	    var maxRows = 100;
	    $('.maintable tbody tr:gt(' + (maxRows - 1) + ')').hide();
	}
	
	$(function(){
		var yearMonth = [];
		var rows = [,];
		var selected_year = "";
		var payrolls = <%= staff_payroll %>
		$("#return").click(function(){
			window.location.href = "menu.jsp";
		})

		getData(true);

		function getData(start) {
			if (start) {
				if (payrolls != "") {
					$.each(payrolls, function (index, item) {
						yearMonth.push(item.payroll_date.substring(0,6))
						rows.push(item.payroll_date.substring(0,6), "<tr><td class='staff_code' data-staff-code="+item.staff_code+">" + item.staff_name + "</td><td><input type='number' value=" + item.salary + " class='salary'></td></tr>");

					});

					var uniqueDate = yearMonth.filter((value, index, self) => {
						return self.indexOf(value) === index;
					});
					
					uniqueDate.sort()
					uniqueDate.reverse()
					
					$.each(uniqueDate, function(index, item) {
						if (index == 0) {
							selected_year = item
							PopulateTable(selected_year);
							PopulateLabels();
						}
						var option = "<option value='"+item+"'>"+item+"</option>"
						$("#payrollyear").append(option);
					})
					
					limitTableRows();
				}
				/* $.ajax({
					type: "GET",
					url: "/PayrollSystem/PayrollAdmin?isDisp=false", 
					dataType: "json",
					success: function(result){
						$.each(result, function (index, item) {
							yearMonth.push(item.payroll_date.substring(0,6))
							rows.push(item.payroll_date.substring(0,6), "<tr><td class='staff_code' data-staff-code="+item.staff_code+">" + item.staff_name + "</td><td><input type='number' value=" + item.salary + " class='salary'></td></tr>");
				        });
						
						var uniqueDate = yearMonth.filter((value, index, self) => {
							return self.indexOf(value) === index;
						});
						
						uniqueDate.sort()
						uniqueDate.reverse()
						
						$.each(uniqueDate, function(index, item) {
							if (index == 0) {
								selected_year = item
								PopulateTable(selected_year);
								PopulateLabels();
							}
							var option = "<option value='"+item+"'>"+item+"</option>"
							$("#payrollyear").append(option);
						})
						
						limitTableRows();
		  			},
		  			error: function(xhr, textStatus, errorThrown) {
		  		        console.error("AJAX Error:", textStatus, errorThrown)
		  		        alert('Request failed. Check the console for details.')
		  		    } 
				});*/
			} else {
				rows = [];
				$.ajax({
					type: "GET",
					url: "/PayrollSystem/PayrollAdmin?isDisp=false", 
					dataType: "json",
					success: function(result){
						$.each(result, function (index, item) {
							rows.push(item.payroll_date.substring(0,6), "<tr><td class='staff_code' data-staff-code="+item.staff_code+">" + item.staff_name + "</td><td><input type='number' value=" + item.salary + " class='salary'></td></tr>");
				        });
						
						PopulateTable($("#payrollyear").val());
		  			},
		  			error: function(xhr, textStatus, errorThrown) {
		  		        console.error("AJAX Error:", textStatus, errorThrown)
		  		        alert('Request failed. Check the console for details.')
		  		    }
				});
			}
		}
		
		function PopulateTable(year) {
			$(".maintable tbody").empty();
			var apply_tr = false;
			
			$.each(rows, function(outerIndex, innerArray) {
				if (!apply_tr) {
				    if (innerArray == year) {
				    	apply_tr = true
				    }
				} else {
			    	$("#payroll_table").append(innerArray);
			    	apply_tr = false;
				}
			});
			
			PopulateLabels();
		}
		
		$("#payrollyear").on('change',function(){
			PopulateTable($("#payrollyear").val())
		})
		
		const inputCheck = /^[0-9]+$/
		
		$(document).on('focusout', '.salary', function() {
			$("#message").html("");
			$("#message").css("color", "red")
			var isPass = false;
			if (!inputCheck.test($(this).val())) {
				$("#message").html(getMessage("INF0010"));
				isPass = true;
			} else {
				if ($(this).val() < 0) {
					$("#message").html(getMessage("INF0011"));
					isPass = true;
				} else {
					if ($(this).val() > 9999999 || $(this).val() == 0) {
						$("#message").html(getMessage("INF0010"));
						isPass = true;
					}
				}
			}
			
			$("#updateBtn").prop('disabled', isPass);
		});
	
		
		$("#updateBtn").click(function() {
			var staff_codes = [];
			var salaries = [];
			var payroll_date = $("#payrollyear").val();
			$(".maintable tbody tr").each(function() {
				var row = $(this);
				staff_codes.push(row.find('.staff_code').data('staff-code'));
				salaries.push(row.find('.salary').val())
			});
			
			staff_codes = staff_codes.filter(item => item !== "" && item !== null);
			salaries = salaries.filter(item => item !== "" && item !== null);
			
			$.ajax({
				type: "POST",
				url: "/PayrollSystem/PayrollServlet",
				traditional: true,
				data:{payroll_date:payroll_date,
					staff_codes:staff_codes, salaries:salaries},
				dataType: "json",
				success: function(result){
					console.log(result)
					if (result.status == 200) {
						$("#message").css('color', 'blue')
						$("#message").html(result.message);
						//getData(false);
						PopulateLabels();
					} else if (result.status==201){
						$("#message").css("color", "green")
						$("#message").html('何も更新されなかった');
					} else {
						$("#message").html(getMessage("INF0017"));
					}
	  			},
	  			error: function(xhr, textStatus, errorThrown) {
	  		        console.error("AJAX Error:", textStatus, errorThrown)
	  		        alert('Request failed. Check the console for details.')
	  		    }
			});
		})
		
		function PopulateLabels() {
			var salaries = [];
			$(".maintable tbody tr").each(function() {
				salaries.push($(this).find('.salary').val())
			});
			salaries = salaries.filter(item => item !== "" && item !== null)
			var salariesInt = salaries.map(Number)
			
			var sum = 0
			for (var i=0;i<salariesInt.length;i++)
				sum+=salariesInt[i]
			
			var highest = Math.max(...salariesInt)
			var lowest = Math.min(...salariesInt)
			var avg = Math.round(sum / salariesInt.length)
			
			$("#total").html(sum.toLocaleString('en-US'))
			$("#avg").html(avg.toLocaleString('en-US'))
			$("#max").html(highest.toLocaleString('en-US'))
			$("#min").html(lowest.toLocaleString('en-US'))
		}
	})
</script>