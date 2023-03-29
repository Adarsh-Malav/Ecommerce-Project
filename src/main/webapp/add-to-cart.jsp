<%@page import="com.dao.CartDao"%>
<%@page import="com.bean.Cart"%>
<%@page import="com.dao.ProductDao"%>
<%@page import="com.bean.Product"%>
<%@include file="header.jsp" %>
<%@page import="java.util.List"%>
<%@page import="com.dao.WishlistDao"%>
<%@page import="com.bean.Wishlist"%>
<%  
	int pid=Integer.parseInt(request.getParameter("pid"));
	int id=Integer.parseInt(request.getParameter("uid"));
	Product p=ProductDao.getProduct(pid);
	Cart c=new Cart();
	c.setPid(pid);
	c.setUid(id);
	c.setProduct_price(p.getProduct_price());
	c.setProduct_qty(1);
	c.setTotal_price(p.getProduct_price());
	c.setPayment_status(false);
	
	CartDao.addToCart(c);
	List<Cart> list=CartDao.getCartByUser(u.getId());	
	session.setAttribute("cart_count", list.size());
	response.sendRedirect("cart.jsp");
	

%>