<%@ include file="header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Reservations</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/darkly/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Matching the Darkly theme with a custom table style */
        .table-dark {
            background-color: #495057;
        }

        .table-dark th,
        .table-dark td {
            border-color: #343a40;
        }
    </style>
</head>
<body class="bg-dark text-white">
<div class="container mt-4">
    <div class="card bg-secondary text-white">
        <div class="card-header text-center">
            <h2>My Reservations</h2>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty reservations}">
                    <table class="table table-striped table-dark">
                        <thead>
                        <tr>
                                <%--dupa test scot reservation id--%>
                            <th scope="col">Reservation ID</th>
                            <th scope="col">Movie</th>
                            <th scope="col">Tickets</th>
                            <th scope="col">Seats</th>
                            <th scope="col">Total Price</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="reservation" items="${reservations}">
                            <tr>
                                    <%--dupa test scot reservation id--%>
                                <td>${reservation.id}</td>
                                <td>${reservation.movie.title}</td>
                                <td>${reservation.numberOfTickets}</td>
                                <td>${reservation.seats}</td>
                                <td>$${reservation.totalPrice}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p class="text-center">You have no reservations.</p>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="card-footer text-end">
            <a href="${pageContext.request.contextPath}/movies" class="btn btn-secondary"
               style="border: 1px solid #343a40;">Back to Movies List</a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
