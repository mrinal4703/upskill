/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.suvidhaa;

import com.mysql.cj.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
//import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.math.BigInteger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.MimeMessageHelper;
import java.net.Authenticator;
import java.net.PasswordAuthentication;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Properties;
import java.util.Random;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import static com.mysql.cj.Session.*;

/**
 * @author mrina
 */
@Controller
public class UniversalController {

    @Autowired
    private JavaMailSender javaMailSender;

    @RequestMapping("/welcomepage")
    public String welcomefunction() {
        System.out.println("This is welcome page");
        return "welcomepage";
    }

    @RequestMapping("/header")
    public String header() {
        return "header";
    }

    @RequestMapping("/login")
    public String loginfunction() {
        System.out.println("This is login page");
        return "login";
    }

    @RequestMapping("/signup")
    public String signupfunction() {
        System.out.println("This is signup page");
        return "signup";
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        session.removeAttribute("email");
        session.setAttribute("loggedIn", false);
        return "redirect:/welcomepage";
    }
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            BigInteger hashedPassword = new BigInteger(1, hash);
            return hashedPassword.toString(16);
        } catch (NoSuchAlgorithmException ex) {
            ex.printStackTrace();
            return null;
        }
    }
    @RequestMapping(value = "/signup", method = RequestMethod.POST)
    public String signupFunction(HttpServletRequest request, HttpServletResponse response, @RequestParam("name") String name, @RequestParam("password") String password, @RequestParam("email") String email, @RequestParam("age") Integer age, @RequestParam("address") String address, @RequestParam("phone") BigInteger phone, Model model) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
            String hashedPassword = hashPassword(password);
            PreparedStatement checkStmt = con.prepareStatement("select count(*) from patients where email = ?");
            checkStmt.setString(1, email);
            ResultSet resultSet = checkStmt.executeQuery();
            resultSet.next();
            int count = resultSet.getInt(1);
            if (count > 0) {
                model.addAttribute("error", "Email already exists");
                return "signup";
            }
            PreparedStatement stmt = con.prepareStatement("insert into patients (name, password, email, age, address, phone, type) values (?, ?, ?, ?, ?, ?, ?)");
            stmt.setString(1, name);
            stmt.setString(2, hashedPassword);
            stmt.setString(3, email);
            stmt.setInt(4, age);
            stmt.setString(5, address);
            stmt.setObject(6, phone);
            stmt.setString(7, "patient");
            stmt.executeUpdate();
            sendSignupConfirmationEmail(email, name);

        } catch (Exception e) {
            e.printStackTrace();
            return "signup";
        }
        return "redirect:/login";
    }
    private void sendSignupConfirmationEmail(String recipientEmail, String name) {
        try {

            MimeMessage message = javaMailSender.createMimeMessage();

            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(recipientEmail);
            helper.setSubject("Welcome to Suvidha");
            String htmlContent = "<!DOCTYPE html>\n" +
                    "<html lang=\"en\">\n" +
                    "<head>\n" +
                    "    <meta charset=\"UTF-8\">\n" +
                    "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
                    "    <style>\n" +
                    "        body {\n" +
                    "            font-family: Arial, sans-serif;\n" +
                    "            background-color: #f4f4f4;\n" +
                    "            margin: 0;\n" +
                    "            padding: 0;\n" +
                    "        }\n" +
                    "        .container {\n" +
                    "            max-width: 600px;\n" +
                    "            margin: 0 auto;\n" +
                    "            background-color: #ffffff;\n" +
                    "            padding: 20px;\n" +
                    "            border-radius: 10px;\n" +
                    "            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);\n" +
                    "        }\n" +
                    "        .header {\n" +
                    "            text-align: center;\n" +
                    "            padding: 10px 0;\n" +
                    "            border-bottom: 1px solid #e0e0e0;\n" +
                    "        }\n" +
                    "        .header img {\n" +
                    "            max-width: 100%;\n" +
                    "            height: auto;\n" +
                    "            width: auto;\n" +
                    "        }\n" +
                    "        .content {\n" +
                    "            padding: 20px;\n" +
                    "            text-align: center;\n" +
                    "        }\n" +
                    "        .content h1 {\n" +
                    "            color: #333333;\n" +
                    "        }\n" +
                    "        .headtitle {\n" +
                    "            color: #d97706;\n" +
                    "            display: flex;\n" +
                    "            align-items: center;\n" +
                    "            justify-content: center;\n" +
                    "        }\n" +
                    "        .headlogo {\n" +
                    "            height: 207px;\n" +
                    "            width: auto;\n" +
                    "        }\n" +
                    "        .headdiv {\n" +
                    "            display: flex;\n" +
                    "            align-items: center;\n" +
                    "            justify-content: center;\n" +
                    "        }\n" +
                    "        .icon {\n" +
                    "            color: #dc2626;\n" +
                    "            margin-right: 8px;\n" +
                    "        }\n" +
                    "        .content p {\n" +
                    "            color: #666666;\n" +
                    "            line-height: 1.6;\n" +
                    "        }\n" +
                    "        .footer {\n" +
                    "            text-align: center;\n" +
                    "            padding: 20px;\n" +
                    "            color: #aaaaaa;\n" +
                    "            font-size: 12px;\n" +
                    "        }\n" +
                    "    </style>\n" +
                    "</head>\n" +
                    "<body>\n" +
                    "    <div class=\"container\">\n" +
                    "        <div class=\"header\">\n" +
                    "           <img src=\"https://github.com/mrinal4703/Suvidha_images/blob/main/suvidha.jpg?raw=true\" alt=\"Suvidha Logo\" class=\"headlogo\">\n" +
                    "        </div>\n" +
                    "        <div class=\"content\">\n" +
                    "            <h1>Welcome to Suvidha, " + name + "!</h1>\n" +
                    "            <p>Welcome to Suvidha,  your trusted companion on your healthcare journey. We're here to provide you with personalized care and support every step of the way.</p>\n" +
                    "            <p>Thank you for choosing Suvidha. We look forward to assisting you with your healthcare needs.</p>\n" +
                    "        </div>\n" +
                    "        <div class=\"footer\">\n" +
                    "            &copy; 2024 Suvidha Healthcare. All rights reserved.\n" +
                    "        </div>\n" +
                    "    </div>\n" +
                    "</body>\n" +
                    "</html>\n";

            helper.setText(htmlContent, true);
            javaMailSender.send(message);
            System.out.println("Signup confirmation email sent successfully to: " + recipientEmail);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String loginFunction(HttpServletRequest request, HttpServletResponse response,
                                @RequestParam("password") String password, @RequestParam("email") String email,
                                Model model) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root")) {
                String hashedPassword = hashPassword(password);
                System.out.println(hashedPassword);
                PreparedStatement stmt = con.prepareStatement("SELECT 'doctor' as user_type, email FROM doctor WHERE email = ? AND password = ? UNION SELECT 'nurse' as user_type, email FROM nurse WHERE email = ? AND password = ? UNION SELECT 'staff' as user_type, email FROM staff WHERE email = ? AND password = ? UNION SELECT 'patient' as user_type, email FROM patients WHERE email = ? AND password = ?");
                stmt.setString(1, email);
                stmt.setString(2, hashedPassword);
                stmt.setString(3, email);
                stmt.setString(4, hashedPassword);
                stmt.setString(5, email);
                stmt.setString(6, hashedPassword);
                stmt.setString(7, email);
                stmt.setString(8, hashedPassword);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    // Successful login
                    HttpSession session = request.getSession();
                    session.setAttribute("email", email);
                    session.setMaxInactiveInterval(30 * 24 * 30 * 60); // 30 days
                    session.setAttribute("loggedIn", true);
                    String userType = rs.getString("user_type");
                    session.setAttribute("userType", userType);
                    if ("doctor".equals(userType)) {
                        return "redirect:/DashboardForMedical";
                    } else if ("patient".equals(userType)) {
                        return "redirect:/DashboardForPatients";
                    } else if ("nurse".equals(userType)) {
                        return "redirect:/DashboardForNurse";
                    } else if ("staff".equals(userType)) {
                        return "redirect:/DashboardForStaff";
                    } else {
                        model.addAttribute("error", "Invalid user type.");
                        return "login"; // Return to login page with error message
                    }
                } else {
                    model.addAttribute("error", "Invalid email or password.");
                    return "login"; // Return to login page with error message
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            String errorMessage = "An error occurred: " + e.getMessage();
            model.addAttribute("error", errorMessage);
            return "login";
        }
    }


    @RequestMapping("/feedback")
    public String feedback() {
        return "feedback";
    }

    @RequestMapping("/DashboardForPatients")
    public String DashboardForPatients() {
        return "DashboardForPatients";
    }

    @RequestMapping("/DashboardForMedical")
    public String DashboardForMedical() {
        return "DashboardForMedical";
    }

    @RequestMapping(value = "/appointment", method = RequestMethod.POST)
    public String appointment(@RequestParam("appointment_day") Date appointment_day,
                              @RequestParam("email") String email,
                              @RequestParam("doctor_name") String doctor_name,
                              Model model) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");

            PreparedStatement stmt = con.prepareStatement("select count(*) from patients where email = ? and appointment_day is not null;");
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            int count = 0;
            if(rs.next()){
                count= rs.getInt(1);
            }

            PreparedStatement check1 = con.prepareStatement("select count(*) from patients where email = ? and doctor_name = ? and appointment_day = ?;");
            check1.setString(1, email);
            check1.setString(2, doctor_name);
            check1.setDate(3, appointment_day);
            ResultSet ch1 = check1.executeQuery();
            int ch1count = 0;
            if(ch1.next()){
                ch1count= ch1.getInt(1);
            }

            if (ch1count > 0) {
                model.addAttribute("error", "Appointment already exists.");
                return "redirect:/DashboardForPatients";
            }

            PreparedStatement check2 = con.prepareStatement("select count(*) from patients where email = ? and appointment_day = ?;");
            check2.setString(1, email);
            check2.setDate(2, appointment_day);
            ResultSet ch2 = check2.executeQuery();
            int ch2count = 0;
            if(ch2.next()){
                ch2count= ch2.getInt(1);
            }

            if (ch2count > 0) {
                model.addAttribute("error", "Appointment already exists on same day.");
                return "redirect:/DashboardForPatients";
            }

            if (count != 0) {
                // No existing appointment, insert a new record
                PreparedStatement stmt1 = con.prepareStatement("SELECT name, age, address, phone, password, type FROM patients WHERE email = ?");
                stmt1.setString(1, email);
                ResultSet rs1 = stmt1.executeQuery();

                if (rs1.next()) {
                    // Insert new record with appointment_day and doctor_name
                    PreparedStatement stmt2 = con.prepareStatement(
                            "INSERT INTO patients (name, email, age, address, phone, appointment_day, doctor_name, password, type) " +
                                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
                    );
                    stmt2.setString(1, rs1.getString("name"));
                    stmt2.setString(2, email);
                    stmt2.setInt(3, rs1.getInt("age"));
                    stmt2.setString(4, rs1.getString("address"));
                    stmt2.setLong(5, rs1.getLong("phone"));
                    stmt2.setDate(6, appointment_day);
                    stmt2.setString(7, doctor_name);
                    stmt2.setString(8, rs1.getString("password"));
                    stmt2.setString(9, rs1.getString("type"));
                    stmt2.executeUpdate();
                    System.out.println("Inserted new record with appointment_day and doctor_name.");
                    appointmentSetup(doctor_name,appointment_day,email);
                }
            } else {
                PreparedStatement stmt2 = con.prepareStatement("update patients set appointment_day = ?, doctor_name = ? where email = ?");
                stmt2.setDate(1, appointment_day);
                stmt2.setString(2, doctor_name);
                stmt2.setString(3, email);
                stmt2.executeUpdate();
                System.out.println("Updated existing record with appointment_day and doctor_name.");
                System.out.println("Appointment already exists for this email, appointment_day, and doctor_name.");
                appointmentSetup(doctor_name,appointment_day,email);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/DashboardForPatients";
    }
    private void appointmentSetup(String Doctor_name, Date date, String recipientEmail) {
        try {

            MimeMessage message = javaMailSender.createMimeMessage();

            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(recipientEmail);
            helper.setSubject("Appointment Scheduled");
            String htmlContent = "<!DOCTYPE html>\n" +
                    "<html lang=\"en\">\n" +
                    "<head>\n" +
                    "    <meta charset=\"UTF-8\">\n" +
                    "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
                    "    <style>\n" +
                    "        body {\n" +
                    "            font-family: Arial, sans-serif;\n" +
                    "            background-color: #f4f4f4;\n" +
                    "            margin: 0;\n" +
                    "            padding: 0;\n" +
                    "        }\n" +
                    "        .container {\n" +
                    "            max-width: 600px;\n" +
                    "            margin: 0 auto;\n" +
                    "            background-color: #ffffff;\n" +
                    "            padding: 20px;\n" +
                    "            border-radius: 10px;\n" +
                    "            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);\n" +
                    "        }\n" +
                    "        .header {\n" +
                    "            text-align: center;\n" +
                    "            padding: 10px 0;\n" +
                    "            border-bottom: 1px solid #e0e0e0;\n" +
                    "        }\n" +
                    "        .header img {\n" +
                    "            max-width: 100%;\n" +
                    "            height: auto;\n" +
                    "            width: auto;\n" +
                    "        }\n" +
                    "        .content {\n" +
                    "            padding: 20px;\n" +
                    "            text-align: center;\n" +
                    "        }\n" +
                    "        .content h1 {\n" +
                    "            color: #333333;\n" +
                    "        }\n" +
                    "        .headtitle {\n" +
                    "            color: #d97706;\n" +
                    "            display: flex;\n" +
                    "            align-items: center;\n" +
                    "            justify-content: center;\n" +
                    "        }\n" +
                    "        .headlogo {\n" +
                    "            height: 207px;\n" +
                    "            width: auto;\n" +
                    "        }\n" +
                    "        .headdiv {\n" +
                    "            display: flex;\n" +
                    "            align-items: center;\n" +
                    "            justify-content: center;\n" +
                    "        }\n" +
                    "        .icon {\n" +
                    "            color: #dc2626;\n" +
                    "            margin-right: 8px;\n" +
                    "        }\n" +
                    "        .content p {\n" +
                    "            color: #666666;\n" +
                    "            line-height: 1.6;\n" +
                    "        }\n" +
                    "        .footer {\n" +
                    "            text-align: center;\n" +
                    "            padding: 20px;\n" +
                    "            color: #aaaaaa;\n" +
                    "            font-size: 12px;\n" +
                    "        }\n" +
                    "    </style>\n" +
                    "</head>\n" +
                    "<body>\n" +
                    "    <div class=\"container\">\n" +
                    "        <div class=\"header\">\n" +
                    "           <img src=\"https://github.com/mrinal4703/Suvidha_images/blob/main/suvidha.jpg?raw=true\" alt=\"Suvidha Logo\" class=\"headlogo\">\n" +
                    "        </div>\n" +
                    "        <div class=\"content\">\n" +
                    "            <h1>Appointment with , " + Doctor_name + "!</h1>\n" +
                    "            <p>Your appointment with " + Doctor_name + " on " + date + ". Kindly be on time.</p>\n" +
                    "            <p>Thank you for choosing Suvidha. We look forward to assisting you with your healthcare needs.</p>\n" +
                    "        </div>\n" +
                    "        <div class=\"footer\">\n" +
                    "            &copy; 2024 Suvidha Healthcare. All rights reserved.\n" +
                    "        </div>\n" +
                    "    </div>\n" +
                    "</body>\n" +
                    "</html>\n";

            helper.setText(htmlContent, true);
            javaMailSender.send(message);
            System.out.println("Appointment confirmation sent successfully to: " + recipientEmail);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @RequestMapping(value = "/caseregister", method = RequestMethod.POST)
    public String caseregister(@RequestParam("email") String email, @RequestParam("patient_email") String patient_email, Model model) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
            System.out.println(email + '\n' + patient_email);
            int atIndex = email.indexOf('@');
            String username = email.substring(0, atIndex);
            java.util.Date today = new java.util.Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String formattedDate = sdf.format(today);
            Date admission_date = new Date(today.getTime());
            int patientAtIndex = patient_email.indexOf('@');
            String patientUsername = patient_email.substring(0, patientAtIndex);
            Random rand = new Random();
            int randomNumber = rand.nextInt(1000) + 1;
            String medical_history_id = username + formattedDate + patientUsername + randomNumber;
            PreparedStatement stmt1 = con.prepareStatement("insert into medical_history (medical_history_id) values (?)");
            stmt1.setString(1, medical_history_id);
            stmt1.executeUpdate();
            PreparedStatement stmt = con.prepareStatement("update patients set admission_date = ?, medical_history_id = ? where email = ? and doctor_name = (select name from doctor where email = ?);");
            stmt.setDate(1, admission_date);
            stmt.setString(2, medical_history_id);
            stmt.setString(3, patient_email);
            stmt.setString(4, email);
            stmt.executeUpdate();
            try {
                // Update case_live and total_cases in the doctor table
                PreparedStatement updateStmt = con.prepareStatement("UPDATE doctor SET case_live = CASE WHEN case_live IS NULL THEN 1 ELSE case_live + 1 END, total_cases = CASE WHEN total_cases IS NULL THEN 1 ELSE total_cases + 1 END WHERE email = ?");
                updateStmt.setString(1, email);
                int rowsAffectedDoctor = updateStmt.executeUpdate();
                System.out.println("Rows affected in doctor table: " + rowsAffectedDoctor);

                // Update case_live and total_cases in the departments table
                PreparedStatement updateStmt2 = con.prepareStatement("UPDATE departments SET case_live = CASE WHEN case_live IS NULL THEN 1 ELSE case_live + 1 END, total_cases = CASE WHEN total_cases IS NULL THEN 1 ELSE total_cases + 1 END WHERE specialization = (SELECT specialization FROM doctor WHERE email = ?)");
                updateStmt2.setString(1, email);
                int rowsAffectedDepartments = updateStmt2.executeUpdate();
                System.out.println("Rows affected in departments table: " + rowsAffectedDepartments);
            } catch (SQLException e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/DashboardForMedical";
    }

    @RequestMapping(value = "/newhistory", method = RequestMethod.POST)
    public String newhistory(@RequestParam("email") String email, @RequestParam("medical_history_id") String medical_history_id, @RequestParam("medical_history_detail") String medical_history_detail, @RequestParam("symptoms") String symptoms, @RequestParam("disease_name") String disease_name, @RequestParam("treatment_provided") String treatment_provided, @RequestParam("specialization") String specialization, Model model) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
            Float bill = 0.0F;
            PreparedStatement stmt = con.prepareStatement("select consultancy_fees from departments where specialization = ?");
            stmt.setString(1, specialization);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                bill = rs.getFloat("consultancy_fees");
            }
            java.util.Date today = new java.util.Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String formattedDate = sdf.format(today);
            Date history_keepup_date = new Date(today.getTime());
            PreparedStatement stmt1 = con.prepareStatement("update medical_history set medical_history_detail = ?, medical_bill = ? where medical_history_id = ?");
            stmt1.setString(1, medical_history_detail);
            stmt1.setFloat(2, bill);
            stmt1.setString(3, medical_history_id);
            stmt1.executeUpdate();
            PreparedStatement stmt2 = con.prepareStatement("update patients set disease_name = ?, treatment_provided = ?, symptoms = ? where medical_history_id = ? and email = ?");
            stmt2.setString(1,disease_name);
            stmt2.setString(2, treatment_provided);
            stmt2.setString(3, symptoms);
            stmt2.setString(4, medical_history_id);
            stmt2.setString(5, email);
            stmt2.executeUpdate();
            PreparedStatement stmt3 = con.prepareStatement("insert into datewise_medicalhistory (medical_history_id, history_keepup_date, medical_history_content) values (?,?,?)");
            stmt3.setString(1, medical_history_id);
            stmt3.setDate(2, history_keepup_date);
            stmt3.setString(3, medical_history_detail);
            stmt3.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/DashboardForMedical";
    }
    @RequestMapping(value = "/solved", method = RequestMethod.POST)
    public String solvedCase (@RequestParam("medical_history_id") String medical_history_id, @RequestParam("specialization") String specialization, @RequestParam("email") String email, Model model){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
            java.util.Date today = new java.util.Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String formattedDate = sdf.format(today);
            Date discharge_date = new Date(today.getTime());
            PreparedStatement stmt = con.prepareStatement("update departments set case_solved = case when case_solved is null then 1 else case_solved + 1 end, case_live = case_live - 1 where specialization = ?");
            stmt.setString(1, specialization);
            stmt.executeUpdate();
            PreparedStatement stmt1 = con.prepareStatement("update doctor set case_solved = case when case_solved is null then 1 else case_solved + 1 end, case_live = case_live - 1 where email = ?");
            stmt1.setString(1, email);
            stmt1.executeUpdate();
            PreparedStatement stmt2 = con.prepareStatement("update patients set discharge_date = ? where medical_history_id = ?");
            stmt2.setDate(1,discharge_date);
            stmt2.setString(2, medical_history_id);
            stmt2.executeUpdate();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return "redirect:/DashboardForMedical";
    }
    @RequestMapping(value = "/edithistory", method = RequestMethod.POST)
    public String edithistory(@RequestParam("specialization") String specialization,
                              @RequestParam("medical_history_id") String medical_history_id,
                              @RequestParam("medical_history_detail") String medical_history_detail,
                              Model model) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
            Float bill = 0.0F;
            String content = "";
            java.util.Date today = new java.util.Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String formattedDate = sdf.format(today);
            Date history_keepup_date = new Date(today.getTime());
            PreparedStatement stmt = con.prepareStatement("select consultancy_fees from departments where specialization = ?");
            stmt.setString(1, specialization);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                bill = rs.getFloat("consultancy_fees");
            }
            PreparedStatement stmt1 = con.prepareStatement("select medical_history_detail, medical_bill from medical_history where medical_history_id = ?");
            stmt1.setString(1, medical_history_id);
            ResultSet rs1 = stmt1.executeQuery();
            if (rs1.next()) {
                bill += rs1.getFloat("medical_bill");
                content = rs1.getString("medical_history_detail");
                content += " " + medical_history_detail;
            }
            PreparedStatement stmt2 = con.prepareStatement("update medical_history set medical_history_detail = ?, medical_bill = ? where medical_history_id = ?");
            stmt2.setString(1, content);
            stmt2.setFloat(2, bill);
            stmt2.setString(3, medical_history_id);
            stmt2.executeUpdate();
            PreparedStatement stmt3 = con.prepareStatement("insert into datewise_medicalhistory (medical_history_id, history_keepup_date, medical_history_content) values (?,?,?)");
            stmt3.setString(1, medical_history_id);
            stmt3.setDate(2, history_keepup_date);
            stmt3.setString(3, medical_history_detail);
            stmt3.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/DashboardForMedical";
    }
    @RequestMapping(value = "/messagesend", method = RequestMethod.POST)
    public String messageSend(@RequestParam("messages") String messages, @RequestParam("patient_email") String patient_email, @RequestParam("doctor_email") String doctor_email, Model model) {
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
            java.util.Date today = new java.util.Date();
            Date todayy = new Date(today.getTime());
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String time_send = sdf.format(todayy);
            PreparedStatement stmt = con.prepareStatement("insert into messages (messages, patient_email, doctor_email, time_send) values (?,?,?,?)");
            stmt.setString(1, messages);
            stmt.setString(2, patient_email);
            stmt.setString(3, doctor_email);
            stmt.setString(4,time_send);
            stmt.executeUpdate();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return "redirect:/DashboardForMedical";
    }

    @RequestMapping(value = "nurseassist", method = RequestMethod.POST)
    public String nurseassist(@RequestParam("patient_email") String patient_email, @RequestParam("email") String email, @RequestParam("nurse_email") String nurse_email, @RequestParam("medical_history_id") String medical_history_id, Model model) {
        try{
            medical_history_id = medical_history_id.replace(",", "");
            System.out.println("medical history is: " + medical_history_id);
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
            PreparedStatement stmt = con.prepareStatement("select count(*) as count from medical_assignments where doctor_email = ? and patient_email = ? and medical_history_id = ?");
            stmt.setString(1, email);
            stmt.setString(2, patient_email);
            stmt.setString(3, medical_history_id);
            ResultSet rs = stmt.executeQuery();
            int count = 0;
            if (rs.next()) {
                count = rs.getInt("count");
            }
            if(count >0){
                String emails = "";
                PreparedStatement stmt1 = con.prepareStatement("select nurses_emails from medical_assignments where medical_history_id = ?");
                stmt1.setString(1, medical_history_id);
                ResultSet rs1 = stmt1.executeQuery();
                if (rs1.next()) {
                    emails=rs1.getString("nurses_emails");
                }
//                int nurses_emails_length = nurse_email.length();
//                int emails_length = emails.length();
//                for (int i = 0; i <= emails_length - nurses_emails_length; i++) {
//                    int j;
//                    for (j = 0; j < nurses_emails_length; j++) {
//                        if (emails.charAt(i + j) != nurse_email.charAt(j)) {
//                            break;
//                        }
//                    }
//                    if (j == nurses_emails_length) {
//                        model.addAttribute("error", "Already appointed");
//                        return "redirect:/DashboardForMedical";
//                    }
//                }
                if (emails.contains(nurse_email)) {
                    model.addAttribute("error", "Already appointed");
                    return "redirect:/DashboardForMedical";
                }
                emails = emails + ", " + nurse_email;
                PreparedStatement stmt2 = con.prepareStatement("update medical_assignments set nurses_emails = ? where medical_history_id = ?");
                stmt2.setString(1, emails);
                stmt2.setString(2, medical_history_id);
                stmt2.executeUpdate();
            }
            else{
                PreparedStatement stmt2 = con.prepareStatement("insert into medical_assignments (patient_email, doctor_email, nurses_emails, medical_history_id) values (?,?,?,?)");
                stmt2.setString(1, patient_email);
                stmt2.setString(2, email);
                stmt2.setString(3, nurse_email);
                stmt2.setString(4, medical_history_id);
                stmt2.executeUpdate();
            }
            sendAssistConfirmationEmail(email,medical_history_id,nurse_email);
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return "redirect:/DashboardForMedical";
    }

    private void sendAssistConfirmationEmail(String doctor_mail, String medical_history_id, String nurse_email) {
        try {

            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);
            helper.setTo(nurse_email);
            helper.setSubject("New assignment to a case");

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
            PreparedStatement stmt = con.prepareStatement("SELECT p.name, p.email, p.age, p.address, p.phone, p.disease_name, p.doctor_name, p.treatment_provided, p.admission_date, p.symptoms, m.medical_history_detail, m.medical_history_id FROM patients p JOIN medical_history m ON p.medical_history_id = m.medical_history_id JOIN doctor d ON p.doctor_name = d.name WHERE d.email = ? AND p.discharge_date IS NULL AND p.disease_name IS NOT NULL AND m.medical_history_id = ?;");
            stmt.setString(1, doctor_mail);
            stmt.setString(2, medical_history_id);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                String htmlContent = "<!DOCTYPE html>\n" +
                        "<html lang=\"en\">\n" +
                        "<head>\n" +
                        "    <meta charset=\"UTF-8\">\n" +
                        "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
                        "    <style>\n" +
                        "        body {\n" +
                        "            font-family: Arial, sans-serif;\n" +
                        "            background-color: #f4f4f4;\n" +
                        "            margin: 0;\n" +
                        "            padding: 0;\n" +
                        "        }\n" +
                        "        .container {\n" +
                        "            max-width: 600px;\n" +
                        "            margin: 0 auto;\n" +
                        "            background-color: #ffffff;\n" +
                        "            padding: 20px;\n" +
                        "            border-radius: 10px;\n" +
                        "            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);\n" +
                        "        }\n" +
                        "        .header {\n" +
                        "            text-align: center;\n" +
                        "            padding: 10px 0;\n" +
                        "            border-bottom: 1px solid #e0e0e0;\n" +
                        "        }\n" +
                        "        .header img {\n" +
                        "            max-width: 100%;\n" +
                        "            height: auto;\n" +
                        "            width: auto;\n" +
                        "        }\n" +
                        "        .content {\n" +
                        "            padding: 20px;\n" +
                        "            text-align: center;\n" +
                        "        }\n" +
                        "        .content h1 {\n" +
                        "            color: #333333;\n" +
                        "        }\n" +
                        "        .content p {\n" +
                        "            color: #666666;\n" +
                        "            line-height: 1.6;\n" +
                        "        }\n" +
                        "        .footer {\n" +
                        "            text-align: center;\n" +
                        "            padding: 20px;\n" +
                        "            color: #aaaaaa;\n" +
                        "            font-size: 12px;\n" +
                        "        }\n" +
                        "        .p-3 {\n" +
                        "            padding: 0.75rem;\n" +
                        "        }\n" +
                        "        .record-page {\n" +
                        "            padding: 12px 12px 12px 12px;\n" +
                        "            justify-content: center;\n" +
                        "            display: flex;\n" +
                        "        }\n" +
                        "        .record-details {\n" +
                        "            max-width: 600px;\n" +
                        "            margin: 0 auto;\n" +
                        "            background-color: #ffffff;\n" +
                        "            padding: 20px;\n" +
                        "            border-radius: 10px;\n" +
                        "            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);\n" +
                        "        }\n" +
                        "        .text-3xl {\n" +
                        "            font-size: 1.875rem;\n" +
                        "            line-height: 2.25rem;\n" +
                        "        }\n" +
                        "        .text-lg {\n" +
                        "            font-size: 1.125rem;\n" +
                        "            line-height: 1.75rem;\n" +
                        "        }\n" +
                        "        .font-bold {\n" +
                        "            font-weight: bold;\n" +
                        "        }\n" +
                        "        .record-info p {\n" +
                        "            color: #666666;\n" +
                        "            line-height: 1.6;\n" +
                        "            margin-bottom: 10px;\n" +
                        "        }\n" +
                        "    </style>\n" +
                        "</head>\n" +
                        "<body>\n" +
                        "    <div class=\"container\">\n" +
                        "        <div class=\"header\">\n" +
                        "            <img src=\"https://github.com/mrinal4703/Suvidha_images/blob/main/suvidha.jpg?raw=true\" alt=\"Suvidha Logo\">\n" +
                        "        </div>\n" +
                        "        <div class=\"content\">\n" +
                        "            <h1>A new assignment for the case with " + rs.getString("name") + "!</h1>\n" +
                        "            <p>The case details are as follows:</p>\n" +
                        "            <div class=\"p-3 record-page\">\n" +
                        "                <div class=\"record-details\">\n" +
                        "                    <div class=\"record-info\">\n" +
                        "                        <p class=\"text-3xl font-bold\">" + rs.getString("disease_name") + "</p>\n" +
                        "                        <p class=\"text-lg font-bold\">" + rs.getString("doctor_name") + "</p>\n" +
                        "                        <p><strong>Admission Date:</strong> " + rs.getString("admission_date") + "</p>\n" +
                        "                        <p><strong>Treatment Provided:</strong> " + rs.getString("treatment_provided") + "</p>\n" +
                        "                        <p class=\"font-bold\">Details:</p>\n" +
                        "                        " + rs.getString("medical_history_detail") + "\n" +
                        "                    </div>\n" +
                        "                </div>\n" +
                        "            </div>\n" +
                        "        </div>\n" +
                        "        <div class=\"footer\">\n" +
                        "            &copy; 2024 Suvidha Healthcare. All rights reserved.\n" +
                        "        </div>\n" +
                        "    </div>\n" +
                        "</body>\n" +
                        "</html>";
                helper.setText(htmlContent, true);
            }
            javaMailSender.send(message);
            System.out.println("Assist confirmation email sent successfully to: " + nurse_email);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @RequestMapping("/DashboardForStaff")
    public String DashboardForStaff() {
        return "DashboardForStaff";
    }
    @RequestMapping(value = "/prescriptionsend", method = RequestMethod.POST)
    public String PrescriptionSend(@RequestParam("pharmacist_email") String pharmacist_email, @RequestParam("email") String email, @RequestParam("medical_history_id") String medical_history_id, @RequestParam("prescription_detail") String  prescription_detail, Model model) {
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
            java.util.Date today = new java.util.Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String formattedDate = sdf.format(today);
            Date prescription_day = new Date(today.getTime());
            PreparedStatement stmt = con.prepareStatement("insert into prescription_summary (pharmacist_email, patient_email, prescription_day, medical_history_id, prescription_detail,paid_status) values (?,?,?,?,?,?)");
            stmt.setString(1, pharmacist_email);
            stmt.setString(2, email);
            stmt.setDate(3, prescription_day);
            stmt.setString(4, medical_history_id);
            stmt.setString(5, prescription_detail);
            stmt.setString(6,"Unpaid");
            stmt.executeUpdate();
        }
        catch (Exception e){
            e.printStackTrace();
        }
        return "redirect:/DashboardForMedical";
    }
    @RequestMapping(value = "/prescriptionbill", method = RequestMethod.POST)
    public String PrescriptionBill(@RequestParam("medical_history_id") String medical_history_id, @RequestParam("prescription_day") Date prescription_day, Model model) {
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/suvidha?characterEncoding=utf8", "root", "root");
            float bill = 0.0F;
            Random random = new Random();
            if (random.nextFloat() < 0.7) {
                bill = 100 + random.nextFloat() * (800 - 100);
            }
            else {
                bill = 801 + random.nextFloat() * (10000 - 801);
            }
            PreparedStatement stmt = con.prepareStatement("update prescription_summary set prescription_bill = ? where medical_history_id = ? and prescription_day = ?");
            stmt.setFloat(1,bill);
            stmt.setString(2,medical_history_id);
            stmt.setDate(3, prescription_day);
            stmt.executeUpdate();
        }
        catch (Exception e){
            e.printStackTrace();
        }
        return "redirect:/DashboardForStaff";
    }
}
