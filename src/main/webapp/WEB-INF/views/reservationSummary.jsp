<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Reservation Summary</title>
</head>
<body>
<h1>Reservation Summary</h1>

<p>Movie: ${tempReservation.movie.title}</p>
<p>Number of Tickets: ${tempReservation.numberOfTickets}</p>
<p>Seats: ${tempReservation.seats}</p>
<p>Total Price: $${tempReservation.totalPrice}</p>

<form action="${pageContext.request.contextPath}/confirmReservation" method="post">
    <!-- add to db -->
    <input type="hidden" name="movieId" value="${tempReservation.movie.id}" />
    <input type="hidden" name="numberOfTickets" value="${tempReservation.numberOfTickets}" />
    <c:forEach var="id" items="${seatIdList}">
        <input type="hidden" name="seatIds" value="${id}" />
    </c:forEach>

    <button type="submit">Confirm Reservation</button>
</form>
</body>
</html>
