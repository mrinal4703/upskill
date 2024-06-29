<%-- 
    Document   : welcomepage
    Created on : 01-Jun-2024, 9:00:36 pm
    Author     : mrina
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!--  This site was created in Webflow. http://www.webflow.com  -->
<!--  Last Published: Fri May 15 2020 11:36:12 GMT+0000 (Coordinated Universal Time)  -->
<html data-wf-page="5ea1b995c6b4c13faa406a09" data-wf-site="5ea1b995c6b4c10f74406a08">

<head>
    <meta charset="utf-8" />
    <!-- Include common head content -->
    <jsp:include page="${pageContext.request.contextPath}/WEB-INF/jsp/commonHead.jsp" />
    <title>Suvidha</title>
    <link href="http://api-azure.writesonic.com/static/css/lander-409e35.webflow.css" rel="stylesheet" type="text/css" />
</head>

<body>
<%@ include file="header.jsp" %>
<div class="section overflow-hidden">
    <div class="container mb-3xl">
        <div class="row">
            <div class="column align-center mx-4">
                <h1 class="text-giga font-black text-center mx-4">Streamline healthcare management with Suvidha.
                </h1>
                <p class="text-2xl text-center max-w-lg"> Suvidha offers a comprehensive solution for healthcare organizations, providing oversight, patient-centric records, and automated reporting. With robust security measures and user-friendly interfaces, Suvidha streamlines operations and improves efficiency. Gain valuable insights and ensure success through ongoing collaboration and skill development.</p>
                <a href="login" class="button main text-3xl mt-lg w-button">Join us</a>
                <div class="x`
                row
                items-center
                mt-lg
                _w-full
                max-w-lg
                wrap
                justify-center
              ">
                    <div class="logo-container">
                        <img src="http://api-azure.writesonic.com/static/images/Groups.png" alt="intercom logo" class="intercom" />
                    </div>
                    <div class="logo-container">
                        <img src="http://api-azure.writesonic.com/static/images/Group.png" alt="" class="buffer" />
                    </div>
                    <div class="logo-container ph">
                        <img src="http://api-azure.writesonic.com/static/images/product-hunt-1.png" alt="" class="product-hunt" />
                    </div>
                    <div class="logo-container">
                        <img src="http://api-azure.writesonic.com/static/images/icon_slack.png" alt="" class="slack" />
                    </div>
                    <div class="logo-container">
                        <img src="http://api-azure.writesonic.com/static/images/580b57fcd9996e24bc43c513.png" alt="" class="airbnb" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="circle"></div>
</div>
<div class="section">
    <img src="${pageContext.request.contextPath}/static/images/suvidha-cabin.png" class="product-shot" data-w-id="a4177896-a5e5-6c6a-0980-01ce8ea2054a" alt="" />
</div>
<div class="section">
    <div class="container mt-2xl mb-2xl">
        <div class="row">
            <div class="column align-center">
                <h2 class="max-w-lg text-3xl font-bold text-center">Transforming healthcare management with innovation and efficiency.
                </h2>
                <p class="text-2xl text-center max-w-md">
                    Suvidha provides a comprehensive solution for managing all aspects of healthcare, from departmental oversight to patient-centric records. With automated reporting and robust security measures, it streamlines processes and enhances efficiency. Learn from our experience in team alignment and agile problem-solving techniques to ensure continued success in the ever-evolving healthcare landscape.
                </p>
            </div>
        </div>
    </div>
</div>
<div class="section">
    <div class="container">
        <div class="row items-center v-t">
            <div class="column align-left p-2xl">
                <h6 class="max-w-lg text-md">#1 Feature</h6>
                <h2 class="max-w-lg text-3xl font-bold">Streamline departmental operations for enhanced patient care.
                </h2>
                <p class="text-2xl"> Efficiently categorize and monitor departments by specialization, doctor, and nurse counts with Suvidha. Streamline your operations, improve coordination, and deliver enhanced patient care. Take control of your healthcare management system and ensure smooth and efficient workflows for better outcomes.</p>
            </div>
            <div class="column align-center p-2xl">
                <img src="${pageContext.request.contextPath}/static/images/first.png" alt="" class="feature-card" />
            </div>
        </div>
        <div class="row reverse items-center v-t">
            <div class="column align-left p-2xl">
                <h6 class="max-w-lg text-md">#2 Feature</h6>
                <h2 class="max-w-lg text-3xl font-bold">Stay on top of your healthcare records effortlessly.
                </h2>
                <p class="text-2xl"> Say goodbye to the hassle of manually generating and sending medical reports and bills. With Suvidha&#39;s automated reporting feature, you can effortlessly stay on top of your healthcare records. Save time, streamline processes, and ensure accurate delivery to patients. Experience the convenience of automated reporting today.</p>
            </div>
            <div class="column align-center p-2xl">
                <img src="${pageContext.request.contextPath}/static/images/second.png" alt="" class="feature-card" />
            </div>
        </div>
        <div class="row items-center v-t">
            <div class="column align-left p-2xl">
                <h6 class="max-w-lg text-md">#3 Feature</h6>
                <h2 class="max-w-lg text-3xl font-bold">Unlock valuable insights with data analysis.
                </h2>
                <p class="text-2xl"> Gain a deeper understanding of your patients and hospital performance with graphical analysis. Uncover trends, identify areas for improvement, and make data-driven decisions to drive success. Harness the power of data to unlock valuable insights and take your healthcare management to the next level.</p>
            </div>
            <div class="column align-center p-2xl">
                <img src="${pageContext.request.contextPath}/static/images/third.png" alt="" class="feature-card" />
            </div>
        </div>
    </div>
</div>
<div class="section main mt-2xl">
    <div class="container mt-2xl mb-2xl">
        <div class="row items-center">
            <div class="column align-center">
                <h1 class="max-w-lg text-giga text-center text-white">Experience a new era of healthcare management with Suvidha.
                </h1>
            </div>
        </div>
    </div>
</div>
<div class="section pb-2xl-m">
    <div class="container mt-lg mb-sm">
        <div class="row v-l">
            <div class="column text-md align-left">
                <div class="lg"><img src="${pageContext.request.contextPath}/static/images/suvidha.jpg" class="h-14" alt="logo"/></div>
                <%String mail = "suvidha.sevaa@gmail.com";%>
                <a href="mailto:<%=mail%>" class="u mt-lg">suvidha.sevaa@gmail.com</a>
                <div class="row gap-3 mt-lg ml-3">
                    <i class="fa-brands fa-twitter"></i>
                    <i class="fa-brands fa-instagram"></i>
                    <i class="fa-brands fa-facebook"></i>
                </div>
            </div>
            <div class="column align-left">
                <h6 class="max-w-lg mb-xl font-bold footer-header">Company</h6>
                <div class="mt-md">Apply</div>
                <div class="mt-md">Specializations</div>
                <div class="mt-md">Growth</div>
            </div>
            <div class="column align-left">
                <h6 class="max-w-lg mb-xl font-bold footer-header">Contact</h6>
                <div>Support</div>
                <div class="mt-md">Medical Staffs</div>
            </div>
            <div class="column align-left">
                <h6 class="max-w-lg mb-xl font-bold footer-header">Resources</h6>
                <div class="mt-md">Reviews</div>
            </div>
        </div>
    </div>
    <div class="mx-auto">
        &copy; 2024 Suvidha Healthcare. All rights reserved.
    </div>
</div>
<script src="https://d3e54v103j8qbb.cloudfront.net/js/jquery-3.4.1.min.220afd743d.js?site=5ea1b995c6b4c10f74406a08"
        type="text/javascript" integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo=" crossorigin="anonymous">
</script>

<script src="http://api-azure.writesonic.com/static/js/webflow.js" type="text/javascript"></script>
<!-- [if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif] -->
<script>
    feather.replace();
</script>
</body>

</html>

