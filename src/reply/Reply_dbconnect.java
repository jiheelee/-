//sql ó�� ������
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
//	phpmyadmin�� ����
	
	public static Connection getConnection(){  
	    Connection con=null;  
	    try{  
	        Class.forName("com.mysql.cj.jdbc.Driver");  
	        con=DriverManager.getConnection("jdbc:mysql://localhost:3306/project?serverTimezone=Asia/Seoul","root","585900");
//	        �ּ�, ���̵�� ��� ������ �ְ� ������ ��´�
	    }catch(Exception e){System.out.println(e);}  
	    return con;  
	}
//	insert �Լ�
	
	public static int save(String title, String content, int rootid, int relevel, int recnt, int parent){  
	    int status=0;
	    Calendar cal = new GregorianCalendar();
	    try{  
	        Connection con=getConnection();  
	        PreparedStatement ps=con.prepareStatement(  
	        		"insert into reply(title, date, content, rootid, relevel, recnt, viewcnt,parent) values(?,now(),?,?,?,?,?,?)");
	        ps.setString(1, title);
//	        preparedStatement�� ? �ڸ��� ���� �־��ֱ� ���� setString�� ����Ѵ�
	        ps.setString(2, content);
	        ps.setInt(3, rootid);
	        ps.setInt(4, relevel);
	        ps.setInt(5, recnt);
	        ps.setInt(6, 0);
	        ps.setInt(7, parent);
	        status=ps.executeUpdate();
//	        executeUpdate�� ������ �����Ѵ�
	        ps.close();
	        con.close();
	    }catch(Exception e){System.out.println(e);
	    }  
	    return status;
	}
//	���ڵ带 �������� �Լ�
	public static ArrayList<Content> getRecords(int from, int cnt, String searchWhat, String word) {
//		���ڵ带 ������ �� ���� ������ ���� �������� ������ ���ڷ� �޴´�
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
//		�ܾ� ���ʿ� % ��ȣ�� ���̸� �� �ܾ �����ϴ� ���ڵ带 ã�� ��
		System.out.println(word);
		try{
			Connection con=getConnection();
			PreparedStatement ps;
			if(word=="%%"||word==null||word.equals("%%")||word.equals("%null%")) {
//				�� ������ �˻����� ���� ��� ���ڵ带 ���
				
				ps = con.prepareStatement("select * from reply ORDER by rootid desc, recnt asc limit ?, ?");
//			limit a, b�� a+1���� �����Ͽ� b�� �����´ٴ� ��
				ps.setInt(1, from-1);
				ps.setInt(2, cnt);
			} else {
//				�˻�� �Է����� ���� ���� �������� ã�� ������, �˻���� ���������� select��
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
//			��ü�� �����ϸ� �߰�������
			rs.close();
			ps.close();
			con.close();
			
		}catch(Exception e) {
			System.out.println(e);
			return null;
		}
		
		return records;
	}
//	�α�� ž ���̺� ���ڵ���� �������� �ڵ�
	public static ArrayList<Content> getTopFive(){
		ArrayList<Content> records = new ArrayList<>();
		int id;
		String title;
		try{
			Connection con=getConnection();
			PreparedStatement ps = con.prepareStatement("select * from reply where relevel = 0 ORDER by viewcnt limit 0, 5");
//			���� �߿��� ��ȸ���� �������� ���ڵ带 5�� �����´�
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

//	����¡�� ���� ��ü ���ڵ� ������ �������� �Լ�
	public static int getTotalNum(String word, String searchWhat) {
		int num = 0;
		word = "%" + word + "%";
		try {
			Connection con = getConnection();
			PreparedStatement ps;
			if(word=="%%"||word==null||word.equals("%%")||word.equals("%null%")) {
//				�˻�� ���� ���� �� �����´�
				ps = con.prepareStatement("select count(*) AS cnt from reply");
			} else {
//				���� ���� �˻�� �ش��ϴ� �͸�
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

//	���ο� �� ��ȣ ����
	public static int getNewPostNum(){
		int num = 0;
		try {
			Connection con = getConnection();
			PreparedStatement ps = con.prepareStatement("show table status where name = 'reply'");
//			show table status���� 11��° �ε����� auto increment
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
//		parent �÷��� DB�� �߰��Ͽ� �θ� ���� ������ �ִ´�
		System.out.println(rootid);
		System.out.println(relevel);
		System.out.println(recnt);
		int num = 0;
		int numMax = 0;
		int cnt = 0;
		LinkedList<Integer> queue = new LinkedList<>();
//		ť����
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
//				�θ� ���� ���� ���� ���� ���
				System.out.println("cnt : " + cnt);
				queue.add(parent);
//				�θ� �� ��ȣ ť�� �߰�
				while(!queue.isEmpty()) {
					int p = queue.remove();
//					�ϳ� �̴´�
					ps2.setInt(1,rootid);
					ps2.setInt(2,p);
					ResultSet rs2 = ps2.executeQuery();
//					�ڽ� �۵��� ������ �޴´�
					while(rs2.next()) {
						queue.add(rs2.getInt("id"));
//						�ڽ� �� id�� �ٽ� ť�� �߰��Ѵ� 
						int rnt = rs2.getInt("recnt");
						if(rnt > numMax) {
							numMax = rnt;
//							���� �ִ� ������ ���� �� ������ Ŭ ��� �ִ� ���� �ٲ��ش� 
						}
					}
				}
				num = numMax + 1;
			} else {
//				�θ� ���� ���� ���� ��� �׳� �θ� �ۿ� 1�� �����ش�
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
//	����� �ְ� ���� ������ ��� +1�� ���ִ� �ڵ�
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
//	id�� ���ڵ� �ϳ� �������� �ڵ�
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
//			limit a, b�� a+1���� �����Ͽ� b�� �����´ٴ� ��
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
//			��ü�� �����ϸ� �߰�������
			rs.close();
			ps.close();
			con.close();
			
		}catch(Exception e) {
			System.out.println(e);
			return null;
		}
		
		return c;
	}
//	������Ʈ �ڵ�
	public static int update(int id, String title, String content){  
	    int status=0;
	    Calendar cal = new GregorianCalendar();
	    try{  
	        Connection con=getConnection();  
	        PreparedStatement ps=con.prepareStatement(  
	        		"update reply set title = ?, content = ? where id = ?");
	        ps.setString(1, title);
//	        preparedStatement�� ? �ڸ��� ���� �־��ֱ� ���� setString�� ����Ѵ�
	        ps.setString(2, content);
	        ps.setInt(3, id);
	        status=ps.executeUpdate();
//	        executeUpdate�� ������ �����Ѵ�
	        ps.close();
	        con.close();
	    }catch(Exception e){System.out.println(e);
	    }  
	    return status;
	}
//	�����ϴ� �ڵ�
	public static int delete(int id){
		LinkedList<Integer> queue = new LinkedList<>();
		int status = 0;
		try {
			Connection con = getConnection();
			PreparedStatement ps1 = con.prepareStatement("delete from reply where id = ? ");
			PreparedStatement ps2 = con.prepareStatement("select id from reply where parent = ? ");
//			�ڽ��� �����ִ� �ڵ�
			
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
//	��ȸ�� ������Ʈ �ڵ�
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
//	��� ���� ���ϴ� �ڵ�
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
