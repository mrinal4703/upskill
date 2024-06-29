<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Include common head content -->
    <jsp:include page="${pageContext.request.contextPath}/WEB-INF/jsp/commonHead.jsp"/>
    <title>Dashboard</title>
</head>
<%
    String email = (String) session.getAttribute("email");
    String position = "";
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
        PreparedStatement st = con.prepareStatement("select position from staff where email = ?");
        st.setString(1, email);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            position = rs.getString("position");
        }
%>
<body>
<%@ include file="header.jsp" %>
<h1 class="text-3xl ml-3">
    <%
        String name = "";
        PreparedStatement stmtnm = con.prepareStatement("select * from staff where email=?");
        stmtnm.setString(1, email);
        ResultSet rsnm = stmtnm.executeQuery();
        if (rsnm.next()) {
            name = rsnm.getString("name");
        } else {
            name = "";
        }
    %>
    Welcome <%=name%>
</h1>
<%
    if (position.equals("Pharmacist")) {
%>
<div class="grid grid-flow-row grid-cols-5 gap-2">
    <div class="col-span-3 flex flex-col">
        <div class="h-full bg-white rounded-lg shadow-md mx-3 p-5 my-4">
            <div class="border-b border-gray-300 p2-4 mb-3">
                <h1 class="text-lg font-bold">Prescriptions</h1>
            </div>
            <div class="grid grid-cols-2 gap-4">
                <%
                    PreparedStatement stmt = con.prepareStatement("select pre.pharmacist_email, pre.patient_email, pre.prescription_day, pre.medical_history_id, pre.prescription_detail, pre.paid_status, pre.prescription_bill, pat.name, pat.doctor_name from prescription_summary as pre join patients as pat on pre.patient_email = pat.email where pre.pharmacist_email = ? and pre.paid_status = 'Unpaid';");
                    stmt.setString(1, email);
                    ResultSet rst = stmt.executeQuery();
                    while (rst.next()) {
                %>
                <div class="col-span-1 flex-col">
                    <div class="h-ful w-96 bg-white rounded-lg border border-2 mx-3 p-5 my-4">
                        <p class="text-lg font-bold">For <%= rst.getString("name") %>
                        </p>
                        <p class="text-md italic text-end">-<%= rst.getString("doctor_name") %>
                        </p>
                        <p class="text-md"><%= rst.getString("prescription_detail") %>
                        </p>
                        <%
                            float bill = rst.getFloat("prescription_bill");
                            if (rst.wasNull()) {
                        %>
                        <form action="prescriptionbill" method="post" class="space-y-4">
                            <input name="medical_history_id" value="<%= rst.getString("medical_history_id") %>" hidden>
                            <input name="prescription_day" value="<%= rst.getDate("prescription_day") %>" hidden>
                            <button type="submit"
                                    class="bg-blue-500 text-white font-bold m-4 mx-auto py-2 px-4 rounded focus:outline-none focus:bg-blue-700">
                                <i class="fa-solid fa-money-check-dollar"></i> Generate bill
                            </button>
                        </form>
                        <%
                        } else {
                        %>
                        <p class="text-md text-end">Rs. <%= rst.getString("prescription_bill") %>
                        </p>
                        <%
                            }
                        %>
                    </div>
                </div>
                <%
                    }
                %>
            </div>

        </div>
    </div>
    <div class="col-span-2 row-span-2 flex flex-col">
        <div class="h-full bg-white rounded-lg shadow-md mx-3 p-5 my-4">
            <div class="border-b border-gray-300 p2-4 mb-3">
                <h1 class="text-lg font-bold">Unpaid bills</h1>
            </div>
            <div class="overflow-y-auto max-h-96"> <!-- Scrollable container with a fixed max height -->
                <%
                    PreparedStatement stmt1 = con.prepareStatement("SELECT pre.pharmacist_email, pre.patient_email, pre.prescription_day, pre.medical_history_id, pre.prescription_detail, pre.paid_status, pre.prescription_bill, pat.phone, pat.name, pat.doctor_name FROM prescription_summary AS pre JOIN patients AS pat ON pre.patient_email = pat.email WHERE pre.pharmacist_email = ? AND pre.paid_status = 'Unpaid';");
                    stmt1.setString(1, email); // Assuming 'email' is defined and holds the pharmacist's email address
                    ResultSet rst1 = stmt1.executeQuery(); // Use stmt1 here instead of stmt

                    if (rst1.next()) {
                %>
                <table class="table-auto mx-auto w-full">
                    <thead class="bg-gray-200">
                    <tr>
                        <th class="px-4 py-2 border border-solid border-black font-bold">Patient's Name</th>
                        <th class="px-4 py-2 border border-solid border-black font-bold">Bill</th>
                        <th class="px-4 py-2 border border-solid border-black font-bold">Prescribed Date</th>
                        <th class="px-4 py-2 border border-solid border-black font-bold">Phone number</th>
                        <th class="px-4 py-2 border border-solid border-black font-bold">Email ID</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% do { %>
                    <tr class="border border-solid border-black">
                        <td class="border border-solid border-black px-4 py-2"><%= rst1.getString("name") %>
                        </td>
                        <td class="border border-solid border-black px-4 py-2">
                            Rs. <%= rst1.getString("prescription_bill") %>
                        </td>
                        <td class="border border-solid border-black px-4 py-2"><%= rst1.getString("prescription_day") %>
                        </td>
                        <td class="border border-solid border-black px-4 py-2 hover:text-blue-600">
                            <a href="tel:<%= rst1.getString("phone") %>" class="flex items-center">
                                <span class="ml-1"><%= rst1.getString("phone") %></span>
                            </a>
                        </td>
                        <td class="border border-solid border-black px-4 py-2 hover:text-gray-400">
                            <a href="mailto:<%= rst1.getString("patient_email") %>"><%= rst1.getString("patient_email") %>
                            </a>
                        </td>
                    </tr>
                    <% } while (rst1.next()); %>
                    </tbody>
                </table>
                <% } else { %>
                <p>All bills paid.</p>
                <% } %>

            </div>
        </div>
    </div>
</div>
<%
} else {
%>

<%
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
<script src="../${pageContext.request.contextPath}/node_modules/flowbite/dist/flowbite.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.js"></script>
</body>
<%
    } catch (ClassNotFoundException | SQLException e) {
        throw new RuntimeException(e);
    }
%>
</html>