<html>
<head>
    <title>Reservation Summary</title>
</head>
<body>
<h1>Reservation Summary</h1>
<p>Movie: ${reservation.movie.title}</p>
<p>Number of Tickets: ${reservation.numberOfTickets}</p>
<p>Selected Seats: ${reservation.seats}</p>
<p>Total Price: $${reservation.totalPrice}</p>
<form action="confirmReservation" method="post">
    <input type="hidden" name="reservationId" value="${reservation.id}" />
    <button type="submit">Confirm Reservation</button>
</form>
</body>
</html>