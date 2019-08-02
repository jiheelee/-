package reply;

import java.util.Date;

public class Content {
	int id;
	String title;
	String date;
	String content;
	int rootid;
	int relevel;
	int recnt;
	int viewcnt;
	int parent;
	public int getParent() {
		return parent;
	}
	public void setParent(int parent) {
		this.parent = parent;
	}
	public int getRootid() {
		return rootid;
	}
	public void setRootid(int rootid) {
		this.rootid = rootid;
	}
	public int getRelevel() {
		return relevel;
	}
	public void setRelevel(int relevel) {
		this.relevel = relevel;
	}
	public int getRecnt() {
		return recnt;
	}
	public void setRecnt(int recnt) {
		this.recnt = recnt;
	}
	

	public int getViewcnt() {
		return viewcnt;
	}
	public void setWatch(int viewcnt) {
		this.viewcnt = viewcnt;
	}
	public String getTitle() {
		return title;
	}
	public int getId() {
		return id;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	Content(int id, String title){
		this.id = id;
		this.title = title;
	}
		
	Content(int id, String title, String date, String content,  int rootid, int relevel, int recnt, int viewcnt){
		this.id = id;
		this.title = title;
		this.date = date;
		this.content = content;
		this.viewcnt = viewcnt;
		this.rootid = rootid;
		this.relevel = relevel;
		this.recnt = recnt;
	}
}
