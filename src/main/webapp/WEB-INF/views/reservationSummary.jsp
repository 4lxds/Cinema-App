<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reservation Summary</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
<div class="container mt-4">
    <h1>Reservation Summary</h1>
    <c:if test="${not empty base64Image}">
        <img src="data:image/jpeg;base64,${base64Image}" alt="Movie Image" class="img-fluid mb-3"
             style="max-width: 300px;"/>
    </c:if>
    <p><strong>Movie:</strong> ${tempReservation.movie.title}</p>
    <p><strong>Number of Tickets:</strong> ${tempReservation.numberOfTickets}</p>
    <p><strong>Seats:</strong> ${tempReservation.seats}</p>
    <p><strong>Total Price:</strong> $${tempReservation.totalPrice}</p>
    <form action="${pageContext.request.contextPath}/confirmReservation" method="post">
        <input type="hidden" name="movieId" value="${tempReservation.movie.id}"/>
        <input type="hidden" name="numberOfTickets" value="${tempReservation.numberOfTickets}"/>
        <c:forEach var="id" items="${seatIdList}">
            <input type="hidden" name="seatIds" value="${id}"/>
        </c:forEach>
        <button type="submit" class="btn btn-success">Confirm Reservation</button>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>