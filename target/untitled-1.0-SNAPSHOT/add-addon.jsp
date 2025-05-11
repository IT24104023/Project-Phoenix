<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Add Add-on - Phoenix Vehicle Rental</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <style>
    @keyframes slideUp { from { opacity: 0; transform: translateY(50px); } to { opacity: 1; transform: translateY(0); } }
    .slide-up { animation: slideUp 0.8s ease-out; }
    .input-field { transition: all 0.3s ease; }
    .input-field:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
    .btn-submit { transition: all 0.3s ease; }
    .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
  </style>
</head>
<body class="bg-gray-100 font-sans">
<nav class="bg-white shadow-lg p-4">
  <div class="container mx-auto flex justify-between items-center">
    <h1 class="text-2xl font-bold text-blue-700">Phoenix Vehicle Rental</h1>
    <div class="space-x-4">
      <a href="vehicles?action=list" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Vehicles</a>
      <c:if test="${sessionScope.isAdmin}">
        <a href="add-vehicle.jsp" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Add Vehicle</a>
        <a href="vehicles?action=rentals" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Rentals</a>
        <a href="add-addon.jsp" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Add Add-on</a>
      </c:if>
      <a href="vehicles?action=reviews" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Reviews</a>
      <a href="vehicles?action=logout" class="text-red-600 hover:text-red-800 transition-all duration-300">Log Out</a>
    </div>
  </div>
</nav>
<div class="container mx-auto p-6 flex justify-center">
  <div class="bg-white p-8 rounded-lg shadow-lg max-w-md w-full slide-up">
    <c:if test="${sessionScope.user == null || !sessionScope.isAdmin}">
      <c:redirect url="vehicles?action=list"/>
    </c:if>
    <h1 class="text-3xl font-bold text-blue-700 mb-6">Add New Add-on</h1>
    <c:if test="${not empty error}">
      <p class="text-red-500 mb-4 text-center">${error}</p>
    </c:if>
    <form action="vehicles" method="post">
      <input type="hidden" name="action" value="createAddon">
      <div class="mb-4">
        <input type="text" name="addonId" placeholder="Add-on ID (e.g., A001)" class="input-field w-full p-3 border rounded-lg focus:outline-none" required>
      </div>
      <div class="mb-4">
        <input type="text" name="name" placeholder="Add-on Name (e.g., Child Seat)" class="input-field w-full p-3 border rounded-lg focus:outline-none" required>
      </div>
      <div class="mb-4">
        <input type="number" name="price" placeholder="Price (e.g., 10.00)" step="0.01" min="0" class="input-field w-full p-3 border rounded-lg focus:outline-none" required>
      </div>
      <button type="submit" class="btn-submit w-full bg-blue-600 text-white p-3 rounded-lg font-semibold hover:bg-blue-700">Add Add-on</button>
    </form>
  </div>
</div>
</body>
</html>