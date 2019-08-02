<!-- 글 작성 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page import="java.util.*, java.text.*"  %>
<%@include file="reply_header.jsp"%>
<%
try{
	int id = Integer.parseInt(request.getParameter("id"));
	
	int status = Reply_dbconnect.updateWatch(id);
// 	클릭 시 조회 수를 늘리는 updateWatch 함수
	Content c = Reply_dbconnect.getRecordById(id);
// 	id로 레코드 하나를 가져오는 getRecordById 함수
	String title = c.getTitle();
	String date = c.getDate();
	String content = c.getContent();
	int rootid = c.getRootid();
	int relevel = c.getRelevel();
	int recnt = c.getRecnt();
	int viewcnt = c.getViewcnt();
	int relevelPlus = relevel + 1;
%>
<style>
th{
	background-color: #e8e8e8;
}

</style>
<div class="center">
	<div class="div_form">
		  <table class="table table-bordered" style="text-align: left;">
			  <thead class="thead-dark">
			    <tr>
			      <th scope="col" style="width: 15%"></th>
			      <th scope="col" style="text-align:center; width:20%"></th>
			      <th scope="col" style="text-align:center; width:10%"></th>
			      <th scope="col" style="text-align:left; width:20%">글보기</th>
			      <th scope="col" style="text-align:center; width:15%"></th>
			      <th scope="col" style="text-align:center; width:20%"></th>
			    </tr>
			  </thead>
			  <tbody>
			    <tr>
			      <th scope="row">번호</th>
			      <td colspan="5"><%=id %></td>
			    </tr>
			    <tr>
			      <th scope="row">제목</th>
			      <td colspan="5"><xmp><%=title%></xmp></td>
			    </tr>
			    
			    <tr>
			      <th scope="row">일자</th>
			      <td colspan="5"><%=date %></td>
			    </tr>
			    
			    <tr>
			      <th scope="row">조회수</th>
			      <td colspan="5"><%=viewcnt %></td>
			    </tr>
			    
			    <tr>
			      <th scope="row">원글</th>
			      <td><%=rootid %></td>
			      <th scope="row">댓글수준</th>
			      <td><%=relevel %></td>
			      <th scope="row">댓글 내 순서</th>
			      <td><%=recnt %></td>
			    </tr>
			    
			    <tr>
			      <th scope="row">내용</th>
			      <td colspan="5" class="table_left"><div style="width: 730px;word-break:break-all; white-space: normal; padding: 10px;"><%=content %></div></td>
			    </tr>
			
			  </tbody>
			</table>
			<br><br>
			<button style="width:100px; height:50px;" class="btn btn-primary" onClick="location.href='reply_insert.jsp?parent=<%=id%>&rootId=<%=rootid%>&relevel=<%=relevelPlus%>&recnt=<%=recnt%>'">답글</button>
<!-- 			insert로 이동하는 답글 버튼에 아이디와 답글 레벨, 순서 등을 파라미터로 넘겨준다  -->
			<button style="width:100px; height:50px;" class="btn btn-warning" onClick="location.href='reply_edit.jsp?id=<%=id%>'">수정</button>
			<button style="width:100px; height:50px;" class="btn btn-dark" onClick="location.href='reply_list.jsp?'">목록</button>
<!-- 			submit을 눌렀을 때 check함수 실행 -->
		
	</div>
</div>
<%} catch (Exception e){
	response.sendRedirect("error.jsp");
	}%>
}
</body>
<script>
      $('#summernote').summernote({
        placeholder: 'Say hello to your friends :)',
        tabsize: 2,
        height: 400,
        width: 700
      });
//       summernote 사용을 위해 script를 써줌
    </script>
</html>