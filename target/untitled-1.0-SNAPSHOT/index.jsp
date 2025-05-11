<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Phoenix Vehicle Rental Service</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .fade-in { animation: fadeIn 1s ease-in-out; }
        .nav-link { transition: all 0.3s ease; }
        .nav-link:hover { transform: scale(1.1); color: #1d4ed8; }
        .hero-bg { background: linear-gradient(135deg, #3b82f6, #1e3a8a); }
        .btn-login { transition: all 0.3s ease; }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); }
    </style>
</head>
<body class="bg-gray-100 font-sans">
<nav class="bg-white shadow-lg p-4">
    <div class="container mx-auto flex justify-between items-center">
        <h1 class="text-2xl font-bold text-blue-700">Phoenix Vehicle Rental</h1>
        <div class="space-x-4">
            <c:if test="${sessionScope.user != null}">
                <a href="vehicles?action=list" class="nav-link text-blue-600 hover:text-blue-800">Vehicles</a>
                <c:if test="${sessionScope.isAdmin}">
                    <a href="add-vehicle.jsp" class="nav-link text-blue-600 hover:text-blue-800">Add Vehicle</a>
                    <a href="vehicles?action=rentals" class="nav-link text-blue-600 hover:text-blue-800">Rentals</a>
                </c:if>
                <a href="vehicles?action=logout" class="nav-link text-red-600 hover:text-red-800">Logout</a>
            </c:if>
        </div>
    </div>
</nav>
<div class="hero-bg text-white py-20 text-center fade-in">
    <div class="container mx-auto">
        <h1 class="text-5xl font-bold mb-4">Welcome to Phoenix Vehicle Rental Service</h1>
        <p class="text-lg mb-6">Rent your dream vehicle with ease and convenience.</p>
        <c:if test="${sessionScope.user == null}">
            <a href="login.jsp" class="btn-login bg-white text-blue-700 px-6 py-3 rounded-lg font-semibold hover:bg-blue-100">Login</a>
            <a href="register.jsp" class="btn-login bg-white text-blue-700 px-6 py-3 rounded-lg font-semibold hover:bg-blue-100 ml-4">Register</a>
        </c:if>
        <c:if test="${sessionScope.user != null}">
            <a href="vehicles?action=list" class="bg-white text-blue-700 px-6 py-3 rounded-full font-semibold hover:bg-blue-100 transition-all duration-300 transform hover:scale-105">Explore Vehicles</a>
        </c:if>
    </div>
</div>
</body>
</html>