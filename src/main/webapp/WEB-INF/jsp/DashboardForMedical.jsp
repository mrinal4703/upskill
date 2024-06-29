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
    <!-- Icons -->
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0"/>
    <title>Dashboard</title>
    <style>
        .selected {
            font-weight: bold;
        }
    </style>

</head>
<%
    String email = (String) session.getAttribute("email");
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String currentDate = formatter.format(date);
%>
<body>
<%@ include file="header.jsp" %>
<h1 class="text-3xl ml-3">
    <%
        String name = "";
        String specialization = "";
        PreparedStatement stmt = con.prepareStatement("select * from doctor where email=?");
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
        } else {
            name = "";
        }
    %>
    Welcome <%=name%>
</h1>

<div class="grid grid-cols-4 gap-2">
    <div class="row-span-3 col-span-2 bg-white rounded-lg shadow-md mx-3 p-3 my-4">
        <div class="border-b border-gray-300 pb-2 mb-2">
            <h1 class="text-lg font-bold">Your Appointments</h1>
        </div>
        <div class="overflow-y-auto max-h-64"> <!-- Add a wrapper div for scrolling -->
            <table class="table-auto mx-auto">
                <thead class="bg-gray-200">
                <%
                    PreparedStatement stmt1 = con.prepareStatement("select * from patients where doctor_name = (select name from doctor where email = ?);");
                    stmt1.setString(1, email);
                    ResultSet rs1 = stmt1.executeQuery();
                    if (rs1.isBeforeFirst()) {
                %>
                <tr>
                    <th class="px-4 py-2 border border-solid border-black font-bold">Patient's Name</th>
                    <th class="px-4 py-2 border border-solid border-black font-bold">Email</th>
                    <th class="px-4 py-2 border border-solid border-black font-bold">Appointment Day</th>
                </tr>
                </thead>
                <tbody>
                <%
                    while (rs1.next()) {
                %>
                <tr class="border border-solid border-black">
                    <td class="border border-solid border-black px-4 py-2"><%=rs1.getString("name")%>
                    </td>
                    <td class="border border-solid border-black px-4 py-2"><%=rs1.getString("email")%>
                    </td>
                    <td class="border border-solid border-black px-4 py-2"><%=rs1.getString("appointment_day")%>
                    </td>
                </tr>
                <%
                    }
                %>
                </tbody>
                <% } else { %>
                <h1 class="text-lg ml-3">No Appointments.</h1>
                <% } %>
            </table>
        </div>
    </div>
    <div class="col-span-1 flex flex-col row-span-2 bg-white rounded-lg shadow-md mx-3 p-3 my-3">
        <div class="flex justify-center items-center h-128 w-128 relative"> <!-- Added relative positioning -->
            <!-- SVG Container -->
            <svg class="w-full h-full">
                <g>
                    <%
                        float percent_doctor = 0.0F;
                        int case_solved = 0;
                        int total_cases = 0;
                        PreparedStatement statement1 = con.prepareStatement("select case_live, case_solved, total_cases from doctor where email=?");
                        statement1.setString(1, email);
                        ResultSet resultSet1 = statement1.executeQuery();
                        if (resultSet1.next()) {
                            case_solved = resultSet1.getInt("case_solved");
                            total_cases = resultSet1.getInt("total_cases");
                            if (total_cases != 0) { // Avoid division by zero
                                percent_doctor = ((float) case_solved / total_cases) * 100;
                            }
                        }
                    %>
                    <!-- Progress circle -->
                    <circle cx="50%" cy="50%" r="45" fill="none" stroke="#4F46E5" stroke-width="13"
                            <% float radius = 45;%>
                            <% float circumference = 2 * (float) Math.PI * radius; %>
                            <% float dashLength = (percent_doctor / 100) * circumference; %>
                            <% float gapLength = circumference - dashLength; %>
                            stroke-dasharray="<%= dashLength + "," + gapLength %>"
                            style="stroke-dashoffset: 0; transform-origin: center;">
                    </circle>
                    <text x="50%" y="50%" text-anchor="middle" fill="#000" font-size="24px"
                          dy=".3em"><%=percent_doctor%>%
                    </text>
                    <!-- Added text element -->
                </g>
            </svg>
        </div>
        <h1 class="mx-auto">Cases Solved by you</h1>
    </div>
    <div class="col-span-1 flex flex-col row-span-2 bg-white rounded-lg shadow-md mx-3 p-3 my-3">
        <div class="flex justify-center items-center h-128 w-128 relative"> <!-- Added relative positioning -->
            <!-- SVG Container -->
            <svg class="w-full h-full">
                <g>
                    <%
                        float percent_specialization = 0.0F;
                        int case_solved_spec = 0;
                        int total_cases_spec = 0;
                        PreparedStatement statement2 = con.prepareStatement("select case_live, case_solved, total_cases from departments where specialization=?");
                        statement2.setString(1, specialization);
                        ResultSet resultSet2 = statement1.executeQuery();
                        if (resultSet2.next()) {
                            case_solved_spec = resultSet2.getInt("case_solved");
                            total_cases_spec = resultSet2.getInt("total_cases");
                            if (total_cases_spec != 0) { // Avoid division by zero
                                percent_specialization = ((float) case_solved_spec / total_cases_spec) * 100;
                            }
                        }
                    %>
                    <circle cx="50%" cy="50%" r="45" fill="none" stroke="#4F46E5" stroke-width="13"
                            <% float radius1 = 45;%>
                            <% float circumference1 = 2 * (float) Math.PI * radius1; %>
                            <% float dashLength1 = (percent_specialization / 100) * circumference1; %>
                            <% float gapLength1 = circumference1 - dashLength1; %>
                            stroke-dasharray="<%= dashLength1 + "," + gapLength1 %>"
                            style="stroke-dashoffset: 0; transform-origin: center;">
                    </circle>
                    <text x="50%" y="50%" text-anchor="middle" fill="#000" font-size="24px"
                          dy=".3em"><%=percent_specialization%>%
                    </text>
                    <!-- Added text element -->
                </g>
            </svg>
        </div>
        <h1 class="mx-auto">Cases Solved by Institute</h1>
    </div>
    <div class="col-span-1 row-span-1 bg-white rounded-lg shadow-md mx-3 p-3 my-4">
        <div class="border-b border-gray-300 pb-2 mb-2">
            <%
                PreparedStatement stmts = con.prepareStatement("select specialization from doctor where email = ?;");
                stmts.setString(1, email);
                ResultSet rsts = stmts.executeQuery();
                if (rsts.next()) {
                    specialization = rs.getString("specialization");
            %>
            <h1 class="text-lg font-bold"><%=rs.getString("specialization")%>'s schedule in on:</h1>
            <%
                } else {
                }
                rsts.close();
                stmts.close();
            %>

        </div>
        <div>
            <%

                PreparedStatement stmt2 = con.prepareStatement("select availability from departments where specialization = (select specialization from doctor where email = ?)");
                stmt2.setString(1, email);
                ResultSet rs2 = stmt2.executeQuery();
                if (rs2.next()) { %>
            <h1 class="text-lg ml-3"><%=rs2.getString(1) %>
            </h1>
            <% } else { %>
            <h1 class="text-lg ml-3">You have no schedule.</h1>
            <% } %>
        </div>
    </div>
    <div class="col-span-1 row-span-1 bg-white rounded-lg shadow-md mx-3 p-3 my-4">
        <div class="border-b border-gray-300 pb-2 mb-2">
            <h1 class="text-lg font-bold">Your important meetings for today</h1>
        </div>
        <div>
            <%
                PreparedStatement stmt3 = con.prepareStatement("select appointment_day, doctor_name from patients where email=? and appointment_day IS NOT NULL and appointment_day = ?");
                stmt3.setString(1, email);
                stmt3.setString(2, currentDate);
                ResultSet rs3 = stmt3.executeQuery();
                if (rs3.next()) { %>
            <h1 class="text-lg ml-3">You have an appointment with Dr. <%= rs3.getString("doctor_name") %>
                on <%= rs3.getString("appointment_day") %>
            </h1>
            <% } else { %>
            <h1 class="text-lg ml-3">You have none, today.</h1>
            <% } %>
        </div>
    </div>
</div>

<div class="grid grid-cols-2 gap-2">
    <div class="col-span-1 flex flex-col">
        <h1 class="text-2xl ml-3">Your live cases</h1>
        <div class="h-full bg-white rounded-lg shadow-md mx-3 p-5 my-4">
            <% Integer total = 0;
                PreparedStatement stmt4 = con.prepareStatement("SELECT case_live FROM doctor WHERE email = ?;");
                stmt4.setString(1, email);
                ResultSet rs4 = stmt4.executeQuery();
                if (rs4.next()) {
                    int casesManaging = rs4.getInt("case_live");
                    if (!rs4.wasNull()) {
                        total = casesManaging;
                    }
                } %>
            <div class="border-b border-gray-300 pb-2 mb-2">
                <h1 class="text-lg font-bold">Your <%= total %> live cases</h1>
            </div>
            <div class="flex flex-row gap-4">
                <div id="accordion-collapse" data-accordion="collapse">
                    <%
                        PreparedStatement stmt5 = con.prepareStatement("SELECT row_number() OVER (ORDER BY p.id) AS auto_increment_id, p.name, p.email, p.age, p.address, p.phone, p.disease_name, p.treatment_provided, p.admission_date, p.symptoms, m.medical_history_detail, m.medical_history_id FROM patients p JOIN medical_history m ON p.medical_history_id = m.medical_history_id JOIN doctor d ON p.doctor_name = d.name WHERE d.email = ? AND p.discharge_date IS NULL;");
                        stmt5.setString(1, email);
                        ResultSet rs5 = stmt5.executeQuery();
                        while (rs5.next()) {
                            boolean diseaseName = rs5.getString("disease_name") == null || "null".equals(rs5.getString("disease_name"));
                            boolean symptoms = rs5.getString("symptoms") == null || "null".equals(rs5.getString("symptoms"));
                            boolean medicalHistoryDetail = rs5.getString("medical_history_detail") == null || "null".equals(rs5.getString("medical_history_detail"));
                    %>
                    <div class="m-4">
                        <h2 id="accordion-collapse-heading-<%= rs5.getRow() %>">
                            <button class="flex items-center justify-between w-full p-5 font-medium rtl:text-right text-lg text-gray-500 border border-gray-200 rounded-t-xl focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-800 dark:border-gray-700 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800 gap-3"
                                    type="button" data-accordion-target="#accordion-collapse-body-<%= rs5.getRow() %>"
                                    data-popover-target="popover-right-<%= rs5.getRow() %>"
                                    data-popover-placement="right"
                                    aria-expanded="false" aria-controls="accordion-collapse-body-<%= rs5.getRow() %>">
                                Case of <%= rs5.getString("name") %>
                            </button>
                        </h2>
                        <div data-popover id="popover-right-<%= rs5.getRow() %>" role="tooltip"
                             class="absolute z-10 invisible inline-block w-64 text-sm text-gray-500 transition-opacity duration-300 bg-white border border-gray-200 rounded-lg shadow-sm opacity-0 dark:text-gray-400 dark:border-gray-600 dark:bg-gray-800">
                            <div class="flex justify-between px-3 py-2 bg-gray-100 border-b border-gray-200 rounded-t-lg dark:border-gray-600 dark:bg-gray-700">
                                <h3 class="font-semibold text-md text-gray-900 dark:text-white"><%= rs5.getString("name") %>
                                </h3>
                                <div class="flex items-center space-x-2">
                                    <a href="mailto:<%= rs5.getString("email") %>" class="flex items-center">
                                        <span class="material-symbols-outlined">mail</span>
                                    </a>
                                    <a href="tel:<%= rs5.getString("phone") %>" class="flex items-center">
                                        <span class="material-symbols-outlined">call</span>
                                    </a>
                                </div>
                            </div>
                            <div class="px-3 py-2">
                                <p>
                                    <%
                                        if (!diseaseName && !symptoms) {
                                    %>
                                    <%= rs5.getString("disease_name") %>, due to <%= rs5.getString("symptoms") %>
                                    <%
                                    } else {
                                    %>
                                    Not diagnosed yet.
                                    <%
                                        }
                                    %>
                                </p>
                            </div>
                            <div data-popper-arrow></div>
                        </div>
                        <div data-popover id="popover-pharma-<%= rs5.getRow() %>" role="tooltip"
                             class="absolute z-10 invisible inline-block w-96 text-sm text-gray-500 transition-opacity duration-300 bg-white border border-gray-200 rounded-lg shadow-sm opacity-0 dark:text-gray-400 dark:border-gray-600 dark:bg-gray-800">
                            <div class="px-3 py-2 bg-gray-100 border-b border-gray-200 rounded-t-lg dark:border-gray-600 dark:bg-gray-700">
                                <h3 class="font-semibold text-gray-900 dark:text-white">Prescription</h3>
                            </div>
                            <div class="px-3 py-2">
                                <form action="prescriptionsend" method="post" class="space-y-4">
                                    <div>
                                        <label class="block">Pharmacist:</label>
                                        <input
                                                list="myOptionspharma"
                                                name="pharmacist_email"
                                                placeholder="Pharmacist Name"
                                                class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                                                required
                                        />
                                        <datalist id="myOptionspharma">
                                            <%
                                                String currentShift = "No Shift";
                                                java.time.LocalTime currentTime = java.time.LocalTime.now();

                                                PreparedStatement stmtpharma = con.prepareStatement("select * from shift;");
                                                ResultSet rstpharma = stmtpharma.executeQuery();

                                                while (rstpharma.next()) {
                                                    String shiftName = rstpharma.getString("shifts");
                                                    java.time.LocalTime shiftStartTime = rstpharma.getTime("shift_start").toLocalTime();
                                                    java.time.LocalTime shiftEndTime = rstpharma.getTime("shift_end").toLocalTime();

                                                    if (shiftStartTime.isBefore(shiftEndTime)) {
                                                        if (currentTime.isAfter(shiftStartTime) && currentTime.isBefore(shiftEndTime)) {
                                                            currentShift = shiftName;
                                                            break;
                                                        }
                                                    } else {
                                                        if (currentTime.isAfter(shiftStartTime) || currentTime.isBefore(shiftEndTime)) {
                                                            currentShift = shiftName;
                                                            break;
                                                        }
                                                    }
                                                }

                                                PreparedStatement stmtmed = con.prepareStatement("select name, email from staff where position = 'Pharmacist' and shifts = ?;");
                                                stmtmed.setString(1, currentShift);
                                                ResultSet rstmed = stmtmed.executeQuery();

                                                while (rstmed.next()) {
                                            %>
                                            <option value="<%= rstmed.getString("email") %>"><%= rstmed.getString("name") %></option>
                                            <% } %>
                                        </datalist>
                                    </div>
                                    <input name="email" value="<%=rs5.getString("email")%>" hidden>
                                    <input name="medical_history_id" value="<%=rs5.getString("medical_history_id")%>" hidden>
                                    <textarea
                                            name="prescription_detail"
                                            rows="4"
                                            cols="50"
                                            class="block w-full p-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                                            placeholder="Enter prescription"
                                            required
                                    ></textarea>
                                    <button type="submit"
                                            class="w-3/4 bg-blue-500 text-white font-bold py-2 px-4 rounded focus:outline-none focus:bg-blue-700">
                                        Prescribe
                                    </button>
                                </form>

                            </div>
                            <div data-popper-arrow></div>
                        </div>
                        <div id="accordion-collapse-body-<%= rs5.getRow() %>" class="hidden"
                             aria-labelledby="accordion-collapse-heading-<%= rs5.getRow() %>"
                             data-popover-target="popover-pharma-<%= rs5.getRow() %>" data-popover-trigger="click" data-popover-placement="right">
                            <div class="p-5 border rounded-b-xl border-gray-200 dark:border-gray-700 dark:bg-gray-900">
                                <%
                                    if (!medicalHistoryDetail) {
                                %>
                                <p class="mb-2 text-gray-500 dark:text-gray-400">Diagnosed
                                    with <%=rs5.getString("disease_name")%>,
                                    with symptoms <%=rs5.getString("symptoms")%>
                                </p>
                                <p class="mb-2 text-gray-500 dark:text-gray-400">Treatment
                                    provided: <%=rs5.getString("treatment_provided")%>
                                </p>
                                <div>
                                    <button id="button1" class="mx-2 selected" onclick="showDiv('div1', this)">Show
                                        History at
                                        once
                                    </button>
                                    <button id="button2" class="mx-2" onclick="showDiv('div2', this)">Show History date
                                        wise
                                    </button>
                                </div>
                                <div class="p-3 w-full border border-2 rounded-md bg-yellow-100">
                                    <div id="div1">
                                        <%=rs5.getString("medical_history_detail")%>
                                    </div>
                                    <div id="div2" style="display: none;">
                                        <%
                                            PreparedStatement stmt8 = con.prepareStatement("SELECT history_keepup_date, medical_history_content FROM datewise_medicalhistory WHERE medical_history_id = ?");
                                            stmt8.setString(1, rs5.getString("medical_history_id"));
                                            ResultSet rs8 = stmt8.executeQuery();
                                            if (rs8.next()) {
                                        %>
                                        <p><%=rs8.getString("medical_history_content")%>
                                        </p>
                                        <p class="mb-2 italic text-gray-500 dark:text-gray-400">
                                            - <%=rs8.getString("history_keepup_date")%>
                                        </p>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>
                                <br>
                                <form action="edithistory" method="post" class="space-y-4">
                                    <input name="specialization" value="<%=specialization%>" hidden required>
                                    <input name="medical_history_id" value="<%=rs5.getString("medical_history_id")%>"
                                           hidden
                                           required>
                                    <textarea
                                            id="medical_history_detail"
                                            name="medical_history_detail"
                                            rows="1"
                                            cols="50"
                                            class="block w-full p-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                                            placeholder="Enter medical history details"
                                            required
                                    ></textarea>
                                    <button class="flex flex-row p-2 border border-2 text-white bg-blue-700 rounded-md border-black"
                                            type="submit"><span class="material-symbols-outlined">edit_note</span> Add
                                        this detail
                                    </button>
                                </form>
                                <%
                                } else {
                                %>
                                <form action="newhistory" method="post" class="space-y-4">
                                    <input name="email" value="<%=rs5.getString("email")%>" hidden required>
                                    <input name="medical_history_id" value="<%=rs5.getString("medical_history_id")%>"
                                           hidden
                                           required>
                                    <div>
                                        <label class="block">Disease Name:</label>
                                        <input
                                                list="myOptions3"
                                                name="disease_name"
                                                placeholder="Disease Name"
                                                class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                                                required
                                        />
                                        <datalist id="myOptions3">
                                            <%
                                                PreparedStatement stmt6 = con.prepareStatement("SELECT disease_name FROM diseases;");
                                                ResultSet rst6 = stmt6.executeQuery();
                                                while (rst6.next()) {
                                            %>
                                            <option value="<%=rst6.getString("disease_name") %>"><%= rst6.getString("disease_name") %>
                                            </option>
                                            <% } %>
                                        </datalist>
                                    </div>
                                    <div>
                                        <label class="block">Symptoms:</label>
                                        <input
                                                type="text"
                                                name="symptoms"
                                                placeholder="Symptoms"
                                                class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                                                required
                                        />
                                    </div>
                                    <input name="specialization" value="<%=specialization%>" hidden required>
                                    <textarea name="treatment_provided" rows="1" cols="50"
                                              class="block w-full p-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                                              placeholder="Treatment to provide" required></textarea>
                                    <textarea
                                            name="medical_history_detail"
                                            rows="1"
                                            cols="50"
                                            class="block w-full p-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                                            placeholder="Enter medical history details"
                                            required
                                    ></textarea>
                                    <button type="submit"><span class="material-symbols-outlined">edit_note</span>
                                    </button>
                                </form>
                                <%
                                    }
                                %>
                                <form action="solved" method="post"
                                      class="mt-auto align-items-md-end justify-end align-content-end align-items-end flex">
                                    <input name="specialization" value="<%=specialization%>" hidden required>
                                    <input name="medical_history_id" value="<%=rs5.getString("medical_history_id")%>"
                                           hidden
                                           required>
                                    <input name="email" value="<%=email%>" hidden required>
                                    <button data-popover-target="popover-bottom" data-popover-placement="bottom"
                                            class="px-3 border border-2 rounded-md"><span
                                            class="material-symbols-outlined">check</span></button>
                                    <div data-popover id="popover-bottom" role="tooltip"
                                         class="absolute z-10 invisible inline-block w-20 text-sm text-gray-500 transition-opacity duration-300 bg-white border border-gray-200 rounded-lg shadow-sm opacity-0 dark:text-gray-400 dark:border-gray-600 dark:bg-gray-800">
                                        <div class="px-3 py-2">
                                            <p>Case Solved!</p>
                                        </div>
                                        <div data-popper-arrow></div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    <div class="col-span-1 row-span-4 flex flex-col">
        <h1 class="text-2xl ml-3">Messages</h1>
        <div class="bg-white rounded-lg shadow-md mx-3 p-5 my-4">
            <div>
                <button id="buttonpatients" class="mx-2 selected" onclick="showDivmess('divpatients', this)">To patients
                </button>
                <button id="buttonmedical" class="mx-2" onclick="showDivmess('divmedical', this)">To medical staffs
                </button>
            </div>
            <div class="p-3 w-full border border-2 rounded-md bg-yellow-100">
                <div id="divpatients">
                    <form action="messagesend" method="post" class="space-y-4">
                        <input name="doctor_email" value="<%=email%>" hidden required>
                        <div>
                            <label class="block">Patient's Name:</label>
                            <input
                                    list="myOptions4"
                                    name="patient_email"
                                    class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                                    required
                            />
                            <datalist id="myOptions4">
                                <%
                                    PreparedStatement stmt9 = con.prepareStatement("select name, email from patients where doctor_name = (select name from doctor where email = ?)");
                                    stmt9.setString(1, email);
                                    ResultSet rs9 = stmt9.executeQuery();
                                    while (rs9.next()) {
                                %>
                                <option value="<%=rs9.getString("email") %>"><%= rs9.getString("name") %>
                                </option>
                                <%
                                    }
                                %>
                            </datalist>
                        </div>
                        <div class="flex justify-between">
                            <textarea
                                    name="messages"
                                    rows="3"
                                    cols="50"
                                    class="block w-full p-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                                    placeholder="Enter message"
                                    required
                            ></textarea>
                            <button type="submit"><span class="material-symbols-outlined">send</span></button>
                        </div>
                    </form>
                </div>
                <div id="divmedical" style="display: none;">
                    <form action="messagesend" method="post" class="space-y-4">
                        <input name="doctor_email" value="<%=email%>" hidden required>
                        <div>
                            <label class="block">Medical staff's Name:</label>
                            <input
                                    list="myOptions5"
                                    name="patient_email"
                                    class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                                    required
                            />
                            <datalist id="myOptions5">
                                <%
                                    PreparedStatement stmt10 = con.prepareStatement("select name, email from doctor union select name, email from nurse union select name, email from staff");
                                    ResultSet rs10 = stmt10.executeQuery();
                                    while (rs10.next()) {
                                %>
                                <option value="<%=rs10.getString("email") %>"><%= rs10.getString("name") %>
                                </option>
                                <%
                                    }
                                %>
                            </datalist>
                        </div>
                        <div class="flex justify-between">
                            <textarea
                                    name="messages"
                                    rows="3"
                                    cols="50"
                                    class="block w-full p-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                                    placeholder="Enter message"
                                    required
                            ></textarea>
                            <button type="submit"><span class="material-symbols-outlined">send</span></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="staticBackdrop"
     class="modal fixed bg-white p-2 top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-96 h-96 rounded-lg shadow-md hidden border-2 border-black"
     data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel"
     aria-hidden="true">
    <div class="modal-dialog ">
        <div class="flex items-center justify-between">
            <h1 class="text-xl text-amber-600" id="staticBackdropLabel">Case Detail</h1>
            <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <hr class="my-2 font-bold">
        <div class="modal-body">
            <form action="caseregister" method="post" class="space-y-4">
                <label>
                    <input name="email" value="<%=email%>" hidden/>
                </label>
                <div>
                    <label class="block">Patient's Name:</label>
                    <input
                            list="myOptions1"
                            name="patient_email"
                            placeholder="Search Patient's name"
                            class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                            required
                    />
                    <datalist id="myOptions1">
                        <%
                            PreparedStatement stmt7 = con.prepareStatement("select p.email as email, p.name name from patients as p join doctor as d on p.doctor_name = d.name where p.medical_history_id is null and d.email = ?;");
                            stmt7.setString(1, email);
                            ResultSet rst7 = stmt7.executeQuery();
                            while (rst7.next()) {
                        %>
                        <option value="<%=rst7.getString("email") %>"><%= rst7.getString("name") %>
                        </option>
                        <% } %>
                    </datalist>
                </div>
                <button type="submit"
                        class="w-3/4 bg-blue-500 text-white font-bold py-2 px-4 rounded focus:outline-none focus:bg-blue-700">
                    Create
                </button>
            </form>

        </div>
    </div>
</div>

<div id="staticBackdrop-nurse"
     class="modal fixed bg-white p-2 top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-96 h-96 rounded-lg shadow-md hidden border-2 border-black"
     data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel-nurse"
     aria-hidden="true">
    <div class="modal-dialog ">
        <div class="flex items-center justify-between">
            <h1 class="text-xl text-amber-600" id="staticBackdropLabel-nurse">Case Detail</h1>
            <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>
        <hr class="my-2 font-bold">
        <div class="modal-body">
            <form action="nurseassist" method="post" class="space-y-4">
                <label>
                    <input name="email" value="<%=email%>" hidden/>
                </label>
                <label>
                    <input name="medical_history_id" value="" hidden/>
                </label>
                <div>
                    <label class="block text-lg font-medium text-gray-700 mb-2">Patient's Details:</label>
                    <input
                            list="myOptions-detail"
                            name="patient_email"
                            placeholder="Search Patient's name"
                            class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                            required
                    />
                    <datalist id="myOptions-detail">
                        <%
                            PreparedStatement stmt12 = con.prepareStatement("SELECT p.name, p.email, p.age, p.address, p.phone, p.disease_name, p.treatment_provided, p.admission_date, p.symptoms, m.medical_history_detail, m.medical_history_id FROM patients p JOIN medical_history m ON p.medical_history_id = m.medical_history_id JOIN doctor d ON p.doctor_name = d.name WHERE d.email = ? AND p.discharge_date IS NULL AND p.disease_name IS NOT NULL;");
                            stmt12.setString(1, email);
                            ResultSet rst12 = stmt12.executeQuery();
                            while (rst12.next()) {
                        %>
                        <option value="<%=rst12.getString("email") %>">Case of <%= rst12.getString("name") %>
                            for <%= rst12.getString("disease_name") %>
                        </option>
                        <label>
                            <input name="medical_history_id" value="<%=rst12.getString("medical_history_id") %>"
                                   hidden/>
                        </label>
                        <% } %>
                    </datalist>
                    <label>
                        <input name="medical_history_id" value="" hidden/>
                    </label>
                </div>
                <div>
                    <label class="block">Nurses:</label>
                    <input
                            list="myOptions_nurse"
                            name="nurse_email"
                            placeholder="Search Nurse's name"
                            class="w-full px-4 py-2 border rounded focus:outline-none focus:border-blue-500"
                            required
                    />
                    <datalist id="myOptions_nurse">
                        <%
                            PreparedStatement stmt11 = con.prepareStatement("select name, email from nurse where specialization = ?;");
                            stmt11.setString(1, specialization);
                            ResultSet rst11 = stmt11.executeQuery();
                            while (rst11.next()) {
                        %>
                        <option value="<%=rst11.getString("email") %>"><%= rst11.getString("name") %>
                        </option>
                        <% } %>
                    </datalist>
                </div>
                <button type="submit"
                        class="w-3/4 bg-blue-500 text-white font-bold py-2 px-4 rounded focus:outline-none focus:bg-blue-700">
                    Create
                </button>
            </form>

        </div>
    </div>
</div>

<%--<button class="fixed right-4 bottom-24 p-4 rounded-2xl text-lg bg-green-700 shadow-md text-white border-0"--%>
<%--        data-drawer-target="drawer-right-example" data-drawer-show="drawer-right-example" data-drawer-placement="right"--%>
<%--        aria-controls="drawer-right-example">--%>
<%--    <i class="fa-solid fa-user-doctor"></i>--%>
<%--</button>--%>

<div id="drawer-right-example"
     class="fixed top-0 right-0 z-40 h-screen p-4 overflow-y-auto transition-transform translate-x-full bg-white w-96 dark:bg-gray-800"
     tabindex="-1" aria-labelledby="drawer-right-label">
    <!-- Centered content -->
    <div class="flex justify-center">
        <div class="flex items-center justify-center rounded-full border-2 border-black w-32 h-32 overflow-hidden">
            <img src="${pageContext.request.contextPath}/static/images/chatbot1-removebg-preview.png" alt=""
                 class="object-cover w-full h-full"/>
        </div>
    </div>
    <!-- Close button -->
    <button type="button" data-drawer-hide="drawer-right-example" aria-controls="drawer-right-example"
            class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm w-8 h-8 absolute top-2.5 right-2.5 inline-flex items-center justify-center dark:hover:bg-gray-600 dark:hover:text-white">
        <svg class="w-3 h-3" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"></path>
        </svg>
        <span class="sr-only">Close menu</span>
    </button>
    <!-- Title -->
    <p class="mb-6 text-lg font-bold text-center text-gray-500 dark:text-gray-400">Suvidha Saathi</p>
    <div>
        <div id="Questions">
            <textarea id="question-input" class="w-full p-2 border rounded"
                      placeholder="Enter your question here"></textarea>
            <div class="flex gap-2">
                <button id="send-button" class="mt-2 w-full p-2 bg-blue-500 text-white rounded">Send</button>
                <button id="reload-button"
                        class="mt-2 w-16 h-12 p-2 bg-blue-500 text-md text-white rounded-full flex items-center justify-center">
                    <span class="material-symbols-outlined">refresh</span>
                </button>
            </div>
        </div>
        <div id="Answers" class="mt-4">
            <!-- Answer will be displayed here -->
        </div>
        <!-- Loading spinner -->
        <div id="status" class="text-center mt-4"></div>
    </div>
</div>

<div data-dial-init class="fixed end-6 bottom-6 group">
    <div id="speed-dial-menu-default" class="flex flex-col items-center mb-4 space-y-2">
        <button data-popover-target="popover-nurse" data-popover-placement="left" type="button"
                class="flex justify-center items-center w-[52px] h-[52px] text-gray-500 hover:text-gray-900 bg-white rounded-full border border-gray-200 shadow-sm hover:bg-gray-50 dark:bg-gray-700 dark:hover:bg-gray-600 focus:ring-4 focus:ring-gray-300 focus:outline-none dark:focus:ring-gray-400 opacity-0 group-hover:opacity-100 invisible group-hover:visible"
                data-bs-toggle="modal" data-bs-target="#staticBackdrop-nurse"
                aria-controls="drawer-right-example">
            <i class="fa-solid fa-user-nurse text-lg"></i>
            <span class="sr-only">bot</span>
        </button>
        <div data-popover id="popover-nurse" role="tooltip"
             class="absolute z-10 invisible inline-block w-auto px-3 py-2 text-sm font-medium text-white transition-opacity duration-300 bg-gray-700 rounded-lg shadow-sm opacity-0 tooltip">
            Assist a nurse
            <div data-popper-arrow></div>
        </div>
        <button data-popover-target="popover-bot" data-popover-placement="left" type="button"
                class="flex justify-center items-center w-[52px] h-[52px] text-gray-500 hover:text-gray-900 bg-white rounded-full border border-gray-200 shadow-sm hover:bg-gray-50 dark:bg-gray-700 dark:hover:bg-gray-600 focus:ring-4 focus:ring-gray-300 focus:outline-none dark:focus:ring-gray-400 opacity-0 group-hover:opacity-100 invisible group-hover:visible"
                data-drawer-target="drawer-right-example" data-drawer-show="drawer-right-example"
                data-drawer-placement="right"
                aria-controls="drawer-right-example">
            <i class="fa-solid fa-user-doctor text-lg"></i>
            <span class="sr-only">bot</span>
        </button>
        <div data-popover id="popover-bot" role="tooltip"
             class="absolute z-10 invisible inline-block w-auto px-3 py-2 text-sm font-medium text-white transition-opacity duration-300 bg-gray-700 rounded-lg shadow-sm opacity-0 tooltip">
            Suvidha Saathi
            <div data-popper-arrow></div>
        </div>
        <button data-popover-target="popover-case" data-popover-placement="left" type="button"
                class="flex justify-center items-center w-[52px] h-[52px] text-gray-500 hover:text-gray-900 bg-white rounded-full border border-gray-200 shadow-sm hover:bg-gray-50 dark:bg-gray-700 dark:hover:bg-gray-600 focus:ring-4 focus:ring-gray-300 focus:outline-none dark:focus:ring-gray-400 opacity-0 group-hover:opacity-100 invisible group-hover:visible"
                data-bs-toggle="modal" data-bs-target="#staticBackdrop">
            <span class="material-symbols-outlined">lab_profile</span>
            <span class="sr-only">bot</span>
        </button>
        <div data-popover id="popover-case" role="tooltip"
             class="absolute z-10 invisible inline-block w-auto px-3 py-2 text-sm font-medium text-white transition-opacity duration-300 bg-gray-700 rounded-lg shadow-sm opacity-0 tooltip">
            Create a new case
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
<script src="../${pageContext.request.contextPath}/node_modules/flowbite/dist/flowbite.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.3.0/flowbite.min.js"></script>

<script>
    function showDiv(divId, btn) {
        var div1 = document.getElementById('div1');
        var div2 = document.getElementById('div2');
        var button1 = document.getElementById('button1');
        var button2 = document.getElementById('button2');

        if (divId === 'div1') {
            div1.style.display = "block";
            div2.style.display = "none";
            button1.classList.add('selected');
            button2.classList.remove('selected');
        } else if (divId === 'div2') {
            div2.style.display = "block";
            div1.style.display = "none";
            button2.classList.add('selected');
            button1.classList.remove('selected');
        }
    }
</script>

<script>
    function showDivmess(divId, btn) {
        var div1 = document.getElementById('divpatients');
        var div2 = document.getElementById('divmedical');
        var button1 = document.getElementById('buttonpatients');
        var button2 = document.getElementById('buttonmedical');

        if (divId === 'divpatients') {
            div1.style.display = "block";
            div2.style.display = "none";
            button1.classList.add('selected');
            button2.classList.remove('selected');
        } else if (divId === 'divmedical') {
            div2.style.display = "block";
            div1.style.display = "none";
            button2.classList.add('selected');
            button1.classList.remove('selected');
        }
    }
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const sendButton = document.getElementById("send-button");
        const questionInput = document.getElementById("question-input");
        const answersDiv = document.getElementById("Answers");
        const statusDiv = document.getElementById("status");
        const reloadButton = document.getElementById("reload-button");

        sendButton.addEventListener("click", function () {
            const question = questionInput.value.trim();
            if (question === "") {
                alert("Please enter a question.");
                return;
            }

            const myHeaders = new Headers();
            myHeaders.append("Content-Type", "application/json");
            myHeaders.append("Accept", "application/json");
            myHeaders.append("Authorization", "Bearer sk-06832a66a3c647dd8759b2726b670205");

            const raw = JSON.stringify({
                "question": question,
                "training_data": "Provide Medical Information and related information"
            });

            const requestOptions = {
                method: "POST",
                headers: myHeaders,
                body: raw,
                redirect: "follow"
            };

            // Show loading spinner
            statusDiv.innerHTML = '<div role="status"><svg aria-hidden="true" class="inline w-8 h-8 text-gray-200 animate-spin dark:text-gray-600 fill-gray-600 dark:fill-gray-300" viewBox="0 0 100 101" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z" fill="currentColor"/><path d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z" fill="currentFill"/></svg><span class="sr-only">Loading...</span></div>';


            fetch("https://api.worqhat.com/api/ai/content/v2", requestOptions)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(result => {
                    if (result && result.content) {
                        answersDiv.innerText = result.content;
                    } else {
                        answersDiv.innerText = "No answer found for the given question.";
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    answersDiv.innerText = "An error occurred while fetching the answer: " + error.message;
                })
                .finally(() => {
                    // Hide loading spinner
                    statusDiv.innerHTML = '';
                });
        });

        reloadButton.addEventListener("click", function () {
            questionInput.value = "";
            answersDiv.innerText = "";
        });
    });
</script>

<script src="https://kit.fontawesome.com/992e336b17.js" crossorigin="anonymous"></script>
</body>
<%
    } catch (ClassNotFoundException | SQLException e) {
        throw new RuntimeException(e);
    }
%>
</html>