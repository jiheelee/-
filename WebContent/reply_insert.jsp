<!-- 글 작성 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page import="java.util.*, java.text.*"  %>
<%@include file="reply_header.jsp"%>
<style>
th{
	background-color: #e8e8e8;
}

</style>
<%

 java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd");
// 	날짜 형식을 정해줌
 String today = formatter.format(new java.util.Date());
// 현재 날짜를 넣어줌
	int newPostNum = Reply_dbconnect.getNewPostNum();
// 	글 번호 받아오는 getNewPostNum 함수
	String rId =Integer.toString(newPostNum);
	rId = request.getParameter("rootId");
	if(rId==null){
		rId = Integer.toString(newPostNum);  
	}
	String rcnt = request.getParameter("recnt");
	if(rcnt == null){
		rcnt = "1";
	}
	int rootId = Integer.parseInt(rId);
	String rlevel;
	rlevel = request.getParameter("relevel");
	if(rlevel==null){
		rlevel = "0";  
	}
	int relevel = Integer.parseInt(rlevel);
	int recnt = Integer.parseInt(rcnt);
	String part = request.getParameter("parent");
// 	부모 글 변수
	if(part == null){
		part = "0";
	}
// 	원글은 부모 글 번호 0으로 설정
	int parent = Integer.parseInt(part);
	if(relevel==0){
		recnt = 1;
	}else{
		recnt = Reply_dbconnect.getNewInPostNum(rootId, relevel, recnt, parent);
// 		원글 내 순서를 정하기 위해 rootid, 답글 레벨, 부모 글의 원글 내 순서, 부모 글의 번호를 파라미터로 넘겨준다 
	}
	%>
	
<div class="center">
	<div class="div_form">
		<form method="post" action="reply_insertDB.jsp">
		  <input type= "hidden" value="<%=parent %>" name = "parent">
		  <table class="table table-bordered" style="text-align: left;">
			  <thead class="thead-dark">
			    <tr>
			      <th scope="col" style="width: 15%"></th>
			      <th scope="col" style="text-align:center; width:20%"></th>
			      <th scope="col" style="text-align:center; width:10%"></th>
			      <th scope="col" style="text-align:left; width:20%">글작성</th>
			      <th scope="col" style="text-align:center; width:15%"></th>
			      <th scope="col" style="text-align:center; width:20%"></th>
			    </tr>
			  </thead>
			  <tbody>
			    <tr>
			      <th scope="row">번호</th>
			      <td colspan="5"><input type="hidden" value="<%=newPostNum%>" name="id"><%=newPostNum %></td>
			    </tr>
			    <tr>
			      <th scope="row">제목</th>
			      <td colspan="5"><input type="text" name="title" id="title" size=95 maxlength=70></td>
			    </tr>
			    
			    <tr>
			      <th scope="row">일자</th>
			      <td colspan="5"><%=today %></td>
			    </tr>
			    
			   <tr>
			      <th scope="row">원글</th>
			      <td><input type="hidden" name="rootId" value="<%=rootId %>"><%=rootId %></td>
			      <th scope="row">댓글수준</th>
			      <td><input type="hidden" name="relevel" value="<%=relevel %>"><%=relevel %></td>
			      <th scope="row">댓글 내 순서</th>
			      <td><input type="hidden" name="recnt" value="<%=recnt %>"><%=recnt %></td>
  				</tr>
			    <tr>
			      <th scope="row">내용</th>
			      <td class="table_left " colspan="5"><textarea id="summernote" name="content" class="table_left"></textarea></td>
<!-- 			      id로를 통해 내용 부분을 썸머노트 에디터로 설정한다 -->
			    </tr>
			  </tbody>
			</table>
			<br><br>
			<button type="submit" style="width:100px; height:50px;" class="btn btn-dark" onClick="check()">Submit</button>
<!-- 			submit을 눌렀을 때 check함수 실행 -->
			<button type="button" style="width:100px; height:50px;" class="btn btn-light" onClick="location.href='reply_list.jsp'">Back</button>
<!-- 			list로 이동 -->
		</form>
	</div>
</div>
</body>
<script>
function check(){
	   var str = document.getElementById('summernote');
	   var str2 = document.getElementById('title');
	   if( str2.value == '' || str2.value == null){
	      alert( '제목을 입력해주세요' );
	      event.preventDefault();
	      return false;
	   }
	   if(str.value == '' || str.value == null || str.value == '<p><br></p>'){
		      alert( '내용을 입력해주세요' );
		      event.preventDefault();
		      return false;
		   }
	}

</script>
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