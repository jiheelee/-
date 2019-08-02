<!-- insert를 위한 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page import="java.util.*, java.text.*"  %>
<%@include file="reply_header.jsp"%>
<%
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	int rootid = Integer.parseInt(request.getParameter("rootId"));
	int relevel = Integer.parseInt(request.getParameter("relevel"));
	int recnt = Integer.parseInt(request.getParameter("recnt"));
	int parent = Integer.parseInt(request.getParameter("parent"));
	int id = Integer.parseInt(request.getParameter("id"));

	try{
	int status = Reply_dbconnect.save(title,content,rootid,relevel,recnt,parent);
	int status2 = Reply_dbconnect.updateAfter(recnt, rootid, id);
	if(status==1){
		
	response.sendRedirect("reply_list.jsp");
	}else{
		%>
		<div style="text-align: center;">
			<div class="card border-danger mb-3" style="width:700px; max-width: 27rem; display: inline-block; margin: 0 auto;">
			  <div class="card-header">Header</div>
			  <div class="card-body text-danger">
			    <h5 class="card-title">파일 업로드 실패!! 용량이 큽니다</h5>
			    <p class="card-text"></p>
			    <button class="btn btn-danger" onClick="location.href='reply_list.jsp'">목록으로 돌아가기</button>
			  </div>
			</div>
		</div>
		<%
	}
		
	}catch(Exception e){
		%>
		<div style="text-align: center;">
			<div class="card border-danger mb-3" style="width:700px; max-width: 27rem; display: inline-block; margin: 0 auto;">
			  <div class="card-header">Header</div>
			  <div class="card-body text-danger">
			    <h5 class="card-title">파일 업로드 실패!! 용량이 큽니다</h5>
			    <p class="card-text"></p>
			    <button class="btn btn-danger" onClick="location.href='reply_list.jsp'">목록으로 돌아가기</button>
			  </div>
			</div>
		</div>
		
		<% 
	}
// 	insert를 위한 save에 title과 content를 인자로 넘겨줌
// 	response.sendRedirect("gongji_list.jsp");
// 	이동을 위해서 response.sendRedirect
// 	pageContext.forward는 이동하는데 주소는 바뀌지 않음
	
%>



</body>
</html>