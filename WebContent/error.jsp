<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page import="java.util.*, java.text.*"  %>
<%@include file="reply_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
out.print("<script>alert('비정상적인 접근입니다. 목록으로 이동합니다.')</script>");
out.print("<script>location.href='reply_list.jsp'</script>");
%>
</body>
</html>