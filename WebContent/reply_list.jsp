<!-- 리스트 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ page import="java.util.*, java.text.*,java.sql.Timestamp"  %>
<%@include file="reply_header.jsp"%>

<style>
.table td, .table th {
	vertical-align: middle;
	font-size : 16px;
}
.carousel-inner .carousel-item {
  transition: -webkit-transform 1s ease;
  transition: transform 1s ease;
  transition: transform 1s ease, -webkit-transform 1s ease;
}
</style>
<script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
<script>
$(document).ready(function() {
	  jQuery.fn.carousel.Constructor.TRANSITION_DURATION = 30  // 2 seconds
	});
</script>
<div class="center" style="">
<!-- 글 조회수 순위 5개 뽑기 -->
<div style="text-align: right; width:900px; display:block; margin-left:250px; vertical-align:center;">

<%
	  ArrayList<Content> topFives = Reply_dbconnect.getTopFive();
// 		5개를 가져오는 함수 getTopFive
 		if(topFives!=null && !topFives.isEmpty()){
//  		비어있지 않을때만
 %> 
 <span class="badge badge-pill badge-danger" style="margin-bottom:30px; margin-right:30px; float: top;">인기글</span>
	<div style="width:150px; height:20px; display:inline-block; text-align:left;" id="carouselExampleInterval" class="carousel slide" data-ride="carousel">
  <div class="carousel-inner carousel slide top-to-bottom">
<!--   		슬라이드를 가져오는 코드 -->
 <% 
		Content cont = topFives.get(0);
		int top_id = cont.getId();
// 		글보기로 넘어가기 위해 글 번호를 받는다
		 String top_title = cont.getTitle();
// 		글제목으로 표시하기 위해 글 제목을 받는다
 %> 
    <div class="carousel-item active item" data-interval="100">
       <a class="d-block w-100" style="color: blue; display:inline-block; font-size: 12px;" href="reply_view.jsp?id=<%=top_id%>"><%=top_title %></a>
    </div>
 
   <%
		  for(int t = 1; t < topFives.size(); t++){
// 			  하나씩 가져오는 코드
			  cont = topFives.get(t);
			  top_id = cont.getId();
			  top_title = cont.getTitle();
			  if(top_title.length() >= 7){			  
				  top_title = top_title.substring(0,7);
			  }
		%>
    <div class="carousel-item" data-interval="10">
      <a class="d-block w-100" style="color: blue; display:inline-block;" href="reply_view.jsp?id=<%=top_id%>"><%=top_title %></a>
    </div>
      <%} %>
    <div class="carousel-item">
    </div>
  </div>
</div>
</div>
	<%} %>
	<div class="div_form">
		<table class="table table-hover">
<!--  		마우스를 위에 올려놓으면 색이 변한다 -->
 		  <thead class="thead-dark">
		    <tr>
		      <th scope="col" style="width:15%">번호</th>
		      <th scope="col" style="width:40%">제목</th>
		      <th scope="col" style="width:30%">등록일</th>
		      <th scope="col" style="width:15%;">조회수</th>
<!-- 		      컬럼마다 넓이 설정 -->
		    </tr>
		  </thead>
		  <tbody>
		  <%
		  	
		  	String selectContent = request.getParameter("word");
		  	String searchWhat = request.getParameter("search");
		  	String from = request.getParameter("from");
// 		  	시작 번호 체크
			String cnt = request.getParameter("cnt");
// 			보여줄 개수 체크
			int number_page = 5;
// 			보여지는 페이지 숫자 개수
			int bigPage;
			if(from==null || from==""){
				from = "1";
			}
			if(cnt==null || cnt==""){
				cnt = "10";
			}
// 			인자가 들어오지 않을 경우
			int fromCT = Integer.parseInt(from);
			int currentPage = (fromCT/10) + 1;
// 			현재 페이지
			fromCT = (fromCT/10)*10 + 1;
			int cntCT = Integer.parseInt(cnt);
			bigPage = (fromCT-1)/(cntCT*number_page);
			int startP = bigPage*number_page;
			ArrayList<Content> replies = Reply_dbconnect.getRecords(fromCT,cntCT,searchWhat,selectContent);
			int totalRecords = Reply_dbconnect.getTotalNum(selectContent, searchWhat);
// 			DBconnect 클래스에서 getRecords 함수에 출력하고 싶은 시작 레코드 인덱스와 마지막 인덱스를 넘긴다
			int endBigPage = totalRecords/(cntCT*number_page);
			if(bigPage==endBigPage){
				number_page = (int)Math.ceil((double)totalRecords/cntCT) - startP;
// 				마지막 페이지일 경우 필요한 페이지 개수
			}
			int id;
			String title;
			String date;
			int viewcnt;
			int relevel;
			int rootid;
			int recnt;
			if(replies!=null){
			for(int i=0; i<replies.size(); i++){
				String repeat = "";
// 				arraylist에 size를 통해 크기를 가져와 그만큼 for문을 돌려준다
				Content c = replies.get(i);
				id = c.getId();
				title = c.getTitle();
				date = c.getDate();
				viewcnt = c.getViewcnt();
				relevel = c.getRelevel();
				rootid = c.getRootid();
				recnt = c.getRecnt();
				
				Date cdate = new Date(System.currentTimeMillis());
				String currentDate = new SimpleDateFormat("yyyyMMdd").format(cdate);
				Date thisdate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
				long gap = (cdate.getTime() - thisdate.getTime())/3600000;
// 				새로운 글에 new를 표시해주기 위해 현재 시간과 작성시간의 차이를 구한다. 3600000으로 나누면 시간 기준이다.
				
				int reply_num = Reply_dbconnect.getReplyNum(rootid);	
  			%>  
		    <tr style="text-align:center; vertical-align: center">
		      <td style="text-align:center; vertical-align: center"> <%=id %></td>
		      <td style="text-align:left; width:150px ;overflow: hidden;
			   text-overflow: ellipsis;
			   white-space: nowrap;
			   max-width: 200px;"> 
<!-- 			   제목이 너무 길 경우를 대비하여 자르는 css 적용 -->
			   <%
			   	for(int k=0; k<relevel; k++){
			   %>
			   <img src="upload/blank.PNG" style="display:inline-block; width:15px; height:8px;">
<!-- 			   level에 따라 공백을 넣어주어 단계를 명시적으로 표현해준다 -->
			   <% } %>
			   <%
			   	if(relevel > 0){
			   %>
			   <img src="upload/re12.png" style="display:inline-block; width:30x; height: 30px;">
<!-- 			   reply 표시 그림 -->
			   <% } %>
			   <%
			   	
			   if(gap <= 1){
// 				   한 시간 이내이면
			   %>
			   <img src="https://blogimgs.pstatic.net/imgs/ico_n.gif" alt="new">
<!-- 			   new 표시 그림 -->
			   <% } %>
			   <a href="reply_view.jsp?id=<%=id%>" style="color:black; display:inline-block;">
			  
			   <xmp><%=title %></xmp>
			   
			   </a>
			   <%
			   	if(reply_num > 0 && relevel == 0){
// 			   		답글이 있고 원글이면 답글 개수 표현
			   %>
			  [<%=reply_num %>]
			   <%} %>
			   
			   </td>
<!-- 		      xmp를 쓰면 태그 코드 에러를 해결할 수 있다 -->
		      <td><%=date%></td>
		      <td><%=viewcnt%></td>
		    </tr>
		    <%
			}
			}
		    %>
		  </tbody>
		</table>
		<br>
		<nav aria-label="..." style="display: inline-block; margin: 0 auto;">
		  <ul class="pagination">
<!-- 		  페이지 css를 가져온다 -->
		<%
		int beforeP = bigPage - 1;
		if(beforeP<0){
			beforeP = 0;
		}
		int beforeNum = beforeP * cntCT * number_page+ 1;
		%>
<!-- 		이전 페이지로 이동 -->
		    <li class="page-item">
		      <a class="page-link" href="reply_list.jsp?from=<%=beforeNum%>&cnt=<%=cntCT%>&search=<%=searchWhat%>&word=<%=selectContent%>">Previous</a>
<!-- 		      페이지 이동 시에 검색 기준과 검색어를 get 방식으로 넘겨주어 저장되게 한다 -->
		    </li>
		<%
			for(int i=startP + 1; i<=startP + number_page; i++){
				if(i==currentPage){
// 					현재 페이지와 같으면 색 다르게 표시
		%>
		    <li class="page-item active" aria-current="page">
		      <a class="page-link" href="reply_list.jsp?from=<%=(i-1)*cntCT + 1%>&cnt=<%=cntCT%>&search=<%=searchWhat%>&word=<%=selectContent%>"><%=i%><span class="sr-only">(current)</span></a>
		    </li>
		<%} else {%>
		    <li class="page-item"><a class="page-link" href="reply_list.jsp?from=<%=(i-1)*cntCT + 1%>&cnt=<%=cntCT%>&search=<%=searchWhat%>&word=<%=selectContent%>"><%=i %></a></li>
		<%}
			}
		int nextP = bigPage + 1;
		int nextNum = nextP * cntCT * number_page + 1;
		if(nextP >= endBigPage){
			nextNum = totalRecords;	
		}
		
		%>
		    <li class="page-item">
		      <a class="page-link" href="reply_list.jsp?from=<%=nextNum%>&cnt=<%=cntCT%>&search=<%=searchWhat%>&word=<%=selectContent%>">Next</a>
		    </li>
		  </ul>
		</nav>
		<div style="text-align: right">
		<button style="width:100px; height:50px; background-color: #f2f2f2;" class="btn btn-light" OnClick="window.location='reply_insert.jsp'">글쓰기</button>
		</div>
<!-- 		다음페이지로 이동 -->
		<DIV class='aside_menu' style="vertical-align: top;">
<!-- 		검색 기능 구현 -->
		  <FORM method='post' action='reply_list.jsp' style="vertical-align: top;">
		  <input type="hidden" name="from" value="1">
		  <input type="hidden" name="cnt" value="<%=cntCT %>">
<!-- 		  시작점과 개수를 hidden으로 넘겨주어 값을 저장한다 -->
		  <div style="display:inline-block">
		    	<select class="custom-select" name="search" style="width:100px; display: inline-block; border-color: #00dddd; height: 47px;">
				  <option value="title" selected="selected">제목</option>
				  <option value="id">글번호</option>
				</select>
		  </div>
				<div style="display:inline-block;">
			    <input type="text" style="margin-top:10px; width: 300px;  height: 44px; display: inline-block" class="form-control" name="word" placeholder="특수문자는 사용할수 없습니다.">
				</div>
		      <button style="height: 48px; background-color: #00dddd; border-color: #00dddd;" type='submit' class="btn btn-info">검색</button>   
		      <button style="height: 48px; color: black; background-color: #fff; border-color: #00dddd;" class="btn btn-info"
		      onClick="location.href='reply_list.jsp'">전체보기</button>   
		  </FORM>
		  <DIV class='menu_line' style='clear: both;'></DIV>
		</DIV>


		
		
		<br><br><br><br><br><br><br><br><br><br><br><br>
	</div>
</div>
</body>
</html>