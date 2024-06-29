<%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 02-06-2024
  Time: 12:22
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Include common head content -->
    <jsp:include page="${pageContext.request.contextPath}/WEB-INF/jsp/commonHead.jsp" />
    <title>Login</title>
</head>
<body>
<%@ include file="header.jsp"%>
<div class="grid grid-cols-2">
    <div class="col-span-1 flex items-center justify-center">
        <img src="${pageContext.request.contextPath}/static/images/login.png" class="h-[calc(100vh-5rem)]" alt="logo"/>
    </div>
    <div class="col-span-1 flex items-center justify-center">
        <div class="w-3/4 mx-auto bg-white my-4 p-4 border rounded-lg shadow-lg">
            <form action="login" method="post" class="space-y-4">
                <c:if test="${not empty error}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                        <strong class="font-bold">Error!</strong>
                        <span class="block sm:inline">${error}</span>
                    </div>
                </c:if>
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
                <button type="submit"
                        class="w-full bg-blue-500 text-white font-bold py-2 px-4 rounded focus:outline-none focus:bg-blue-700">
                    Login
                </button>
            </form>
            <h1 class="text-lg mt-2 text-gray-500 text-center">New Here? <a href="signup" class="text-black hover:text-blue-600">Sign Up</a></h1>
        </div>
    </div>
</div>

</body>
</html>
