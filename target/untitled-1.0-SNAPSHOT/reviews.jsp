<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Reviews - Phoenix Vehicle Rental</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <style>
    @keyframes fadeInUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    .table-row { animation: fadeInUp 0.5s ease-out; }
    .btn-action { transition: all 0.3s ease; }
    .btn-action:hover { transform: scale(1.05); }
    .input-field, .select-field, .textarea-field { transition: all 0.3s ease; }
    .input-field:focus, .select-field:focus, .textarea-field:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
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
<div class="container mx-auto p-6">
  <h1 class="text-3xl font-bold text-blue-700 mb-6">Vehicle Reviews</h1>
  <c:if test="${not empty error}">
    <p class="text-red-500 mb-4 text-center">${error}</p>
  </c:if>
  <!-- Add Review Form (Only for Customers) -->
  <c:if test="${!sessionScope.isAdmin}">
    <div class="bg-white p-8 rounded-lg shadow-lg max-w-md w-full mb-6">
      <h2 class="text-2xl font-semibold text-blue-700 mb-4">Add a Review</h2>
      <form action="vehicles" method="post">
        <input type="hidden" name="action" value="addReview">
        <div class="mb-4">
          <select name="vehicleId" class="select-field w-full p-3 border rounded-lg focus:outline-none" required>
            <option value="">Select Vehicle</option>
            <c:forEach items="${vehicles}" var="vehicle">
              <option value="${vehicle.id}">${vehicle.model} (${vehicle.id})</option>
            </c:forEach>
          </select>
        </div>
        <div class="mb-4">
          <input type="number" name="rating" placeholder="Rating (1-5)" min="1" max="5" class="input-field w-full p-3 border rounded-lg focus:outline-none" required>
        </div>
        <div class="mb-4">
          <textarea name="comment" placeholder="Your Review" class="textarea-field w-full p-3 border rounded-lg focus:outline-none" rows="4" required></textarea>
        </div>
        <button type="submit" class="btn-submit w-full bg-blue-600 text-white p-3 rounded-lg font-semibold hover:bg-blue-700">Submit Review</button>
      </form>
    </div>
  </c:if>
  <!-- Reviews Table -->
  <div class="bg-white shadow-lg rounded-lg overflow-hidden">
    <table class="w-full">
      <thead class="bg-blue-600 text-white">
      <tr>
        <th class="p-4 text-left">Vehicle</th>
        <th class="p-4 text-left">User</th>
        <th class="p-4 text-left">Rating</th>
        <th class="p-4 text-left">Comment</th>
        <th class="p-4 text-left">Date</th>
        <th class="p-4 text-left">Actions</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${reviews}" var="review">
        <tr class="table-row border-b hover:bg-gray-50">
          <td class="p-4">
            <c:forEach items="${vehicles}" var="vehicle">
              <c:if test="${vehicle.id == review.vehicleId}">
                ${vehicle.model} (${vehicle.id})
              </c:if>
            </c:forEach>
          </td>
          <td class="p-4">${review.username}</td>
          <td class="p-4">${review.rating}/5</td>
          <td class="p-4">${review.comment}</td>
          <td class="p-4">${review.reviewDate}</td>
          <td class="p-4">
            <c:if test="${sessionScope.user.username == review.username && !sessionScope.isAdmin}">
              <form action="vehicles" method="post" class="inline">
                <input type="hidden" name="action" value="deleteReview">
                <input type="hidden" name="reviewId" value="${review.reviewId}">
                <button type="submit" class="btn-action text-red-600 hover:text-red-800">Delete</button>
              </form>
            </c:if>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>