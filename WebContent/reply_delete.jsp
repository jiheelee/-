<!-- insert를 위한 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page import="reply.Reply_dbconnect" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<%
	try{
		
	int id = Integer.parseInt(request.getParameter("id"));
	int status = Reply_dbconnect.delete(id);
	if(status==1){
		
		response.sendRedirect("reply_list.jsp");
		}else{
			%>
			<div style="text-align: center;">
				<div class="card border-danger mb-3" style="width:700px; max-width: 27rem; display: inline-block; margin: 0 auto;">
				  <div class="card-header">Header</div>
				  <div class="card-body text-danger">
				    <h5 class="card-title">삭제 실패!!</h5>
				    <p class="card-text"></p>
				    <button class="btn btn-danger" onClick="location.href='reply_list.jsp'">목록으로 돌아가기</button>
				  </div>
				</div>
			</div>
			<%
		}
	
	}catch(Exception e){
	out.print(e);		
	}
%>

</head>
<body>

</body>
</html>