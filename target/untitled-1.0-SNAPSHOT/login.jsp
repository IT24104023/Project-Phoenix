<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Login - Phoenix Vehicle Rental</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <style>
    @keyframes slideUp {
      from { opacity: 0; transform: translateY(50px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .slide-up { animation: slideUp 0.8s ease-out; }
    .input-field { transition: all 0.3s ease; }
    .input-field:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
    .btn-login { transition: all 0.3s ease; }
    .btn-login:hover { transform: translateY(-2px); box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
  </style>
</head>
<body class="bg-gray-100 font-sans flex items-center justify-center min-h-screen">
<div class="bg-white p-8 rounded-lg shadow-lg max-w-md w-full slide-up">
  <h1 class="text-3xl font-bold text-blue-700 mb-6 text-center">Login</h1>
  <c:if test="${not empty error}">
    <p class="text-red-500 mb-4 text-center">${error}</p>
  </c:if>
  <c:if test="${not empty success}">
    <p class="text-green-500 mb-4 text-center">${success}</p>
  </c:if>
  <form action="vehicles" method="post">
    <input type="hidden" name="action" value="login">
    <div class="mb-4">
      <input type="text" name="username" placeholder="Username" class="input-field w-full p-3 border rounded-lg focus:outline-none" required>
    </div>
    <div class="mb-6">
      <input type="password" name="password" placeholder="Password" class="input-field w-full p-3 border rounded-lg focus:outline-none" required>
    </div>
    <button type="submit" class="btn-login w-full bg-blue-600 text-white p-3 rounded-lg font-semibold hover:bg-blue-700">Login</button>
  </form>
  <p class="mt-4 text-center">Don't have an account? <a href="register.jsp" class="text-blue-600 hover:underline">Register</a></p>
</div>
</body>
</html>