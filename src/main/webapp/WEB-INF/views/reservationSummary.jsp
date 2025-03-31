<%@ include file="header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reservation Summary</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
<div class="container mt-4">
    <div class="card bg-secondary text-white">
        <div class="card-header text-center">
            <h2 class="mb-0">Reservation Summary</h2>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4 text-center">
                    <c:if test="${not empty base64Image}">
                        <img src="data:image/jpeg;base64,${base64Image}" alt="Movie Image"
                             class="img-fluid mb-3"
                             style="max-width: 300px;"/>
                    </c:if>
                </div>
                <div class="col-md-8">
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
                        <button type="submit" class="btn btn-primary">Confirm Reservation</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="card-footer text-end">
            <a href="${pageContext.request.contextPath}/reservation?movieId=${tempReservation.movie.id}"
               class="btn btn-warning me-2">
                Back to Seat Selection
            </a>
            <a href="${pageContext.request.contextPath}/movies" class="btn btn-secondary"
               style="border: 1px solid #343a40;">
                Back to Movies List
            </a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>