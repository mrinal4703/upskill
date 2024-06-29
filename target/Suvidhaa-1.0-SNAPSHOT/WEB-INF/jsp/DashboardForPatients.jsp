<%@ page import="java.sql.*, java.util.*, java.text.*" %>
<%@ page import="java.util.Date" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Include common head content -->
    <jsp:include page="${pageContext.request.contextPath}/WEB-INF/jsp/commonHead.jsp"/>
    <title>Dashboard</title>
    <!-- Icons -->
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0"/>
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0"/>
</head>
<%
    String email = (String) session.getAttribute("email");
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
%>
<body>
<%@ include file="header.jsp" %>
<h1 class="text-3xl ml-3">
    <%
        String name = "";
        PreparedStatement stmt = con.prepareStatement("select * from patients where email=?");
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
        }
    %>
    Welcome <%=name%>
</h1>
<div class="grid grid-rows-3 grid-cols-5 gap-2">
    <div class="row-span-3 col-span-3 bg-white rounded-lg shadow-md mx-3 p-3 my-4">
        <div class="border-b border-gray-300 pb-2 mb-2">
            <h1 class="text-lg font-bold">List of Doctors and their Specialities</h1>
        </div>
        <div class="overflow-y-auto max-h-96"> <!-- Scrollable container with a fixed max height -->
            <table class="table-auto mx-auto w-full">
                <thead class="bg-gray-200">
                <%
                    PreparedStatement stmt4 = con.prepareStatement("select * from doctor");
                    ResultSet rs4 = stmt4.executeQuery();
                    if (rs4.next()) {
                %>
                <tr>
                    <th class="px-4 py-2 border border-solid border-black font-bold">Doctor's Name</th>
                    <th class="px-4 py-2 border border-solid border-black font-bold">Specialization</th>
                    <th class="px-4 py-2 border border-solid border-black font-bold">Position</th>
                    <th class="px-4 py-2 border border-solid border-black font-bold">Cases</th>
                    <th class="px-4 py-2 border border-solid border-black font-bold">Phone number</th>
                    <th class="px-4 py-2 border border-solid border-black font-bold">Email ID</th>
                </tr>
                </thead>
                <tbody>
                <%
                    do {
                %>
                <tr class="border border-solid border-black">
                    <td class="border border-solid border-black px-4 py-2"><%=rs4.getString("name")%>
                    </td>
                    <td class="border border-solid border-black px-4 py-2"><%=rs4.getString("specialization")%>
                    </td>
                    <td class="border border-solid border-black px-4 py-2"><%=rs4.getString("position")%>
                    </td>
                    <td class="border border-solid border-black px-4 py-2"><%=rs4.getString("total_cases")%>
                    </td>
                    <td class="border border-solid border-black px-4 py-2 hover:text-blue-600">
                        <a href="tel:<%=rs4.getString("phone")%>" class="flex items-center">
                            <span class="ml-1"><%=rs4.getString("phone")%></span>
                        </a>
                    </td>
                    <td class="border border-solid border-black px-4 py-2 hover:text-gray-400"><a
                            href="mailto:<%=rs4.getString("email")%>"><%=rs4.getString("email")%>
                    </a>
                    </td>
                </tr>
                <%
                    } while (rs4.next());
                %>
                <% } else { %>
                <tr>
                    <td colspan="6" class="text-lg ml-3">No Doctors registered.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <div class="row-span-3 col-span-2 bg-white rounded-lg shadow-md mx-3 p-3 my-4">
        <div class="border-b border-gray-300 pb-2 mb-2">
            <h1 class="text-lg font-bold">Specializations and their availability</h1>
        </div>
        <div class="overflow-y-auto max-h-96"> <!-- Scrollable container with a fixed max height -->
            <table class="table-auto mx-auto w-full">
                <thead class="bg-gray-200">
                <%
                    PreparedStatement stmt6 = con.prepareStatement("select * from departments");
                    ResultSet rs6 = stmt6.executeQuery();
                    if (rs6.next()) {
                %>
                <tr>
                    <th class="px-4 py-2 border border-solid border-black font-bold">Specialization</th>
                    <th class="px-4 py-2 border border-solid border-black font-bold">Availability</th>
                </tr>
                </thead>
                <tbody>
                <%
                    do {
                %>
                <tr class="border border-solid border-black">
                    <td class="border border-solid border-black px-4 py-2"><%=rs6.getString("specialization")%>
                    </td>
                    <td class="border border-solid border-black px-4 py-2"><%=rs6.getString("availability")%>
                    </td>
                </tr>
                <%
                    } while (rs6.next());
                %>
                <% } else { %>
                <tr>
                    <td colspan="2" class="border border-solid border-black px-4 py-2 text-center">No Departments.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="grid grid-rows-3 grid-cols-4 gap-2">
    <div class="col-span-2 row-span-3 bg-white rounded-lg shadow-md mx-3 p-3 my-4">
        <div class="border-b border-gray-300 p2-4 mb-3">
            <h1 class="text-lg font-bold">Your Medical History</h1>
        </div>
        <div class="">
            <%
                int recordsPerPage = 1; // Number of records to display per page
                int totalRecords = 0; // Total number of records
                PreparedStatement stmt3 = con.prepareStatement("select count(*) as total_records from patients as pat join medical_history as med on med.medical_history_id = pat.medical_history_id where pat.email = ?");
                stmt3.setString(1, email);
                ResultSet rsCount = stmt3.executeQuery();
                if (rsCount.next()) {
                    totalRecords = rsCount.getInt("total_records");
                }
                int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
                int currentPage = 1; // Default current page
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) {
                        currentPage = 1;
                    } else if (currentPage > totalPages) {
                        currentPage = totalPages;
                    }
                }
            %>
            <div class="my-4 flex flex-col items-center justify-center">
                <nav aria-label="Page navigation example">
                    <ul class="inline-flex -space-x-px text-base h-10">
                        <li>
                            <a href="?page=<%= currentPage - 1 %>"
                               class="flex items-center justify-center px-4 h-10 ms-0 leading-tight text-gray-500 bg-white border border-e-0 border-gray-300 rounded-s-lg hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white">Previous
                                Case</a>
                        </li>
                        <% for (int pageNum = 1; pageNum <= totalPages; pageNum++) { %>
                        <li>
                            <a href="?page=<%= pageNum %>"
                               class="flex items-center justify-center px-4 h-10 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white <%= pageNum == currentPage ? "text-blue-600 border-blue-300 bg-blue-50 hover:bg-blue-100 hover:text-blue-700 dark:border-gray-700 dark:bg-gray-700 dark:text-white" : "" %>"><%= pageNum %>
                            </a>
                        </li>
                        <% } %>
                        <li>
                            <a href="?page=<%= currentPage + 1 %>"
                               class="flex items-center justify-center px-4 h-10 leading-tight text-gray-500 bg-white border border-gray-300 rounded-e-lg hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white">Next
                                Case</a>
                        </li>
                    </ul>
                </nav>
            </div>
            <%
                // Fetch records for the current page
                stmt3 = con.prepareStatement("select med.*, pat.* from patients as pat join medical_history as med on med.medical_history_id = pat.medical_history_id where pat.email = ? limit ? offset ?");
                stmt3.setString(1, email);
                stmt3.setInt(2, recordsPerPage);
                stmt3.setInt(3, (currentPage - 1) * recordsPerPage);
                ResultSet rs3 = stmt3.executeQuery();
                while (rs3.next()) {
            %>
            <div class="p-3 record-page">
                <div class="record-details">
                    <%--                    <h2 class="record-heading">Record <%= rs3.getRow() + (currentPage - 1) * recordsPerPage %></h2>--%>
                    <div class="record-info">
                        <p class="text-3xl font-bold"><%= rs3.getString("disease_name") %>
                        </p>
                        <p class="text-lg font-bold"><%= rs3.getString("doctor_name") %>
                        </p>
                        <% if (rs3.getString("discharge_date") == null) { %>
                        <p><strong>Admission Date:</strong> <%= rs3.getString("admission_date") %> - Live</p>
                        <% } else { %>
                        <p><strong>Admission Date:</strong> <%= rs3.getString("admission_date") %>
                            - <%= rs3.getString("discharge_date") %>
                        </p>
                        <% } %>
                        <p><strong>Treatment Provided:</strong> <%= rs3.getString("treatment_provided") %>
                        </p>
                        <p class="font-bold">Details:</p>
                        <%= rs3.getString("medical_history_detail") %>
                    </div>
                </div>
            </div>
            <%
                }
                if (totalRecords == 0) {
            %>
            <div class="no-record">
                <h1 class="text-lg ml-3">You have no Medical history.</h1>
            </div>
            <%
                }
            %>


            <%--            <table class="table-auto mx-auto">--%>
            <%--                <thead class="bg-gray-200">--%>
            <%--                <%--%>
            <%--                    PreparedStatement stmt3 = con.prepareStatement("select med.*, pat.* from patients as pat join medical_history as med on med.medical_history_id = pat.medical_history_id where pat.email = ?");--%>
            <%--                    stmt3.setString(1, email);--%>
            <%--                    ResultSet rs3 = stmt3.executeQuery();--%>
            <%--                    if (rs3.next()) {--%>
            <%--                %>--%>
            <%--                <table class="table-auto mx-auto">--%>
            <%--                    <thead class="bg-gray-200">--%>
            <%--                    <tr>--%>
            <%--                        <th class="px-4 py-2 border border-solid border-black font-bold">Doctor's Name</th>--%>
            <%--                        <th class="px-4 py-2 border border-solid border-black font-bold">Disease</th>--%>
            <%--                        <th class="px-4 py-2 border border-solid border-black font-bold">Details</th>--%>
            <%--                        <th class="px-4 py-2 border border-solid border-black font-bold">Diagnosis</th>--%>
            <%--                        <th class="px-4 py-2 border border-solid border-black font-bold">Treatment</th>--%>
            <%--                    </tr>--%>
            <%--                    </thead>--%>
            <%--                    <tbody>--%>
            <%--                    <%--%>
            <%--                        do {--%>
            <%--                    %>--%>
            <%--                    <tr class="border border-solid border-black">--%>
            <%--                        <td class="border border-solid border-black px-4 py-2"><%=rs3.getString("doctor_name")%>--%>
            <%--                        </td>--%>
            <%--                        <td class="border border-solid border-black px-4 py-2"><%=rs3.getString("disease_name")%>--%>
            <%--                        </td>--%>
            <%--                        <td class="border border-solid border-black px-4 py-2"><%=rs3.getString("medical_history_detail")%>--%>
            <%--                        </td>--%>
            <%--                        <% if (rs3.getString("discharge_date") == null) { %>--%>
            <%--                        <td class="border border-solid border-black px-4 py-2"><%=rs3.getString("admission_date")%> ---%>
            <%--                            Live--%>
            <%--                        </td>--%>
            <%--                        <% } else { %>--%>
            <%--                        <td class="border border-solid border-black px-4 py-2"><%=rs3.getString("admission_date")%>--%>
            <%--                            - <%=rs3.getString("discharge_date")%>--%>
            <%--                        </td>--%>
            <%--                        <% } %>--%>
            <%--                        <td class="border border-solid border-black px-4 py-2"><%=rs3.getString("treatment_provided")%>--%>
            <%--                        </td>--%>
            <%--                    </tr>--%>
            <%--                    <% } while (rs3.next()); %>--%>
            <%--                    </tbody>--%>
            <%--                </table>--%>
            <%--                <% } else { %>--%>
            <%--                <h1 class="text-lg ml-3">You have no Medical history.</h1>--%>
            <%--                <% } %>--%>

            <%--                </thead>--%>
            <%--            </table>--%>
        </div>
    </div>
    <div class="col-span-2 row-span-1 bg-white rounded-lg shadow-md mx-3 p-3 my-4">
        <div class="border-b border-gray-300 pb-2 mb-2">
            <h1 class="text-lg font-bold">Your appointment for Today</h1>
        </div>
        <div>
            <%
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                Date date = new Date();
                String currentDate = formatter.format(date);
                PreparedStatement stmt2 = con.prepareStatement("select appointment_day, doctor_name from patients where email=? and appointment_day IS NOT NULL and appointment_day = ?");
                stmt2.setString(1, email);
                stmt2.setString(2, currentDate);
                ResultSet rs1 = stmt2.executeQuery();
                if (rs1.next()) { %>
            <h1 class="text-lg ml-3">You have an appointment with Dr. <%= rs1.getString("doctor_name") %>
                on <%= rs1.getString("appointment_day") %>
            </h1>
            <% } else { %>
            <h1 class="text-lg ml-3">You have no appointment today.</h1>
            <% } %>
        </div>
    </div>
    <div class="col-span-2 row-span-2 bg-white rounded-lg shadow-md mx-3 p-3 my-4">
        <div class="border-b border-gray-300 p-2 mb-2">
            <h1 class="text-lg font-bold">Your Medical Bill</h1>
        </div>
        <div class="grid grid-cols-2 gap-3">
            <div class="col-span-1">
                <table class="table-auto mx-auto">
                    <thead class="bg-gray-200">
                    <tr>
                        <th class="px-4 py-2 border border-solid border-black font-bold">Doctor's Name</th>
                        <th class="px-4 py-2 border border-solid border-black font-bold">Bill Amount</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        PreparedStatement stmt5 = con.prepareStatement("SELECT med.*, pat.* FROM patients AS pat JOIN medical_history AS med ON med.medical_history_id = pat.medical_history_id WHERE pat.email = ?");
                        stmt5.setString(1, email);
                        ResultSet rs5 = stmt5.executeQuery();
                        if (rs5.next()) {
                            do {
                    %>
                    <tr class="border border-solid border-black">
                        <td class="border border-solid border-black px-4 py-2"><%= rs5.getString("doctor_name") %>
                        </td>
                        <td class="border border-solid border-black px-4 py-2">Rs. <%= rs5.getString("medical_bill") %>
                        </td>
                    </tr>
                    <% } while (rs5.next()); %>
                    <% } else { %>
                    <tr>
                        <td colspan="2" class="text-lg ml-3">You have no Medical bill.</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <div class="col-span-1">
                <table class="table-auto mx-auto">
                    <thead class="bg-gray-200">
                    <tr>
                        <th class="px-4 py-2 border border-solid border-black font-bold">Doctor's Name</th>
                        <th class="px-4 py-2 border border-solid border-black font-bold">Prescription Bill</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        PreparedStatement stmt7 = con.prepareStatement("SELECT pre.prescription_bill, pat.doctor_name FROM prescription_summary AS pre JOIN patients AS pat ON pre.patient_email = pat.email WHERE pre.paid_status = 'Unpaid' AND pre.patient_email = ?");
                        stmt7.setString(1, email);
                        ResultSet rs7 = stmt7.executeQuery();
                        if (rs7.next()) {
                            do {
                    %>
                    <tr class="border border-solid border-black">
                        <td class="border border-solid border-black px-4 py-2"><%= rs7.getString("doctor_name") %>
                        </td>
                        <td class="border border-solid border-black px-4 py-2">
                            Rs. <%= rs7.getString("prescription_bill") %>
                        </td>
                    </tr>
                    <% } while (rs7.next()); %>
                    <% } else { %>
                    <tr>
                        <td colspan="2" class="text-lg ml-3">You have no Prescription bill.</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

<div data-dial-init class="fixed end-6 bottom-6 group">
    <div id="speed-dial-menu-default" class="flex flex-col items-center mb-4 space-y-2">
        <button data-popover-target="popover-left" data-popover-placement="left" type="button"
                class="flex justify-center items-center w-[52px] h-[52px] text-gray-500 hover:text-gray-900 bg-white rounded-full border border-gray-200 shadow-sm hover:bg-gray-50 dark:bg-gray-700 dark:hover:bg-gray-600 focus:ring-4 focus:ring-gray-300 focus:outline-none dark:focus:ring-gray-400 opacity-0 group-hover:opacity-100 invisible group-hover:visible"
                data-bs-toggle="modal" data-bs-target="#staticBackdrop">
            <span class="material-symbols-outlined">schedule</span>
            <span class="sr-only">Schedule</span>
        </button>
        <div data-popover id="popover-left" role="tooltip"
             class="absolute z-10 invisible inline-block w-auto px-3 py-2 text-sm font-medium text-white transition-opacity duration-300 bg-gray-700 rounded-lg shadow-sm opacity-0 tooltip">
            Schedule Appointment
            <div data-popper-arrow></div>
        </div>
    </div>
    <button type="button" data-dial-toggle="speed-dial-menu-default" aria-controls="speed-dial-menu-default"
            aria-expanded="false"
            class="flex items-center justify-center text-white bg-blue-700 rounded-full w-14 h-14 hover:bg-blue-800 dark:bg-blue-600 dark:hover:bg-blue-700 focus:ring-4 focus:ring-blue-300 focus:outline-none dark:focus:ring-blue-800">
        <svg class="w-5 h-5 transition-transform group-hover:rotate-45" aria-hidden="true"
             xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 18 18">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M9 1v16M1 9h16"></path>
        </svg>
        <span class="sr-only">Open actions menu</span>
    </button>
</div>


<%--<button class="fixed right-4 bottom-4 px-5 py-4 rounded-2xl text-lg bg-green-700 shadow-md text-white border-0 "--%>
<%--        data-bs-toggle="modal" data-bs-target="#staticBackdrop">--%>
<%--    Schedule Appointment--%>
<%--</button>--%>

<div id="staticBackdrop"
     class="modal fixed bg-white p-2 top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-96 h-96 rounded-lg shadow-md hidden border-2 border-black"
     data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel"
     aria-hidden="true">
    <div class="modal-dialog ">
        <div class="flex items-center justify-between">
            <h1 class="text-xl text-amber-600" id="staticBackdropLabel">Appointment</h1>
            <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <hr class="my-2 font-bold">

        <div class="modal-body">
            <form action="appointment" method="post" class="space-y-4">
                <c:if test="${not empty error}">
                    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
                        <strong class="font-bold">Error!</strong>
                        <span class="block sm:inline">${error}</span>
                    </div>
                </c:if>
                <div>
                    <label class="block">Appointment Date:</label>
                    <input
                            type="date"
                            name="appointment_day"
                            placeholder="Set date"
                            class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                            required
                    />

                </div>
                <input name="email" value="<%=email%>" hidden>
                <div>
                    <label class="block">Doctor's Name:</label>
                    <input
                            list="myOptions"
                            name="doctor_name"
                            placeholder="Search Doctor's name"
                            class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                            required
                    />
                    <datalist id="myOptions">
                        <%
                            PreparedStatement stmt1 = con.prepareStatement("select name from doctor;");
                            ResultSet rst = stmt1.executeQuery();
                            while (rst.next()) {
                        %>
                        <option value="<%=rst.getString(1) %>"><%= rst.getString(1) %>
                        </option>
                        <% } %>
                    </datalist>
                </div>
                <button type="submit"
                        class="w-3/4 bg-blue-500 text-white font-bold py-2 px-4 rounded focus:outline-none focus:bg-blue-700">
                    Schedule
                </button>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
<script src="../${pageContext.request.contextPath}/node_modules/flowbite/dist/flowbite.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.js"></script>

</body>
<%
    } catch (ClassNotFoundException e) {
        throw new RuntimeException(e);
    }
%>
</html>