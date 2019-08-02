<!-- 글 수정 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page import="java.util.*, java.text.*"  %>
<%@include file="reply_header.jsp"%>
<%
	int id = Integer.parseInt(request.getParameter("id"));
	Content c = Reply_dbconnect.getRecordById(id);
// 	레코드 하나를 아이디로 불러오는 getRecordById함수
	String title = c.getTitle();
	String date = c.getDate();
	String content = c.getContent();
	int rootid = c.getRootid();
	int relevel = c.getRelevel();
	int recnt = c.getRecnt();
	int viewcnt = c.getViewcnt();
 	
%>
<style>
th{
	background-color: #e8e8e8;
}

</style>
<div class="center">
	<div class="div_form">
		<form method="post" name="fm" >
<!-- 		폼이름 fm으로 설정하고 submit을 했을 때 name을 통해 호출해준다 -->
		  <input type= "hidden" value="<%=id %>" name = "id">
		  <table class="table table-bordered" style="text-align: left;">
			  <thead class="thead-dark">
			    <tr>
			      <th scope="col" style="width: 15%"></th>
			      <th scope="col" style="text-align:center; width:20%"></th>
			      <th scope="col" style="text-align:center; width:10%"></th>
			      <th scope="col" style="text-align:left; width:20%">글수정</th>
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
			      <td colspan="5"><input id="title" name="title" value="<%=title %>"></td>
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
			      <td class="table_left" colspan="5"><textarea id="summernote" name="content" class="table_left"><%=content %></textarea></td>
			    </tr>
			   
			  </tbody>
			</table>
			<br><br>
			<button type="button" style="width:100px; height:50px;" class="btn btn-warning" onClick = "submitForm('update')">수정 완료</button>
<!-- 			수정 버튼 -->
			<button type="button" style="width:100px; height:50px;" class="btn btn-danger" onClick = "submitForm('delete')">지우기</button>
<!-- 			 삭제 버튼 -->
			<button type="button" style="width:100px; height:50px;" class="btn btn-dark" onClick = "submitForm('cancel')">취소</button>
<!-- 			취소 버튼 -->
			
			
<!-- 			submit을 눌렀을 때 check함수 실행 -->
		</form>
	</div>
</div>
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

<script>
function submitForm(mode){
	if(mode=="update"){
// 		mode가 업데이트일때
		var str = document.getElementById('summernote');
		var str2 = document.getElementById('title');
		   if( str2.value == '' || str2.value == null){
		      alert( '제목을 입력해주세요' );
		      event.preventDefault();
		      return false;
		   }
		   if(str.value == '' || str.value == null || str.value=='<p><br></p>'){
			      alert( '내용을 입력해주세요' );
			      event.preventDefault();
			      return false;
		   }
		fm.action = "reply_updateDB.jsp";
	} else if(mode=="delete"){
// 		모드가 delete일때
		if(confirm('정말 삭제하시겠습니까?')==true){
			fm.action = "reply_delete.jsp";	
		}
	} else if(mode=="cancel"){
// 		모드가 수정 취소일때
		fm.action = "reply_view.jsp?id=" + <%=id%>;
	}
	fm.submit();
}
</script>
</html>