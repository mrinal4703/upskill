<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/output.css">
    <!-- Include common head content -->
    <jsp:include page="${pageContext.request.contextPath}/WEB-INF/jsp/commonHead.jsp" />
    <title>Sign Up</title>
</head>
<body>
<%@ include file="header.jsp"%>
<h1 class="text-3xl"></h1>
<div class="grid grid-cols-2">
    <div class="col-span-1 flex items-center justify-center">
        <img src="${pageContext.request.contextPath}/static/images/signup.png" class="h-[calc(100vh-5rem)]" alt="logo"/>
    </div>
    <div class="col-span-1 flex items-center justify-center">
        <div class="w-3/4 mx-auto bg-white my-4 p-4 border rounded-lg shadow-lg">
            <form action="signup" method="post" class="space-y-4">
                <c:if test="${not empty error}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                        <strong class="font-bold">Error!</strong>
                        <span class="block sm:inline">${error}</span>
                    </div>
                </c:if>
                <div>
                    <label class="block">Name:</label>
                    <input
                            type="text"
                            name="name"
                            placeholder="Name"
                            class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                            required
                    />
                </div>
                <div>
                    <label class="block">Email:</label>
                    <input
                            type="email"
                            name="email"
                            placeholder="Email"
                            class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                            required
                    />
                </div>
                <div>
                    <label class="block">Password:</label>
                    <input
                            type="password"
                            name="password"
                            placeholder="Password"
                            class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                            required
                    />
                </div>
                <div>
                    <label class="block">Age:</label>
                    <input
                            type="number"
                            name="age"
                            placeholder="Age"
                            minlength="1"
                            maxlength="3"
                            class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                            required
                    />
                </div>
                <div>
                    <label class="block">Address:</label>
                    <input
                            type="text"
                            name="address"
                            placeholder="Address"
                            class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                            required
                    />
                </div>
                <div>
                    <label class="block">Phone number:</label>
                    <input
                            type="tel"
                            name="phone"
                            placeholder="Phone Number"
                            minlength="10"
                            maxlength="10"
                            class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                            required
                    />
                </div>
                <button type="submit"
                        class="w-full bg-blue-500 text-white font-bold py-2 px-4 rounded focus:outline-none focus:bg-blue-700">
                    Sign Up
                </button>
            </form>
            <h1 class="text-lg mt-2 text-gray-500 text-center">Already a member? <a href="login" class="text-black hover:text-blue-600">Login</a></h1>
        </div>
    </div>
</div>

<%--<script>--%>
<%--    function validateForm() {--%>
<%--        resetErrors();--%>

<%--        var age = document.getElementById('age').value;--%>
<%--        var dob = document.getElementById('dob').value;--%>
<%--        var email = document.getElementById('email').value;--%>

<%--        var isValid = true;--%>

<%--        --%>

<%--        if (!/^[0-9]{1,2}$/.test(age)) {--%>
<%--            displayError('ageError', 'Enter valid age!!');--%>
<%--            isValid = false;--%>
<%--        }--%>

<%--        if (!/^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/20[0-9]{2}$/.test(dob)) {--%>
<%--            displayError('dobError', 'Enter valid Date of Birth!!');--%>
<%--            isValid = false;--%>
<%--        }--%>

<%--        if (!/^[a-zA-Z0-9]{1,20}(\.[a-zA-Z0-9]{1,20}){0,5}@[a-zA-Z0-9]{3,}(?:\.[a-zA-Z0-9-]+){1,5}$/.test(email)) {--%>
<%--            displayError('emailError', 'Enter valid email!!');--%>
<%--            isValid = false;--%>
<%--        }--%>

<%--        return isValid;--%>
<%--    }--%>

<%--    function displayError(elementId, message) {--%>
<%--        document.getElementById(elementId).innerText = message;--%>
<%--    }--%>

<%--    function resetErrors() {--%>
<%--        var errorElements = document.querySelectorAll('.error');--%>
<%--        errorElements.forEach(function (element) {--%>
<%--            element.innerText = '';--%>
<%--        });--%>
<%--    }--%>
<%--</script>--%>
</body>
</html>