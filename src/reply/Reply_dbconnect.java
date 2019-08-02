//sql 처리 페이지
package reply;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.LinkedList;

public class Reply_dbconnect {
//	phpmyadmin과 연결
	
	public static Connection getConnection(){  
	    Connection con=null;  
	    try{  
	        Class.forName("com.mysql.cj.jdbc.Driver");  
	        con=DriverManager.getConnection("jdbc:mysql://localhost:3306/project?serverTimezone=Asia/Seoul","root","585900");
//	        주소, 아이디와 비번 정보를 넣고 변수에 담는다
	    }catch(Exception e){System.out.println(e);}  
	    return con;  
	}
//	insert 함수
	
	public static int save(String title, String content, int rootid, int relevel, int recnt, int parent){  
	    int status=0;
	    Calendar cal = new GregorianCalendar();
	    try{  
	        Connection con=getConnection();  
	        PreparedStatement ps=con.prepareStatement(  
	        		"insert into reply(title, date, content, rootid, relevel, recnt, viewcnt,parent) values(?,now(),?,?,?,?,?,?)");
	        ps.setString(1, title);
//	        preparedStatement의 ? 자리에 값을 넣어주기 위해 setString을 사용한다
	        ps.setString(2, content);
	        ps.setInt(3, rootid);
	        ps.setInt(4, relevel);
	        ps.setInt(5, recnt);
	        ps.setInt(6, 0);
	        ps.setInt(7, parent);
	        status=ps.executeUpdate();
//	        executeUpdate로 쿼리를 실행한다
	        ps.close();
	        con.close();
	    }catch(Exception e){System.out.println(e);
	    }  
	    return status;
	}
//	레코드를 가져오는 함수
	public static ArrayList<Content> getRecords(int from, int cnt, String searchWhat, String word) {
//		레코드를 가져올 때 범위 지정을 위해 시작점과 개수를 인자로 받는다
		ArrayList<Content> records = new ArrayList<>();
		String title = "";
		String date;
		String content = "";
		int id;
		int rootId;
		int relevel;
		int recnt;
		int viewcnt;
		word = "%" + word + "%";
//		단어 양쪽에 % 기호를 붙이면 그 단어를 포함하는 레코드를 찾는 것
		System.out.println(word);
		try{
			Connection con=getConnection();
			PreparedStatement ps;
			if(word=="%%"||word==null||word.equals("%%")||word.equals("%null%")) {
//				빈 값으로 검색했을 때는 모든 레코드를 출력
				
				ps = con.prepareStatement("select * from reply ORDER by rootid desc, recnt asc limit ?, ?");
//			limit a, b는 a+1부터 시작하여 b개 가져온다는 뜻
				ps.setInt(1, from-1);
				ps.setInt(2, cnt);
			} else {
//				검색어를 입력했을 때는 무슨 기준으로 찾을 것인지, 검색어는 무엇인지로 select함
				ps = con.prepareStatement("select * from reply where "+ searchWhat + " LIKE ? ORDER by rootid, recnt limit ?, ?");
				ps.setString(1, word);
				ps.setInt(2, from-1);
				ps.setInt(3, cnt);
			}
			ResultSet rs = ps.executeQuery();
			if(rs.equals(null)) {
				ps = con.prepareStatement("select * from reply ORDER by rootid, recnt limit ?, ?");
					ps.setInt(1, from-1);
					ps.setInt(2, cnt);
				rs = ps.executeQuery();
			}
			while(rs.next()) {
				id = rs.getInt("id");
				title = rs.getString("title");
				date = rs.getString("date");
				content = rs.getString("content");
				rootId = rs.getInt("rootId");
				relevel = rs.getInt("relevel");
				recnt = rs.getInt("recnt");
				viewcnt = rs.getInt("viewcnt");
				records.add(new Content(id, title, date, content, rootId, relevel, recnt, viewcnt));
				System.out.println("ok");
				System.out.println(viewcnt);
			}
//			객체를 생성하며 추가시켜줌
			rs.close();
			ps.close();
			con.close();
			
		}catch(Exception e) {
			System.out.println(e);
			return null;
		}
		
		return records;
	}
//	인기글 탑 파이브 레코드들을 가져오는 코드
	public static ArrayList<Content> getTopFive(){
		ArrayList<Content> records = new ArrayList<>();
		int id;
		String title;
		try{
			Connection con=getConnection();
			PreparedStatement ps = con.prepareStatement("select * from reply where relevel = 0 ORDER by viewcnt limit 0, 5");
//			원글 중에서 조회수를 기준으로 레코드를 5개 가져온다
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				id = rs.getInt("id");
				title = rs.getString("title");
				records.add(new Content(id, title));
			}
			rs.close();
			ps.close();
			con.close();
		}catch(Exception e) {
			System.out.println(e);
			return null;
		}
		return records;
	}

//	페이징을 위해 전체 레코드 개수를 가져오는 함수
	public static int getTotalNum(String word, String searchWhat) {
		int num = 0;
		word = "%" + word + "%";
		try {
			Connection con = getConnection();
			PreparedStatement ps;
			if(word=="%%"||word==null||word.equals("%%")||word.equals("%null%")) {
//				검색어가 없을 때는 다 가져온다
				ps = con.prepareStatement("select count(*) AS cnt from reply");
			} else {
//				있을 때는 검색어에 해당하는 것만
				ps = con.prepareStatement("select count(*) AS cnt from reply where "+ searchWhat + " LIKE ?");
				ps.setString(1, word);
			}
			ResultSet rs = ps.executeQuery();
			if(rs.equals(null)) {
				ps = con.prepareStatement("select count(*) AS cnt from reply");
			}
			rs = ps.executeQuery();
			rs.next();
			num = rs.getInt("cnt");
			rs.close();
			ps.close();
			con.close();
		}catch(Exception e) {
			System.out.println(e);
		}
		
		return num;
	}

//	새로운 글 번호 추출
	public static int getNewPostNum(){
		int num = 0;
		try {
			Connection con = getConnection();
			PreparedStatement ps = con.prepareStatement("show table status where name = 'reply'");
//			show table status에서 11번째 인덱스는 auto increment
			ResultSet rs = ps.executeQuery();
			rs.next();
			num = rs.getInt(11);
			rs.close();
			ps.close();
			con.close();
		}catch(Exception e) {
			System.out.println(e);
		}
		
		return num;
	}
	public static int getNewInPostNum(int rootid, int relevel, int recnt, int parent){
//		parent 컬럼을 DB에 추가하여 부모 글의 정보를 넣는다
		System.out.println(rootid);
		System.out.println(relevel);
		System.out.println(recnt);
		int num = 0;
		int numMax = 0;
		int cnt = 0;
		LinkedList<Integer> queue = new LinkedList<>();
//		큐선언
		try {
			Connection con = getConnection();
			PreparedStatement ps1 = con.prepareStatement("select count(*) AS cnt from reply where rootid = ? "
					+ "and parent=?");
			PreparedStatement ps2 = con.prepareStatement("select id, recnt from reply where rootid = ? "
					+ "and parent = ?");
			
			ps1.setInt(1, rootid);
			ps1.setInt(2, parent);
			ResultSet rs = ps1.executeQuery();
			rs.next();
			cnt = rs.getInt("cnt");
			if(cnt > 0) {
//				부모 글이 같은 글이 있을 경우
				System.out.println("cnt : " + cnt);
				queue.add(parent);
//				부모 글 번호 큐에 추가
				while(!queue.isEmpty()) {
					int p = queue.remove();
//					하나 뽑는다
					ps2.setInt(1,rootid);
					ps2.setInt(2,p);
					ResultSet rs2 = ps2.executeQuery();
//					자식 글들의 정보를 받는다
					while(rs2.next()) {
						queue.add(rs2.getInt("id"));
//						자식 글 id를 다시 큐에 추가한다 
						int rnt = rs2.getInt("recnt");
						if(rnt > numMax) {
							numMax = rnt;
//							만약 최대 값보다 원글 내 순서가 클 경우 최대 값을 바꿔준다 
						}
					}
				}
				num = numMax + 1;
			} else {
//				부모가 같은 글이 없을 경우 그냥 부모 글에 1만 더해준다
				num = recnt + 1;
			}			
			rs.close();
			ps1.close();
			ps2.close();
			con.close();
		}catch(Exception e) {
			System.out.println(e);
		}	
		return num;
	}
//	답글을 넣고 다음 순서에 모두 +1을 해주는 코드
	public static int updateAfter(int recnt, int rootid, int id) {
		int status = 0;
		try {
			Connection con = getConnection();
			PreparedStatement ps5 = con.prepareStatement("update reply set recnt = recnt + 1 where rootid = ? "
					+ "and recnt >= ? and id <> ?");
			ps5.setInt(1, rootid);
			ps5.setInt(2, recnt);
			ps5.setInt(3, id);
			status = ps5.executeUpdate();
			ps5.close();
			con.close();
		}catch(Exception e) {
			System.out.println(e);
		}	
		return status;
	}
//	id로 레코드 하나 가져오는 코드
	public static Content getRecordById(int key) {
		Content c = null;
		String title = "";
		String date;
		String content = "";
		int id;
		int rootId;
		int relevel;
		int recnt;
		int viewcnt;
		try{
			Connection con=getConnection();
			PreparedStatement ps = con.prepareStatement("select * from reply where id=?");
//			limit a, b는 a+1부터 시작하여 b개 가져온다는 뜻
			ps.setInt(1, key);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				id = rs.getInt("id");
				title = rs.getString("title");
				date = rs.getString("date");
				content = rs.getString("content");
				rootId = rs.getInt("rootid");
				relevel = rs.getInt("relevel");
				recnt = rs.getInt("recnt");
				viewcnt = rs.getInt("viewcnt");
				c = new Content(id, title, date, content, rootId, relevel, recnt, viewcnt);
			}
//			객체를 생성하며 추가시켜줌
			rs.close();
			ps.close();
			con.close();
			
		}catch(Exception e) {
			System.out.println(e);
			return null;
		}
		
		return c;
	}
//	업데이트 코드
	public static int update(int id, String title, String content){  
	    int status=0;
	    Calendar cal = new GregorianCalendar();
	    try{  
	        Connection con=getConnection();  
	        PreparedStatement ps=con.prepareStatement(  
	        		"update reply set title = ?, content = ? where id = ?");
	        ps.setString(1, title);
//	        preparedStatement의 ? 자리에 값을 넣어주기 위해 setString을 사용한다
	        ps.setString(2, content);
	        ps.setInt(3, id);
	        status=ps.executeUpdate();
//	        executeUpdate로 쿼리를 실행한다
	        ps.close();
	        con.close();
	    }catch(Exception e){System.out.println(e);
	    }  
	    return status;
	}
//	삭제하는 코드
	public static int delete(int id){
		LinkedList<Integer> queue = new LinkedList<>();
		int status = 0;
		try {
			Connection con = getConnection();
			PreparedStatement ps1 = con.prepareStatement("delete from reply where id = ? ");
			PreparedStatement ps2 = con.prepareStatement("select id from reply where parent = ? ");
//			자식을 지워주는 코드
			
			ps1.setInt(1, id);
			status = ps1.executeUpdate();
			queue.add(id);
			while(!queue.isEmpty()) {
				int p = queue.remove();
				ps2.setInt(1,p);
				ResultSet rs2 = ps2.executeQuery();
				while(rs2.next()) {
					queue.add(rs2.getInt("id"));
					ps1.setInt(1, rs2.getInt("id"));
					int status2 = ps1.executeUpdate();
				}
				rs2.close();
			}
			ps1.close();
			ps2.close();
			con.close();
			
		}catch(Exception e) {
			System.out.println(e);
		}	
		return status;
	}
//	조회수 업데이트 코드
	public static int updateWatch(int id) {
		int status = 0;
		try {
			Connection con = getConnection();
			PreparedStatement ps = con.prepareStatement("update reply set viewcnt = viewcnt + 1 where id=?");
			ps.setInt(1, id);
			status = ps.executeUpdate();
			ps.close();
			con.close();
		}catch(Exception e) {
			System.out.println(e);
		}
		
		return status;
	}
//	답글 개수 구하는 코드
	public static int getReplyNum(int rootid) {
		int num = 0;
		try {
			Connection con = getConnection();
			PreparedStatement ps = con.prepareStatement("select count(*) AS cnt from reply where rootid=?");
			ps.setInt(1, rootid);
			ResultSet rs = ps.executeQuery();
			rs.next();
			num = rs.getInt("cnt") - 1;
			rs.close();
			ps.close();
			con.close();
		}catch(Exception e) {
			System.out.println(e);
		}
		
		return num;
	}
}
