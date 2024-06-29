<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*, java.util.*, java.text.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Flow bite -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.css" rel="stylesheet" />

    <!-- Include common head content -->
    <jsp:include page="${pageContext.request.contextPath}/WEB-INF/jsp/commonHead.jsp"/>

    <!-- Icons -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <title>Header</title>
</head>
<%
    try{
    String email1 = (String) session.getAttribute("email");
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
    String[] tables = {"patients", "doctor", "staff", "nurse"};
    String type = null;
    for (String table : tables) {
        String query = "SELECT type FROM " + table + " WHERE email = ?";
        PreparedStatement statement1 = con1.prepareStatement(query);
        statement1.setString(1, email1);
        ResultSet rstt = statement1.executeQuery();

        if (rstt.next()) {
            type = rstt.getString("type");
            System.out.println("Email found in table " + table + " with type: " + type);
            break;
        }
    }

%>
<body>
<div class="flex justify-between bg-white items-center h-14 mb-2">
    <!-- Logo on the left -->
    <a href="welcomepage"><img src="${pageContext.request.contextPath}/static/images/suvidha.jpg" class="h-14" alt="logo"/></a>

    <%
        Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
        if(loggedIn == null || !loggedIn) {
    %>
    <div class="flex space-x-4 p-2 mr-10">
        <a class="text-xl" href="#" onclick="alert('Please Login')">Dashboard</a>
        <a class="text-xl" href="login">Login/Signup</a>
    </div>
    <%
    } else {
    %>
    <div class="flex space-x-4 p-2 mr-10">
        <button type="button" id="menu-button" aria-expanded="true" aria-haspopup="true"><span class="material-symbols-outlined">sms</span></button>
        <a class="text-xl font-black" href="feedback"><img src="${pageContext.request.contextPath}/static/images/feedback.png" class="h-8 font-black" alt="feedback"/></a>
        <%
            if(type.equals("patient")){
        %>
        <a class="text-xl" href="DashboardForPatients">Dashboard</a>
        <%}
            else if(type.equals("doctor")){
        %>
        <a class="text-xl" href="DashboardForMedical">Dashboard</a>
        <%}
            else if(type.equals("staff")){
        %>
        <a class="text-xl" href="DashboardForStaff">Dashboard</a>
        <%}
            else if(type.equals("nurse")){
        %>
        <%}
        %>
        <a class="text-xl" href="logout">Logout</a>
    </div>
    <%
        }
    %>

    <div id="dropdown-menu" class="absolute right-20 top-10 z-10 mt-2 w-96 p-2 origin-top-right rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none hidden" role="menu" aria-orientation="vertical" aria-labelledby="menu-button" tabindex="-1">
        <div class="py-1" role="none">
            <%
                PreparedStatement statement = con1.prepareStatement("select me.messages, do.name as doctor_name, pat.name as patient_name from messages as me join doctor as do on do.email = me.doctor_email join patients as pat on pat.email = me.patient_email and pat.email = ?");
                statement.setString(1, email1);
                ResultSet resultSet = statement.executeQuery();
                if(resultSet.next()) {%>
            <p class="text-md"><%=resultSet.getString("messages")%></p>
            <h1 class="sm italic">- <%=resultSet.getString("doctor_name")%></h1>
            <hr>
            <%} else {%>
            <h1 class="text-lg">No messages</h1>
            <%}}catch (Exception e){e.getMessage();}
            %>

        </div>
    </div>

<%--        <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">Dashboard</button>--%>

<%--        <!-- Login/Signup button -->--%>
<%--        <button class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded"></button>--%>
<%--    </div>--%>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const menuButton = document.getElementById('menu-button');
        const dropdownMenu = document.getElementById('dropdown-menu');

        menuButton.addEventListener('click', function () {
            const isExpanded = menuButton.getAttribute('aria-expanded') === 'true';
            menuButton.setAttribute('aria-expanded', !isExpanded);
            dropdownMenu.classList.toggle('hidden');
        });

        document.addEventListener('click', function (event) {
            if (!menuButton.contains(event.target) && !dropdownMenu.contains(event.target)) {
                menuButton.setAttribute('aria-expanded', 'false');
                dropdownMenu.classList.add('hidden');
            }
        });
    });
</script>

<script src="https://kit.fontawesome.com/992e336b17.js" crossorigin="anonymous"></script>

</body>

</html>