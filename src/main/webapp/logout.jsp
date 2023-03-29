<%
	session.removeAttribute("u");
	session.invalidate();
	request.setAttribute("msg", "User Logged out Successfully");
	request.getRequestDispatcher("account.jsp").forward(request, response);
%> 