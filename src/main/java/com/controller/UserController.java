	package com.controller;

import java.io.IOException;
import java.util.List;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bean.Cart;
import com.bean.User;
import com.bean.Wishlist;
import com.dao.CartDao;
import com.dao.UserDao;
import com.dao.WishlistDao;
import com.service.Services;


@WebServlet("/UserController")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String action=request.getParameter("action");
		if(action.equalsIgnoreCase("register")) {
			boolean flag=UserDao.checkEmail(request.getParameter("email"));
			if(flag==false)
			{	
			if(request.getParameter("password").equals(request.getParameter("cpassword")))
				{
				User u=new User();
				u.setUsertype(request.getParameter("usertype"));
				u.setFname(request.getParameter("fname"));
				u.setLname(request.getParameter("lname"));
				u.setEmail(request.getParameter("email"));
				u.setMobile(request.getParameter("mobile"));
				u.setAddress(request.getParameter("address"));
				u.setPassword(request.getParameter("password"));
				UserDao.registerUser(u);
				response.sendRedirect("index.jsp");
				}
			else {
				request.setAttribute("msg", "password and confirm password does not match");
				request.getRequestDispatcher("register.jsp").forward(request, response);
			     }
			}
			else {
				request.setAttribute("msg", "Email already Registered");
				request.getRequestDispatcher("register.jsp").forward(request, response);
				
			}	
		}
		else if(action.equalsIgnoreCase("login"))
		{
			User u=UserDao.login(request.getParameter("email"));
			if(u==null)
			{
				request.setAttribute("msg", "Email not Registered");
				request.getRequestDispatcher("account.jsp").forward(request, response);
			}
			else if(!u.getPassword().equals(request.getParameter("password")))
			{
				request.setAttribute("msg", "Invalid Password");
				request.getRequestDispatcher("account.jsp").forward(request, response);
				
			}
			else if(u.getUsertype().equals("buyer"))
			{
				List<Wishlist> list=WishlistDao.getWishlistByUser(u.getId());
				List<Cart> list1=CartDao.getCartByUser(u.getId());
				HttpSession session=request.getSession();
				session.setAttribute("u", u); 
				session.setAttribute("wishlist_count", list.size());
				session.setAttribute("cart_count", list1.size());
				request.getRequestDispatcher("index.jsp").forward(request, response);
			}
			else
			{
				HttpSession session=request.getSession();
				session.setAttribute("u", u);
				request.getRequestDispatcher("seller-index.jsp").forward(request, response);
			}
		}
		else if (action.equalsIgnoreCase("change password"))
		{
			HttpSession session=request.getSession();
			User u=(User)session.getAttribute("u");
			if(u.getPassword().equals(request.getParameter("old_password")))
			{
				if(request.getParameter("new_password").equals(request.getParameter("cnew_password")))
				{
					UserDao.changePassword(u.getEmail(), request.getParameter("new_password"));
					response.sendRedirect("logout.jsp");
				}
				else 
				{
					if(u.getUsertype().equals("buyer")) 
					{
					request.setAttribute("msg", "Password and Confirm Does Not Matched");
					request.getRequestDispatcher("change-password.jsp").forward(request, response);
					}
					else
					{
						request.setAttribute("msg", "Password and Confirm Does Not Matched");
						request.getRequestDispatcher("seller-change-password.jsp").forward(request, response);
							
					}
				}
			}
			else if(u.getUsertype().equals("buyer"))
			{
				request.setAttribute("msg", "Old Password Does Not Matched");
				request.getRequestDispatcher("change-password.jsp").forward(request, response);
			}
			else 
			{
				request.setAttribute("msg", "Old Password Does Not Matched");
				request.getRequestDispatcher("seller-change-password.jsp").forward(request, response);
			}
		}
		else if (action.equalsIgnoreCase("forgot password"))
		{
			boolean flag=UserDao.checkEmail(request.getParameter("email"));
			if(flag==true)
			{
				Random t=new Random();
				int minRange =1000, maxRange=9999;
				int otp=t.nextInt(maxRange-minRange)+minRange;
				Services.sendMail(request.getParameter("email"),otp);
				request.setAttribute("email", request.getParameter("email"));
				request.setAttribute("otp", otp);
				request.getRequestDispatcher("otp.jsp").forward(request, response);
				
				
			}
			else
			{
				request.setAttribute("msg", "Email Not Registered");
				request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
			}
		}
		else if (action.equalsIgnoreCase("verify otp")) 
		{
			int otp=Integer.parseInt(request.getParameter("otp"));
			int uotp=Integer.parseInt(request.getParameter("uotp"));
			String email=request.getParameter("email");
			
			if(otp==uotp)
			{
				request.setAttribute("email", email);
				request.getRequestDispatcher("new-password.jsp").forward(request, response);
			}
			else
			{
				request.setAttribute("msg", "Incorrect OTP");
				request.setAttribute("email", email);
				request.setAttribute("otp", otp);
				request.getRequestDispatcher("otp.jsp").forward(request, response);	
			}
		}
		else if (action.equalsIgnoreCase("update password"))
		{
			String email=request.getParameter("email");
			String np=request.getParameter("new_password");
			String cnp=request.getParameter("cnew_password");
			
			if(np.equals(cnp))
			{
			UserDao.changePassword(email, np);
			request.setAttribute("msg", "Password Updated Successfully");
			request.getRequestDispatcher("account.jsp").forward(request, response);
			}
			else
			{
				request.setAttribute("email", email);
				request.setAttribute("msg", "New Password and Confirm New Password Does not Matched");
				request.getRequestDispatcher("new-password.jsp").forward(request, response);				
			}

		}
	}

}
