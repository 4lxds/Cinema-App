<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thank You!</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
<div class="container mt-4 text-center">
    <h1 class="mb-4">Thank You!</h1>
    <c:if test="${not empty base64Image}">
        <img src="data:image/jpeg;base64,${base64Image}" alt="Movie Image" class="img-fluid mb-3"
             style="max-width: 300px;"/>
    </c:if>
    <p>Your reservation for <strong>${reservation.movie.title}</strong> is confirmed.</p>
    <p><strong>Number of Tickets:</strong> ${reservation.numberOfTickets}</p>
    <p><strong>Seats:</strong> ${reservation.seats}</p>
    <p><strong>Total Price:</strong> $${reservation.totalPrice}</p>
    <a href="${pageContext.request.contextPath}/movies" class="btn btn-primary mt-3">Back to Movies</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>