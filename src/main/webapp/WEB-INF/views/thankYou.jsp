<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thank You!</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
<div class="container mt-4">
    <div class="card bg-secondary text-white">
        <div class="card-header text-center">
            <h2 class="mb-0">Thank You!</h2>
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
                <div class="col-md-8 text-start">
                    <p>Your reservation for <strong>${reservation.movie.title}</strong> is confirmed.</p>
                    <p><strong>Number of Tickets:</strong> ${reservation.numberOfTickets}</p>
                    <p><strong>Seats:</strong> ${reservation.seats}</p>
                    <p><strong>Total Price:</strong> $${reservation.totalPrice}</p>
                </div>
            </div>
        </div>
        <div class="card-footer text-end">
            <a href="${pageContext.request.contextPath}/movies" class="btn btn-primary"
               style="border: 1px solid #343a40;">
                Back to Movies</a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>