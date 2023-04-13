<%@page import="java.util.Random"%>
<%@page import="com.bean.Product"%>
<%@page import="com.dao.ProductDao"%>
<%@page import="com.bean.Cart"%>
<%@page import="com.dao.CartDao"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="header.jsp" %>
<%
 	Random randomGenerator = new Random();
	int randomInt = randomGenerator.nextInt(1000000);
 %>
<!DOCTYPE html>
<html lang="en">
  <head>
   <style type="text/css">
   .bttnStyle
   {
   		background-color: lightblue;
   		border-radius: 0.5rem;
   		border:1px solid transperent;
   }
   </style>

  </head>
  <body>
   
  
  <!-- catg header banner section -->
  <section id="aa-catg-head-banner">
   <img src="img/fashion/fashion-header-bg-8.jpg" alt="fashion img">
   <div class="aa-catg-head-banner-area">
     <div class="container">
      <div class="aa-catg-head-banner-content">
        <h2>Cart Page</h2>
        <ol class="breadcrumb">
          <li><a href="index.jsp">Home</a></li>                   
          <li class="active">Cart</li>
        </ol>
      </div>
     </div>
   </div>
  </section>
  <!-- / catg header banner section -->

 <!-- Cart view section -->
 <section id="cart-view">
   <div class="container">
     <div class="row">
       <div class="col-md-12">
         <div class="cart-view-area">
           <div class="cart-view-table">
               <div class="table-responsive">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>Remove</th>
                        <th>Image</th>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Total</th>
                      </tr>
                    </thead>
                    <tbody>
                    <%
                    	int net_price=0;
                    	List<Cart> list=CartDao.getCartByUser(u.getId());
                    	for(Cart c:list)
                    	{
                    		net_price=net_price+c.getTotal_price();
                    		Product p=ProductDao.getProduct(c.getPid());
                    		
                    %>
                      <tr>
                        <td><a class="remove" href="remove-from-cart.jsp?pid=<%=p.getPid()%>&uid=<%=c.getUid()%>"><fa class="fa fa-close"></fa></a></td>
                        <td><a href="#"><img src="product_images/<%=p.getProduct_image() %>" alt="img"></a></td>
                        <td><a class="aa-cart-title" href="#"><%=p.getProduct_name() %></a></td>
                        <td><%=c.getProduct_price() %></td>
                        <td>
                            <form name="change-qty" method="post" action="change-qty.jsp">
	                        	<input type="hidden" name="cid" value="<%=c.getCid()%>">
	                        	<input class="aa-cart-quantity" type="number" name="product_qty" value="<%=c.getProduct_qty()%>" onchange="this.form.submit();">
                        	</form>
                        </td>	
                        <td><%=c.getTotal_price()%></td>
                      </tr>
                      <%
                      }
                    	
                    	%>
                      <tr>
                        <td colspan="6" class="aa-cart-view-bottom">
                          <div class="aa-cart-coupon">
                            <input class="aa-coupon-code" type="text" placeholder="Coupon">
                            <input class="aa-cart-view-btn" type="submit" value="Apply Coupon">
                          </div>
                          <input class="aa-cart-view-btn" type="submit" value="Update Cart">
                        </td>
                      </tr>
                      </tbody>
                  </table>
                </div>
             </form>
             <!-- Cart Total view -->
             <div class="cart-view-total">
               <h4>Cart Totals</h4>
               <table class="aa-totals-table">
                 <tbody>
                   <tr>
                     <th>Subtotal</th>
                     <td><%=net_price %></td>
                   </tr>
                   <tr>
                     <th>Total</th>
                     <td><%=net_price %></td>
                   </tr>
                 </tbody>
               </table>
               <form>
					<input type="text" id="amount" name="amount" value="<%=net_price%>">
				</form>
            <button id="payButton" onclick="CreateOrderID()" class="bttnStyle">Pay Now</button>
             </div>
           </div>
         </div>
       </div>
     </div>
   </div>
 </section>
 <!-- / Cart view section -->


  <!-- Subscribe section -->
 
  <!-- / Subscribe section -->

  <!-- footer -->  

  <!-- / footer -->
  <!-- Login Modal -->  
  <div class="modal fade" id="login-modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">                      
        <div class="modal-body">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
          <h4>Login or Register</h4>
          <form class="aa-login-form" action="">
            <label for="">Username or Email address<span>*</span></label>
            <input type="text" placeholder="Username or email">
            <label for="">Password<span>*</span></label>
            <input type="password" placeholder="Password">
            <button class="aa-browse-btn" type="submit">Login</button>
            <label for="rememberme" class="rememberme"><input type="checkbox" id="rememberme"> Remember me </label>
            <p class="aa-lost-password"><a href="#">Lost your password?</a></p>
            <div class="aa-register-now">
              Don't have an account?<a href="account.jsp">Register now!</a>
            </div>
          </form>
        </div>                        
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div>

<script type="text/javascript">
	var xhttp=new XMLHttpRequest();
	var RazorpayOrderId;
	function CreateOrderID()
	{
		xhttp.open("GET","http://localhost:8080/MyProject/OrderCreation",false);
		xhttp.send();
		RazorpayOrderId=xhttp.responseText;
		OpenCheckOut();
	}
</script>

<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script type="text/javascript">
	
	
	function OpenCheckOut()
	{
		var amount=document.getElementById("amount").value;
		var new_amount=parseInt(amount)*100;
		var options={
				"key":"rzp_test_WhWQffOcDwCYx0",
				"amount":new_amount,
				"currency":"INR",
				"name":"Tops",
				"description":"Test",
				"callback_url":"http://localhost:8080/MyProject/index.jsp?id=<%=u.getId()%>",
				"prefill":{
					"name":"Adarsh Malav",
					"email":"malav.adarsh0045@gmail.com",
					"contact":"9962146456"
				},
				"notes":{
					"address":"Surat"
				},
				"theme":{
					"color":"#3399cc"
				}
				
				
		};
		var rzp1=new Razorpay(options);
		rzp1.on('payment.failed',function (response){
			alert(response.error.code);
	        alert(response.error.description);
	        alert(response.error.source);
	        alert(response.error.step);
	        alert(response.error.reason);
	        alert(response.error.metadata.order_id);
	        alert(response.error.metadata.payment_id);
		});
		rzp1.open();
	    e.preventDefault();
	}
</script>
    
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.js"></script>  
    <!-- SmartMenus jQuery plugin -->
    <script type="text/javascript" src="js/jquery.smartmenus.js"></script>
    <!-- SmartMenus jQuery Bootstrap Addon -->
    <script type="text/javascript" src="js/jquery.smartmenus.bootstrap.js"></script>  
    <!-- To Slider JS -->
    <script src="js/sequence.js"></script>
    <script src="js/sequence-theme.modern-slide-in.js"></script>  
    <!-- Product view slider -->
    <script type="text/javascript" src="js/jquery.simpleGallery.js"></script>
    <script type="text/javascript" src="js/jquery.simpleLens.js"></script>
    <!-- slick slider -->
    <script type="text/javascript" src="js/slick.js"></script>
    <!-- Price picker slider -->
    <script type="text/javascript" src="js/nouislider.js"></script>
    <!-- Custom js -->
    <script src="js/custom.js"></script> 

  </body>
</html>