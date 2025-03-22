<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Make a Reservation</title>
</head>
<body>
<h1>Reserve Tickets for ${movie.title}</h1>
<p>Price per ticket: $${movie.ticketPrice}</p>

<form action="${pageContext.request.contextPath}/reserve" method="post">
    <input type="hidden" name="movieId" value="${movie.id}" />

    <label for="numberOfTickets">Number of Tickets:</label>
    <input type="number" name="numberOfTickets" id="numberOfTickets" min="1" required /><br/>

    <label for="selectedSeats">Select Seats (comma separated, e.g. A1,A2):</label>
    <input type="text" name="selectedSeats" id="selectedSeats" required /><br/>

    <button type="submit">Reserve Tickets</button>
</form>

<a href="${pageContext.request.contextPath}/movies">Back to Movies List</a>
</body>
</html>