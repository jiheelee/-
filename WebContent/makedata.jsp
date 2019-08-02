<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<%@ page import="java.sql.*,javax.sql.*,java.net.*,java.io.*" %>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
	<h1>Make table</h1>
	<%
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn =DriverManager.getConnection("jdbc:mysql://localhost:3306/naverdb?serverTimezone=Asia/Seoul","root","585900");
	Statement stmt = conn.createStatement();
	%>
	<%
	try{
		stmt.execute("drop table gongji");
		out.println("drop table gongji OK <br>");
		
	}catch(Exception e){
		out.println(e.toString());
	}
	
	%>
	<% stmt.execute("create table gongji(id int not null primary key auto_increment, title varchar(70), date date, content text) DEFAULT CHARSET=utf8");%>
	<%
	String sql="";
	sql="insert into gongji(title, date, content) values('공지사항1', date(now()),'공지사항내용1')"; stmt.execute(sql);
	stmt.close();
	conn.close();
	
	%>	
</body>
</html>