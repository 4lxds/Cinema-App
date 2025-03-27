<html>
<head>
    <title>Thank You!</title>
</head>
<body>
<h1>Thank You!</h1>
<p>Your reservation for ${reservation.movie.title} is confirmed.</p>
<p>Number of Tickets: ${reservation.numberOfTickets}</p>
<p>Seats: ${reservation.seats}</p>
<p>Total Price: $${reservation.totalPrice}</p>

<a href="${pageContext.request.contextPath}/movies">Back to Movies</a>
</body>
</html>