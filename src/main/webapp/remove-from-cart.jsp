<%@page import="com.dao.CartDao"%>
<%@page import="com.bean.Cart"%>
<%@page import="java.util.List"%>
<%@include file="header.jsp" %>
<%@page import="com.dao.WishlistDao"%>
<%@page import="com.bean.Wishlist"%>
<%  
	int pid=Integer.parseInt(request.getParameter("pid"));
	int id=Integer.parseInt(request.getParameter("uid"));
	Cart c=new Cart();
	c.setPid(pid);
	c.setUid(id);
	CartDao.removeFromCart(c);
	List<Cart> list=CartDao.getCartByUser(u.getId());	
	session.setAttribute("cart_count", list.size());
	response.sendRedirect("cart.jsp");
	

%>