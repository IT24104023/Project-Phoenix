<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Phoenix Vehicle Rental</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <style>
    @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    .vehicle-card { animation: fadeIn 0.5s ease-in; }
    .btn-action { transition: all 0.3s ease; }
    .btn-action:hover { transform: scale(1.05); }
    .input-field, .select-field { transition: all 0.3s ease; }
    .input-field:focus, .select-field:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
    .error-text { color: #ef4444; font-size: 0.875rem; display: none; }
    .input-error { border-color: #ef4444; }
  </style>
  <script>
    function toggleCardNumberInput(selectElement, formId) {
      const form = document.getElementById(formId);
      const cardNumberInput = form.querySelector('input[name="cardNumber"]');
      const cvnInput = form.querySelector('input[name="cvn"]');
      const isCard = selectElement.value === 'Card';
      cardNumberInput.style.display = isCard ? 'block' : 'none';
      cvnInput.style.display = isCard ? 'block' : 'none';
      cardNumberInput.required = isCard;
      cvnInput.required = isCard;
      cardNumberInput.classList.remove('input-error');
      cvnInput.classList.remove('input-error');
      form.querySelector('#cardNumberError').style.display = 'none';
      form.querySelector('#cvnError').style.display = 'none';
    }
    function validateCardNumber(input) {
      const errorSpan = input.closest('form').querySelector('#cardNumberError');
      const pattern = /^[0-9]{16}$/;
      if (input.value && !pattern.test(input.value)) {
        input.classList.add('input-error');
        errorSpan.style.display = 'block';
      } else {
        input.classList.remove('input-error');
        errorSpan.style.display = 'none';
      }
    }
    function validateCvn(input) {
      const errorSpan = input.closest('form').querySelector('#cvnError');
      const pattern = /^[0-9]{3,4}$/;
      if (input.value && !pattern.test(input.value)) {
        input.classList.add('input-error');
        errorSpan.style.display = 'block';
      } else {
        input.classList.remove('input-error');
        errorSpan.style.display = 'none';
      }
    }
    function validateForm(form) {
      let isValid = true;
      const paymentMethod = form.querySelector('select[name="paymentMethod"]').value;
      if (paymentMethod === 'Card') {
        const cardNumberInput = form.querySelector('input[name="cardNumber"]');
        const cvnInput = form.querySelector('input[name="cvn"]');
        validateCardNumber(cardNumberInput);
        validateCvn(cvnInput);
        if (cardNumberInput.classList.contains('input-error') || cvnInput.classList.contains('input-error')) {
          isValid = false;
        }
      }
      return isValid;
    }
  </script>
</head>
<body class="bg-gray-100 font-sans">
<nav class="bg-white shadow-lg p-4">
  <div class="container mx-auto flex justify-between items-center">
    <h1 class="text-2xl font-bold text-blue-700">Phoenix Vehicle Rental</h1>
    <div class="space-x-4">
      <a href="vehicles?action=list" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Vehicles</a>
      <c:if test="${sessionScope.isAdmin}">
        <a href="add-vehicle.jsp" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Add Vehicle</a>
        <a href="add-addon.jsp" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Add Add-on</a>
      </c:if>
      <a href="vehicles?action=rentals" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Rentals</a>
      <a href="vehicles?action=reviews" class="text-blue-600 hover:text-blue-800 transition-all duration-300">Reviews</a>
      <a href="vehicles?action=logout" class="text-red-600 hover:text-red-800 transition-all duration-300">Log Out</a>
    </div>
  </div>
</nav>
<div class="container mx-auto p-6">
  <h1 class="text-3xl font-bold text-blue-700 mb-6">Available Vehicles</h1>
  <c:if test="${not empty error}">
    <p class="text-red-500 mb-4 text-center">${error}</p>
  </c:if>
  <form class="mb-6">
    <div class="flex flex-wrap gap-4">
      <input type="text" name="search" placeholder="Search by ID or Model" value="${param.search}" class="input-field p-3 border rounded-lg focus:outline-none w-full md:w-1/3">
      <select name="availability" class="select-field p-3 border rounded-lg focus:outline-none w-full md:w-1/4">
        <option value="">All Availability</option>
        <option value="true" ${param.availability == 'true' ? 'selected' : ''}>Available</option>
        <option value="false" ${param.availability == 'false' ? 'selected' : ''}>Rented</option>
      </select>
      <select name="category" class="select-field p-3 border rounded-lg focus:outline-none w-full md:w-1/4">
        <option value="">All Categories</option>
        <option value="Economy" ${param.category == 'Economy' ? 'selected' : ''}>Economy</option>
        <option value="Luxury" ${param.category == 'Luxury' ? 'selected' : ''}>Luxury</option>
        <option value="SUV" ${param.category == 'SUV' ? 'selected' : ''}>SUV</option>
        <option value="Van" ${param.category == 'Van' ? 'selected' : ''}>Van</option>
      </select>
      <button type="submit" class="btn-action bg-blue-600 text-white p-3 rounded-lg hover:bg-blue-700">Search</button>
    </div>
    <input type="hidden" name="action" value="list">
  </form>
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <c:forEach items="${vehicles}" var="vehicle">
      <div class="vehicle-card bg-white shadow-lg rounded-lg p-6">
        <h2 class="text-xl font-semibold text-blue-700">${vehicle.model}</h2>
        <p class="text-gray-600">ID: ${vehicle.id}</p>
        <p class="text-gray-600">Price: $${vehicle.rentPrice}/day</p>
        <p class="text-gray-600">Category: ${vehicle.category}</p>
        <p class="text-gray-600">Status: ${vehicle.available ? 'Available' : 'Rented'}</p>
        <c:if test="${vehicle.available}">
          <form action="vehicles" method="post" id="rentForm_${vehicle.id}" onsubmit="return validateForm(this)">
            <input type="hidden" name="action" value="rent">
            <input type="hidden" name="id" value="${vehicle.id}">
            <div class="mt-4">
              <input type="text" name="customerName" placeholder="Enter your name" value="${sessionScope.user.username}" class="input-field w-full p-3 border rounded-lg mb-2 focus:outline-none" required>
              <input type="text" name="idCardNumber" placeholder="ID Card Number" class="input-field w-full p-3 border rounded-lg mb-2 focus:outline-none" required>
              <input type="number" name="days" placeholder="Rental Days" min="1" class="input-field w-full p-3 border rounded-lg mb-2 focus:outline-none" required>
              <select name="paymentMethod" class="select-field w-full p-3 border rounded-lg mb-2 focus:outline-none" onchange="toggleCardNumberInput(this, 'rentForm_${vehicle.id}')" required>
                <option value="Cash">Cash</option>
                <option value="Card">Card</option>
              </select>
              <input type="text" name="cardNumber" placeholder="Card Number (16 digits)" class="input-field w-full p-3 border rounded-lg mb-2 mt-4 focus:outline-none" style="display: none;" oninput="validateCardNumber(this)">
              <span id="cardNumberError" class="error-text">Please enter a valid 16-digit card number.</span>
              <input type="text" name="cvn" placeholder="CVN (3-4 digits)" class="input-field w-full p-3 border rounded-lg mb-2 focus:outline-none" style="display: none;" oninput="validateCvn(this)">
              <span id="cvnError" class="error-text">Please enter a valid CVN (3-4 digits).</span>
              <div class="mb-2">
                <label class="block text-gray-700 font-semibold mb-1">Add-ons:</label>
                <c:forEach items="${addons}" var="addon">
                  <div>
                    <input type="checkbox" name="addons" value="${addon.name}" class="mr-2">
                    <label>${addon.name} ($${addon.price})</label>
                  </div>
                </c:forEach>
              </div>
              <button type="submit" class="btn-action w-full bg-blue-600 text-white p-3 rounded-lg hover:bg-blue-700">Rent Vehicle</button>
            </div>
          </form>
        </c:if>
        <c:if test="${sessionScope.isAdmin}">
          <div class="mt-4 flex gap-2">
            <form action="vehicles" method="get" class="inline">
              <input type="hidden" name="action" value="edit">
              <input type="hidden" name="id" value="${vehicle.id}">
              <button type="submit" class="btn-action bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700">Edit</button>
            </form>
            <form action="vehicles" method="post" class="inline">
              <input type="hidden" name="action" value="delete">
              <input type="hidden" name="id" value="${vehicle.id}">
              <button type="submit" class="btn-action bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700">Delete</button>
            </form>
          </div>
        </c:if>
      </div>
    </c:forEach>
  </div>
</div>
</body>
</html>