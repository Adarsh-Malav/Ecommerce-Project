package com.controller;

import java.io.File;
import java.io.IOException;


import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bean.Product;
import com.bean.User;
import com.dao.ProductDao;


@WebServlet("/ProductController")
@MultipartConfig(fileSizeThreshold = 1024*1024*512,
maxFileSize = 1024*1024*512,maxRequestSize = 1024*1024*512) //512
public class ProductController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private String extractfilename(javax.servlet.http.Part file) {
		String cd = file.getHeader("content-disposition");
		System.out.println(cd);
		String[] items = cd.split(";");
		for(String string : items) {
			if(string.trim().startsWith("filename")) {
				return string.substring(string.indexOf("=") + 2,string.length()-1);
			}
		}
		return "";
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action=request.getParameter("action");
		if(action.equalsIgnoreCase("add product"))
		{
			String savePath="C:\\Users\\Adarsh Malav\\eclipse-workspace\\MyProject\\src\\main\\webapp\\product_images";
			File fileSaveDir=new File(savePath);
			if(!fileSaveDir.exists()) {
				fileSaveDir.mkdir();
			}
			javax.servlet.http.Part file1 = request.getPart("product_image");
			String fileName=extractfilename(file1);
			file1.write(savePath + File.separator + fileName);
			String filePath=savePath + File.separator +fileName;
			
			String savePath2="C:\\Users\\Adarsh Malav\\eclipse-workspace\\MyProject\\src\\main\\webapp\\product_images";
			File imgSaveDir=new File(savePath2);
			if(!imgSaveDir.exists()) {
				imgSaveDir.mkdir();
			}
			
			HttpSession session=request.getSession();
			User u=(User)session.getAttribute("u");
		
			Product p=new Product();
			p.setProduct_category(request.getParameter("product_category"));
			p.setProduct_name(request.getParameter("product_name"));
			p.setProduct_price(Integer.parseInt(request.getParameter("product_price")));
			p.setProduct_desc(request.getParameter("product_desc"));
			p.setProduct_image(fileName);
			p.setUid(u.getId());
			ProductDao.insertProduct(p);
			request.setAttribute("msg", "Product Added Successfully");
			request.getRequestDispatcher("seller-add-product.jsp").forward(request, response);
		}
		else if(action.equalsIgnoreCase("update product"))
		{
			Product p=new Product();
			p.setPid(Integer.parseInt(request.getParameter("pid"))); 
			p.setProduct_category(request.getParameter("product_category"));
			p.setProduct_name(request.getParameter("product_name"));
			p.setProduct_price(Integer.parseInt(request.getParameter("product_price")));
			p.setProduct_desc(request.getParameter("product_desc"));
			p.setUid(Integer.parseInt(request.getParameter("uid")));
			ProductDao.updateProduct(p);
			response.sendRedirect("seller-view-product.jsp");
		}
	}

}
