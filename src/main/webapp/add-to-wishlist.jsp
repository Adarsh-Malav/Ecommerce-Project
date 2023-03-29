<%@include file="header.jsp" %>
<%@page import="java.util.List"%>
<%@page import="com.dao.WishlistDao"%>
<%@page import="com.bean.Wishlist"%>
<%  
	int pid=Integer.parseInt(request.getParameter("pid"));
	int id=Integer.parseInt(request.getParameter("uid"));
	Wishlist w=new Wishlist();
	w.setPid(pid);
	w.setUid(id);
	WishlistDao.addToWishlist(w);
	List<Wishlist> list=WishlistDao.getWishlistByUser(u.getId());	
	session.setAttribute("wishlist_count", list.size());
	response.sendRedirect("wishlist.jsp");
	

%>