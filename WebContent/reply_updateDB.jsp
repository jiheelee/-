<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page import="reply.Reply_dbconnect" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
try{
	int id = Integer.parseInt(request.getParameter("id"));
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	int status = Reply_dbconnect.update(id, title, content);
	response.sendRedirect("reply_view.jsp?id=" + id);
}catch(Exception e){
	out.print(e);		
	}
%>
</body>
</html>