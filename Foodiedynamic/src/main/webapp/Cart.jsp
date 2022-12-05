<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="com.FoodieServers.DbCon" %>
    <%@page import="com.FoodieServers.productdao" %>
<%@page import="java.util.*"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.FoodieModels.Cart" %>
<%@page import="java.util.ArrayList"%>
<%@page import="com.FoodieModels.User"%>
<%
DecimalFormat dcf = new DecimalFormat("#.##");
request.setAttribute("dcf", dcf);
User auth = (User) request.getSession().getAttribute("auth");
if (auth != null) {
    request.setAttribute("person", auth);
}
ArrayList<Cart> cart_list = (ArrayList<Cart>) session.getAttribute("cart-list");
List<Cart> cartProduct = null;
if (cart_list != null) {
	productdao pDao = new productdao(DbCon.getConnection());
	cartProduct = pDao.getCartProducts(cart_list);
	double total = pDao.getTotalCartPrice(cart_list);
	request.setAttribute("total", total);
	request.setAttribute("cart_list", cart_list);
}
%>
<!DOCTYPE html>
<html>
<head>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
<link rel="stylesheet" href="style.css">
<script src="https://kit.fontawesome.com/64e1bb2e91.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
<link rel="stylesheet" href="style.css">
<script src="https://kit.fontawesome.com/64e1bb2e91.js" crossorigin="anonymous"></script>
<title>Foodiee</title>
<style type="text/css">
.table tbody td{
vertical-align: middle;
}
.btn-incre, .btn-decre{
box-shadow: none;
font-size: 25px;
}
</style>
</head>
<body >
<nav class="navbar fixed-top navbar-expand-md navbar-light bg-light" id= "myHeader">
  <a href="index.jsp" class="navbar-brand"><i><strong>Foodie</strong></i></a>

  <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#mnav">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse nav-container" id="mnav">
    <ul class="navbar-nav navmargin">
      <li class="nav-item"><a href="index.jsp" class="nav-link">Home</a></li>
          <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            Categories
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="chinees.jsp">Chinees</a></li>
            <li><a class="dropdown-item" href="northindian.jsp">North Indian</a></li>
            <li><a class="dropdown-item" href="southindian.jsp">South Indian</a></li>
            <li><a class="dropdown-item" href="western.jsp">Western</a></li>
          </ul>
        </li>
          <li class="nav-item"><a href="orders.jsp" class="nav-link">Previous Orders</a></li>
        </ul>
      <form class="form-inline d-flex flex-nowrap searchbar">
        <input type="search" class="form-control" placeholder="search">
        <button class="btn btn-outline-danger">Search</button>
      </form>
      <a class="nav-link cartlink" href="Cart.jsp" style="margin-left: 1%;">Cart </a>
      <div style="font-size: 10px" class="badge bg-danger cart-img-badge"><span>${ cart_list.size() }</span></div>
      <a href="#!"  data-toggle="modal" data-target="#exampleModal"class="nav-link profile-name" style="margin-left: 1%;"><i class="fa-solid fa-user">  </i><%= auth.getName() %></a>
  </div>
	<a href="logout"><button class="btn btn-outline-danger logout">Logout</button></a>
</nav>

	<div class="container my-3" style="padding-top:50px;">
		<div class="d-flex py-3"><h3>Total Price: $ ${(total>0)?dcf.format(total):0} </h3> <a class="mx-3 btn btn-primary" href="cart-check-out">Check Out</a></div>
		<table class="table table-light">
			<thead>
				<tr>
					<th scope="col">Name</th>
					<th scope="col">Category</th>
					<th scope="col">Price</th>
					<th scope="col">Buy Now</th>
					<th scope="col">Cancel</th>
				</tr>
			</thead>
			<tbody>
				<%
				if (cart_list != null) {
					for (Cart c : cartProduct) {
				%>
				<tr>
					<td><%=c.getName()%></td>
					<td><%=c.getCategory()%></td>
					<td><%= dcf.format(c.getPrice())%></td>
					<td>
						<form action="order-now" method="post" class="form-inline">
						<input type="hidden" name="id" value="<%= c.getId()%>" class="form-input">
							<div class="form-group d-flex justify-content-between w-50">
								<a class="btn bnt-sm btn-incre" href="QuantityServlet?action=inc&id=<%=c.getId()%>"><i class="fas fa-plus-square"></i></a> 
								<input type="text" name="quantity" class="form-control W-50" " value="<%=c.getQuantity()%>" readonly> 
								<a class="btn btn-sm btn-decre" href="QuantityServlet?action=dec&id=<%=c.getId()%>"><i class="fas fa-minus-square"></i></a>
							<button type="submit" class="btn btn-primary btn-sm">Buy</button>
							</div>
						</form>
					</td>
					<td><a href="remove-from-cart?id=<%=c.getId() %>" class="btn btn-sm btn-danger">Remove</a></td>
				</tr>

				<%
				}}%>
			</tbody>
		</table>
	</div>

	<%@include file="footer.jsp"%>
</body>
</html>