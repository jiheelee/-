<!-- header 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
 <% request.setCharacterEncoding("utf-8"); %> 

<%@page import="reply.Reply_dbconnect" %>
<%@page import="reply.Content" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<link href="https://fonts.googleapis.com/css?family=Geostar|Poor+Story&display=swap" rel="stylesheet">
<!-- 구글 폰트 사용을 위해 추가 -->
<link rel="stylesheet" href="reply_main.css">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<!-- 부트 스트랩 사용을 위해 추가 -->
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
 <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js"></script>
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/js/bootstrap.min.js"></script>
 <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.12/summernote-bs4.css" rel="stylesheet">
 <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.12/summernote-bs4.js"></script>
</head>
<body>
<br><br><br>
<div class="center">
	<h1 class="big_h" onClick="location.href='reply_list.jsp'" style="cursor:pointer">커뮤니티</h1>
<!-- 	cursor: 속성으로 마우스를 갖다댔을 때 모양 설정 -->
<!-- 클릭시 list 페이지로 가게 설정 -->
</div>
<br><br><br><br>
